import 'package:drift/drift.dart';
import 'database.dart';

class RecordingRepository {
  final AppDatabase _db;

  RecordingRepository(this._db);

  Future<int> startSession() => _db.insertSession(
        SpeedSessionsCompanion(startTime: Value(DateTime.now())),
      );

  Future<void> addRecord(
    int sessionId,
    double speedMph,
    double? lat,
    double? lng,
  ) =>
      _db.insertRecord(SpeedRecordsCompanion(
        sessionId: Value(sessionId),
        timestamp: Value(DateTime.now()),
        speedMph: Value(speedMph),
        latitude: Value(lat),
        longitude: Value(lng),
      ));

  Future<void> stopSession(
    int sessionId,
    double distanceMiles,
    double maxSpeedMph,
  ) =>
      _db.updateSession(sessionId, DateTime.now(), distanceMiles, maxSpeedMph);

  Future<double> getTotalOdometer() => _db.getTotalMiles();

  Future<void> addToOdometer(double miles) => _db.addToOdometer(miles);

  Future<void> setOdometer(double miles) => _db.setOdometer(miles);

  Future<void> deleteSession(int sessionId, double distanceMiles) =>
      _db.deleteSession(sessionId, distanceMiles);

  Stream<List<SpeedSession>> watchSessions() => _db.watchAllSessions();
}
