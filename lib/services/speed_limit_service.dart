import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'gps_service.dart';

// Replace with your TomTom API key from developer.tomtom.com (free registration)
const String _kTomTomApiKey = 'Z4ZsXD1J7YsQeUN3QE2MGvveM0qp0Q57';

class SpeedLimitService extends ChangeNotifier {
  final GpsService _gps;

  double? speedLimitMph; // null = unknown / not yet fetched

  bool _fetching = false;
  DateTime? _lastRequest;
  double? _lastLat, _lastLng;

  static const _kMinInterval = Duration(seconds: 15);
  static const _kMinDistanceM = 80.0;

  SpeedLimitService(this._gps) {
    _gps.addListener(_onGpsChanged);
  }

  void _onGpsChanged() {
    final pos = _gps.lastPosition;
    if (pos == null || _gps.gpsStatus != GpsStatus.active) return;
    _maybeRefresh(pos.latitude, pos.longitude);
  }

  Future<void> _maybeRefresh(double lat, double lng) async {
    if (_fetching) {
      return;
    }

    final now = DateTime.now();
    if (_lastRequest != null &&
        now.difference(_lastRequest!) < _kMinInterval) {
      return;
    }

    if (_lastLat != null && _lastLng != null) {
      final d = Geolocator.distanceBetween(_lastLat!, _lastLng!, lat, lng);
      if (d < _kMinDistanceM) {
        return;
      }
    }

    _fetching = true;
    _lastRequest = now;
    _lastLat = lat;
    _lastLng = lng;

    try {
      final latStr = lat.toStringAsFixed(6);
      final lngStr = lng.toStringAsFixed(6);
      final uri = Uri.parse(
        'https://api.tomtom.com/search/2/reverseGeocode/$latStr,$lngStr.json'
        '?key=$_kTomTomApiKey&returnSpeedLimit=true&radius=50',
      );
      final resp = await http.get(uri).timeout(const Duration(seconds: 5));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        final addresses = data['addresses'] as List?;
        if (addresses != null && addresses.isNotEmpty) {
          final addr = addresses[0] as Map<String, dynamic>;
          // TomTom returns speedLimit as a combined string e.g. "30.00MPH" or "48.00KPH"
          final address = addr['address'] as Map<String, dynamic>?;
          final speedLimitStr = address?['speedLimit'] as String?;
          if (speedLimitStr != null && speedLimitStr.isNotEmpty) {
            final match = RegExp(r'([\d.]+)(MPH|KPH|KMH)', caseSensitive: false)
                .firstMatch(speedLimitStr);
            if (match != null) {
              final value = double.tryParse(match.group(1)!);
              final unit = match.group(2)!.toUpperCase();
              if (value != null) {
                speedLimitMph = unit == 'MPH' ? value : value * 0.621371;
              }
            }
          }
        }
      }
    } catch (_) {
      // Network error — keep last known limit, don't clear it
    } finally {
      _fetching = false;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _gps.removeListener(_onGpsChanged);
    super.dispose();
  }
}
