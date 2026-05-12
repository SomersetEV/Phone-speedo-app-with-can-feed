import 'dart:async';

import 'package:flutter/foundation.dart';

import 'ble_service.dart';

// Parses live CAN frames from BleService.rawDataStream and exposes decoded
// vehicle values. Frames arrive as CSV lines matching the session file format:
//   TimeStamp,ID,Extended,Bus,LEN,D1,D2,D3,D4,D5,D6,D7,D8
// ID and byte fields may be decimal or hex strings — both are handled.

class CanService extends ChangeNotifier {
  final BleService _ble;
  StreamSubscription<String>? _sub;

  // ── Outlander motor / inverter (IDs 0x299, 0x733) ────────────────────────
  double? motorTempC;    // bytes[0] - 40                     from 0x733
  double? invTempC;      // avg(bytes[1]-40, bytes[4]-40)     from 0x299

  // ── Outlander OBC / DC-DC (IDs 0x377, 0x389) ─────────────────────────────
  double? lvVolts;        // (bytes[0]<<8|bytes[1]) * 0.01 V   from 0x377
  double? lvAmps;         // (bytes[2]<<8|bytes[3]) * 0.1 A    from 0x377
  double? chargerPowerKw; // ACVolts * ACAmps / 1000           from 0x389

  // ── MG coolant heater (IDs 0x2B5, 0x2B6) ────────────────────────────────
  double? heaterPowerKw;  // hvVolt * bytes[4] * 0.75 / 1000  from 0x2B5+0x2B6
  double _heaterHvVolt = 0; // cached from 0x2B6 bytes[2]

  // ── BMW SBOX battery current (ID 0x200) ───────────────────────────────────
  double? ampDraw;        // signed 24-bit amps, 1:1 scale      from 0x200

  CanService(this._ble) {
    _sub = _ble.rawDataStream.listen(_onLine);
  }

  static int? _parseInt(String s) {
    final t = s.trim();
    return int.tryParse(t) ?? int.tryParse(t, radix: 16);
  }

  void _onLine(String line) {
    final parts = line.trim().split(',');
    if (parts.length < 6) return;

    final id = _parseInt(parts[1]);
    if (id == null) return;

    final bytes = <int>[];
    for (int i = 5; i < parts.length && bytes.length < 8; i++) {
      bytes.add(_parseInt(parts[i]) ?? 0);
    }

    var changed = false;

    switch (id) {
      case 0x299:
        if (bytes.length >= 5) {
          invTempC = ((bytes[1] - 40) + (bytes[4] - 40)) / 2.0;
          changed = true;
        }
      case 0x733:
        if (bytes.isNotEmpty) {
          motorTempC = (bytes[0] - 40).toDouble();
          changed = true;
        }
      case 0x377:
        if (bytes.length >= 4) {
          lvVolts = ((bytes[0] << 8) | bytes[1]) * 0.01;
          lvAmps = ((bytes[2] << 8) | bytes[3]) * 0.1;
          changed = true;
        }
      case 0x389:
        if (bytes.length >= 7) {
          final acVolts = bytes[1].toDouble();
          final acAmps = bytes[6] * 0.1;
          chargerPowerKw = (acVolts * acAmps) / 1000.0;
          changed = true;
        }
      case 0x2B6:
        if (bytes.length >= 3) {
          _heaterHvVolt = bytes[2].toDouble();
          changed = true;
        }
      case 0x2B5:
        if (bytes.length >= 5) {
          heaterPowerKw = (_heaterHvVolt * bytes[4] * 0.75) / 1000.0;
          changed = true;
        }
      case 0x200:
        if (bytes.length >= 3) {
          final raw = (bytes[2] << 16) | (bytes[1] << 8) | bytes[0];
          ampDraw = ((raw << 40) >> 40).toDouble();
          changed = true;
        }
    }

    if (changed) notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
