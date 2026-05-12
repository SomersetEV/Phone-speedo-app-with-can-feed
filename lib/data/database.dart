import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// ── Tables ───────────────────────────────────────────────────────────────────

class SpeedSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  RealColumn get totalDistanceMiles =>
      real().withDefault(const Constant(0.0))();
  RealColumn get maxSpeedMph => real().withDefault(const Constant(0.0))();
}

class SpeedRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(SpeedSessions, #id)();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get speedMph => real()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
}

// Single-row table — id is always 1
class OdometerTotal extends Table {
  IntColumn get id => integer()();
  RealColumn get totalMiles => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Database ─────────────────────────────────────────────────────────────────

@DriftDatabase(tables: [SpeedSessions, SpeedRecords, OdometerTotal])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // SpeedSessions
  Future<int> insertSession(SpeedSessionsCompanion session) =>
      into(speedSessions).insert(session);

  Future<void> updateSession(
    int sessionId,
    DateTime endTime,
    double distanceMiles,
    double maxSpeed,
  ) =>
      (update(speedSessions)..where((s) => s.id.equals(sessionId))).write(
        SpeedSessionsCompanion(
          endTime: Value(endTime),
          totalDistanceMiles: Value(distanceMiles),
          maxSpeedMph: Value(maxSpeed),
        ),
      );

  Stream<List<SpeedSession>> watchAllSessions() =>
      (select(speedSessions)
            ..orderBy([(s) => OrderingTerm.desc(s.startTime)]))
          .watch();

  // SpeedRecords
  Future<void> insertRecord(SpeedRecordsCompanion record) =>
      into(speedRecords).insert(record);

  // OdometerTotal
  Future<double> getTotalMiles() async {
    final row = await (select(odometerTotal)
          ..where((o) => o.id.equals(1)))
        .getSingleOrNull();
    return row?.totalMiles ?? 0.0;
  }

  Future<void> addToOdometer(double miles) => customStatement(
        'INSERT INTO odometer_total (id, total_miles) VALUES (1, ?) '
        'ON CONFLICT(id) DO UPDATE SET total_miles = total_miles + ?',
        [miles, miles],
      );

  Future<void> setOdometer(double miles) => customStatement(
        'INSERT INTO odometer_total (id, total_miles) VALUES (1, ?) '
        'ON CONFLICT(id) DO UPDATE SET total_miles = ?',
        [miles, miles],
      );

  Future<void> deleteSession(int sessionId, double distanceMiles) =>
      transaction(() async {
        // Subtract session distance from odometer (floor at 0).
        await customStatement(
          'UPDATE odometer_total SET total_miles = MAX(0, total_miles - ?) WHERE id = 1',
          [distanceMiles],
        );
        await (delete(speedRecords)
              ..where((r) => r.sessionId.equals(sessionId)))
            .go();
        await (delete(speedSessions)..where((s) => s.id.equals(sessionId)))
            .go();
      });
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'car_speedo.db'));
    return NativeDatabase.createInBackground(file);
  });
}
