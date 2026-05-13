import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../data/recording_repository.dart';

enum GpsStatus { noPermission, searching, active, lost }

class GpsService extends ChangeNotifier {
  final RecordingRepository _repository;

  GpsService(this._repository) {
    unawaited(_init());
  }

  double speedMph = 0.0;
  double tripOdometer = 0.0;
  double totalOdometer = 0.0;
  GpsStatus gpsStatus = GpsStatus.searching;
  bool isRecording = false;
  double? lastAccuracyM;

  Position? get lastPosition => _lastPosition;

  bool _disposed = false;
  int? _currentSessionId;
  double _maxSpeedThisSession = 0.0;
  double _baseOdometer = 0.0;
  Position? _lastPosition;
  StreamSubscription<Position>? _positionSub;
  StreamSubscription<UserAccelerometerEvent>? _accelSub;
  Timer? _recordTimer;

  double _pendingSpeedMph = 0.0;
  double? _pendingLat;
  double? _pendingLng;

  // Rolling buffer of linear-acceleration magnitudes (gravity removed).
  final List<double> _accelBuffer = [];
  static const int _kAccelWindow = 8;        // ~400 ms at 50 ms sampling
  static const double _kStationaryMps2 = 0.40; // m/s² threshold

  bool get _isPhoneStationary {
    if (_accelBuffer.length < 3) return false;
    final avg = _accelBuffer.reduce((a, b) => a + b) / _accelBuffer.length;
    return avg < _kStationaryMps2;
  }

  Future<void> _init() async {
    totalOdometer = await _repository.getTotalOdometer();
    if (_disposed) return;
    notifyListeners();

    try {
      _accelSub = userAccelerometerEventStream(
        samplingPeriod: const Duration(milliseconds: 50),
      ).listen((event) {
        final mag = sqrt(
            event.x * event.x + event.y * event.y + event.z * event.z);
        _accelBuffer.add(mag);
        if (_accelBuffer.length > _kAccelWindow) _accelBuffer.removeAt(0);
      });
    } catch (_) {}

    var permission = await Geolocator.checkPermission();
    if (_disposed) return;
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (_disposed) return;
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      gpsStatus = GpsStatus.noPermission;
      notifyListeners();
      return;
    }

    final settings = _makeLocationSettings();
    _positionSub = Geolocator.getPositionStream(locationSettings: settings)
        .listen(_onPosition, onError: (_) {
      if (_disposed) return;
      gpsStatus = GpsStatus.lost;
      notifyListeners();
    });
  }

  void _onPosition(Position position) {
    final rawMps = position.speed < 0 ? 0.0 : position.speed;
    final accMps = position.speedAccuracy; // m/s 1-sigma; 0 = not available

    // Three-layer noise rejection:
    // 1. Hard deadband (~1 mph) — GPS noise floor on any device
    // 2. Speed-accuracy gate — if speed is within chip's own error margin
    // 3. Accelerometer gate — only for readings < 3 mph; avoids masking real
    //    slow driving but catches stationary GPS drift
    const kDeadbandMps = 0.45;
    final withinNoise = accMps > 0 && rawMps <= accMps;
    final lowSpeed = rawMps * 2.23694 < 3.0;
    speedMph =
        (rawMps < kDeadbandMps || withinNoise || (lowSpeed && _isPhoneStationary))
            ? 0.0
            : rawMps * 2.23694;

    lastAccuracyM = position.accuracy;
    gpsStatus = GpsStatus.active;

    if (_lastPosition != null && isRecording && !_isPhoneStationary) {
      final distM = _haversineMeters(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );
      tripOdometer += distM / 1609.344;
      totalOdometer = _baseOdometer + tripOdometer;
      if (speedMph > _maxSpeedThisSession) _maxSpeedThisSession = speedMph;
    }
    _lastPosition = position;

    _pendingSpeedMph = speedMph;
    _pendingLat = position.latitude;
    _pendingLng = position.longitude;

    notifyListeners();
  }

  Future<void> refreshOdometer() async {
    totalOdometer = await _repository.getTotalOdometer();
    notifyListeners();
  }

  Future<void> startRecording() async {
    if (isRecording) return;
    // Flip flag synchronously to block any concurrent call.
    isRecording = true;
    tripOdometer = 0.0;
    _maxSpeedThisSession = 0.0;
    _baseOdometer = totalOdometer;
    _lastPosition = null;

    try {
      final sessionId = await _repository.startSession();
      _currentSessionId = sessionId;
    } catch (_) {
      isRecording = false;
      notifyListeners();
      return;
    }

    WakelockPlus.enable();
    notifyListeners();

    _recordTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (_currentSessionId != null) {
        await _repository.addRecord(
          _currentSessionId!,
          _pendingSpeedMph,
          _pendingLat,
          _pendingLng,
        );
      }
    });
  }

  Future<void> stopRecording() async {
    if (!isRecording || _currentSessionId == null) return;
    // Flip flags synchronously to block any concurrent call.
    final sessionId = _currentSessionId!;
    final trip = tripOdometer;
    final maxSpeed = _maxSpeedThisSession;
    isRecording = false;
    _currentSessionId = null;
    _recordTimer?.cancel();
    _recordTimer = null;
    WakelockPlus.disable();
    notifyListeners();

    await _repository.stopSession(sessionId, trip, maxSpeed);
    await _repository.addToOdometer(trip);
    totalOdometer = await _repository.getTotalOdometer();
    notifyListeners();
  }

  static LocationSettings _makeLocationSettings() {
    if (Platform.isAndroid) {
      return AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
        intervalDuration: const Duration(milliseconds: 200),
      );
    }
    return const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 0,
    );
  }

  static double _haversineMeters(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const r = 6371000.0;
    final dLat = _rad(lat2 - lat1);
    final dLng = _rad(lng2 - lng1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_rad(lat1)) * cos(_rad(lat2)) * sin(dLng / 2) * sin(dLng / 2);
    return 2 * r * asin(sqrt(a));
  }

  static double _rad(double deg) => deg * pi / 180;

  @override
  void dispose() {
    _disposed = true;
    _positionSub?.cancel();
    _accelSub?.cancel();
    _recordTimer?.cancel();
    super.dispose();
  }
}
