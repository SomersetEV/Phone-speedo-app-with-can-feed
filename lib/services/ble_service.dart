import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

const String _nusSvcUuid = '6e400001-b5a3-f393-e0a9-e50e24dcca9e';
const String _nusTxUuid  = '6e400003-b5a3-f393-e0a9-e50e24dcca9e';
const String _deviceName = 'SomersetEV-Tractor';
const int    _targetMtu  = 512;

enum BleConnectionState { disconnected, scanning, connecting, connected }

class BleService extends ChangeNotifier {
  BleConnectionState connectionState = BleConnectionState.disconnected;
  String? lastError;
  String? connectedDeviceName;

  BluetoothDevice? _device;
  BluetoothDevice? _lastDevice;
  BluetoothCharacteristic? _txChar;
  StreamSubscription<List<int>>? _notifySub;
  StreamSubscription<BluetoothConnectionState>? _stateSub;
  StreamSubscription<List<ScanResult>>? _scanSub;
  Timer? _scanTimeoutTimer;

  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 3;

  // Raw NUS notification stream — forwarded to future CAN data consumers
  final _rawDataController = StreamController<String>.broadcast();
  Stream<String> get rawDataStream => _rawDataController.stream;

  Future<void> startScan() async {
    if (connectionState != BleConnectionState.disconnected) return;
    _setState(BleConnectionState.scanning);
    lastError = null;

    await FlutterBluePlus.stopScan();

    _scanSub = FlutterBluePlus.scanResults.listen((results) async {
      for (final result in results) {
        if (result.device.platformName == _deviceName) {
          _scanTimeoutTimer?.cancel();
          _scanSub?.cancel();
          _scanSub = null;
          await FlutterBluePlus.stopScan();
          await _connect(result.device);
          return;
        }
      }
    });

    await FlutterBluePlus.startScan(
      withServices: [Guid(_nusSvcUuid)],
      timeout: const Duration(seconds: 15),
    );

    _scanTimeoutTimer = Timer(const Duration(seconds: 16), () {
      if (connectionState == BleConnectionState.scanning) {
        _setState(BleConnectionState.disconnected);
        lastError = 'LilyGo board not found — is it powered on?';
        notifyListeners();
      }
    });
  }

  Future<void> _connect(BluetoothDevice device) async {
    _setState(BleConnectionState.connecting);
    _device = device;
    _lastDevice = device;

    _stateSub = device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected) {
        _handleDisconnect();
      }
    });

    try {
      await device.connect(timeout: const Duration(seconds: 10));
    } catch (e) {
      lastError = 'Connection failed: $e';
      _setState(BleConnectionState.disconnected);
      notifyListeners();
      return;
    }

    try {
      await device.requestMtu(_targetMtu);
    } catch (_) {}

    final services = await device.discoverServices();
    BluetoothService nusSvc;
    try {
      nusSvc = services.firstWhere(
        (s) => s.serviceUuid == Guid(_nusSvcUuid),
      );
    } catch (_) {
      lastError = 'NUS service not found on device';
      _handleDisconnect(reconnect: false);
      return;
    }

    try {
      _txChar = nusSvc.characteristics.firstWhere(
        (c) => c.characteristicUuid == Guid(_nusTxUuid),
      );
      await _txChar!.setNotifyValue(true);
      _notifySub = _txChar!.onValueReceived.listen(_onNotification);
    } catch (_) {}

    connectedDeviceName = device.platformName;
    _reconnectAttempts = 0;
    lastError = null;
    _setState(BleConnectionState.connected);
  }

  void disconnect() {
    _stateSub?.cancel();
    _stateSub = null;
    _device?.disconnect();
    _handleDisconnect(reconnect: false);
  }

  void _handleDisconnect({bool reconnect = true}) {
    _notifySub?.cancel();
    _stateSub?.cancel();
    _scanSub?.cancel();
    _scanTimeoutTimer?.cancel();
    _notifySub = null;
    _stateSub = null;
    _scanSub = null;
    _scanTimeoutTimer = null;
    _txChar = null;
    _device = null;
    connectedDeviceName = null;

    if (reconnect &&
        _lastDevice != null &&
        _reconnectAttempts < _maxReconnectAttempts) {
      _reconnectAttempts++;
      lastError =
          'Connection lost — reconnecting ($_reconnectAttempts/$_maxReconnectAttempts)...';
      _setState(BleConnectionState.scanning);
      Future.delayed(const Duration(seconds: 3), _reconnect);
    } else {
      _reconnectAttempts = 0;
      _setState(BleConnectionState.disconnected);
    }
  }

  Future<void> _reconnect() async {
    if (connectionState != BleConnectionState.scanning) return;
    if (_lastDevice == null) return;
    await _connect(_lastDevice!);
  }

  void _onNotification(List<int> value) {
    final text = utf8.decode(value, allowMalformed: true);
    _rawDataController.add(text);
  }

  void _setState(BleConnectionState state) {
    connectionState = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _rawDataController.close();
    _notifySub?.cancel();
    _stateSub?.cancel();
    _scanSub?.cancel();
    _scanTimeoutTimer?.cancel();
    super.dispose();
  }
}
