import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'ble_service.dart';

class CanRecordingService extends ChangeNotifier {
  final BleService _ble;
  StreamSubscription<String>? _sub;
  IOSink? _sink;

  bool isRecording = false;
  int frameCount = 0;

  CanRecordingService(this._ble);

  Future<Directory> _dir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'can_logs'));
    if (!dir.existsSync()) dir.createSync();
    return dir;
  }

  Future<void> startRecording() async {
    if (isRecording) return;
    final dir = await _dir();
    final name =
        'can_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
    final file = File(p.join(dir.path, name));
    _sink = file.openWrite();
    frameCount = 0;
    isRecording = true;
    notifyListeners();
    _sub = _ble.rawDataStream.listen((line) {
      try {
        _sink?.writeln(line);
      } catch (_) {
        // Disk full or write error — stop recording gracefully.
        stopRecording();
        return;
      }
      frameCount++;
      // Notify every 25 frames to avoid rebuilding UI on every CAN message.
      if (frameCount % 25 == 0) notifyListeners();
    });
  }

  Future<void> stopRecording() async {
    if (!isRecording) return;
    await _sub?.cancel();
    _sub = null;
    await _sink?.flush();
    await _sink?.close();
    _sink = null;
    isRecording = false;
    notifyListeners();
  }

  Future<List<File>> listSessions() async {
    final dir = await _dir();
    final files = dir
        .listSync()
        .whereType<File>()
        .where((f) =>
            p.basename(f.path).startsWith('can_') &&
            f.path.endsWith('.csv'))
        .toList()
      ..sort((a, b) => b.path.compareTo(a.path));
    return files;
  }

  Future<void> deleteSession(File file) => file.delete();

  @override
  void dispose() {
    _sub?.cancel();
    _sink?.close();
    super.dispose();
  }
}
