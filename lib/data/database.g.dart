// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SpeedSessionsTable extends SpeedSessions
    with TableInfo<$SpeedSessionsTable, SpeedSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpeedSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _totalDistanceMilesMeta =
      const VerificationMeta('totalDistanceMiles');
  @override
  late final GeneratedColumn<double> totalDistanceMiles =
      GeneratedColumn<double>('total_distance_miles', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _maxSpeedMphMeta =
      const VerificationMeta('maxSpeedMph');
  @override
  late final GeneratedColumn<double> maxSpeedMph = GeneratedColumn<double>(
      'max_speed_mph', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, startTime, endTime, totalDistanceMiles, maxSpeedMph];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'speed_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<SpeedSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    }
    if (data.containsKey('total_distance_miles')) {
      context.handle(
          _totalDistanceMilesMeta,
          totalDistanceMiles.isAcceptableOrUnknown(
              data['total_distance_miles']!, _totalDistanceMilesMeta));
    }
    if (data.containsKey('max_speed_mph')) {
      context.handle(
          _maxSpeedMphMeta,
          maxSpeedMph.isAcceptableOrUnknown(
              data['max_speed_mph']!, _maxSpeedMphMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpeedSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpeedSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time']),
      totalDistanceMiles: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_distance_miles'])!,
      maxSpeedMph: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_speed_mph'])!,
    );
  }

  @override
  $SpeedSessionsTable createAlias(String alias) {
    return $SpeedSessionsTable(attachedDatabase, alias);
  }
}

class SpeedSession extends DataClass implements Insertable<SpeedSession> {
  final int id;
  final DateTime startTime;
  final DateTime? endTime;
  final double totalDistanceMiles;
  final double maxSpeedMph;
  const SpeedSession(
      {required this.id,
      required this.startTime,
      this.endTime,
      required this.totalDistanceMiles,
      required this.maxSpeedMph});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    map['total_distance_miles'] = Variable<double>(totalDistanceMiles);
    map['max_speed_mph'] = Variable<double>(maxSpeedMph);
    return map;
  }

  SpeedSessionsCompanion toCompanion(bool nullToAbsent) {
    return SpeedSessionsCompanion(
      id: Value(id),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      totalDistanceMiles: Value(totalDistanceMiles),
      maxSpeedMph: Value(maxSpeedMph),
    );
  }

  factory SpeedSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpeedSession(
      id: serializer.fromJson<int>(json['id']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      totalDistanceMiles:
          serializer.fromJson<double>(json['totalDistanceMiles']),
      maxSpeedMph: serializer.fromJson<double>(json['maxSpeedMph']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'totalDistanceMiles': serializer.toJson<double>(totalDistanceMiles),
      'maxSpeedMph': serializer.toJson<double>(maxSpeedMph),
    };
  }

  SpeedSession copyWith(
          {int? id,
          DateTime? startTime,
          Value<DateTime?> endTime = const Value.absent(),
          double? totalDistanceMiles,
          double? maxSpeedMph}) =>
      SpeedSession(
        id: id ?? this.id,
        startTime: startTime ?? this.startTime,
        endTime: endTime.present ? endTime.value : this.endTime,
        totalDistanceMiles: totalDistanceMiles ?? this.totalDistanceMiles,
        maxSpeedMph: maxSpeedMph ?? this.maxSpeedMph,
      );
  SpeedSession copyWithCompanion(SpeedSessionsCompanion data) {
    return SpeedSession(
      id: data.id.present ? data.id.value : this.id,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      totalDistanceMiles: data.totalDistanceMiles.present
          ? data.totalDistanceMiles.value
          : this.totalDistanceMiles,
      maxSpeedMph:
          data.maxSpeedMph.present ? data.maxSpeedMph.value : this.maxSpeedMph,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpeedSession(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('totalDistanceMiles: $totalDistanceMiles, ')
          ..write('maxSpeedMph: $maxSpeedMph')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, startTime, endTime, totalDistanceMiles, maxSpeedMph);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpeedSession &&
          other.id == this.id &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.totalDistanceMiles == this.totalDistanceMiles &&
          other.maxSpeedMph == this.maxSpeedMph);
}

class SpeedSessionsCompanion extends UpdateCompanion<SpeedSession> {
  final Value<int> id;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  final Value<double> totalDistanceMiles;
  final Value<double> maxSpeedMph;
  const SpeedSessionsCompanion({
    this.id = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.totalDistanceMiles = const Value.absent(),
    this.maxSpeedMph = const Value.absent(),
  });
  SpeedSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startTime,
    this.endTime = const Value.absent(),
    this.totalDistanceMiles = const Value.absent(),
    this.maxSpeedMph = const Value.absent(),
  }) : startTime = Value(startTime);
  static Insertable<SpeedSession> custom({
    Expression<int>? id,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<double>? totalDistanceMiles,
    Expression<double>? maxSpeedMph,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (totalDistanceMiles != null)
        'total_distance_miles': totalDistanceMiles,
      if (maxSpeedMph != null) 'max_speed_mph': maxSpeedMph,
    });
  }

  SpeedSessionsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? startTime,
      Value<DateTime?>? endTime,
      Value<double>? totalDistanceMiles,
      Value<double>? maxSpeedMph}) {
    return SpeedSessionsCompanion(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalDistanceMiles: totalDistanceMiles ?? this.totalDistanceMiles,
      maxSpeedMph: maxSpeedMph ?? this.maxSpeedMph,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (totalDistanceMiles.present) {
      map['total_distance_miles'] = Variable<double>(totalDistanceMiles.value);
    }
    if (maxSpeedMph.present) {
      map['max_speed_mph'] = Variable<double>(maxSpeedMph.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpeedSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('totalDistanceMiles: $totalDistanceMiles, ')
          ..write('maxSpeedMph: $maxSpeedMph')
          ..write(')'))
        .toString();
  }
}

class $SpeedRecordsTable extends SpeedRecords
    with TableInfo<$SpeedRecordsTable, SpeedRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpeedRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
      'session_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES speed_sessions (id)'));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _speedMphMeta =
      const VerificationMeta('speedMph');
  @override
  late final GeneratedColumn<double> speedMph = GeneratedColumn<double>(
      'speed_mph', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, sessionId, timestamp, speedMph, latitude, longitude];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'speed_records';
  @override
  VerificationContext validateIntegrity(Insertable<SpeedRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('speed_mph')) {
      context.handle(_speedMphMeta,
          speedMph.isAcceptableOrUnknown(data['speed_mph']!, _speedMphMeta));
    } else if (isInserting) {
      context.missing(_speedMphMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpeedRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpeedRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_id'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      speedMph: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}speed_mph'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
    );
  }

  @override
  $SpeedRecordsTable createAlias(String alias) {
    return $SpeedRecordsTable(attachedDatabase, alias);
  }
}

class SpeedRecord extends DataClass implements Insertable<SpeedRecord> {
  final int id;
  final int sessionId;
  final DateTime timestamp;
  final double speedMph;
  final double? latitude;
  final double? longitude;
  const SpeedRecord(
      {required this.id,
      required this.sessionId,
      required this.timestamp,
      required this.speedMph,
      this.latitude,
      this.longitude});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['speed_mph'] = Variable<double>(speedMph);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    return map;
  }

  SpeedRecordsCompanion toCompanion(bool nullToAbsent) {
    return SpeedRecordsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      timestamp: Value(timestamp),
      speedMph: Value(speedMph),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
    );
  }

  factory SpeedRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpeedRecord(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      speedMph: serializer.fromJson<double>(json['speedMph']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'speedMph': serializer.toJson<double>(speedMph),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
    };
  }

  SpeedRecord copyWith(
          {int? id,
          int? sessionId,
          DateTime? timestamp,
          double? speedMph,
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent()}) =>
      SpeedRecord(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        timestamp: timestamp ?? this.timestamp,
        speedMph: speedMph ?? this.speedMph,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
      );
  SpeedRecord copyWithCompanion(SpeedRecordsCompanion data) {
    return SpeedRecord(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      speedMph: data.speedMph.present ? data.speedMph.value : this.speedMph,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpeedRecord(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('timestamp: $timestamp, ')
          ..write('speedMph: $speedMph, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionId, timestamp, speedMph, latitude, longitude);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpeedRecord &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.timestamp == this.timestamp &&
          other.speedMph == this.speedMph &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude);
}

class SpeedRecordsCompanion extends UpdateCompanion<SpeedRecord> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<DateTime> timestamp;
  final Value<double> speedMph;
  final Value<double?> latitude;
  final Value<double?> longitude;
  const SpeedRecordsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.speedMph = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
  });
  SpeedRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required DateTime timestamp,
    required double speedMph,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
  })  : sessionId = Value(sessionId),
        timestamp = Value(timestamp),
        speedMph = Value(speedMph);
  static Insertable<SpeedRecord> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<DateTime>? timestamp,
    Expression<double>? speedMph,
    Expression<double>? latitude,
    Expression<double>? longitude,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (timestamp != null) 'timestamp': timestamp,
      if (speedMph != null) 'speed_mph': speedMph,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    });
  }

  SpeedRecordsCompanion copyWith(
      {Value<int>? id,
      Value<int>? sessionId,
      Value<DateTime>? timestamp,
      Value<double>? speedMph,
      Value<double?>? latitude,
      Value<double?>? longitude}) {
    return SpeedRecordsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      timestamp: timestamp ?? this.timestamp,
      speedMph: speedMph ?? this.speedMph,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (speedMph.present) {
      map['speed_mph'] = Variable<double>(speedMph.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpeedRecordsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('timestamp: $timestamp, ')
          ..write('speedMph: $speedMph, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }
}

class $OdometerTotalTable extends OdometerTotal
    with TableInfo<$OdometerTotalTable, OdometerTotalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OdometerTotalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalMilesMeta =
      const VerificationMeta('totalMiles');
  @override
  late final GeneratedColumn<double> totalMiles = GeneratedColumn<double>(
      'total_miles', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  @override
  List<GeneratedColumn> get $columns => [id, totalMiles];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'odometer_total';
  @override
  VerificationContext validateIntegrity(Insertable<OdometerTotalData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('total_miles')) {
      context.handle(
          _totalMilesMeta,
          totalMiles.isAcceptableOrUnknown(
              data['total_miles']!, _totalMilesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OdometerTotalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OdometerTotalData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      totalMiles: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_miles'])!,
    );
  }

  @override
  $OdometerTotalTable createAlias(String alias) {
    return $OdometerTotalTable(attachedDatabase, alias);
  }
}

class OdometerTotalData extends DataClass
    implements Insertable<OdometerTotalData> {
  final int id;
  final double totalMiles;
  const OdometerTotalData({required this.id, required this.totalMiles});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['total_miles'] = Variable<double>(totalMiles);
    return map;
  }

  OdometerTotalCompanion toCompanion(bool nullToAbsent) {
    return OdometerTotalCompanion(
      id: Value(id),
      totalMiles: Value(totalMiles),
    );
  }

  factory OdometerTotalData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OdometerTotalData(
      id: serializer.fromJson<int>(json['id']),
      totalMiles: serializer.fromJson<double>(json['totalMiles']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'totalMiles': serializer.toJson<double>(totalMiles),
    };
  }

  OdometerTotalData copyWith({int? id, double? totalMiles}) =>
      OdometerTotalData(
        id: id ?? this.id,
        totalMiles: totalMiles ?? this.totalMiles,
      );
  OdometerTotalData copyWithCompanion(OdometerTotalCompanion data) {
    return OdometerTotalData(
      id: data.id.present ? data.id.value : this.id,
      totalMiles:
          data.totalMiles.present ? data.totalMiles.value : this.totalMiles,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OdometerTotalData(')
          ..write('id: $id, ')
          ..write('totalMiles: $totalMiles')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, totalMiles);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OdometerTotalData &&
          other.id == this.id &&
          other.totalMiles == this.totalMiles);
}

class OdometerTotalCompanion extends UpdateCompanion<OdometerTotalData> {
  final Value<int> id;
  final Value<double> totalMiles;
  const OdometerTotalCompanion({
    this.id = const Value.absent(),
    this.totalMiles = const Value.absent(),
  });
  OdometerTotalCompanion.insert({
    this.id = const Value.absent(),
    this.totalMiles = const Value.absent(),
  });
  static Insertable<OdometerTotalData> custom({
    Expression<int>? id,
    Expression<double>? totalMiles,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (totalMiles != null) 'total_miles': totalMiles,
    });
  }

  OdometerTotalCompanion copyWith({Value<int>? id, Value<double>? totalMiles}) {
    return OdometerTotalCompanion(
      id: id ?? this.id,
      totalMiles: totalMiles ?? this.totalMiles,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (totalMiles.present) {
      map['total_miles'] = Variable<double>(totalMiles.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OdometerTotalCompanion(')
          ..write('id: $id, ')
          ..write('totalMiles: $totalMiles')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SpeedSessionsTable speedSessions = $SpeedSessionsTable(this);
  late final $SpeedRecordsTable speedRecords = $SpeedRecordsTable(this);
  late final $OdometerTotalTable odometerTotal = $OdometerTotalTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [speedSessions, speedRecords, odometerTotal];
}

typedef $$SpeedSessionsTableCreateCompanionBuilder = SpeedSessionsCompanion
    Function({
  Value<int> id,
  required DateTime startTime,
  Value<DateTime?> endTime,
  Value<double> totalDistanceMiles,
  Value<double> maxSpeedMph,
});
typedef $$SpeedSessionsTableUpdateCompanionBuilder = SpeedSessionsCompanion
    Function({
  Value<int> id,
  Value<DateTime> startTime,
  Value<DateTime?> endTime,
  Value<double> totalDistanceMiles,
  Value<double> maxSpeedMph,
});

final class $$SpeedSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SpeedSessionsTable, SpeedSession> {
  $$SpeedSessionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SpeedRecordsTable, List<SpeedRecord>>
      _speedRecordsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.speedRecords,
              aliasName: $_aliasNameGenerator(
                  db.speedSessions.id, db.speedRecords.sessionId));

  $$SpeedRecordsTableProcessedTableManager get speedRecordsRefs {
    final manager = $$SpeedRecordsTableTableManager($_db, $_db.speedRecords)
        .filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_speedRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SpeedSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SpeedSessionsTable> {
  $$SpeedSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalDistanceMiles => $composableBuilder(
      column: $table.totalDistanceMiles,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxSpeedMph => $composableBuilder(
      column: $table.maxSpeedMph, builder: (column) => ColumnFilters(column));

  Expression<bool> speedRecordsRefs(
      Expression<bool> Function($$SpeedRecordsTableFilterComposer f) f) {
    final $$SpeedRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.speedRecords,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeedRecordsTableFilterComposer(
              $db: $db,
              $table: $db.speedRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SpeedSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SpeedSessionsTable> {
  $$SpeedSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalDistanceMiles => $composableBuilder(
      column: $table.totalDistanceMiles,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxSpeedMph => $composableBuilder(
      column: $table.maxSpeedMph, builder: (column) => ColumnOrderings(column));
}

class $$SpeedSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpeedSessionsTable> {
  $$SpeedSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<double> get totalDistanceMiles => $composableBuilder(
      column: $table.totalDistanceMiles, builder: (column) => column);

  GeneratedColumn<double> get maxSpeedMph => $composableBuilder(
      column: $table.maxSpeedMph, builder: (column) => column);

  Expression<T> speedRecordsRefs<T extends Object>(
      Expression<T> Function($$SpeedRecordsTableAnnotationComposer a) f) {
    final $$SpeedRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.speedRecords,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeedRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.speedRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SpeedSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SpeedSessionsTable,
    SpeedSession,
    $$SpeedSessionsTableFilterComposer,
    $$SpeedSessionsTableOrderingComposer,
    $$SpeedSessionsTableAnnotationComposer,
    $$SpeedSessionsTableCreateCompanionBuilder,
    $$SpeedSessionsTableUpdateCompanionBuilder,
    (SpeedSession, $$SpeedSessionsTableReferences),
    SpeedSession,
    PrefetchHooks Function({bool speedRecordsRefs})> {
  $$SpeedSessionsTableTableManager(_$AppDatabase db, $SpeedSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpeedSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpeedSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpeedSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> startTime = const Value.absent(),
            Value<DateTime?> endTime = const Value.absent(),
            Value<double> totalDistanceMiles = const Value.absent(),
            Value<double> maxSpeedMph = const Value.absent(),
          }) =>
              SpeedSessionsCompanion(
            id: id,
            startTime: startTime,
            endTime: endTime,
            totalDistanceMiles: totalDistanceMiles,
            maxSpeedMph: maxSpeedMph,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime startTime,
            Value<DateTime?> endTime = const Value.absent(),
            Value<double> totalDistanceMiles = const Value.absent(),
            Value<double> maxSpeedMph = const Value.absent(),
          }) =>
              SpeedSessionsCompanion.insert(
            id: id,
            startTime: startTime,
            endTime: endTime,
            totalDistanceMiles: totalDistanceMiles,
            maxSpeedMph: maxSpeedMph,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SpeedSessionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({speedRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (speedRecordsRefs) db.speedRecords],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (speedRecordsRefs)
                    await $_getPrefetchedData<SpeedSession, $SpeedSessionsTable,
                            SpeedRecord>(
                        currentTable: table,
                        referencedTable: $$SpeedSessionsTableReferences
                            ._speedRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SpeedSessionsTableReferences(db, table, p0)
                                .speedRecordsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SpeedSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SpeedSessionsTable,
    SpeedSession,
    $$SpeedSessionsTableFilterComposer,
    $$SpeedSessionsTableOrderingComposer,
    $$SpeedSessionsTableAnnotationComposer,
    $$SpeedSessionsTableCreateCompanionBuilder,
    $$SpeedSessionsTableUpdateCompanionBuilder,
    (SpeedSession, $$SpeedSessionsTableReferences),
    SpeedSession,
    PrefetchHooks Function({bool speedRecordsRefs})>;
typedef $$SpeedRecordsTableCreateCompanionBuilder = SpeedRecordsCompanion
    Function({
  Value<int> id,
  required int sessionId,
  required DateTime timestamp,
  required double speedMph,
  Value<double?> latitude,
  Value<double?> longitude,
});
typedef $$SpeedRecordsTableUpdateCompanionBuilder = SpeedRecordsCompanion
    Function({
  Value<int> id,
  Value<int> sessionId,
  Value<DateTime> timestamp,
  Value<double> speedMph,
  Value<double?> latitude,
  Value<double?> longitude,
});

final class $$SpeedRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $SpeedRecordsTable, SpeedRecord> {
  $$SpeedRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SpeedSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.speedSessions.createAlias(
          $_aliasNameGenerator(db.speedRecords.sessionId, db.speedSessions.id));

  $$SpeedSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$SpeedSessionsTableTableManager($_db, $_db.speedSessions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SpeedRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $SpeedRecordsTable> {
  $$SpeedRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get speedMph => $composableBuilder(
      column: $table.speedMph, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  $$SpeedSessionsTableFilterComposer get sessionId {
    final $$SpeedSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.speedSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeedSessionsTableFilterComposer(
              $db: $db,
              $table: $db.speedSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SpeedRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $SpeedRecordsTable> {
  $$SpeedRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get speedMph => $composableBuilder(
      column: $table.speedMph, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  $$SpeedSessionsTableOrderingComposer get sessionId {
    final $$SpeedSessionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.speedSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeedSessionsTableOrderingComposer(
              $db: $db,
              $table: $db.speedSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SpeedRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpeedRecordsTable> {
  $$SpeedRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get speedMph =>
      $composableBuilder(column: $table.speedMph, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  $$SpeedSessionsTableAnnotationComposer get sessionId {
    final $$SpeedSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.speedSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeedSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.speedSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SpeedRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SpeedRecordsTable,
    SpeedRecord,
    $$SpeedRecordsTableFilterComposer,
    $$SpeedRecordsTableOrderingComposer,
    $$SpeedRecordsTableAnnotationComposer,
    $$SpeedRecordsTableCreateCompanionBuilder,
    $$SpeedRecordsTableUpdateCompanionBuilder,
    (SpeedRecord, $$SpeedRecordsTableReferences),
    SpeedRecord,
    PrefetchHooks Function({bool sessionId})> {
  $$SpeedRecordsTableTableManager(_$AppDatabase db, $SpeedRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpeedRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpeedRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpeedRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sessionId = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<double> speedMph = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
          }) =>
              SpeedRecordsCompanion(
            id: id,
            sessionId: sessionId,
            timestamp: timestamp,
            speedMph: speedMph,
            latitude: latitude,
            longitude: longitude,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sessionId,
            required DateTime timestamp,
            required double speedMph,
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
          }) =>
              SpeedRecordsCompanion.insert(
            id: id,
            sessionId: sessionId,
            timestamp: timestamp,
            speedMph: speedMph,
            latitude: latitude,
            longitude: longitude,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SpeedRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (sessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessionId,
                    referencedTable:
                        $$SpeedRecordsTableReferences._sessionIdTable(db),
                    referencedColumn:
                        $$SpeedRecordsTableReferences._sessionIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SpeedRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SpeedRecordsTable,
    SpeedRecord,
    $$SpeedRecordsTableFilterComposer,
    $$SpeedRecordsTableOrderingComposer,
    $$SpeedRecordsTableAnnotationComposer,
    $$SpeedRecordsTableCreateCompanionBuilder,
    $$SpeedRecordsTableUpdateCompanionBuilder,
    (SpeedRecord, $$SpeedRecordsTableReferences),
    SpeedRecord,
    PrefetchHooks Function({bool sessionId})>;
typedef $$OdometerTotalTableCreateCompanionBuilder = OdometerTotalCompanion
    Function({
  Value<int> id,
  Value<double> totalMiles,
});
typedef $$OdometerTotalTableUpdateCompanionBuilder = OdometerTotalCompanion
    Function({
  Value<int> id,
  Value<double> totalMiles,
});

class $$OdometerTotalTableFilterComposer
    extends Composer<_$AppDatabase, $OdometerTotalTable> {
  $$OdometerTotalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalMiles => $composableBuilder(
      column: $table.totalMiles, builder: (column) => ColumnFilters(column));
}

class $$OdometerTotalTableOrderingComposer
    extends Composer<_$AppDatabase, $OdometerTotalTable> {
  $$OdometerTotalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalMiles => $composableBuilder(
      column: $table.totalMiles, builder: (column) => ColumnOrderings(column));
}

class $$OdometerTotalTableAnnotationComposer
    extends Composer<_$AppDatabase, $OdometerTotalTable> {
  $$OdometerTotalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get totalMiles => $composableBuilder(
      column: $table.totalMiles, builder: (column) => column);
}

class $$OdometerTotalTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OdometerTotalTable,
    OdometerTotalData,
    $$OdometerTotalTableFilterComposer,
    $$OdometerTotalTableOrderingComposer,
    $$OdometerTotalTableAnnotationComposer,
    $$OdometerTotalTableCreateCompanionBuilder,
    $$OdometerTotalTableUpdateCompanionBuilder,
    (
      OdometerTotalData,
      BaseReferences<_$AppDatabase, $OdometerTotalTable, OdometerTotalData>
    ),
    OdometerTotalData,
    PrefetchHooks Function()> {
  $$OdometerTotalTableTableManager(_$AppDatabase db, $OdometerTotalTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OdometerTotalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OdometerTotalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OdometerTotalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> totalMiles = const Value.absent(),
          }) =>
              OdometerTotalCompanion(
            id: id,
            totalMiles: totalMiles,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> totalMiles = const Value.absent(),
          }) =>
              OdometerTotalCompanion.insert(
            id: id,
            totalMiles: totalMiles,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OdometerTotalTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OdometerTotalTable,
    OdometerTotalData,
    $$OdometerTotalTableFilterComposer,
    $$OdometerTotalTableOrderingComposer,
    $$OdometerTotalTableAnnotationComposer,
    $$OdometerTotalTableCreateCompanionBuilder,
    $$OdometerTotalTableUpdateCompanionBuilder,
    (
      OdometerTotalData,
      BaseReferences<_$AppDatabase, $OdometerTotalTable, OdometerTotalData>
    ),
    OdometerTotalData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SpeedSessionsTableTableManager get speedSessions =>
      $$SpeedSessionsTableTableManager(_db, _db.speedSessions);
  $$SpeedRecordsTableTableManager get speedRecords =>
      $$SpeedRecordsTableTableManager(_db, _db.speedRecords);
  $$OdometerTotalTableTableManager get odometerTotal =>
      $$OdometerTotalTableTableManager(_db, _db.odometerTotal);
}
