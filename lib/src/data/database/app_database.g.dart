// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MeetingRowsTable extends MeetingRows
    with TableInfo<$MeetingRowsTable, MeetingRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeetingRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPinnedMeta = const VerificationMeta(
    'isPinned',
  );
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('auto'),
  );
  static const VerificationMeta _summaryPreviewMeta = const VerificationMeta(
    'summaryPreview',
  );
  @override
  late final GeneratedColumn<String> summaryPreview = GeneratedColumn<String>(
    'summary_preview',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsJsonMeta = const VerificationMeta(
    'tagsJson',
  );
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
    'tags_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    createdAt,
    startedAt,
    endedAt,
    durationMs,
    status,
    isPinned,
    isFavorite,
    languageCode,
    summaryPreview,
    tagsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meeting_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<MeetingRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    }
    if (data.containsKey('summary_preview')) {
      context.handle(
        _summaryPreviewMeta,
        summaryPreview.isAcceptableOrUnknown(
          data['summary_preview']!,
          _summaryPreviewMeta,
        ),
      );
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MeetingRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeetingRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pinned'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      )!,
      summaryPreview: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary_preview'],
      ),
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
      )!,
    );
  }

  @override
  $MeetingRowsTable createAlias(String alias) {
    return $MeetingRowsTable(attachedDatabase, alias);
  }
}

class MeetingRecord extends DataClass implements Insertable<MeetingRecord> {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int durationMs;
  final String status;
  final bool isPinned;
  final bool isFavorite;
  final String languageCode;
  final String? summaryPreview;
  final String tagsJson;
  const MeetingRecord({
    required this.id,
    required this.title,
    required this.createdAt,
    this.startedAt,
    this.endedAt,
    required this.durationMs,
    required this.status,
    required this.isPinned,
    required this.isFavorite,
    required this.languageCode,
    this.summaryPreview,
    required this.tagsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['duration_ms'] = Variable<int>(durationMs);
    map['status'] = Variable<String>(status);
    map['is_pinned'] = Variable<bool>(isPinned);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['language_code'] = Variable<String>(languageCode);
    if (!nullToAbsent || summaryPreview != null) {
      map['summary_preview'] = Variable<String>(summaryPreview);
    }
    map['tags_json'] = Variable<String>(tagsJson);
    return map;
  }

  MeetingRowsCompanion toCompanion(bool nullToAbsent) {
    return MeetingRowsCompanion(
      id: Value(id),
      title: Value(title),
      createdAt: Value(createdAt),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      durationMs: Value(durationMs),
      status: Value(status),
      isPinned: Value(isPinned),
      isFavorite: Value(isFavorite),
      languageCode: Value(languageCode),
      summaryPreview: summaryPreview == null && nullToAbsent
          ? const Value.absent()
          : Value(summaryPreview),
      tagsJson: Value(tagsJson),
    );
  }

  factory MeetingRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeetingRecord(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      status: serializer.fromJson<String>(json['status']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      summaryPreview: serializer.fromJson<String?>(json['summaryPreview']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'durationMs': serializer.toJson<int>(durationMs),
      'status': serializer.toJson<String>(status),
      'isPinned': serializer.toJson<bool>(isPinned),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'languageCode': serializer.toJson<String>(languageCode),
      'summaryPreview': serializer.toJson<String?>(summaryPreview),
      'tagsJson': serializer.toJson<String>(tagsJson),
    };
  }

  MeetingRecord copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> endedAt = const Value.absent(),
    int? durationMs,
    String? status,
    bool? isPinned,
    bool? isFavorite,
    String? languageCode,
    Value<String?> summaryPreview = const Value.absent(),
    String? tagsJson,
  }) => MeetingRecord(
    id: id ?? this.id,
    title: title ?? this.title,
    createdAt: createdAt ?? this.createdAt,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    durationMs: durationMs ?? this.durationMs,
    status: status ?? this.status,
    isPinned: isPinned ?? this.isPinned,
    isFavorite: isFavorite ?? this.isFavorite,
    languageCode: languageCode ?? this.languageCode,
    summaryPreview: summaryPreview.present
        ? summaryPreview.value
        : this.summaryPreview,
    tagsJson: tagsJson ?? this.tagsJson,
  );
  MeetingRecord copyWithCompanion(MeetingRowsCompanion data) {
    return MeetingRecord(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      status: data.status.present ? data.status.value : this.status,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      summaryPreview: data.summaryPreview.present
          ? data.summaryPreview.value
          : this.summaryPreview,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeetingRecord(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationMs: $durationMs, ')
          ..write('status: $status, ')
          ..write('isPinned: $isPinned, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('languageCode: $languageCode, ')
          ..write('summaryPreview: $summaryPreview, ')
          ..write('tagsJson: $tagsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    createdAt,
    startedAt,
    endedAt,
    durationMs,
    status,
    isPinned,
    isFavorite,
    languageCode,
    summaryPreview,
    tagsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeetingRecord &&
          other.id == this.id &&
          other.title == this.title &&
          other.createdAt == this.createdAt &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.durationMs == this.durationMs &&
          other.status == this.status &&
          other.isPinned == this.isPinned &&
          other.isFavorite == this.isFavorite &&
          other.languageCode == this.languageCode &&
          other.summaryPreview == this.summaryPreview &&
          other.tagsJson == this.tagsJson);
}

class MeetingRowsCompanion extends UpdateCompanion<MeetingRecord> {
  final Value<String> id;
  final Value<String> title;
  final Value<DateTime> createdAt;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> durationMs;
  final Value<String> status;
  final Value<bool> isPinned;
  final Value<bool> isFavorite;
  final Value<String> languageCode;
  final Value<String?> summaryPreview;
  final Value<String> tagsJson;
  final Value<int> rowid;
  const MeetingRowsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.status = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.summaryPreview = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeetingRowsCompanion.insert({
    required String id,
    required String title,
    required DateTime createdAt,
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationMs = const Value.absent(),
    required String status,
    this.isPinned = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.summaryPreview = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       createdAt = Value(createdAt),
       status = Value(status);
  static Insertable<MeetingRecord> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? durationMs,
    Expression<String>? status,
    Expression<bool>? isPinned,
    Expression<bool>? isFavorite,
    Expression<String>? languageCode,
    Expression<String>? summaryPreview,
    Expression<String>? tagsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (durationMs != null) 'duration_ms': durationMs,
      if (status != null) 'status': status,
      if (isPinned != null) 'is_pinned': isPinned,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (languageCode != null) 'language_code': languageCode,
      if (summaryPreview != null) 'summary_preview': summaryPreview,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeetingRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<DateTime>? createdAt,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int>? durationMs,
    Value<String>? status,
    Value<bool>? isPinned,
    Value<bool>? isFavorite,
    Value<String>? languageCode,
    Value<String?>? summaryPreview,
    Value<String>? tagsJson,
    Value<int>? rowid,
  }) {
    return MeetingRowsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationMs: durationMs ?? this.durationMs,
      status: status ?? this.status,
      isPinned: isPinned ?? this.isPinned,
      isFavorite: isFavorite ?? this.isFavorite,
      languageCode: languageCode ?? this.languageCode,
      summaryPreview: summaryPreview ?? this.summaryPreview,
      tagsJson: tagsJson ?? this.tagsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (summaryPreview.present) {
      map['summary_preview'] = Variable<String>(summaryPreview.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeetingRowsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationMs: $durationMs, ')
          ..write('status: $status, ')
          ..write('isPinned: $isPinned, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('languageCode: $languageCode, ')
          ..write('summaryPreview: $summaryPreview, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AudioAssetRowsTable extends AudioAssetRows
    with TableInfo<$AudioAssetRowsTable, AudioAssetRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AudioAssetRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meetingIdMeta = const VerificationMeta(
    'meetingId',
  );
  @override
  late final GeneratedColumn<String> meetingId = GeneratedColumn<String>(
    'meeting_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meeting_rows (id)',
    ),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sampleRateMeta = const VerificationMeta(
    'sampleRate',
  );
  @override
  late final GeneratedColumn<int> sampleRate = GeneratedColumn<int>(
    'sample_rate',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _channelsMeta = const VerificationMeta(
    'channels',
  );
  @override
  late final GeneratedColumn<int> channels = GeneratedColumn<int>(
    'channels',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _byteSizeMeta = const VerificationMeta(
    'byteSize',
  );
  @override
  late final GeneratedColumn<int> byteSize = GeneratedColumn<int>(
    'byte_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    meetingId,
    source,
    path,
    sampleRate,
    channels,
    durationMs,
    byteSize,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audio_asset_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<AudioAssetRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('meeting_id')) {
      context.handle(
        _meetingIdMeta,
        meetingId.isAcceptableOrUnknown(data['meeting_id']!, _meetingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_meetingIdMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('sample_rate')) {
      context.handle(
        _sampleRateMeta,
        sampleRate.isAcceptableOrUnknown(data['sample_rate']!, _sampleRateMeta),
      );
    } else if (isInserting) {
      context.missing(_sampleRateMeta);
    }
    if (data.containsKey('channels')) {
      context.handle(
        _channelsMeta,
        channels.isAcceptableOrUnknown(data['channels']!, _channelsMeta),
      );
    } else if (isInserting) {
      context.missing(_channelsMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('byte_size')) {
      context.handle(
        _byteSizeMeta,
        byteSize.isAcceptableOrUnknown(data['byte_size']!, _byteSizeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AudioAssetRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AudioAssetRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      meetingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meeting_id'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      sampleRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sample_rate'],
      )!,
      channels: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}channels'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      byteSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}byte_size'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AudioAssetRowsTable createAlias(String alias) {
    return $AudioAssetRowsTable(attachedDatabase, alias);
  }
}

class AudioAssetRecord extends DataClass
    implements Insertable<AudioAssetRecord> {
  final String id;
  final String meetingId;
  final String source;
  final String path;
  final int sampleRate;
  final int channels;
  final int durationMs;
  final int byteSize;
  final DateTime createdAt;
  const AudioAssetRecord({
    required this.id,
    required this.meetingId,
    required this.source,
    required this.path,
    required this.sampleRate,
    required this.channels,
    required this.durationMs,
    required this.byteSize,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['meeting_id'] = Variable<String>(meetingId);
    map['source'] = Variable<String>(source);
    map['path'] = Variable<String>(path);
    map['sample_rate'] = Variable<int>(sampleRate);
    map['channels'] = Variable<int>(channels);
    map['duration_ms'] = Variable<int>(durationMs);
    map['byte_size'] = Variable<int>(byteSize);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AudioAssetRowsCompanion toCompanion(bool nullToAbsent) {
    return AudioAssetRowsCompanion(
      id: Value(id),
      meetingId: Value(meetingId),
      source: Value(source),
      path: Value(path),
      sampleRate: Value(sampleRate),
      channels: Value(channels),
      durationMs: Value(durationMs),
      byteSize: Value(byteSize),
      createdAt: Value(createdAt),
    );
  }

  factory AudioAssetRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AudioAssetRecord(
      id: serializer.fromJson<String>(json['id']),
      meetingId: serializer.fromJson<String>(json['meetingId']),
      source: serializer.fromJson<String>(json['source']),
      path: serializer.fromJson<String>(json['path']),
      sampleRate: serializer.fromJson<int>(json['sampleRate']),
      channels: serializer.fromJson<int>(json['channels']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      byteSize: serializer.fromJson<int>(json['byteSize']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'meetingId': serializer.toJson<String>(meetingId),
      'source': serializer.toJson<String>(source),
      'path': serializer.toJson<String>(path),
      'sampleRate': serializer.toJson<int>(sampleRate),
      'channels': serializer.toJson<int>(channels),
      'durationMs': serializer.toJson<int>(durationMs),
      'byteSize': serializer.toJson<int>(byteSize),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AudioAssetRecord copyWith({
    String? id,
    String? meetingId,
    String? source,
    String? path,
    int? sampleRate,
    int? channels,
    int? durationMs,
    int? byteSize,
    DateTime? createdAt,
  }) => AudioAssetRecord(
    id: id ?? this.id,
    meetingId: meetingId ?? this.meetingId,
    source: source ?? this.source,
    path: path ?? this.path,
    sampleRate: sampleRate ?? this.sampleRate,
    channels: channels ?? this.channels,
    durationMs: durationMs ?? this.durationMs,
    byteSize: byteSize ?? this.byteSize,
    createdAt: createdAt ?? this.createdAt,
  );
  AudioAssetRecord copyWithCompanion(AudioAssetRowsCompanion data) {
    return AudioAssetRecord(
      id: data.id.present ? data.id.value : this.id,
      meetingId: data.meetingId.present ? data.meetingId.value : this.meetingId,
      source: data.source.present ? data.source.value : this.source,
      path: data.path.present ? data.path.value : this.path,
      sampleRate: data.sampleRate.present
          ? data.sampleRate.value
          : this.sampleRate,
      channels: data.channels.present ? data.channels.value : this.channels,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      byteSize: data.byteSize.present ? data.byteSize.value : this.byteSize,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AudioAssetRecord(')
          ..write('id: $id, ')
          ..write('meetingId: $meetingId, ')
          ..write('source: $source, ')
          ..write('path: $path, ')
          ..write('sampleRate: $sampleRate, ')
          ..write('channels: $channels, ')
          ..write('durationMs: $durationMs, ')
          ..write('byteSize: $byteSize, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    meetingId,
    source,
    path,
    sampleRate,
    channels,
    durationMs,
    byteSize,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AudioAssetRecord &&
          other.id == this.id &&
          other.meetingId == this.meetingId &&
          other.source == this.source &&
          other.path == this.path &&
          other.sampleRate == this.sampleRate &&
          other.channels == this.channels &&
          other.durationMs == this.durationMs &&
          other.byteSize == this.byteSize &&
          other.createdAt == this.createdAt);
}

class AudioAssetRowsCompanion extends UpdateCompanion<AudioAssetRecord> {
  final Value<String> id;
  final Value<String> meetingId;
  final Value<String> source;
  final Value<String> path;
  final Value<int> sampleRate;
  final Value<int> channels;
  final Value<int> durationMs;
  final Value<int> byteSize;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AudioAssetRowsCompanion({
    this.id = const Value.absent(),
    this.meetingId = const Value.absent(),
    this.source = const Value.absent(),
    this.path = const Value.absent(),
    this.sampleRate = const Value.absent(),
    this.channels = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.byteSize = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AudioAssetRowsCompanion.insert({
    required String id,
    required String meetingId,
    required String source,
    required String path,
    required int sampleRate,
    required int channels,
    this.durationMs = const Value.absent(),
    this.byteSize = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       meetingId = Value(meetingId),
       source = Value(source),
       path = Value(path),
       sampleRate = Value(sampleRate),
       channels = Value(channels),
       createdAt = Value(createdAt);
  static Insertable<AudioAssetRecord> custom({
    Expression<String>? id,
    Expression<String>? meetingId,
    Expression<String>? source,
    Expression<String>? path,
    Expression<int>? sampleRate,
    Expression<int>? channels,
    Expression<int>? durationMs,
    Expression<int>? byteSize,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (meetingId != null) 'meeting_id': meetingId,
      if (source != null) 'source': source,
      if (path != null) 'path': path,
      if (sampleRate != null) 'sample_rate': sampleRate,
      if (channels != null) 'channels': channels,
      if (durationMs != null) 'duration_ms': durationMs,
      if (byteSize != null) 'byte_size': byteSize,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AudioAssetRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? meetingId,
    Value<String>? source,
    Value<String>? path,
    Value<int>? sampleRate,
    Value<int>? channels,
    Value<int>? durationMs,
    Value<int>? byteSize,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AudioAssetRowsCompanion(
      id: id ?? this.id,
      meetingId: meetingId ?? this.meetingId,
      source: source ?? this.source,
      path: path ?? this.path,
      sampleRate: sampleRate ?? this.sampleRate,
      channels: channels ?? this.channels,
      durationMs: durationMs ?? this.durationMs,
      byteSize: byteSize ?? this.byteSize,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (meetingId.present) {
      map['meeting_id'] = Variable<String>(meetingId.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (sampleRate.present) {
      map['sample_rate'] = Variable<int>(sampleRate.value);
    }
    if (channels.present) {
      map['channels'] = Variable<int>(channels.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (byteSize.present) {
      map['byte_size'] = Variable<int>(byteSize.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AudioAssetRowsCompanion(')
          ..write('id: $id, ')
          ..write('meetingId: $meetingId, ')
          ..write('source: $source, ')
          ..write('path: $path, ')
          ..write('sampleRate: $sampleRate, ')
          ..write('channels: $channels, ')
          ..write('durationMs: $durationMs, ')
          ..write('byteSize: $byteSize, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TranscriptSegmentRowsTable extends TranscriptSegmentRows
    with TableInfo<$TranscriptSegmentRowsTable, TranscriptSegmentRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TranscriptSegmentRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meetingIdMeta = const VerificationMeta(
    'meetingId',
  );
  @override
  late final GeneratedColumn<String> meetingId = GeneratedColumn<String>(
    'meeting_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meeting_rows (id)',
    ),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speakerLabelMeta = const VerificationMeta(
    'speakerLabel',
  );
  @override
  late final GeneratedColumn<String> speakerLabel = GeneratedColumn<String>(
    'speaker_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startMsMeta = const VerificationMeta(
    'startMs',
  );
  @override
  late final GeneratedColumn<int> startMs = GeneratedColumn<int>(
    'start_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMsMeta = const VerificationMeta('endMs');
  @override
  late final GeneratedColumn<int> endMs = GeneratedColumn<int>(
    'end_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFinalMeta = const VerificationMeta(
    'isFinal',
  );
  @override
  late final GeneratedColumn<bool> isFinal = GeneratedColumn<bool>(
    'is_final',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_final" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _tagsJsonMeta = const VerificationMeta(
    'tagsJson',
  );
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
    'tags_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    meetingId,
    source,
    speakerLabel,
    startMs,
    endMs,
    content,
    confidence,
    isFinal,
    tagsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transcript_segment_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<TranscriptSegmentRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('meeting_id')) {
      context.handle(
        _meetingIdMeta,
        meetingId.isAcceptableOrUnknown(data['meeting_id']!, _meetingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_meetingIdMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('speaker_label')) {
      context.handle(
        _speakerLabelMeta,
        speakerLabel.isAcceptableOrUnknown(
          data['speaker_label']!,
          _speakerLabelMeta,
        ),
      );
    }
    if (data.containsKey('start_ms')) {
      context.handle(
        _startMsMeta,
        startMs.isAcceptableOrUnknown(data['start_ms']!, _startMsMeta),
      );
    } else if (isInserting) {
      context.missing(_startMsMeta);
    }
    if (data.containsKey('end_ms')) {
      context.handle(
        _endMsMeta,
        endMs.isAcceptableOrUnknown(data['end_ms']!, _endMsMeta),
      );
    } else if (isInserting) {
      context.missing(_endMsMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['text']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('is_final')) {
      context.handle(
        _isFinalMeta,
        isFinal.isAcceptableOrUnknown(data['is_final']!, _isFinalMeta),
      );
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TranscriptSegmentRecord map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TranscriptSegmentRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      meetingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meeting_id'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      speakerLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}speaker_label'],
      ),
      startMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_ms'],
      )!,
      endMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_ms'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      ),
      isFinal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_final'],
      )!,
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
      )!,
    );
  }

  @override
  $TranscriptSegmentRowsTable createAlias(String alias) {
    return $TranscriptSegmentRowsTable(attachedDatabase, alias);
  }
}

class TranscriptSegmentRecord extends DataClass
    implements Insertable<TranscriptSegmentRecord> {
  final String id;
  final String meetingId;
  final String source;
  final String? speakerLabel;
  final int startMs;
  final int endMs;
  final String content;
  final double? confidence;
  final bool isFinal;
  final String tagsJson;
  const TranscriptSegmentRecord({
    required this.id,
    required this.meetingId,
    required this.source,
    this.speakerLabel,
    required this.startMs,
    required this.endMs,
    required this.content,
    this.confidence,
    required this.isFinal,
    required this.tagsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['meeting_id'] = Variable<String>(meetingId);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || speakerLabel != null) {
      map['speaker_label'] = Variable<String>(speakerLabel);
    }
    map['start_ms'] = Variable<int>(startMs);
    map['end_ms'] = Variable<int>(endMs);
    map['text'] = Variable<String>(content);
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    map['is_final'] = Variable<bool>(isFinal);
    map['tags_json'] = Variable<String>(tagsJson);
    return map;
  }

  TranscriptSegmentRowsCompanion toCompanion(bool nullToAbsent) {
    return TranscriptSegmentRowsCompanion(
      id: Value(id),
      meetingId: Value(meetingId),
      source: Value(source),
      speakerLabel: speakerLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(speakerLabel),
      startMs: Value(startMs),
      endMs: Value(endMs),
      content: Value(content),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      isFinal: Value(isFinal),
      tagsJson: Value(tagsJson),
    );
  }

  factory TranscriptSegmentRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TranscriptSegmentRecord(
      id: serializer.fromJson<String>(json['id']),
      meetingId: serializer.fromJson<String>(json['meetingId']),
      source: serializer.fromJson<String>(json['source']),
      speakerLabel: serializer.fromJson<String?>(json['speakerLabel']),
      startMs: serializer.fromJson<int>(json['startMs']),
      endMs: serializer.fromJson<int>(json['endMs']),
      content: serializer.fromJson<String>(json['content']),
      confidence: serializer.fromJson<double?>(json['confidence']),
      isFinal: serializer.fromJson<bool>(json['isFinal']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'meetingId': serializer.toJson<String>(meetingId),
      'source': serializer.toJson<String>(source),
      'speakerLabel': serializer.toJson<String?>(speakerLabel),
      'startMs': serializer.toJson<int>(startMs),
      'endMs': serializer.toJson<int>(endMs),
      'content': serializer.toJson<String>(content),
      'confidence': serializer.toJson<double?>(confidence),
      'isFinal': serializer.toJson<bool>(isFinal),
      'tagsJson': serializer.toJson<String>(tagsJson),
    };
  }

  TranscriptSegmentRecord copyWith({
    String? id,
    String? meetingId,
    String? source,
    Value<String?> speakerLabel = const Value.absent(),
    int? startMs,
    int? endMs,
    String? content,
    Value<double?> confidence = const Value.absent(),
    bool? isFinal,
    String? tagsJson,
  }) => TranscriptSegmentRecord(
    id: id ?? this.id,
    meetingId: meetingId ?? this.meetingId,
    source: source ?? this.source,
    speakerLabel: speakerLabel.present ? speakerLabel.value : this.speakerLabel,
    startMs: startMs ?? this.startMs,
    endMs: endMs ?? this.endMs,
    content: content ?? this.content,
    confidence: confidence.present ? confidence.value : this.confidence,
    isFinal: isFinal ?? this.isFinal,
    tagsJson: tagsJson ?? this.tagsJson,
  );
  TranscriptSegmentRecord copyWithCompanion(
    TranscriptSegmentRowsCompanion data,
  ) {
    return TranscriptSegmentRecord(
      id: data.id.present ? data.id.value : this.id,
      meetingId: data.meetingId.present ? data.meetingId.value : this.meetingId,
      source: data.source.present ? data.source.value : this.source,
      speakerLabel: data.speakerLabel.present
          ? data.speakerLabel.value
          : this.speakerLabel,
      startMs: data.startMs.present ? data.startMs.value : this.startMs,
      endMs: data.endMs.present ? data.endMs.value : this.endMs,
      content: data.content.present ? data.content.value : this.content,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      isFinal: data.isFinal.present ? data.isFinal.value : this.isFinal,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TranscriptSegmentRecord(')
          ..write('id: $id, ')
          ..write('meetingId: $meetingId, ')
          ..write('source: $source, ')
          ..write('speakerLabel: $speakerLabel, ')
          ..write('startMs: $startMs, ')
          ..write('endMs: $endMs, ')
          ..write('content: $content, ')
          ..write('confidence: $confidence, ')
          ..write('isFinal: $isFinal, ')
          ..write('tagsJson: $tagsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    meetingId,
    source,
    speakerLabel,
    startMs,
    endMs,
    content,
    confidence,
    isFinal,
    tagsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TranscriptSegmentRecord &&
          other.id == this.id &&
          other.meetingId == this.meetingId &&
          other.source == this.source &&
          other.speakerLabel == this.speakerLabel &&
          other.startMs == this.startMs &&
          other.endMs == this.endMs &&
          other.content == this.content &&
          other.confidence == this.confidence &&
          other.isFinal == this.isFinal &&
          other.tagsJson == this.tagsJson);
}

class TranscriptSegmentRowsCompanion
    extends UpdateCompanion<TranscriptSegmentRecord> {
  final Value<String> id;
  final Value<String> meetingId;
  final Value<String> source;
  final Value<String?> speakerLabel;
  final Value<int> startMs;
  final Value<int> endMs;
  final Value<String> content;
  final Value<double?> confidence;
  final Value<bool> isFinal;
  final Value<String> tagsJson;
  final Value<int> rowid;
  const TranscriptSegmentRowsCompanion({
    this.id = const Value.absent(),
    this.meetingId = const Value.absent(),
    this.source = const Value.absent(),
    this.speakerLabel = const Value.absent(),
    this.startMs = const Value.absent(),
    this.endMs = const Value.absent(),
    this.content = const Value.absent(),
    this.confidence = const Value.absent(),
    this.isFinal = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TranscriptSegmentRowsCompanion.insert({
    required String id,
    required String meetingId,
    required String source,
    this.speakerLabel = const Value.absent(),
    required int startMs,
    required int endMs,
    required String content,
    this.confidence = const Value.absent(),
    this.isFinal = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       meetingId = Value(meetingId),
       source = Value(source),
       startMs = Value(startMs),
       endMs = Value(endMs),
       content = Value(content);
  static Insertable<TranscriptSegmentRecord> custom({
    Expression<String>? id,
    Expression<String>? meetingId,
    Expression<String>? source,
    Expression<String>? speakerLabel,
    Expression<int>? startMs,
    Expression<int>? endMs,
    Expression<String>? content,
    Expression<double>? confidence,
    Expression<bool>? isFinal,
    Expression<String>? tagsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (meetingId != null) 'meeting_id': meetingId,
      if (source != null) 'source': source,
      if (speakerLabel != null) 'speaker_label': speakerLabel,
      if (startMs != null) 'start_ms': startMs,
      if (endMs != null) 'end_ms': endMs,
      if (content != null) 'text': content,
      if (confidence != null) 'confidence': confidence,
      if (isFinal != null) 'is_final': isFinal,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TranscriptSegmentRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? meetingId,
    Value<String>? source,
    Value<String?>? speakerLabel,
    Value<int>? startMs,
    Value<int>? endMs,
    Value<String>? content,
    Value<double?>? confidence,
    Value<bool>? isFinal,
    Value<String>? tagsJson,
    Value<int>? rowid,
  }) {
    return TranscriptSegmentRowsCompanion(
      id: id ?? this.id,
      meetingId: meetingId ?? this.meetingId,
      source: source ?? this.source,
      speakerLabel: speakerLabel ?? this.speakerLabel,
      startMs: startMs ?? this.startMs,
      endMs: endMs ?? this.endMs,
      content: content ?? this.content,
      confidence: confidence ?? this.confidence,
      isFinal: isFinal ?? this.isFinal,
      tagsJson: tagsJson ?? this.tagsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (meetingId.present) {
      map['meeting_id'] = Variable<String>(meetingId.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (speakerLabel.present) {
      map['speaker_label'] = Variable<String>(speakerLabel.value);
    }
    if (startMs.present) {
      map['start_ms'] = Variable<int>(startMs.value);
    }
    if (endMs.present) {
      map['end_ms'] = Variable<int>(endMs.value);
    }
    if (content.present) {
      map['text'] = Variable<String>(content.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (isFinal.present) {
      map['is_final'] = Variable<bool>(isFinal.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TranscriptSegmentRowsCompanion(')
          ..write('id: $id, ')
          ..write('meetingId: $meetingId, ')
          ..write('source: $source, ')
          ..write('speakerLabel: $speakerLabel, ')
          ..write('startMs: $startMs, ')
          ..write('endMs: $endMs, ')
          ..write('content: $content, ')
          ..write('confidence: $confidence, ')
          ..write('isFinal: $isFinal, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SummaryRowsTable extends SummaryRows
    with TableInfo<$SummaryRowsTable, SummaryRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SummaryRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _meetingIdMeta = const VerificationMeta(
    'meetingId',
  );
  @override
  late final GeneratedColumn<String> meetingId = GeneratedColumn<String>(
    'meeting_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meeting_rows (id)',
    ),
  );
  static const VerificationMeta _generatedTitleMeta = const VerificationMeta(
    'generatedTitle',
  );
  @override
  late final GeneratedColumn<String> generatedTitle = GeneratedColumn<String>(
    'generated_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _overviewMeta = const VerificationMeta(
    'overview',
  );
  @override
  late final GeneratedColumn<String> overview = GeneratedColumn<String>(
    'overview',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryJsonMeta = const VerificationMeta(
    'summaryJson',
  );
  @override
  late final GeneratedColumn<String> summaryJson = GeneratedColumn<String>(
    'summary_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    meetingId,
    generatedTitle,
    overview,
    summaryJson,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'summary_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<SummaryRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('meeting_id')) {
      context.handle(
        _meetingIdMeta,
        meetingId.isAcceptableOrUnknown(data['meeting_id']!, _meetingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_meetingIdMeta);
    }
    if (data.containsKey('generated_title')) {
      context.handle(
        _generatedTitleMeta,
        generatedTitle.isAcceptableOrUnknown(
          data['generated_title']!,
          _generatedTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generatedTitleMeta);
    }
    if (data.containsKey('overview')) {
      context.handle(
        _overviewMeta,
        overview.isAcceptableOrUnknown(data['overview']!, _overviewMeta),
      );
    } else if (isInserting) {
      context.missing(_overviewMeta);
    }
    if (data.containsKey('summary_json')) {
      context.handle(
        _summaryJsonMeta,
        summaryJson.isAcceptableOrUnknown(
          data['summary_json']!,
          _summaryJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_summaryJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {meetingId};
  @override
  SummaryRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SummaryRecord(
      meetingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meeting_id'],
      )!,
      generatedTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}generated_title'],
      )!,
      overview: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}overview'],
      )!,
      summaryJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SummaryRowsTable createAlias(String alias) {
    return $SummaryRowsTable(attachedDatabase, alias);
  }
}

class SummaryRecord extends DataClass implements Insertable<SummaryRecord> {
  final String meetingId;
  final String generatedTitle;
  final String overview;
  final String summaryJson;
  final DateTime createdAt;
  const SummaryRecord({
    required this.meetingId,
    required this.generatedTitle,
    required this.overview,
    required this.summaryJson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['meeting_id'] = Variable<String>(meetingId);
    map['generated_title'] = Variable<String>(generatedTitle);
    map['overview'] = Variable<String>(overview);
    map['summary_json'] = Variable<String>(summaryJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SummaryRowsCompanion toCompanion(bool nullToAbsent) {
    return SummaryRowsCompanion(
      meetingId: Value(meetingId),
      generatedTitle: Value(generatedTitle),
      overview: Value(overview),
      summaryJson: Value(summaryJson),
      createdAt: Value(createdAt),
    );
  }

  factory SummaryRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SummaryRecord(
      meetingId: serializer.fromJson<String>(json['meetingId']),
      generatedTitle: serializer.fromJson<String>(json['generatedTitle']),
      overview: serializer.fromJson<String>(json['overview']),
      summaryJson: serializer.fromJson<String>(json['summaryJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'meetingId': serializer.toJson<String>(meetingId),
      'generatedTitle': serializer.toJson<String>(generatedTitle),
      'overview': serializer.toJson<String>(overview),
      'summaryJson': serializer.toJson<String>(summaryJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SummaryRecord copyWith({
    String? meetingId,
    String? generatedTitle,
    String? overview,
    String? summaryJson,
    DateTime? createdAt,
  }) => SummaryRecord(
    meetingId: meetingId ?? this.meetingId,
    generatedTitle: generatedTitle ?? this.generatedTitle,
    overview: overview ?? this.overview,
    summaryJson: summaryJson ?? this.summaryJson,
    createdAt: createdAt ?? this.createdAt,
  );
  SummaryRecord copyWithCompanion(SummaryRowsCompanion data) {
    return SummaryRecord(
      meetingId: data.meetingId.present ? data.meetingId.value : this.meetingId,
      generatedTitle: data.generatedTitle.present
          ? data.generatedTitle.value
          : this.generatedTitle,
      overview: data.overview.present ? data.overview.value : this.overview,
      summaryJson: data.summaryJson.present
          ? data.summaryJson.value
          : this.summaryJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SummaryRecord(')
          ..write('meetingId: $meetingId, ')
          ..write('generatedTitle: $generatedTitle, ')
          ..write('overview: $overview, ')
          ..write('summaryJson: $summaryJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(meetingId, generatedTitle, overview, summaryJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SummaryRecord &&
          other.meetingId == this.meetingId &&
          other.generatedTitle == this.generatedTitle &&
          other.overview == this.overview &&
          other.summaryJson == this.summaryJson &&
          other.createdAt == this.createdAt);
}

class SummaryRowsCompanion extends UpdateCompanion<SummaryRecord> {
  final Value<String> meetingId;
  final Value<String> generatedTitle;
  final Value<String> overview;
  final Value<String> summaryJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SummaryRowsCompanion({
    this.meetingId = const Value.absent(),
    this.generatedTitle = const Value.absent(),
    this.overview = const Value.absent(),
    this.summaryJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SummaryRowsCompanion.insert({
    required String meetingId,
    required String generatedTitle,
    required String overview,
    required String summaryJson,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : meetingId = Value(meetingId),
       generatedTitle = Value(generatedTitle),
       overview = Value(overview),
       summaryJson = Value(summaryJson),
       createdAt = Value(createdAt);
  static Insertable<SummaryRecord> custom({
    Expression<String>? meetingId,
    Expression<String>? generatedTitle,
    Expression<String>? overview,
    Expression<String>? summaryJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (meetingId != null) 'meeting_id': meetingId,
      if (generatedTitle != null) 'generated_title': generatedTitle,
      if (overview != null) 'overview': overview,
      if (summaryJson != null) 'summary_json': summaryJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SummaryRowsCompanion copyWith({
    Value<String>? meetingId,
    Value<String>? generatedTitle,
    Value<String>? overview,
    Value<String>? summaryJson,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SummaryRowsCompanion(
      meetingId: meetingId ?? this.meetingId,
      generatedTitle: generatedTitle ?? this.generatedTitle,
      overview: overview ?? this.overview,
      summaryJson: summaryJson ?? this.summaryJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (meetingId.present) {
      map['meeting_id'] = Variable<String>(meetingId.value);
    }
    if (generatedTitle.present) {
      map['generated_title'] = Variable<String>(generatedTitle.value);
    }
    if (overview.present) {
      map['overview'] = Variable<String>(overview.value);
    }
    if (summaryJson.present) {
      map['summary_json'] = Variable<String>(summaryJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SummaryRowsCompanion(')
          ..write('meetingId: $meetingId, ')
          ..write('generatedTitle: $generatedTitle, ')
          ..write('overview: $overview, ')
          ..write('summaryJson: $summaryJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActionItemRowsTable extends ActionItemRows
    with TableInfo<$ActionItemRowsTable, ActionItemRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActionItemRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meetingIdMeta = const VerificationMeta(
    'meetingId',
  );
  @override
  late final GeneratedColumn<String> meetingId = GeneratedColumn<String>(
    'meeting_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meeting_rows (id)',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerMeta = const VerificationMeta('owner');
  @override
  late final GeneratedColumn<String> owner = GeneratedColumn<String>(
    'owner',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _evidenceJsonMeta = const VerificationMeta(
    'evidenceJson',
  );
  @override
  late final GeneratedColumn<String> evidenceJson = GeneratedColumn<String>(
    'evidence_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    meetingId,
    content,
    owner,
    dueDate,
    done,
    evidenceJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'action_item_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActionItemRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('meeting_id')) {
      context.handle(
        _meetingIdMeta,
        meetingId.isAcceptableOrUnknown(data['meeting_id']!, _meetingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_meetingIdMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['text']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('owner')) {
      context.handle(
        _ownerMeta,
        owner.isAcceptableOrUnknown(data['owner']!, _ownerMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    if (data.containsKey('evidence_json')) {
      context.handle(
        _evidenceJsonMeta,
        evidenceJson.isAcceptableOrUnknown(
          data['evidence_json']!,
          _evidenceJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActionItemRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActionItemRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      meetingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meeting_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      owner: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_date'],
      ),
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
      evidenceJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evidence_json'],
      )!,
    );
  }

  @override
  $ActionItemRowsTable createAlias(String alias) {
    return $ActionItemRowsTable(attachedDatabase, alias);
  }
}

class ActionItemRecord extends DataClass
    implements Insertable<ActionItemRecord> {
  final String id;
  final String meetingId;
  final String content;
  final String? owner;
  final String? dueDate;
  final bool done;
  final String evidenceJson;
  const ActionItemRecord({
    required this.id,
    required this.meetingId,
    required this.content,
    this.owner,
    this.dueDate,
    required this.done,
    required this.evidenceJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['meeting_id'] = Variable<String>(meetingId);
    map['text'] = Variable<String>(content);
    if (!nullToAbsent || owner != null) {
      map['owner'] = Variable<String>(owner);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<String>(dueDate);
    }
    map['done'] = Variable<bool>(done);
    map['evidence_json'] = Variable<String>(evidenceJson);
    return map;
  }

  ActionItemRowsCompanion toCompanion(bool nullToAbsent) {
    return ActionItemRowsCompanion(
      id: Value(id),
      meetingId: Value(meetingId),
      content: Value(content),
      owner: owner == null && nullToAbsent
          ? const Value.absent()
          : Value(owner),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      done: Value(done),
      evidenceJson: Value(evidenceJson),
    );
  }

  factory ActionItemRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActionItemRecord(
      id: serializer.fromJson<String>(json['id']),
      meetingId: serializer.fromJson<String>(json['meetingId']),
      content: serializer.fromJson<String>(json['content']),
      owner: serializer.fromJson<String?>(json['owner']),
      dueDate: serializer.fromJson<String?>(json['dueDate']),
      done: serializer.fromJson<bool>(json['done']),
      evidenceJson: serializer.fromJson<String>(json['evidenceJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'meetingId': serializer.toJson<String>(meetingId),
      'content': serializer.toJson<String>(content),
      'owner': serializer.toJson<String?>(owner),
      'dueDate': serializer.toJson<String?>(dueDate),
      'done': serializer.toJson<bool>(done),
      'evidenceJson': serializer.toJson<String>(evidenceJson),
    };
  }

  ActionItemRecord copyWith({
    String? id,
    String? meetingId,
    String? content,
    Value<String?> owner = const Value.absent(),
    Value<String?> dueDate = const Value.absent(),
    bool? done,
    String? evidenceJson,
  }) => ActionItemRecord(
    id: id ?? this.id,
    meetingId: meetingId ?? this.meetingId,
    content: content ?? this.content,
    owner: owner.present ? owner.value : this.owner,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    done: done ?? this.done,
    evidenceJson: evidenceJson ?? this.evidenceJson,
  );
  ActionItemRecord copyWithCompanion(ActionItemRowsCompanion data) {
    return ActionItemRecord(
      id: data.id.present ? data.id.value : this.id,
      meetingId: data.meetingId.present ? data.meetingId.value : this.meetingId,
      content: data.content.present ? data.content.value : this.content,
      owner: data.owner.present ? data.owner.value : this.owner,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      done: data.done.present ? data.done.value : this.done,
      evidenceJson: data.evidenceJson.present
          ? data.evidenceJson.value
          : this.evidenceJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActionItemRecord(')
          ..write('id: $id, ')
          ..write('meetingId: $meetingId, ')
          ..write('content: $content, ')
          ..write('owner: $owner, ')
          ..write('dueDate: $dueDate, ')
          ..write('done: $done, ')
          ..write('evidenceJson: $evidenceJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, meetingId, content, owner, dueDate, done, evidenceJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActionItemRecord &&
          other.id == this.id &&
          other.meetingId == this.meetingId &&
          other.content == this.content &&
          other.owner == this.owner &&
          other.dueDate == this.dueDate &&
          other.done == this.done &&
          other.evidenceJson == this.evidenceJson);
}

class ActionItemRowsCompanion extends UpdateCompanion<ActionItemRecord> {
  final Value<String> id;
  final Value<String> meetingId;
  final Value<String> content;
  final Value<String?> owner;
  final Value<String?> dueDate;
  final Value<bool> done;
  final Value<String> evidenceJson;
  final Value<int> rowid;
  const ActionItemRowsCompanion({
    this.id = const Value.absent(),
    this.meetingId = const Value.absent(),
    this.content = const Value.absent(),
    this.owner = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.done = const Value.absent(),
    this.evidenceJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActionItemRowsCompanion.insert({
    required String id,
    required String meetingId,
    required String content,
    this.owner = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.done = const Value.absent(),
    this.evidenceJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       meetingId = Value(meetingId),
       content = Value(content);
  static Insertable<ActionItemRecord> custom({
    Expression<String>? id,
    Expression<String>? meetingId,
    Expression<String>? content,
    Expression<String>? owner,
    Expression<String>? dueDate,
    Expression<bool>? done,
    Expression<String>? evidenceJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (meetingId != null) 'meeting_id': meetingId,
      if (content != null) 'text': content,
      if (owner != null) 'owner': owner,
      if (dueDate != null) 'due_date': dueDate,
      if (done != null) 'done': done,
      if (evidenceJson != null) 'evidence_json': evidenceJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActionItemRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? meetingId,
    Value<String>? content,
    Value<String?>? owner,
    Value<String?>? dueDate,
    Value<bool>? done,
    Value<String>? evidenceJson,
    Value<int>? rowid,
  }) {
    return ActionItemRowsCompanion(
      id: id ?? this.id,
      meetingId: meetingId ?? this.meetingId,
      content: content ?? this.content,
      owner: owner ?? this.owner,
      dueDate: dueDate ?? this.dueDate,
      done: done ?? this.done,
      evidenceJson: evidenceJson ?? this.evidenceJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (meetingId.present) {
      map['meeting_id'] = Variable<String>(meetingId.value);
    }
    if (content.present) {
      map['text'] = Variable<String>(content.value);
    }
    if (owner.present) {
      map['owner'] = Variable<String>(owner.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (evidenceJson.present) {
      map['evidence_json'] = Variable<String>(evidenceJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActionItemRowsCompanion(')
          ..write('id: $id, ')
          ..write('meetingId: $meetingId, ')
          ..write('content: $content, ')
          ..write('owner: $owner, ')
          ..write('dueDate: $dueDate, ')
          ..write('done: $done, ')
          ..write('evidenceJson: $evidenceJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DecisionRowsTable extends DecisionRows
    with TableInfo<$DecisionRowsTable, DecisionRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DecisionRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meetingIdMeta = const VerificationMeta(
    'meetingId',
  );
  @override
  late final GeneratedColumn<String> meetingId = GeneratedColumn<String>(
    'meeting_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meeting_rows (id)',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rationaleMeta = const VerificationMeta(
    'rationale',
  );
  @override
  late final GeneratedColumn<String> rationale = GeneratedColumn<String>(
    'rationale',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _evidenceJsonMeta = const VerificationMeta(
    'evidenceJson',
  );
  @override
  late final GeneratedColumn<String> evidenceJson = GeneratedColumn<String>(
    'evidence_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    meetingId,
    content,
    rationale,
    evidenceJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'decision_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<DecisionRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('meeting_id')) {
      context.handle(
        _meetingIdMeta,
        meetingId.isAcceptableOrUnknown(data['meeting_id']!, _meetingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_meetingIdMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['text']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('rationale')) {
      context.handle(
        _rationaleMeta,
        rationale.isAcceptableOrUnknown(data['rationale']!, _rationaleMeta),
      );
    }
    if (data.containsKey('evidence_json')) {
      context.handle(
        _evidenceJsonMeta,
        evidenceJson.isAcceptableOrUnknown(
          data['evidence_json']!,
          _evidenceJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DecisionRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DecisionRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      meetingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meeting_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      rationale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rationale'],
      ),
      evidenceJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evidence_json'],
      )!,
    );
  }

  @override
  $DecisionRowsTable createAlias(String alias) {
    return $DecisionRowsTable(attachedDatabase, alias);
  }
}

class DecisionRecord extends DataClass implements Insertable<DecisionRecord> {
  final String id;
  final String meetingId;
  final String content;
  final String? rationale;
  final String evidenceJson;
  const DecisionRecord({
    required this.id,
    required this.meetingId,
    required this.content,
    this.rationale,
    required this.evidenceJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['meeting_id'] = Variable<String>(meetingId);
    map['text'] = Variable<String>(content);
    if (!nullToAbsent || rationale != null) {
      map['rationale'] = Variable<String>(rationale);
    }
    map['evidence_json'] = Variable<String>(evidenceJson);
    return map;
  }

  DecisionRowsCompanion toCompanion(bool nullToAbsent) {
    return DecisionRowsCompanion(
      id: Value(id),
      meetingId: Value(meetingId),
      content: Value(content),
      rationale: rationale == null && nullToAbsent
          ? const Value.absent()
          : Value(rationale),
      evidenceJson: Value(evidenceJson),
    );
  }

  factory DecisionRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DecisionRecord(
      id: serializer.fromJson<String>(json['id']),
      meetingId: serializer.fromJson<String>(json['meetingId']),
      content: serializer.fromJson<String>(json['content']),
      rationale: serializer.fromJson<String?>(json['rationale']),
      evidenceJson: serializer.fromJson<String>(json['evidenceJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'meetingId': serializer.toJson<String>(meetingId),
      'content': serializer.toJson<String>(content),
      'rationale': serializer.toJson<String?>(rationale),
      'evidenceJson': serializer.toJson<String>(evidenceJson),
    };
  }

  DecisionRecord copyWith({
    String? id,
    String? meetingId,
    String? content,
    Value<String?> rationale = const Value.absent(),
    String? evidenceJson,
  }) => DecisionRecord(
    id: id ?? this.id,
    meetingId: meetingId ?? this.meetingId,
    content: content ?? this.content,
    rationale: rationale.present ? rationale.value : this.rationale,
    evidenceJson: evidenceJson ?? this.evidenceJson,
  );
  DecisionRecord copyWithCompanion(DecisionRowsCompanion data) {
    return DecisionRecord(
      id: data.id.present ? data.id.value : this.id,
      meetingId: data.meetingId.present ? data.meetingId.value : this.meetingId,
      content: data.content.present ? data.content.value : this.content,
      rationale: data.rationale.present ? data.rationale.value : this.rationale,
      evidenceJson: data.evidenceJson.present
          ? data.evidenceJson.value
          : this.evidenceJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DecisionRecord(')
          ..write('id: $id, ')
          ..write('meetingId: $meetingId, ')
          ..write('content: $content, ')
          ..write('rationale: $rationale, ')
          ..write('evidenceJson: $evidenceJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, meetingId, content, rationale, evidenceJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DecisionRecord &&
          other.id == this.id &&
          other.meetingId == this.meetingId &&
          other.content == this.content &&
          other.rationale == this.rationale &&
          other.evidenceJson == this.evidenceJson);
}

class DecisionRowsCompanion extends UpdateCompanion<DecisionRecord> {
  final Value<String> id;
  final Value<String> meetingId;
  final Value<String> content;
  final Value<String?> rationale;
  final Value<String> evidenceJson;
  final Value<int> rowid;
  const DecisionRowsCompanion({
    this.id = const Value.absent(),
    this.meetingId = const Value.absent(),
    this.content = const Value.absent(),
    this.rationale = const Value.absent(),
    this.evidenceJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DecisionRowsCompanion.insert({
    required String id,
    required String meetingId,
    required String content,
    this.rationale = const Value.absent(),
    this.evidenceJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       meetingId = Value(meetingId),
       content = Value(content);
  static Insertable<DecisionRecord> custom({
    Expression<String>? id,
    Expression<String>? meetingId,
    Expression<String>? content,
    Expression<String>? rationale,
    Expression<String>? evidenceJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (meetingId != null) 'meeting_id': meetingId,
      if (content != null) 'text': content,
      if (rationale != null) 'rationale': rationale,
      if (evidenceJson != null) 'evidence_json': evidenceJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DecisionRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? meetingId,
    Value<String>? content,
    Value<String?>? rationale,
    Value<String>? evidenceJson,
    Value<int>? rowid,
  }) {
    return DecisionRowsCompanion(
      id: id ?? this.id,
      meetingId: meetingId ?? this.meetingId,
      content: content ?? this.content,
      rationale: rationale ?? this.rationale,
      evidenceJson: evidenceJson ?? this.evidenceJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (meetingId.present) {
      map['meeting_id'] = Variable<String>(meetingId.value);
    }
    if (content.present) {
      map['text'] = Variable<String>(content.value);
    }
    if (rationale.present) {
      map['rationale'] = Variable<String>(rationale.value);
    }
    if (evidenceJson.present) {
      map['evidence_json'] = Variable<String>(evidenceJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DecisionRowsCompanion(')
          ..write('id: $id, ')
          ..write('meetingId: $meetingId, ')
          ..write('content: $content, ')
          ..write('rationale: $rationale, ')
          ..write('evidenceJson: $evidenceJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatMessageRowsTable extends ChatMessageRows
    with TableInfo<$ChatMessageRowsTable, ChatMessageRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessageRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meetingIdMeta = const VerificationMeta(
    'meetingId',
  );
  @override
  late final GeneratedColumn<String> meetingId = GeneratedColumn<String>(
    'meeting_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meeting_rows (id)',
    ),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isStreamingMeta = const VerificationMeta(
    'isStreaming',
  );
  @override
  late final GeneratedColumn<bool> isStreaming = GeneratedColumn<bool>(
    'is_streaming',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_streaming" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _evidenceJsonMeta = const VerificationMeta(
    'evidenceJson',
  );
  @override
  late final GeneratedColumn<String> evidenceJson = GeneratedColumn<String>(
    'evidence_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    meetingId,
    role,
    content,
    createdAt,
    isStreaming,
    evidenceJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_message_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatMessageRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('meeting_id')) {
      context.handle(
        _meetingIdMeta,
        meetingId.isAcceptableOrUnknown(data['meeting_id']!, _meetingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_meetingIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_streaming')) {
      context.handle(
        _isStreamingMeta,
        isStreaming.isAcceptableOrUnknown(
          data['is_streaming']!,
          _isStreamingMeta,
        ),
      );
    }
    if (data.containsKey('evidence_json')) {
      context.handle(
        _evidenceJsonMeta,
        evidenceJson.isAcceptableOrUnknown(
          data['evidence_json']!,
          _evidenceJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessageRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessageRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      meetingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meeting_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isStreaming: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_streaming'],
      )!,
      evidenceJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evidence_json'],
      )!,
    );
  }

  @override
  $ChatMessageRowsTable createAlias(String alias) {
    return $ChatMessageRowsTable(attachedDatabase, alias);
  }
}

class ChatMessageRecord extends DataClass
    implements Insertable<ChatMessageRecord> {
  final String id;
  final String meetingId;
  final String role;
  final String content;
  final DateTime createdAt;
  final bool isStreaming;
  final String evidenceJson;
  const ChatMessageRecord({
    required this.id,
    required this.meetingId,
    required this.role,
    required this.content,
    required this.createdAt,
    required this.isStreaming,
    required this.evidenceJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['meeting_id'] = Variable<String>(meetingId);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_streaming'] = Variable<bool>(isStreaming);
    map['evidence_json'] = Variable<String>(evidenceJson);
    return map;
  }

  ChatMessageRowsCompanion toCompanion(bool nullToAbsent) {
    return ChatMessageRowsCompanion(
      id: Value(id),
      meetingId: Value(meetingId),
      role: Value(role),
      content: Value(content),
      createdAt: Value(createdAt),
      isStreaming: Value(isStreaming),
      evidenceJson: Value(evidenceJson),
    );
  }

  factory ChatMessageRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessageRecord(
      id: serializer.fromJson<String>(json['id']),
      meetingId: serializer.fromJson<String>(json['meetingId']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isStreaming: serializer.fromJson<bool>(json['isStreaming']),
      evidenceJson: serializer.fromJson<String>(json['evidenceJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'meetingId': serializer.toJson<String>(meetingId),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isStreaming': serializer.toJson<bool>(isStreaming),
      'evidenceJson': serializer.toJson<String>(evidenceJson),
    };
  }

  ChatMessageRecord copyWith({
    String? id,
    String? meetingId,
    String? role,
    String? content,
    DateTime? createdAt,
    bool? isStreaming,
    String? evidenceJson,
  }) => ChatMessageRecord(
    id: id ?? this.id,
    meetingId: meetingId ?? this.meetingId,
    role: role ?? this.role,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    isStreaming: isStreaming ?? this.isStreaming,
    evidenceJson: evidenceJson ?? this.evidenceJson,
  );
  ChatMessageRecord copyWithCompanion(ChatMessageRowsCompanion data) {
    return ChatMessageRecord(
      id: data.id.present ? data.id.value : this.id,
      meetingId: data.meetingId.present ? data.meetingId.value : this.meetingId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isStreaming: data.isStreaming.present
          ? data.isStreaming.value
          : this.isStreaming,
      evidenceJson: data.evidenceJson.present
          ? data.evidenceJson.value
          : this.evidenceJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessageRecord(')
          ..write('id: $id, ')
          ..write('meetingId: $meetingId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('isStreaming: $isStreaming, ')
          ..write('evidenceJson: $evidenceJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    meetingId,
    role,
    content,
    createdAt,
    isStreaming,
    evidenceJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessageRecord &&
          other.id == this.id &&
          other.meetingId == this.meetingId &&
          other.role == this.role &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.isStreaming == this.isStreaming &&
          other.evidenceJson == this.evidenceJson);
}

class ChatMessageRowsCompanion extends UpdateCompanion<ChatMessageRecord> {
  final Value<String> id;
  final Value<String> meetingId;
  final Value<String> role;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<bool> isStreaming;
  final Value<String> evidenceJson;
  final Value<int> rowid;
  const ChatMessageRowsCompanion({
    this.id = const Value.absent(),
    this.meetingId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isStreaming = const Value.absent(),
    this.evidenceJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatMessageRowsCompanion.insert({
    required String id,
    required String meetingId,
    required String role,
    required String content,
    required DateTime createdAt,
    this.isStreaming = const Value.absent(),
    this.evidenceJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       meetingId = Value(meetingId),
       role = Value(role),
       content = Value(content),
       createdAt = Value(createdAt);
  static Insertable<ChatMessageRecord> custom({
    Expression<String>? id,
    Expression<String>? meetingId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<bool>? isStreaming,
    Expression<String>? evidenceJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (meetingId != null) 'meeting_id': meetingId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (isStreaming != null) 'is_streaming': isStreaming,
      if (evidenceJson != null) 'evidence_json': evidenceJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatMessageRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? meetingId,
    Value<String>? role,
    Value<String>? content,
    Value<DateTime>? createdAt,
    Value<bool>? isStreaming,
    Value<String>? evidenceJson,
    Value<int>? rowid,
  }) {
    return ChatMessageRowsCompanion(
      id: id ?? this.id,
      meetingId: meetingId ?? this.meetingId,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isStreaming: isStreaming ?? this.isStreaming,
      evidenceJson: evidenceJson ?? this.evidenceJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (meetingId.present) {
      map['meeting_id'] = Variable<String>(meetingId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isStreaming.present) {
      map['is_streaming'] = Variable<bool>(isStreaming.value);
    }
    if (evidenceJson.present) {
      map['evidence_json'] = Variable<String>(evidenceJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessageRowsCompanion(')
          ..write('id: $id, ')
          ..write('meetingId: $meetingId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('isStreaming: $isStreaming, ')
          ..write('evidenceJson: $evidenceJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TodoRowsTable extends TodoRows
    with TableInfo<$TodoRowsTable, TodoRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meetingIdMeta = const VerificationMeta(
    'meetingId',
  );
  @override
  late final GeneratedColumn<String> meetingId = GeneratedColumn<String>(
    'meeting_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meeting_rows (id)',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    meetingId,
    content,
    done,
    createdAt,
    dueDate,
    notes,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<TodoRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('meeting_id')) {
      context.handle(
        _meetingIdMeta,
        meetingId.isAcceptableOrUnknown(data['meeting_id']!, _meetingIdMeta),
      );
    }
    if (data.containsKey('text')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['text']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TodoRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      meetingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meeting_id'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $TodoRowsTable createAlias(String alias) {
    return $TodoRowsTable(attachedDatabase, alias);
  }
}

class TodoRecord extends DataClass implements Insertable<TodoRecord> {
  final String id;
  final String? meetingId;
  final String content;
  final bool done;
  final DateTime createdAt;
  final DateTime? dueDate;
  final String? notes;
  final int sortOrder;
  const TodoRecord({
    required this.id,
    this.meetingId,
    required this.content,
    required this.done,
    required this.createdAt,
    this.dueDate,
    this.notes,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || meetingId != null) {
      map['meeting_id'] = Variable<String>(meetingId);
    }
    map['text'] = Variable<String>(content);
    map['done'] = Variable<bool>(done);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  TodoRowsCompanion toCompanion(bool nullToAbsent) {
    return TodoRowsCompanion(
      id: Value(id),
      meetingId: meetingId == null && nullToAbsent
          ? const Value.absent()
          : Value(meetingId),
      content: Value(content),
      done: Value(done),
      createdAt: Value(createdAt),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      sortOrder: Value(sortOrder),
    );
  }

  factory TodoRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoRecord(
      id: serializer.fromJson<String>(json['id']),
      meetingId: serializer.fromJson<String?>(json['meetingId']),
      content: serializer.fromJson<String>(json['content']),
      done: serializer.fromJson<bool>(json['done']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'meetingId': serializer.toJson<String?>(meetingId),
      'content': serializer.toJson<String>(content),
      'done': serializer.toJson<bool>(done),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'notes': serializer.toJson<String?>(notes),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  TodoRecord copyWith({
    String? id,
    Value<String?> meetingId = const Value.absent(),
    String? content,
    bool? done,
    DateTime? createdAt,
    Value<DateTime?> dueDate = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    int? sortOrder,
  }) => TodoRecord(
    id: id ?? this.id,
    meetingId: meetingId.present ? meetingId.value : this.meetingId,
    content: content ?? this.content,
    done: done ?? this.done,
    createdAt: createdAt ?? this.createdAt,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    notes: notes.present ? notes.value : this.notes,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  TodoRecord copyWithCompanion(TodoRowsCompanion data) {
    return TodoRecord(
      id: data.id.present ? data.id.value : this.id,
      meetingId: data.meetingId.present ? data.meetingId.value : this.meetingId,
      content: data.content.present ? data.content.value : this.content,
      done: data.done.present ? data.done.value : this.done,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoRecord(')
          ..write('id: $id, ')
          ..write('meetingId: $meetingId, ')
          ..write('content: $content, ')
          ..write('done: $done, ')
          ..write('createdAt: $createdAt, ')
          ..write('dueDate: $dueDate, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    meetingId,
    content,
    done,
    createdAt,
    dueDate,
    notes,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoRecord &&
          other.id == this.id &&
          other.meetingId == this.meetingId &&
          other.content == this.content &&
          other.done == this.done &&
          other.createdAt == this.createdAt &&
          other.dueDate == this.dueDate &&
          other.notes == this.notes &&
          other.sortOrder == this.sortOrder);
}

class TodoRowsCompanion extends UpdateCompanion<TodoRecord> {
  final Value<String> id;
  final Value<String?> meetingId;
  final Value<String> content;
  final Value<bool> done;
  final Value<DateTime> createdAt;
  final Value<DateTime?> dueDate;
  final Value<String?> notes;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const TodoRowsCompanion({
    this.id = const Value.absent(),
    this.meetingId = const Value.absent(),
    this.content = const Value.absent(),
    this.done = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TodoRowsCompanion.insert({
    required String id,
    this.meetingId = const Value.absent(),
    required String content,
    this.done = const Value.absent(),
    required DateTime createdAt,
    this.dueDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       content = Value(content),
       createdAt = Value(createdAt);
  static Insertable<TodoRecord> custom({
    Expression<String>? id,
    Expression<String>? meetingId,
    Expression<String>? content,
    Expression<bool>? done,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? dueDate,
    Expression<String>? notes,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (meetingId != null) 'meeting_id': meetingId,
      if (content != null) 'text': content,
      if (done != null) 'done': done,
      if (createdAt != null) 'created_at': createdAt,
      if (dueDate != null) 'due_date': dueDate,
      if (notes != null) 'notes': notes,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TodoRowsCompanion copyWith({
    Value<String>? id,
    Value<String?>? meetingId,
    Value<String>? content,
    Value<bool>? done,
    Value<DateTime>? createdAt,
    Value<DateTime?>? dueDate,
    Value<String?>? notes,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return TodoRowsCompanion(
      id: id ?? this.id,
      meetingId: meetingId ?? this.meetingId,
      content: content ?? this.content,
      done: done ?? this.done,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (meetingId.present) {
      map['meeting_id'] = Variable<String>(meetingId.value);
    }
    if (content.present) {
      map['text'] = Variable<String>(content.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoRowsCompanion(')
          ..write('id: $id, ')
          ..write('meetingId: $meetingId, ')
          ..write('content: $content, ')
          ..write('done: $done, ')
          ..write('createdAt: $createdAt, ')
          ..write('dueDate: $dueDate, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingRowsTable extends SettingRows
    with TableInfo<$SettingRowsTable, SettingRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'setting_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingRecord(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SettingRowsTable createAlias(String alias) {
    return $SettingRowsTable(attachedDatabase, alias);
  }
}

class SettingRecord extends DataClass implements Insertable<SettingRecord> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const SettingRecord({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SettingRowsCompanion toCompanion(bool nullToAbsent) {
    return SettingRowsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory SettingRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingRecord(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SettingRecord copyWith({String? key, String? value, DateTime? updatedAt}) =>
      SettingRecord(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SettingRecord copyWithCompanion(SettingRowsCompanion data) {
    return SettingRecord(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingRecord(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingRecord &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class SettingRowsCompanion extends UpdateCompanion<SettingRecord> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SettingRowsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingRowsCompanion.insert({
    required String key,
    required String value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<SettingRecord> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingRowsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SettingRowsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingRowsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudyFolderRowsTable extends StudyFolderRows
    with TableInfo<$StudyFolderRowsTable, StudyFolderRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyFolderRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES study_folder_rows (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('teal'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    parentId,
    name,
    description,
    color,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_folder_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyFolderRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyFolderRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyFolderRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StudyFolderRowsTable createAlias(String alias) {
    return $StudyFolderRowsTable(attachedDatabase, alias);
  }
}

class StudyFolderRecord extends DataClass
    implements Insertable<StudyFolderRecord> {
  final String id;
  final String? parentId;
  final String name;
  final String? description;
  final String color;
  final DateTime createdAt;
  const StudyFolderRecord({
    required this.id,
    this.parentId,
    required this.name,
    this.description,
    required this.color,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['color'] = Variable<String>(color);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StudyFolderRowsCompanion toCompanion(bool nullToAbsent) {
    return StudyFolderRowsCompanion(
      id: Value(id),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      color: Value(color),
      createdAt: Value(createdAt),
    );
  }

  factory StudyFolderRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyFolderRecord(
      id: serializer.fromJson<String>(json['id']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      color: serializer.fromJson<String>(json['color']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'parentId': serializer.toJson<String?>(parentId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'color': serializer.toJson<String>(color),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StudyFolderRecord copyWith({
    String? id,
    Value<String?> parentId = const Value.absent(),
    String? name,
    Value<String?> description = const Value.absent(),
    String? color,
    DateTime? createdAt,
  }) => StudyFolderRecord(
    id: id ?? this.id,
    parentId: parentId.present ? parentId.value : this.parentId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    color: color ?? this.color,
    createdAt: createdAt ?? this.createdAt,
  );
  StudyFolderRecord copyWithCompanion(StudyFolderRowsCompanion data) {
    return StudyFolderRecord(
      id: data.id.present ? data.id.value : this.id,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      color: data.color.present ? data.color.value : this.color,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyFolderRecord(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, parentId, name, description, color, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyFolderRecord &&
          other.id == this.id &&
          other.parentId == this.parentId &&
          other.name == this.name &&
          other.description == this.description &&
          other.color == this.color &&
          other.createdAt == this.createdAt);
}

class StudyFolderRowsCompanion extends UpdateCompanion<StudyFolderRecord> {
  final Value<String> id;
  final Value<String?> parentId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> color;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StudyFolderRowsCompanion({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyFolderRowsCompanion.insert({
    required String id,
    this.parentId = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.color = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<StudyFolderRecord> custom({
    Expression<String>? id,
    Expression<String>? parentId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? color,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentId != null) 'parent_id': parentId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyFolderRowsCompanion copyWith({
    Value<String>? id,
    Value<String?>? parentId,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? color,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return StudyFolderRowsCompanion(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyFolderRowsCompanion(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudyDocumentRowsTable extends StudyDocumentRows
    with TableInfo<$StudyDocumentRowsTable, StudyDocumentRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyDocumentRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _folderIdMeta = const VerificationMeta(
    'folderId',
  );
  @override
  late final GeneratedColumn<String> folderId = GeneratedColumn<String>(
    'folder_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES study_folder_rows (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourcePathMeta = const VerificationMeta(
    'sourcePath',
  );
  @override
  late final GeneratedColumn<String> sourcePath = GeneratedColumn<String>(
    'source_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _extractedTextMeta = const VerificationMeta(
    'extractedText',
  );
  @override
  late final GeneratedColumn<String> extractedText = GeneratedColumn<String>(
    'extracted_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    folderId,
    title,
    kind,
    sourcePath,
    category,
    extractedText,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_document_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyDocumentRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('folder_id')) {
      context.handle(
        _folderIdMeta,
        folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_folderIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('source_path')) {
      context.handle(
        _sourcePathMeta,
        sourcePath.isAcceptableOrUnknown(data['source_path']!, _sourcePathMeta),
      );
    } else if (isInserting) {
      context.missing(_sourcePathMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('extracted_text')) {
      context.handle(
        _extractedTextMeta,
        extractedText.isAcceptableOrUnknown(
          data['extracted_text']!,
          _extractedTextMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyDocumentRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyDocumentRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      folderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      sourcePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_path'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      extractedText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extracted_text'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StudyDocumentRowsTable createAlias(String alias) {
    return $StudyDocumentRowsTable(attachedDatabase, alias);
  }
}

class StudyDocumentRecord extends DataClass
    implements Insertable<StudyDocumentRecord> {
  final String id;
  final String folderId;
  final String title;
  final String kind;
  final String sourcePath;
  final String? category;
  final String extractedText;
  final DateTime createdAt;
  const StudyDocumentRecord({
    required this.id,
    required this.folderId,
    required this.title,
    required this.kind,
    required this.sourcePath,
    this.category,
    required this.extractedText,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['folder_id'] = Variable<String>(folderId);
    map['title'] = Variable<String>(title);
    map['kind'] = Variable<String>(kind);
    map['source_path'] = Variable<String>(sourcePath);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['extracted_text'] = Variable<String>(extractedText);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StudyDocumentRowsCompanion toCompanion(bool nullToAbsent) {
    return StudyDocumentRowsCompanion(
      id: Value(id),
      folderId: Value(folderId),
      title: Value(title),
      kind: Value(kind),
      sourcePath: Value(sourcePath),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      extractedText: Value(extractedText),
      createdAt: Value(createdAt),
    );
  }

  factory StudyDocumentRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyDocumentRecord(
      id: serializer.fromJson<String>(json['id']),
      folderId: serializer.fromJson<String>(json['folderId']),
      title: serializer.fromJson<String>(json['title']),
      kind: serializer.fromJson<String>(json['kind']),
      sourcePath: serializer.fromJson<String>(json['sourcePath']),
      category: serializer.fromJson<String?>(json['category']),
      extractedText: serializer.fromJson<String>(json['extractedText']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'folderId': serializer.toJson<String>(folderId),
      'title': serializer.toJson<String>(title),
      'kind': serializer.toJson<String>(kind),
      'sourcePath': serializer.toJson<String>(sourcePath),
      'category': serializer.toJson<String?>(category),
      'extractedText': serializer.toJson<String>(extractedText),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StudyDocumentRecord copyWith({
    String? id,
    String? folderId,
    String? title,
    String? kind,
    String? sourcePath,
    Value<String?> category = const Value.absent(),
    String? extractedText,
    DateTime? createdAt,
  }) => StudyDocumentRecord(
    id: id ?? this.id,
    folderId: folderId ?? this.folderId,
    title: title ?? this.title,
    kind: kind ?? this.kind,
    sourcePath: sourcePath ?? this.sourcePath,
    category: category.present ? category.value : this.category,
    extractedText: extractedText ?? this.extractedText,
    createdAt: createdAt ?? this.createdAt,
  );
  StudyDocumentRecord copyWithCompanion(StudyDocumentRowsCompanion data) {
    return StudyDocumentRecord(
      id: data.id.present ? data.id.value : this.id,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      title: data.title.present ? data.title.value : this.title,
      kind: data.kind.present ? data.kind.value : this.kind,
      sourcePath: data.sourcePath.present
          ? data.sourcePath.value
          : this.sourcePath,
      category: data.category.present ? data.category.value : this.category,
      extractedText: data.extractedText.present
          ? data.extractedText.value
          : this.extractedText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyDocumentRecord(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('title: $title, ')
          ..write('kind: $kind, ')
          ..write('sourcePath: $sourcePath, ')
          ..write('category: $category, ')
          ..write('extractedText: $extractedText, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    folderId,
    title,
    kind,
    sourcePath,
    category,
    extractedText,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyDocumentRecord &&
          other.id == this.id &&
          other.folderId == this.folderId &&
          other.title == this.title &&
          other.kind == this.kind &&
          other.sourcePath == this.sourcePath &&
          other.category == this.category &&
          other.extractedText == this.extractedText &&
          other.createdAt == this.createdAt);
}

class StudyDocumentRowsCompanion extends UpdateCompanion<StudyDocumentRecord> {
  final Value<String> id;
  final Value<String> folderId;
  final Value<String> title;
  final Value<String> kind;
  final Value<String> sourcePath;
  final Value<String?> category;
  final Value<String> extractedText;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StudyDocumentRowsCompanion({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
    this.title = const Value.absent(),
    this.kind = const Value.absent(),
    this.sourcePath = const Value.absent(),
    this.category = const Value.absent(),
    this.extractedText = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyDocumentRowsCompanion.insert({
    required String id,
    required String folderId,
    required String title,
    required String kind,
    required String sourcePath,
    this.category = const Value.absent(),
    this.extractedText = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       folderId = Value(folderId),
       title = Value(title),
       kind = Value(kind),
       sourcePath = Value(sourcePath),
       createdAt = Value(createdAt);
  static Insertable<StudyDocumentRecord> custom({
    Expression<String>? id,
    Expression<String>? folderId,
    Expression<String>? title,
    Expression<String>? kind,
    Expression<String>? sourcePath,
    Expression<String>? category,
    Expression<String>? extractedText,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (folderId != null) 'folder_id': folderId,
      if (title != null) 'title': title,
      if (kind != null) 'kind': kind,
      if (sourcePath != null) 'source_path': sourcePath,
      if (category != null) 'category': category,
      if (extractedText != null) 'extracted_text': extractedText,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyDocumentRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? folderId,
    Value<String>? title,
    Value<String>? kind,
    Value<String>? sourcePath,
    Value<String?>? category,
    Value<String>? extractedText,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return StudyDocumentRowsCompanion(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      title: title ?? this.title,
      kind: kind ?? this.kind,
      sourcePath: sourcePath ?? this.sourcePath,
      category: category ?? this.category,
      extractedText: extractedText ?? this.extractedText,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<String>(folderId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (sourcePath.present) {
      map['source_path'] = Variable<String>(sourcePath.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (extractedText.present) {
      map['extracted_text'] = Variable<String>(extractedText.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyDocumentRowsCompanion(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('title: $title, ')
          ..write('kind: $kind, ')
          ..write('sourcePath: $sourcePath, ')
          ..write('category: $category, ')
          ..write('extractedText: $extractedText, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudyMeetingLinkRowsTable extends StudyMeetingLinkRows
    with TableInfo<$StudyMeetingLinkRowsTable, StudyMeetingLinkRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyMeetingLinkRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _folderIdMeta = const VerificationMeta(
    'folderId',
  );
  @override
  late final GeneratedColumn<String> folderId = GeneratedColumn<String>(
    'folder_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES study_folder_rows (id)',
    ),
  );
  static const VerificationMeta _meetingIdMeta = const VerificationMeta(
    'meetingId',
  );
  @override
  late final GeneratedColumn<String> meetingId = GeneratedColumn<String>(
    'meeting_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meeting_rows (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, folderId, meetingId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_meeting_link_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyMeetingLinkRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('folder_id')) {
      context.handle(
        _folderIdMeta,
        folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_folderIdMeta);
    }
    if (data.containsKey('meeting_id')) {
      context.handle(
        _meetingIdMeta,
        meetingId.isAcceptableOrUnknown(data['meeting_id']!, _meetingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_meetingIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyMeetingLinkRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyMeetingLinkRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      folderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder_id'],
      )!,
      meetingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meeting_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StudyMeetingLinkRowsTable createAlias(String alias) {
    return $StudyMeetingLinkRowsTable(attachedDatabase, alias);
  }
}

class StudyMeetingLinkRecord extends DataClass
    implements Insertable<StudyMeetingLinkRecord> {
  final String id;
  final String folderId;
  final String meetingId;
  final DateTime createdAt;
  const StudyMeetingLinkRecord({
    required this.id,
    required this.folderId,
    required this.meetingId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['folder_id'] = Variable<String>(folderId);
    map['meeting_id'] = Variable<String>(meetingId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StudyMeetingLinkRowsCompanion toCompanion(bool nullToAbsent) {
    return StudyMeetingLinkRowsCompanion(
      id: Value(id),
      folderId: Value(folderId),
      meetingId: Value(meetingId),
      createdAt: Value(createdAt),
    );
  }

  factory StudyMeetingLinkRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyMeetingLinkRecord(
      id: serializer.fromJson<String>(json['id']),
      folderId: serializer.fromJson<String>(json['folderId']),
      meetingId: serializer.fromJson<String>(json['meetingId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'folderId': serializer.toJson<String>(folderId),
      'meetingId': serializer.toJson<String>(meetingId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StudyMeetingLinkRecord copyWith({
    String? id,
    String? folderId,
    String? meetingId,
    DateTime? createdAt,
  }) => StudyMeetingLinkRecord(
    id: id ?? this.id,
    folderId: folderId ?? this.folderId,
    meetingId: meetingId ?? this.meetingId,
    createdAt: createdAt ?? this.createdAt,
  );
  StudyMeetingLinkRecord copyWithCompanion(StudyMeetingLinkRowsCompanion data) {
    return StudyMeetingLinkRecord(
      id: data.id.present ? data.id.value : this.id,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      meetingId: data.meetingId.present ? data.meetingId.value : this.meetingId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyMeetingLinkRecord(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('meetingId: $meetingId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, folderId, meetingId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyMeetingLinkRecord &&
          other.id == this.id &&
          other.folderId == this.folderId &&
          other.meetingId == this.meetingId &&
          other.createdAt == this.createdAt);
}

class StudyMeetingLinkRowsCompanion
    extends UpdateCompanion<StudyMeetingLinkRecord> {
  final Value<String> id;
  final Value<String> folderId;
  final Value<String> meetingId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StudyMeetingLinkRowsCompanion({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
    this.meetingId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyMeetingLinkRowsCompanion.insert({
    required String id,
    required String folderId,
    required String meetingId,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       folderId = Value(folderId),
       meetingId = Value(meetingId),
       createdAt = Value(createdAt);
  static Insertable<StudyMeetingLinkRecord> custom({
    Expression<String>? id,
    Expression<String>? folderId,
    Expression<String>? meetingId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (folderId != null) 'folder_id': folderId,
      if (meetingId != null) 'meeting_id': meetingId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyMeetingLinkRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? folderId,
    Value<String>? meetingId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return StudyMeetingLinkRowsCompanion(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      meetingId: meetingId ?? this.meetingId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<String>(folderId.value);
    }
    if (meetingId.present) {
      map['meeting_id'] = Variable<String>(meetingId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyMeetingLinkRowsCompanion(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('meetingId: $meetingId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudyChatRowsTable extends StudyChatRows
    with TableInfo<$StudyChatRowsTable, StudyChatRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyChatRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _folderIdMeta = const VerificationMeta(
    'folderId',
  );
  @override
  late final GeneratedColumn<String> folderId = GeneratedColumn<String>(
    'folder_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES study_folder_rows (id)',
    ),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    folderId,
    role,
    content,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_chat_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyChatRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('folder_id')) {
      context.handle(
        _folderIdMeta,
        folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_folderIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyChatRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyChatRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      folderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StudyChatRowsTable createAlias(String alias) {
    return $StudyChatRowsTable(attachedDatabase, alias);
  }
}

class StudyChatRecord extends DataClass implements Insertable<StudyChatRecord> {
  final String id;
  final String folderId;
  final String role;
  final String content;
  final DateTime createdAt;
  const StudyChatRecord({
    required this.id,
    required this.folderId,
    required this.role,
    required this.content,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['folder_id'] = Variable<String>(folderId);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StudyChatRowsCompanion toCompanion(bool nullToAbsent) {
    return StudyChatRowsCompanion(
      id: Value(id),
      folderId: Value(folderId),
      role: Value(role),
      content: Value(content),
      createdAt: Value(createdAt),
    );
  }

  factory StudyChatRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyChatRecord(
      id: serializer.fromJson<String>(json['id']),
      folderId: serializer.fromJson<String>(json['folderId']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'folderId': serializer.toJson<String>(folderId),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StudyChatRecord copyWith({
    String? id,
    String? folderId,
    String? role,
    String? content,
    DateTime? createdAt,
  }) => StudyChatRecord(
    id: id ?? this.id,
    folderId: folderId ?? this.folderId,
    role: role ?? this.role,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
  );
  StudyChatRecord copyWithCompanion(StudyChatRowsCompanion data) {
    return StudyChatRecord(
      id: data.id.present ? data.id.value : this.id,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyChatRecord(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, folderId, role, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyChatRecord &&
          other.id == this.id &&
          other.folderId == this.folderId &&
          other.role == this.role &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class StudyChatRowsCompanion extends UpdateCompanion<StudyChatRecord> {
  final Value<String> id;
  final Value<String> folderId;
  final Value<String> role;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StudyChatRowsCompanion({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyChatRowsCompanion.insert({
    required String id,
    required String folderId,
    required String role,
    required String content,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       folderId = Value(folderId),
       role = Value(role),
       content = Value(content),
       createdAt = Value(createdAt);
  static Insertable<StudyChatRecord> custom({
    Expression<String>? id,
    Expression<String>? folderId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (folderId != null) 'folder_id': folderId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyChatRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? folderId,
    Value<String>? role,
    Value<String>? content,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return StudyChatRowsCompanion(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<String>(folderId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyChatRowsCompanion(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MeetingRowsTable meetingRows = $MeetingRowsTable(this);
  late final $AudioAssetRowsTable audioAssetRows = $AudioAssetRowsTable(this);
  late final $TranscriptSegmentRowsTable transcriptSegmentRows =
      $TranscriptSegmentRowsTable(this);
  late final $SummaryRowsTable summaryRows = $SummaryRowsTable(this);
  late final $ActionItemRowsTable actionItemRows = $ActionItemRowsTable(this);
  late final $DecisionRowsTable decisionRows = $DecisionRowsTable(this);
  late final $ChatMessageRowsTable chatMessageRows = $ChatMessageRowsTable(
    this,
  );
  late final $TodoRowsTable todoRows = $TodoRowsTable(this);
  late final $SettingRowsTable settingRows = $SettingRowsTable(this);
  late final $StudyFolderRowsTable studyFolderRows = $StudyFolderRowsTable(
    this,
  );
  late final $StudyDocumentRowsTable studyDocumentRows =
      $StudyDocumentRowsTable(this);
  late final $StudyMeetingLinkRowsTable studyMeetingLinkRows =
      $StudyMeetingLinkRowsTable(this);
  late final $StudyChatRowsTable studyChatRows = $StudyChatRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    meetingRows,
    audioAssetRows,
    transcriptSegmentRows,
    summaryRows,
    actionItemRows,
    decisionRows,
    chatMessageRows,
    todoRows,
    settingRows,
    studyFolderRows,
    studyDocumentRows,
    studyMeetingLinkRows,
    studyChatRows,
  ];
}

typedef $$MeetingRowsTableCreateCompanionBuilder =
    MeetingRowsCompanion Function({
      required String id,
      required String title,
      required DateTime createdAt,
      Value<DateTime?> startedAt,
      Value<DateTime?> endedAt,
      Value<int> durationMs,
      required String status,
      Value<bool> isPinned,
      Value<bool> isFavorite,
      Value<String> languageCode,
      Value<String?> summaryPreview,
      Value<String> tagsJson,
      Value<int> rowid,
    });
typedef $$MeetingRowsTableUpdateCompanionBuilder =
    MeetingRowsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<DateTime> createdAt,
      Value<DateTime?> startedAt,
      Value<DateTime?> endedAt,
      Value<int> durationMs,
      Value<String> status,
      Value<bool> isPinned,
      Value<bool> isFavorite,
      Value<String> languageCode,
      Value<String?> summaryPreview,
      Value<String> tagsJson,
      Value<int> rowid,
    });

final class $$MeetingRowsTableReferences
    extends BaseReferences<_$AppDatabase, $MeetingRowsTable, MeetingRecord> {
  $$MeetingRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AudioAssetRowsTable, List<AudioAssetRecord>>
  _audioAssetRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.audioAssetRows,
    aliasName: $_aliasNameGenerator(
      db.meetingRows.id,
      db.audioAssetRows.meetingId,
    ),
  );

  $$AudioAssetRowsTableProcessedTableManager get audioAssetRowsRefs {
    final manager = $$AudioAssetRowsTableTableManager(
      $_db,
      $_db.audioAssetRows,
    ).filter((f) => f.meetingId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_audioAssetRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TranscriptSegmentRowsTable,
    List<TranscriptSegmentRecord>
  >
  _transcriptSegmentRowsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transcriptSegmentRows,
        aliasName: $_aliasNameGenerator(
          db.meetingRows.id,
          db.transcriptSegmentRows.meetingId,
        ),
      );

  $$TranscriptSegmentRowsTableProcessedTableManager
  get transcriptSegmentRowsRefs {
    final manager = $$TranscriptSegmentRowsTableTableManager(
      $_db,
      $_db.transcriptSegmentRows,
    ).filter((f) => f.meetingId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transcriptSegmentRowsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SummaryRowsTable, List<SummaryRecord>>
  _summaryRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.summaryRows,
    aliasName: $_aliasNameGenerator(
      db.meetingRows.id,
      db.summaryRows.meetingId,
    ),
  );

  $$SummaryRowsTableProcessedTableManager get summaryRowsRefs {
    final manager = $$SummaryRowsTableTableManager(
      $_db,
      $_db.summaryRows,
    ).filter((f) => f.meetingId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_summaryRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ActionItemRowsTable, List<ActionItemRecord>>
  _actionItemRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.actionItemRows,
    aliasName: $_aliasNameGenerator(
      db.meetingRows.id,
      db.actionItemRows.meetingId,
    ),
  );

  $$ActionItemRowsTableProcessedTableManager get actionItemRowsRefs {
    final manager = $$ActionItemRowsTableTableManager(
      $_db,
      $_db.actionItemRows,
    ).filter((f) => f.meetingId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_actionItemRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DecisionRowsTable, List<DecisionRecord>>
  _decisionRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.decisionRows,
    aliasName: $_aliasNameGenerator(
      db.meetingRows.id,
      db.decisionRows.meetingId,
    ),
  );

  $$DecisionRowsTableProcessedTableManager get decisionRowsRefs {
    final manager = $$DecisionRowsTableTableManager(
      $_db,
      $_db.decisionRows,
    ).filter((f) => f.meetingId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_decisionRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ChatMessageRowsTable, List<ChatMessageRecord>>
  _chatMessageRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.chatMessageRows,
    aliasName: $_aliasNameGenerator(
      db.meetingRows.id,
      db.chatMessageRows.meetingId,
    ),
  );

  $$ChatMessageRowsTableProcessedTableManager get chatMessageRowsRefs {
    final manager = $$ChatMessageRowsTableTableManager(
      $_db,
      $_db.chatMessageRows,
    ).filter((f) => f.meetingId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _chatMessageRowsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TodoRowsTable, List<TodoRecord>>
  _todoRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.todoRows,
    aliasName: $_aliasNameGenerator(db.meetingRows.id, db.todoRows.meetingId),
  );

  $$TodoRowsTableProcessedTableManager get todoRowsRefs {
    final manager = $$TodoRowsTableTableManager(
      $_db,
      $_db.todoRows,
    ).filter((f) => f.meetingId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_todoRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $StudyMeetingLinkRowsTable,
    List<StudyMeetingLinkRecord>
  >
  _studyMeetingLinkRowsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.studyMeetingLinkRows,
        aliasName: $_aliasNameGenerator(
          db.meetingRows.id,
          db.studyMeetingLinkRows.meetingId,
        ),
      );

  $$StudyMeetingLinkRowsTableProcessedTableManager
  get studyMeetingLinkRowsRefs {
    final manager = $$StudyMeetingLinkRowsTableTableManager(
      $_db,
      $_db.studyMeetingLinkRows,
    ).filter((f) => f.meetingId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _studyMeetingLinkRowsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MeetingRowsTableFilterComposer
    extends Composer<_$AppDatabase, $MeetingRowsTable> {
  $$MeetingRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summaryPreview => $composableBuilder(
    column: $table.summaryPreview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> audioAssetRowsRefs(
    Expression<bool> Function($$AudioAssetRowsTableFilterComposer f) f,
  ) {
    final $$AudioAssetRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.audioAssetRows,
      getReferencedColumn: (t) => t.meetingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioAssetRowsTableFilterComposer(
            $db: $db,
            $table: $db.audioAssetRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transcriptSegmentRowsRefs(
    Expression<bool> Function($$TranscriptSegmentRowsTableFilterComposer f) f,
  ) {
    final $$TranscriptSegmentRowsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transcriptSegmentRows,
          getReferencedColumn: (t) => t.meetingId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TranscriptSegmentRowsTableFilterComposer(
                $db: $db,
                $table: $db.transcriptSegmentRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> summaryRowsRefs(
    Expression<bool> Function($$SummaryRowsTableFilterComposer f) f,
  ) {
    final $$SummaryRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.summaryRows,
      getReferencedColumn: (t) => t.meetingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SummaryRowsTableFilterComposer(
            $db: $db,
            $table: $db.summaryRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> actionItemRowsRefs(
    Expression<bool> Function($$ActionItemRowsTableFilterComposer f) f,
  ) {
    final $$ActionItemRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.actionItemRows,
      getReferencedColumn: (t) => t.meetingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActionItemRowsTableFilterComposer(
            $db: $db,
            $table: $db.actionItemRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> decisionRowsRefs(
    Expression<bool> Function($$DecisionRowsTableFilterComposer f) f,
  ) {
    final $$DecisionRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.decisionRows,
      getReferencedColumn: (t) => t.meetingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecisionRowsTableFilterComposer(
            $db: $db,
            $table: $db.decisionRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> chatMessageRowsRefs(
    Expression<bool> Function($$ChatMessageRowsTableFilterComposer f) f,
  ) {
    final $$ChatMessageRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chatMessageRows,
      getReferencedColumn: (t) => t.meetingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatMessageRowsTableFilterComposer(
            $db: $db,
            $table: $db.chatMessageRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> todoRowsRefs(
    Expression<bool> Function($$TodoRowsTableFilterComposer f) f,
  ) {
    final $$TodoRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.todoRows,
      getReferencedColumn: (t) => t.meetingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TodoRowsTableFilterComposer(
            $db: $db,
            $table: $db.todoRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> studyMeetingLinkRowsRefs(
    Expression<bool> Function($$StudyMeetingLinkRowsTableFilterComposer f) f,
  ) {
    final $$StudyMeetingLinkRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyMeetingLinkRows,
      getReferencedColumn: (t) => t.meetingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyMeetingLinkRowsTableFilterComposer(
            $db: $db,
            $table: $db.studyMeetingLinkRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MeetingRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $MeetingRowsTable> {
  $$MeetingRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summaryPreview => $composableBuilder(
    column: $table.summaryPreview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MeetingRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeetingRowsTable> {
  $$MeetingRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get summaryPreview => $composableBuilder(
    column: $table.summaryPreview,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  Expression<T> audioAssetRowsRefs<T extends Object>(
    Expression<T> Function($$AudioAssetRowsTableAnnotationComposer a) f,
  ) {
    final $$AudioAssetRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.audioAssetRows,
      getReferencedColumn: (t) => t.meetingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioAssetRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.audioAssetRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transcriptSegmentRowsRefs<T extends Object>(
    Expression<T> Function($$TranscriptSegmentRowsTableAnnotationComposer a) f,
  ) {
    final $$TranscriptSegmentRowsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transcriptSegmentRows,
          getReferencedColumn: (t) => t.meetingId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TranscriptSegmentRowsTableAnnotationComposer(
                $db: $db,
                $table: $db.transcriptSegmentRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> summaryRowsRefs<T extends Object>(
    Expression<T> Function($$SummaryRowsTableAnnotationComposer a) f,
  ) {
    final $$SummaryRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.summaryRows,
      getReferencedColumn: (t) => t.meetingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SummaryRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.summaryRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> actionItemRowsRefs<T extends Object>(
    Expression<T> Function($$ActionItemRowsTableAnnotationComposer a) f,
  ) {
    final $$ActionItemRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.actionItemRows,
      getReferencedColumn: (t) => t.meetingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActionItemRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.actionItemRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> decisionRowsRefs<T extends Object>(
    Expression<T> Function($$DecisionRowsTableAnnotationComposer a) f,
  ) {
    final $$DecisionRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.decisionRows,
      getReferencedColumn: (t) => t.meetingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecisionRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.decisionRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> chatMessageRowsRefs<T extends Object>(
    Expression<T> Function($$ChatMessageRowsTableAnnotationComposer a) f,
  ) {
    final $$ChatMessageRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chatMessageRows,
      getReferencedColumn: (t) => t.meetingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatMessageRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.chatMessageRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> todoRowsRefs<T extends Object>(
    Expression<T> Function($$TodoRowsTableAnnotationComposer a) f,
  ) {
    final $$TodoRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.todoRows,
      getReferencedColumn: (t) => t.meetingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TodoRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.todoRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> studyMeetingLinkRowsRefs<T extends Object>(
    Expression<T> Function($$StudyMeetingLinkRowsTableAnnotationComposer a) f,
  ) {
    final $$StudyMeetingLinkRowsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.studyMeetingLinkRows,
          getReferencedColumn: (t) => t.meetingId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StudyMeetingLinkRowsTableAnnotationComposer(
                $db: $db,
                $table: $db.studyMeetingLinkRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MeetingRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MeetingRowsTable,
          MeetingRecord,
          $$MeetingRowsTableFilterComposer,
          $$MeetingRowsTableOrderingComposer,
          $$MeetingRowsTableAnnotationComposer,
          $$MeetingRowsTableCreateCompanionBuilder,
          $$MeetingRowsTableUpdateCompanionBuilder,
          (MeetingRecord, $$MeetingRowsTableReferences),
          MeetingRecord,
          PrefetchHooks Function({
            bool audioAssetRowsRefs,
            bool transcriptSegmentRowsRefs,
            bool summaryRowsRefs,
            bool actionItemRowsRefs,
            bool decisionRowsRefs,
            bool chatMessageRowsRefs,
            bool todoRowsRefs,
            bool studyMeetingLinkRowsRefs,
          })
        > {
  $$MeetingRowsTableTableManager(_$AppDatabase db, $MeetingRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeetingRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeetingRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeetingRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<String?> summaryPreview = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MeetingRowsCompanion(
                id: id,
                title: title,
                createdAt: createdAt,
                startedAt: startedAt,
                endedAt: endedAt,
                durationMs: durationMs,
                status: status,
                isPinned: isPinned,
                isFavorite: isFavorite,
                languageCode: languageCode,
                summaryPreview: summaryPreview,
                tagsJson: tagsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required DateTime createdAt,
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                required String status,
                Value<bool> isPinned = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<String?> summaryPreview = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MeetingRowsCompanion.insert(
                id: id,
                title: title,
                createdAt: createdAt,
                startedAt: startedAt,
                endedAt: endedAt,
                durationMs: durationMs,
                status: status,
                isPinned: isPinned,
                isFavorite: isFavorite,
                languageCode: languageCode,
                summaryPreview: summaryPreview,
                tagsJson: tagsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MeetingRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                audioAssetRowsRefs = false,
                transcriptSegmentRowsRefs = false,
                summaryRowsRefs = false,
                actionItemRowsRefs = false,
                decisionRowsRefs = false,
                chatMessageRowsRefs = false,
                todoRowsRefs = false,
                studyMeetingLinkRowsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (audioAssetRowsRefs) db.audioAssetRows,
                    if (transcriptSegmentRowsRefs) db.transcriptSegmentRows,
                    if (summaryRowsRefs) db.summaryRows,
                    if (actionItemRowsRefs) db.actionItemRows,
                    if (decisionRowsRefs) db.decisionRows,
                    if (chatMessageRowsRefs) db.chatMessageRows,
                    if (todoRowsRefs) db.todoRows,
                    if (studyMeetingLinkRowsRefs) db.studyMeetingLinkRows,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (audioAssetRowsRefs)
                        await $_getPrefetchedData<
                          MeetingRecord,
                          $MeetingRowsTable,
                          AudioAssetRecord
                        >(
                          currentTable: table,
                          referencedTable: $$MeetingRowsTableReferences
                              ._audioAssetRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MeetingRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).audioAssetRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.meetingId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (transcriptSegmentRowsRefs)
                        await $_getPrefetchedData<
                          MeetingRecord,
                          $MeetingRowsTable,
                          TranscriptSegmentRecord
                        >(
                          currentTable: table,
                          referencedTable: $$MeetingRowsTableReferences
                              ._transcriptSegmentRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MeetingRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).transcriptSegmentRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.meetingId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (summaryRowsRefs)
                        await $_getPrefetchedData<
                          MeetingRecord,
                          $MeetingRowsTable,
                          SummaryRecord
                        >(
                          currentTable: table,
                          referencedTable: $$MeetingRowsTableReferences
                              ._summaryRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MeetingRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).summaryRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.meetingId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (actionItemRowsRefs)
                        await $_getPrefetchedData<
                          MeetingRecord,
                          $MeetingRowsTable,
                          ActionItemRecord
                        >(
                          currentTable: table,
                          referencedTable: $$MeetingRowsTableReferences
                              ._actionItemRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MeetingRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).actionItemRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.meetingId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (decisionRowsRefs)
                        await $_getPrefetchedData<
                          MeetingRecord,
                          $MeetingRowsTable,
                          DecisionRecord
                        >(
                          currentTable: table,
                          referencedTable: $$MeetingRowsTableReferences
                              ._decisionRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MeetingRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).decisionRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.meetingId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (chatMessageRowsRefs)
                        await $_getPrefetchedData<
                          MeetingRecord,
                          $MeetingRowsTable,
                          ChatMessageRecord
                        >(
                          currentTable: table,
                          referencedTable: $$MeetingRowsTableReferences
                              ._chatMessageRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MeetingRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).chatMessageRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.meetingId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (todoRowsRefs)
                        await $_getPrefetchedData<
                          MeetingRecord,
                          $MeetingRowsTable,
                          TodoRecord
                        >(
                          currentTable: table,
                          referencedTable: $$MeetingRowsTableReferences
                              ._todoRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MeetingRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).todoRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.meetingId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (studyMeetingLinkRowsRefs)
                        await $_getPrefetchedData<
                          MeetingRecord,
                          $MeetingRowsTable,
                          StudyMeetingLinkRecord
                        >(
                          currentTable: table,
                          referencedTable: $$MeetingRowsTableReferences
                              ._studyMeetingLinkRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MeetingRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).studyMeetingLinkRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.meetingId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MeetingRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MeetingRowsTable,
      MeetingRecord,
      $$MeetingRowsTableFilterComposer,
      $$MeetingRowsTableOrderingComposer,
      $$MeetingRowsTableAnnotationComposer,
      $$MeetingRowsTableCreateCompanionBuilder,
      $$MeetingRowsTableUpdateCompanionBuilder,
      (MeetingRecord, $$MeetingRowsTableReferences),
      MeetingRecord,
      PrefetchHooks Function({
        bool audioAssetRowsRefs,
        bool transcriptSegmentRowsRefs,
        bool summaryRowsRefs,
        bool actionItemRowsRefs,
        bool decisionRowsRefs,
        bool chatMessageRowsRefs,
        bool todoRowsRefs,
        bool studyMeetingLinkRowsRefs,
      })
    >;
typedef $$AudioAssetRowsTableCreateCompanionBuilder =
    AudioAssetRowsCompanion Function({
      required String id,
      required String meetingId,
      required String source,
      required String path,
      required int sampleRate,
      required int channels,
      Value<int> durationMs,
      Value<int> byteSize,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$AudioAssetRowsTableUpdateCompanionBuilder =
    AudioAssetRowsCompanion Function({
      Value<String> id,
      Value<String> meetingId,
      Value<String> source,
      Value<String> path,
      Value<int> sampleRate,
      Value<int> channels,
      Value<int> durationMs,
      Value<int> byteSize,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$AudioAssetRowsTableReferences
    extends
        BaseReferences<_$AppDatabase, $AudioAssetRowsTable, AudioAssetRecord> {
  $$AudioAssetRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MeetingRowsTable _meetingIdTable(_$AppDatabase db) =>
      db.meetingRows.createAlias(
        $_aliasNameGenerator(db.audioAssetRows.meetingId, db.meetingRows.id),
      );

  $$MeetingRowsTableProcessedTableManager get meetingId {
    final $_column = $_itemColumn<String>('meeting_id')!;

    final manager = $$MeetingRowsTableTableManager(
      $_db,
      $_db.meetingRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_meetingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AudioAssetRowsTableFilterComposer
    extends Composer<_$AppDatabase, $AudioAssetRowsTable> {
  $$AudioAssetRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sampleRate => $composableBuilder(
    column: $table.sampleRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get channels => $composableBuilder(
    column: $table.channels,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MeetingRowsTableFilterComposer get meetingId {
    final $$MeetingRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableFilterComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AudioAssetRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $AudioAssetRowsTable> {
  $$AudioAssetRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sampleRate => $composableBuilder(
    column: $table.sampleRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get channels => $composableBuilder(
    column: $table.channels,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MeetingRowsTableOrderingComposer get meetingId {
    final $$MeetingRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableOrderingComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AudioAssetRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AudioAssetRowsTable> {
  $$AudioAssetRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<int> get sampleRate => $composableBuilder(
    column: $table.sampleRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get channels =>
      $composableBuilder(column: $table.channels, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get byteSize =>
      $composableBuilder(column: $table.byteSize, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MeetingRowsTableAnnotationComposer get meetingId {
    final $$MeetingRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AudioAssetRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AudioAssetRowsTable,
          AudioAssetRecord,
          $$AudioAssetRowsTableFilterComposer,
          $$AudioAssetRowsTableOrderingComposer,
          $$AudioAssetRowsTableAnnotationComposer,
          $$AudioAssetRowsTableCreateCompanionBuilder,
          $$AudioAssetRowsTableUpdateCompanionBuilder,
          (AudioAssetRecord, $$AudioAssetRowsTableReferences),
          AudioAssetRecord,
          PrefetchHooks Function({bool meetingId})
        > {
  $$AudioAssetRowsTableTableManager(
    _$AppDatabase db,
    $AudioAssetRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AudioAssetRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AudioAssetRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AudioAssetRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> meetingId = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<int> sampleRate = const Value.absent(),
                Value<int> channels = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<int> byteSize = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AudioAssetRowsCompanion(
                id: id,
                meetingId: meetingId,
                source: source,
                path: path,
                sampleRate: sampleRate,
                channels: channels,
                durationMs: durationMs,
                byteSize: byteSize,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String meetingId,
                required String source,
                required String path,
                required int sampleRate,
                required int channels,
                Value<int> durationMs = const Value.absent(),
                Value<int> byteSize = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => AudioAssetRowsCompanion.insert(
                id: id,
                meetingId: meetingId,
                source: source,
                path: path,
                sampleRate: sampleRate,
                channels: channels,
                durationMs: durationMs,
                byteSize: byteSize,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AudioAssetRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({meetingId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (meetingId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.meetingId,
                                referencedTable: $$AudioAssetRowsTableReferences
                                    ._meetingIdTable(db),
                                referencedColumn:
                                    $$AudioAssetRowsTableReferences
                                        ._meetingIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AudioAssetRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AudioAssetRowsTable,
      AudioAssetRecord,
      $$AudioAssetRowsTableFilterComposer,
      $$AudioAssetRowsTableOrderingComposer,
      $$AudioAssetRowsTableAnnotationComposer,
      $$AudioAssetRowsTableCreateCompanionBuilder,
      $$AudioAssetRowsTableUpdateCompanionBuilder,
      (AudioAssetRecord, $$AudioAssetRowsTableReferences),
      AudioAssetRecord,
      PrefetchHooks Function({bool meetingId})
    >;
typedef $$TranscriptSegmentRowsTableCreateCompanionBuilder =
    TranscriptSegmentRowsCompanion Function({
      required String id,
      required String meetingId,
      required String source,
      Value<String?> speakerLabel,
      required int startMs,
      required int endMs,
      required String content,
      Value<double?> confidence,
      Value<bool> isFinal,
      Value<String> tagsJson,
      Value<int> rowid,
    });
typedef $$TranscriptSegmentRowsTableUpdateCompanionBuilder =
    TranscriptSegmentRowsCompanion Function({
      Value<String> id,
      Value<String> meetingId,
      Value<String> source,
      Value<String?> speakerLabel,
      Value<int> startMs,
      Value<int> endMs,
      Value<String> content,
      Value<double?> confidence,
      Value<bool> isFinal,
      Value<String> tagsJson,
      Value<int> rowid,
    });

final class $$TranscriptSegmentRowsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TranscriptSegmentRowsTable,
          TranscriptSegmentRecord
        > {
  $$TranscriptSegmentRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MeetingRowsTable _meetingIdTable(_$AppDatabase db) =>
      db.meetingRows.createAlias(
        $_aliasNameGenerator(
          db.transcriptSegmentRows.meetingId,
          db.meetingRows.id,
        ),
      );

  $$MeetingRowsTableProcessedTableManager get meetingId {
    final $_column = $_itemColumn<String>('meeting_id')!;

    final manager = $$MeetingRowsTableTableManager(
      $_db,
      $_db.meetingRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_meetingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TranscriptSegmentRowsTableFilterComposer
    extends Composer<_$AppDatabase, $TranscriptSegmentRowsTable> {
  $$TranscriptSegmentRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get speakerLabel => $composableBuilder(
    column: $table.speakerLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMs => $composableBuilder(
    column: $table.startMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMs => $composableBuilder(
    column: $table.endMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFinal => $composableBuilder(
    column: $table.isFinal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnFilters(column),
  );

  $$MeetingRowsTableFilterComposer get meetingId {
    final $$MeetingRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableFilterComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TranscriptSegmentRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $TranscriptSegmentRowsTable> {
  $$TranscriptSegmentRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speakerLabel => $composableBuilder(
    column: $table.speakerLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMs => $composableBuilder(
    column: $table.startMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMs => $composableBuilder(
    column: $table.endMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFinal => $composableBuilder(
    column: $table.isFinal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$MeetingRowsTableOrderingComposer get meetingId {
    final $$MeetingRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableOrderingComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TranscriptSegmentRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TranscriptSegmentRowsTable> {
  $$TranscriptSegmentRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get speakerLabel => $composableBuilder(
    column: $table.speakerLabel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startMs =>
      $composableBuilder(column: $table.startMs, builder: (column) => column);

  GeneratedColumn<int> get endMs =>
      $composableBuilder(column: $table.endMs, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFinal =>
      $composableBuilder(column: $table.isFinal, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  $$MeetingRowsTableAnnotationComposer get meetingId {
    final $$MeetingRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TranscriptSegmentRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TranscriptSegmentRowsTable,
          TranscriptSegmentRecord,
          $$TranscriptSegmentRowsTableFilterComposer,
          $$TranscriptSegmentRowsTableOrderingComposer,
          $$TranscriptSegmentRowsTableAnnotationComposer,
          $$TranscriptSegmentRowsTableCreateCompanionBuilder,
          $$TranscriptSegmentRowsTableUpdateCompanionBuilder,
          (TranscriptSegmentRecord, $$TranscriptSegmentRowsTableReferences),
          TranscriptSegmentRecord,
          PrefetchHooks Function({bool meetingId})
        > {
  $$TranscriptSegmentRowsTableTableManager(
    _$AppDatabase db,
    $TranscriptSegmentRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TranscriptSegmentRowsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$TranscriptSegmentRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TranscriptSegmentRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> meetingId = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> speakerLabel = const Value.absent(),
                Value<int> startMs = const Value.absent(),
                Value<int> endMs = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<bool> isFinal = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TranscriptSegmentRowsCompanion(
                id: id,
                meetingId: meetingId,
                source: source,
                speakerLabel: speakerLabel,
                startMs: startMs,
                endMs: endMs,
                content: content,
                confidence: confidence,
                isFinal: isFinal,
                tagsJson: tagsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String meetingId,
                required String source,
                Value<String?> speakerLabel = const Value.absent(),
                required int startMs,
                required int endMs,
                required String content,
                Value<double?> confidence = const Value.absent(),
                Value<bool> isFinal = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TranscriptSegmentRowsCompanion.insert(
                id: id,
                meetingId: meetingId,
                source: source,
                speakerLabel: speakerLabel,
                startMs: startMs,
                endMs: endMs,
                content: content,
                confidence: confidence,
                isFinal: isFinal,
                tagsJson: tagsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TranscriptSegmentRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({meetingId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (meetingId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.meetingId,
                                referencedTable:
                                    $$TranscriptSegmentRowsTableReferences
                                        ._meetingIdTable(db),
                                referencedColumn:
                                    $$TranscriptSegmentRowsTableReferences
                                        ._meetingIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TranscriptSegmentRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TranscriptSegmentRowsTable,
      TranscriptSegmentRecord,
      $$TranscriptSegmentRowsTableFilterComposer,
      $$TranscriptSegmentRowsTableOrderingComposer,
      $$TranscriptSegmentRowsTableAnnotationComposer,
      $$TranscriptSegmentRowsTableCreateCompanionBuilder,
      $$TranscriptSegmentRowsTableUpdateCompanionBuilder,
      (TranscriptSegmentRecord, $$TranscriptSegmentRowsTableReferences),
      TranscriptSegmentRecord,
      PrefetchHooks Function({bool meetingId})
    >;
typedef $$SummaryRowsTableCreateCompanionBuilder =
    SummaryRowsCompanion Function({
      required String meetingId,
      required String generatedTitle,
      required String overview,
      required String summaryJson,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$SummaryRowsTableUpdateCompanionBuilder =
    SummaryRowsCompanion Function({
      Value<String> meetingId,
      Value<String> generatedTitle,
      Value<String> overview,
      Value<String> summaryJson,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$SummaryRowsTableReferences
    extends BaseReferences<_$AppDatabase, $SummaryRowsTable, SummaryRecord> {
  $$SummaryRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MeetingRowsTable _meetingIdTable(_$AppDatabase db) =>
      db.meetingRows.createAlias(
        $_aliasNameGenerator(db.summaryRows.meetingId, db.meetingRows.id),
      );

  $$MeetingRowsTableProcessedTableManager get meetingId {
    final $_column = $_itemColumn<String>('meeting_id')!;

    final manager = $$MeetingRowsTableTableManager(
      $_db,
      $_db.meetingRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_meetingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SummaryRowsTableFilterComposer
    extends Composer<_$AppDatabase, $SummaryRowsTable> {
  $$SummaryRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get generatedTitle => $composableBuilder(
    column: $table.generatedTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get overview => $composableBuilder(
    column: $table.overview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MeetingRowsTableFilterComposer get meetingId {
    final $$MeetingRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableFilterComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SummaryRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $SummaryRowsTable> {
  $$SummaryRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get generatedTitle => $composableBuilder(
    column: $table.generatedTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get overview => $composableBuilder(
    column: $table.overview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MeetingRowsTableOrderingComposer get meetingId {
    final $$MeetingRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableOrderingComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SummaryRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SummaryRowsTable> {
  $$SummaryRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get generatedTitle => $composableBuilder(
    column: $table.generatedTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get overview =>
      $composableBuilder(column: $table.overview, builder: (column) => column);

  GeneratedColumn<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MeetingRowsTableAnnotationComposer get meetingId {
    final $$MeetingRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SummaryRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SummaryRowsTable,
          SummaryRecord,
          $$SummaryRowsTableFilterComposer,
          $$SummaryRowsTableOrderingComposer,
          $$SummaryRowsTableAnnotationComposer,
          $$SummaryRowsTableCreateCompanionBuilder,
          $$SummaryRowsTableUpdateCompanionBuilder,
          (SummaryRecord, $$SummaryRowsTableReferences),
          SummaryRecord,
          PrefetchHooks Function({bool meetingId})
        > {
  $$SummaryRowsTableTableManager(_$AppDatabase db, $SummaryRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SummaryRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SummaryRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SummaryRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> meetingId = const Value.absent(),
                Value<String> generatedTitle = const Value.absent(),
                Value<String> overview = const Value.absent(),
                Value<String> summaryJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SummaryRowsCompanion(
                meetingId: meetingId,
                generatedTitle: generatedTitle,
                overview: overview,
                summaryJson: summaryJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String meetingId,
                required String generatedTitle,
                required String overview,
                required String summaryJson,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SummaryRowsCompanion.insert(
                meetingId: meetingId,
                generatedTitle: generatedTitle,
                overview: overview,
                summaryJson: summaryJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SummaryRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({meetingId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (meetingId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.meetingId,
                                referencedTable: $$SummaryRowsTableReferences
                                    ._meetingIdTable(db),
                                referencedColumn: $$SummaryRowsTableReferences
                                    ._meetingIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SummaryRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SummaryRowsTable,
      SummaryRecord,
      $$SummaryRowsTableFilterComposer,
      $$SummaryRowsTableOrderingComposer,
      $$SummaryRowsTableAnnotationComposer,
      $$SummaryRowsTableCreateCompanionBuilder,
      $$SummaryRowsTableUpdateCompanionBuilder,
      (SummaryRecord, $$SummaryRowsTableReferences),
      SummaryRecord,
      PrefetchHooks Function({bool meetingId})
    >;
typedef $$ActionItemRowsTableCreateCompanionBuilder =
    ActionItemRowsCompanion Function({
      required String id,
      required String meetingId,
      required String content,
      Value<String?> owner,
      Value<String?> dueDate,
      Value<bool> done,
      Value<String> evidenceJson,
      Value<int> rowid,
    });
typedef $$ActionItemRowsTableUpdateCompanionBuilder =
    ActionItemRowsCompanion Function({
      Value<String> id,
      Value<String> meetingId,
      Value<String> content,
      Value<String?> owner,
      Value<String?> dueDate,
      Value<bool> done,
      Value<String> evidenceJson,
      Value<int> rowid,
    });

final class $$ActionItemRowsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ActionItemRowsTable, ActionItemRecord> {
  $$ActionItemRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MeetingRowsTable _meetingIdTable(_$AppDatabase db) =>
      db.meetingRows.createAlias(
        $_aliasNameGenerator(db.actionItemRows.meetingId, db.meetingRows.id),
      );

  $$MeetingRowsTableProcessedTableManager get meetingId {
    final $_column = $_itemColumn<String>('meeting_id')!;

    final manager = $$MeetingRowsTableTableManager(
      $_db,
      $_db.meetingRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_meetingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActionItemRowsTableFilterComposer
    extends Composer<_$AppDatabase, $ActionItemRowsTable> {
  $$ActionItemRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get owner => $composableBuilder(
    column: $table.owner,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evidenceJson => $composableBuilder(
    column: $table.evidenceJson,
    builder: (column) => ColumnFilters(column),
  );

  $$MeetingRowsTableFilterComposer get meetingId {
    final $$MeetingRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableFilterComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActionItemRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActionItemRowsTable> {
  $$ActionItemRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get owner => $composableBuilder(
    column: $table.owner,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evidenceJson => $composableBuilder(
    column: $table.evidenceJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$MeetingRowsTableOrderingComposer get meetingId {
    final $$MeetingRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableOrderingComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActionItemRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActionItemRowsTable> {
  $$ActionItemRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get owner =>
      $composableBuilder(column: $table.owner, builder: (column) => column);

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<String> get evidenceJson => $composableBuilder(
    column: $table.evidenceJson,
    builder: (column) => column,
  );

  $$MeetingRowsTableAnnotationComposer get meetingId {
    final $$MeetingRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActionItemRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActionItemRowsTable,
          ActionItemRecord,
          $$ActionItemRowsTableFilterComposer,
          $$ActionItemRowsTableOrderingComposer,
          $$ActionItemRowsTableAnnotationComposer,
          $$ActionItemRowsTableCreateCompanionBuilder,
          $$ActionItemRowsTableUpdateCompanionBuilder,
          (ActionItemRecord, $$ActionItemRowsTableReferences),
          ActionItemRecord,
          PrefetchHooks Function({bool meetingId})
        > {
  $$ActionItemRowsTableTableManager(
    _$AppDatabase db,
    $ActionItemRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActionItemRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActionItemRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActionItemRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> meetingId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> owner = const Value.absent(),
                Value<String?> dueDate = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<String> evidenceJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActionItemRowsCompanion(
                id: id,
                meetingId: meetingId,
                content: content,
                owner: owner,
                dueDate: dueDate,
                done: done,
                evidenceJson: evidenceJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String meetingId,
                required String content,
                Value<String?> owner = const Value.absent(),
                Value<String?> dueDate = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<String> evidenceJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActionItemRowsCompanion.insert(
                id: id,
                meetingId: meetingId,
                content: content,
                owner: owner,
                dueDate: dueDate,
                done: done,
                evidenceJson: evidenceJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActionItemRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({meetingId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (meetingId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.meetingId,
                                referencedTable: $$ActionItemRowsTableReferences
                                    ._meetingIdTable(db),
                                referencedColumn:
                                    $$ActionItemRowsTableReferences
                                        ._meetingIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ActionItemRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActionItemRowsTable,
      ActionItemRecord,
      $$ActionItemRowsTableFilterComposer,
      $$ActionItemRowsTableOrderingComposer,
      $$ActionItemRowsTableAnnotationComposer,
      $$ActionItemRowsTableCreateCompanionBuilder,
      $$ActionItemRowsTableUpdateCompanionBuilder,
      (ActionItemRecord, $$ActionItemRowsTableReferences),
      ActionItemRecord,
      PrefetchHooks Function({bool meetingId})
    >;
typedef $$DecisionRowsTableCreateCompanionBuilder =
    DecisionRowsCompanion Function({
      required String id,
      required String meetingId,
      required String content,
      Value<String?> rationale,
      Value<String> evidenceJson,
      Value<int> rowid,
    });
typedef $$DecisionRowsTableUpdateCompanionBuilder =
    DecisionRowsCompanion Function({
      Value<String> id,
      Value<String> meetingId,
      Value<String> content,
      Value<String?> rationale,
      Value<String> evidenceJson,
      Value<int> rowid,
    });

final class $$DecisionRowsTableReferences
    extends BaseReferences<_$AppDatabase, $DecisionRowsTable, DecisionRecord> {
  $$DecisionRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MeetingRowsTable _meetingIdTable(_$AppDatabase db) =>
      db.meetingRows.createAlias(
        $_aliasNameGenerator(db.decisionRows.meetingId, db.meetingRows.id),
      );

  $$MeetingRowsTableProcessedTableManager get meetingId {
    final $_column = $_itemColumn<String>('meeting_id')!;

    final manager = $$MeetingRowsTableTableManager(
      $_db,
      $_db.meetingRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_meetingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DecisionRowsTableFilterComposer
    extends Composer<_$AppDatabase, $DecisionRowsTable> {
  $$DecisionRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rationale => $composableBuilder(
    column: $table.rationale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evidenceJson => $composableBuilder(
    column: $table.evidenceJson,
    builder: (column) => ColumnFilters(column),
  );

  $$MeetingRowsTableFilterComposer get meetingId {
    final $$MeetingRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableFilterComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DecisionRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $DecisionRowsTable> {
  $$DecisionRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rationale => $composableBuilder(
    column: $table.rationale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evidenceJson => $composableBuilder(
    column: $table.evidenceJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$MeetingRowsTableOrderingComposer get meetingId {
    final $$MeetingRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableOrderingComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DecisionRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DecisionRowsTable> {
  $$DecisionRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get rationale =>
      $composableBuilder(column: $table.rationale, builder: (column) => column);

  GeneratedColumn<String> get evidenceJson => $composableBuilder(
    column: $table.evidenceJson,
    builder: (column) => column,
  );

  $$MeetingRowsTableAnnotationComposer get meetingId {
    final $$MeetingRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DecisionRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DecisionRowsTable,
          DecisionRecord,
          $$DecisionRowsTableFilterComposer,
          $$DecisionRowsTableOrderingComposer,
          $$DecisionRowsTableAnnotationComposer,
          $$DecisionRowsTableCreateCompanionBuilder,
          $$DecisionRowsTableUpdateCompanionBuilder,
          (DecisionRecord, $$DecisionRowsTableReferences),
          DecisionRecord,
          PrefetchHooks Function({bool meetingId})
        > {
  $$DecisionRowsTableTableManager(_$AppDatabase db, $DecisionRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DecisionRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DecisionRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DecisionRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> meetingId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> rationale = const Value.absent(),
                Value<String> evidenceJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DecisionRowsCompanion(
                id: id,
                meetingId: meetingId,
                content: content,
                rationale: rationale,
                evidenceJson: evidenceJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String meetingId,
                required String content,
                Value<String?> rationale = const Value.absent(),
                Value<String> evidenceJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DecisionRowsCompanion.insert(
                id: id,
                meetingId: meetingId,
                content: content,
                rationale: rationale,
                evidenceJson: evidenceJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DecisionRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({meetingId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (meetingId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.meetingId,
                                referencedTable: $$DecisionRowsTableReferences
                                    ._meetingIdTable(db),
                                referencedColumn: $$DecisionRowsTableReferences
                                    ._meetingIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DecisionRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DecisionRowsTable,
      DecisionRecord,
      $$DecisionRowsTableFilterComposer,
      $$DecisionRowsTableOrderingComposer,
      $$DecisionRowsTableAnnotationComposer,
      $$DecisionRowsTableCreateCompanionBuilder,
      $$DecisionRowsTableUpdateCompanionBuilder,
      (DecisionRecord, $$DecisionRowsTableReferences),
      DecisionRecord,
      PrefetchHooks Function({bool meetingId})
    >;
typedef $$ChatMessageRowsTableCreateCompanionBuilder =
    ChatMessageRowsCompanion Function({
      required String id,
      required String meetingId,
      required String role,
      required String content,
      required DateTime createdAt,
      Value<bool> isStreaming,
      Value<String> evidenceJson,
      Value<int> rowid,
    });
typedef $$ChatMessageRowsTableUpdateCompanionBuilder =
    ChatMessageRowsCompanion Function({
      Value<String> id,
      Value<String> meetingId,
      Value<String> role,
      Value<String> content,
      Value<DateTime> createdAt,
      Value<bool> isStreaming,
      Value<String> evidenceJson,
      Value<int> rowid,
    });

final class $$ChatMessageRowsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ChatMessageRowsTable,
          ChatMessageRecord
        > {
  $$ChatMessageRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MeetingRowsTable _meetingIdTable(_$AppDatabase db) =>
      db.meetingRows.createAlias(
        $_aliasNameGenerator(db.chatMessageRows.meetingId, db.meetingRows.id),
      );

  $$MeetingRowsTableProcessedTableManager get meetingId {
    final $_column = $_itemColumn<String>('meeting_id')!;

    final manager = $$MeetingRowsTableTableManager(
      $_db,
      $_db.meetingRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_meetingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChatMessageRowsTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessageRowsTable> {
  $$ChatMessageRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStreaming => $composableBuilder(
    column: $table.isStreaming,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evidenceJson => $composableBuilder(
    column: $table.evidenceJson,
    builder: (column) => ColumnFilters(column),
  );

  $$MeetingRowsTableFilterComposer get meetingId {
    final $$MeetingRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableFilterComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChatMessageRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessageRowsTable> {
  $$ChatMessageRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStreaming => $composableBuilder(
    column: $table.isStreaming,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evidenceJson => $composableBuilder(
    column: $table.evidenceJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$MeetingRowsTableOrderingComposer get meetingId {
    final $$MeetingRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableOrderingComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChatMessageRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessageRowsTable> {
  $$ChatMessageRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isStreaming => $composableBuilder(
    column: $table.isStreaming,
    builder: (column) => column,
  );

  GeneratedColumn<String> get evidenceJson => $composableBuilder(
    column: $table.evidenceJson,
    builder: (column) => column,
  );

  $$MeetingRowsTableAnnotationComposer get meetingId {
    final $$MeetingRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChatMessageRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatMessageRowsTable,
          ChatMessageRecord,
          $$ChatMessageRowsTableFilterComposer,
          $$ChatMessageRowsTableOrderingComposer,
          $$ChatMessageRowsTableAnnotationComposer,
          $$ChatMessageRowsTableCreateCompanionBuilder,
          $$ChatMessageRowsTableUpdateCompanionBuilder,
          (ChatMessageRecord, $$ChatMessageRowsTableReferences),
          ChatMessageRecord,
          PrefetchHooks Function({bool meetingId})
        > {
  $$ChatMessageRowsTableTableManager(
    _$AppDatabase db,
    $ChatMessageRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessageRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessageRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessageRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> meetingId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isStreaming = const Value.absent(),
                Value<String> evidenceJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatMessageRowsCompanion(
                id: id,
                meetingId: meetingId,
                role: role,
                content: content,
                createdAt: createdAt,
                isStreaming: isStreaming,
                evidenceJson: evidenceJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String meetingId,
                required String role,
                required String content,
                required DateTime createdAt,
                Value<bool> isStreaming = const Value.absent(),
                Value<String> evidenceJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatMessageRowsCompanion.insert(
                id: id,
                meetingId: meetingId,
                role: role,
                content: content,
                createdAt: createdAt,
                isStreaming: isStreaming,
                evidenceJson: evidenceJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChatMessageRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({meetingId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (meetingId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.meetingId,
                                referencedTable:
                                    $$ChatMessageRowsTableReferences
                                        ._meetingIdTable(db),
                                referencedColumn:
                                    $$ChatMessageRowsTableReferences
                                        ._meetingIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ChatMessageRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatMessageRowsTable,
      ChatMessageRecord,
      $$ChatMessageRowsTableFilterComposer,
      $$ChatMessageRowsTableOrderingComposer,
      $$ChatMessageRowsTableAnnotationComposer,
      $$ChatMessageRowsTableCreateCompanionBuilder,
      $$ChatMessageRowsTableUpdateCompanionBuilder,
      (ChatMessageRecord, $$ChatMessageRowsTableReferences),
      ChatMessageRecord,
      PrefetchHooks Function({bool meetingId})
    >;
typedef $$TodoRowsTableCreateCompanionBuilder =
    TodoRowsCompanion Function({
      required String id,
      Value<String?> meetingId,
      required String content,
      Value<bool> done,
      required DateTime createdAt,
      Value<DateTime?> dueDate,
      Value<String?> notes,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$TodoRowsTableUpdateCompanionBuilder =
    TodoRowsCompanion Function({
      Value<String> id,
      Value<String?> meetingId,
      Value<String> content,
      Value<bool> done,
      Value<DateTime> createdAt,
      Value<DateTime?> dueDate,
      Value<String?> notes,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$TodoRowsTableReferences
    extends BaseReferences<_$AppDatabase, $TodoRowsTable, TodoRecord> {
  $$TodoRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MeetingRowsTable _meetingIdTable(_$AppDatabase db) =>
      db.meetingRows.createAlias(
        $_aliasNameGenerator(db.todoRows.meetingId, db.meetingRows.id),
      );

  $$MeetingRowsTableProcessedTableManager? get meetingId {
    final $_column = $_itemColumn<String>('meeting_id');
    if ($_column == null) return null;
    final manager = $$MeetingRowsTableTableManager(
      $_db,
      $_db.meetingRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_meetingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TodoRowsTableFilterComposer
    extends Composer<_$AppDatabase, $TodoRowsTable> {
  $$TodoRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$MeetingRowsTableFilterComposer get meetingId {
    final $$MeetingRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableFilterComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TodoRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $TodoRowsTable> {
  $$TodoRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$MeetingRowsTableOrderingComposer get meetingId {
    final $$MeetingRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableOrderingComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TodoRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodoRowsTable> {
  $$TodoRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$MeetingRowsTableAnnotationComposer get meetingId {
    final $$MeetingRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TodoRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TodoRowsTable,
          TodoRecord,
          $$TodoRowsTableFilterComposer,
          $$TodoRowsTableOrderingComposer,
          $$TodoRowsTableAnnotationComposer,
          $$TodoRowsTableCreateCompanionBuilder,
          $$TodoRowsTableUpdateCompanionBuilder,
          (TodoRecord, $$TodoRowsTableReferences),
          TodoRecord,
          PrefetchHooks Function({bool meetingId})
        > {
  $$TodoRowsTableTableManager(_$AppDatabase db, $TodoRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodoRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodoRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodoRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> meetingId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TodoRowsCompanion(
                id: id,
                meetingId: meetingId,
                content: content,
                done: done,
                createdAt: createdAt,
                dueDate: dueDate,
                notes: notes,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> meetingId = const Value.absent(),
                required String content,
                Value<bool> done = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> dueDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TodoRowsCompanion.insert(
                id: id,
                meetingId: meetingId,
                content: content,
                done: done,
                createdAt: createdAt,
                dueDate: dueDate,
                notes: notes,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TodoRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({meetingId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (meetingId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.meetingId,
                                referencedTable: $$TodoRowsTableReferences
                                    ._meetingIdTable(db),
                                referencedColumn: $$TodoRowsTableReferences
                                    ._meetingIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TodoRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TodoRowsTable,
      TodoRecord,
      $$TodoRowsTableFilterComposer,
      $$TodoRowsTableOrderingComposer,
      $$TodoRowsTableAnnotationComposer,
      $$TodoRowsTableCreateCompanionBuilder,
      $$TodoRowsTableUpdateCompanionBuilder,
      (TodoRecord, $$TodoRowsTableReferences),
      TodoRecord,
      PrefetchHooks Function({bool meetingId})
    >;
typedef $$SettingRowsTableCreateCompanionBuilder =
    SettingRowsCompanion Function({
      required String key,
      required String value,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SettingRowsTableUpdateCompanionBuilder =
    SettingRowsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SettingRowsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingRowsTable> {
  $$SettingRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingRowsTable> {
  $$SettingRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingRowsTable> {
  $$SettingRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SettingRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingRowsTable,
          SettingRecord,
          $$SettingRowsTableFilterComposer,
          $$SettingRowsTableOrderingComposer,
          $$SettingRowsTableAnnotationComposer,
          $$SettingRowsTableCreateCompanionBuilder,
          $$SettingRowsTableUpdateCompanionBuilder,
          (
            SettingRecord,
            BaseReferences<_$AppDatabase, $SettingRowsTable, SettingRecord>,
          ),
          SettingRecord,
          PrefetchHooks Function()
        > {
  $$SettingRowsTableTableManager(_$AppDatabase db, $SettingRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingRowsCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SettingRowsCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingRowsTable,
      SettingRecord,
      $$SettingRowsTableFilterComposer,
      $$SettingRowsTableOrderingComposer,
      $$SettingRowsTableAnnotationComposer,
      $$SettingRowsTableCreateCompanionBuilder,
      $$SettingRowsTableUpdateCompanionBuilder,
      (
        SettingRecord,
        BaseReferences<_$AppDatabase, $SettingRowsTable, SettingRecord>,
      ),
      SettingRecord,
      PrefetchHooks Function()
    >;
typedef $$StudyFolderRowsTableCreateCompanionBuilder =
    StudyFolderRowsCompanion Function({
      required String id,
      Value<String?> parentId,
      required String name,
      Value<String?> description,
      Value<String> color,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$StudyFolderRowsTableUpdateCompanionBuilder =
    StudyFolderRowsCompanion Function({
      Value<String> id,
      Value<String?> parentId,
      Value<String> name,
      Value<String?> description,
      Value<String> color,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$StudyFolderRowsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $StudyFolderRowsTable,
          StudyFolderRecord
        > {
  $$StudyFolderRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudyFolderRowsTable _parentIdTable(_$AppDatabase db) =>
      db.studyFolderRows.createAlias(
        $_aliasNameGenerator(
          db.studyFolderRows.parentId,
          db.studyFolderRows.id,
        ),
      );

  $$StudyFolderRowsTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<String>('parent_id');
    if ($_column == null) return null;
    final manager = $$StudyFolderRowsTableTableManager(
      $_db,
      $_db.studyFolderRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$StudyDocumentRowsTable, List<StudyDocumentRecord>>
  _studyDocumentRowsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.studyDocumentRows,
        aliasName: $_aliasNameGenerator(
          db.studyFolderRows.id,
          db.studyDocumentRows.folderId,
        ),
      );

  $$StudyDocumentRowsTableProcessedTableManager get studyDocumentRowsRefs {
    final manager = $$StudyDocumentRowsTableTableManager(
      $_db,
      $_db.studyDocumentRows,
    ).filter((f) => f.folderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _studyDocumentRowsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $StudyMeetingLinkRowsTable,
    List<StudyMeetingLinkRecord>
  >
  _studyMeetingLinkRowsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.studyMeetingLinkRows,
        aliasName: $_aliasNameGenerator(
          db.studyFolderRows.id,
          db.studyMeetingLinkRows.folderId,
        ),
      );

  $$StudyMeetingLinkRowsTableProcessedTableManager
  get studyMeetingLinkRowsRefs {
    final manager = $$StudyMeetingLinkRowsTableTableManager(
      $_db,
      $_db.studyMeetingLinkRows,
    ).filter((f) => f.folderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _studyMeetingLinkRowsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StudyChatRowsTable, List<StudyChatRecord>>
  _studyChatRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.studyChatRows,
    aliasName: $_aliasNameGenerator(
      db.studyFolderRows.id,
      db.studyChatRows.folderId,
    ),
  );

  $$StudyChatRowsTableProcessedTableManager get studyChatRowsRefs {
    final manager = $$StudyChatRowsTableTableManager(
      $_db,
      $_db.studyChatRows,
    ).filter((f) => f.folderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_studyChatRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StudyFolderRowsTableFilterComposer
    extends Composer<_$AppDatabase, $StudyFolderRowsTable> {
  $$StudyFolderRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StudyFolderRowsTableFilterComposer get parentId {
    final $$StudyFolderRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.studyFolderRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyFolderRowsTableFilterComposer(
            $db: $db,
            $table: $db.studyFolderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> studyDocumentRowsRefs(
    Expression<bool> Function($$StudyDocumentRowsTableFilterComposer f) f,
  ) {
    final $$StudyDocumentRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyDocumentRows,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyDocumentRowsTableFilterComposer(
            $db: $db,
            $table: $db.studyDocumentRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> studyMeetingLinkRowsRefs(
    Expression<bool> Function($$StudyMeetingLinkRowsTableFilterComposer f) f,
  ) {
    final $$StudyMeetingLinkRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyMeetingLinkRows,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyMeetingLinkRowsTableFilterComposer(
            $db: $db,
            $table: $db.studyMeetingLinkRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> studyChatRowsRefs(
    Expression<bool> Function($$StudyChatRowsTableFilterComposer f) f,
  ) {
    final $$StudyChatRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyChatRows,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyChatRowsTableFilterComposer(
            $db: $db,
            $table: $db.studyChatRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudyFolderRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyFolderRowsTable> {
  $$StudyFolderRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudyFolderRowsTableOrderingComposer get parentId {
    final $$StudyFolderRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.studyFolderRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyFolderRowsTableOrderingComposer(
            $db: $db,
            $table: $db.studyFolderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyFolderRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyFolderRowsTable> {
  $$StudyFolderRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$StudyFolderRowsTableAnnotationComposer get parentId {
    final $$StudyFolderRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.studyFolderRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyFolderRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.studyFolderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> studyDocumentRowsRefs<T extends Object>(
    Expression<T> Function($$StudyDocumentRowsTableAnnotationComposer a) f,
  ) {
    final $$StudyDocumentRowsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.studyDocumentRows,
          getReferencedColumn: (t) => t.folderId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StudyDocumentRowsTableAnnotationComposer(
                $db: $db,
                $table: $db.studyDocumentRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> studyMeetingLinkRowsRefs<T extends Object>(
    Expression<T> Function($$StudyMeetingLinkRowsTableAnnotationComposer a) f,
  ) {
    final $$StudyMeetingLinkRowsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.studyMeetingLinkRows,
          getReferencedColumn: (t) => t.folderId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StudyMeetingLinkRowsTableAnnotationComposer(
                $db: $db,
                $table: $db.studyMeetingLinkRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> studyChatRowsRefs<T extends Object>(
    Expression<T> Function($$StudyChatRowsTableAnnotationComposer a) f,
  ) {
    final $$StudyChatRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyChatRows,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyChatRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.studyChatRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudyFolderRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudyFolderRowsTable,
          StudyFolderRecord,
          $$StudyFolderRowsTableFilterComposer,
          $$StudyFolderRowsTableOrderingComposer,
          $$StudyFolderRowsTableAnnotationComposer,
          $$StudyFolderRowsTableCreateCompanionBuilder,
          $$StudyFolderRowsTableUpdateCompanionBuilder,
          (StudyFolderRecord, $$StudyFolderRowsTableReferences),
          StudyFolderRecord,
          PrefetchHooks Function({
            bool parentId,
            bool studyDocumentRowsRefs,
            bool studyMeetingLinkRowsRefs,
            bool studyChatRowsRefs,
          })
        > {
  $$StudyFolderRowsTableTableManager(
    _$AppDatabase db,
    $StudyFolderRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyFolderRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyFolderRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyFolderRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyFolderRowsCompanion(
                id: id,
                parentId: parentId,
                name: name,
                description: description,
                color: color,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> parentId = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String> color = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StudyFolderRowsCompanion.insert(
                id: id,
                parentId: parentId,
                name: name,
                description: description,
                color: color,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudyFolderRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                parentId = false,
                studyDocumentRowsRefs = false,
                studyMeetingLinkRowsRefs = false,
                studyChatRowsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (studyDocumentRowsRefs) db.studyDocumentRows,
                    if (studyMeetingLinkRowsRefs) db.studyMeetingLinkRows,
                    if (studyChatRowsRefs) db.studyChatRows,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (parentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.parentId,
                                    referencedTable:
                                        $$StudyFolderRowsTableReferences
                                            ._parentIdTable(db),
                                    referencedColumn:
                                        $$StudyFolderRowsTableReferences
                                            ._parentIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (studyDocumentRowsRefs)
                        await $_getPrefetchedData<
                          StudyFolderRecord,
                          $StudyFolderRowsTable,
                          StudyDocumentRecord
                        >(
                          currentTable: table,
                          referencedTable: $$StudyFolderRowsTableReferences
                              ._studyDocumentRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudyFolderRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).studyDocumentRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.folderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (studyMeetingLinkRowsRefs)
                        await $_getPrefetchedData<
                          StudyFolderRecord,
                          $StudyFolderRowsTable,
                          StudyMeetingLinkRecord
                        >(
                          currentTable: table,
                          referencedTable: $$StudyFolderRowsTableReferences
                              ._studyMeetingLinkRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudyFolderRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).studyMeetingLinkRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.folderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (studyChatRowsRefs)
                        await $_getPrefetchedData<
                          StudyFolderRecord,
                          $StudyFolderRowsTable,
                          StudyChatRecord
                        >(
                          currentTable: table,
                          referencedTable: $$StudyFolderRowsTableReferences
                              ._studyChatRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudyFolderRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).studyChatRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.folderId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StudyFolderRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudyFolderRowsTable,
      StudyFolderRecord,
      $$StudyFolderRowsTableFilterComposer,
      $$StudyFolderRowsTableOrderingComposer,
      $$StudyFolderRowsTableAnnotationComposer,
      $$StudyFolderRowsTableCreateCompanionBuilder,
      $$StudyFolderRowsTableUpdateCompanionBuilder,
      (StudyFolderRecord, $$StudyFolderRowsTableReferences),
      StudyFolderRecord,
      PrefetchHooks Function({
        bool parentId,
        bool studyDocumentRowsRefs,
        bool studyMeetingLinkRowsRefs,
        bool studyChatRowsRefs,
      })
    >;
typedef $$StudyDocumentRowsTableCreateCompanionBuilder =
    StudyDocumentRowsCompanion Function({
      required String id,
      required String folderId,
      required String title,
      required String kind,
      required String sourcePath,
      Value<String?> category,
      Value<String> extractedText,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$StudyDocumentRowsTableUpdateCompanionBuilder =
    StudyDocumentRowsCompanion Function({
      Value<String> id,
      Value<String> folderId,
      Value<String> title,
      Value<String> kind,
      Value<String> sourcePath,
      Value<String?> category,
      Value<String> extractedText,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$StudyDocumentRowsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $StudyDocumentRowsTable,
          StudyDocumentRecord
        > {
  $$StudyDocumentRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudyFolderRowsTable _folderIdTable(_$AppDatabase db) =>
      db.studyFolderRows.createAlias(
        $_aliasNameGenerator(
          db.studyDocumentRows.folderId,
          db.studyFolderRows.id,
        ),
      );

  $$StudyFolderRowsTableProcessedTableManager get folderId {
    final $_column = $_itemColumn<String>('folder_id')!;

    final manager = $$StudyFolderRowsTableTableManager(
      $_db,
      $_db.studyFolderRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_folderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StudyDocumentRowsTableFilterComposer
    extends Composer<_$AppDatabase, $StudyDocumentRowsTable> {
  $$StudyDocumentRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourcePath => $composableBuilder(
    column: $table.sourcePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extractedText => $composableBuilder(
    column: $table.extractedText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StudyFolderRowsTableFilterComposer get folderId {
    final $$StudyFolderRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.studyFolderRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyFolderRowsTableFilterComposer(
            $db: $db,
            $table: $db.studyFolderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyDocumentRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyDocumentRowsTable> {
  $$StudyDocumentRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourcePath => $composableBuilder(
    column: $table.sourcePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extractedText => $composableBuilder(
    column: $table.extractedText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudyFolderRowsTableOrderingComposer get folderId {
    final $$StudyFolderRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.studyFolderRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyFolderRowsTableOrderingComposer(
            $db: $db,
            $table: $db.studyFolderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyDocumentRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyDocumentRowsTable> {
  $$StudyDocumentRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get sourcePath => $composableBuilder(
    column: $table.sourcePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get extractedText => $composableBuilder(
    column: $table.extractedText,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$StudyFolderRowsTableAnnotationComposer get folderId {
    final $$StudyFolderRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.studyFolderRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyFolderRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.studyFolderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyDocumentRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudyDocumentRowsTable,
          StudyDocumentRecord,
          $$StudyDocumentRowsTableFilterComposer,
          $$StudyDocumentRowsTableOrderingComposer,
          $$StudyDocumentRowsTableAnnotationComposer,
          $$StudyDocumentRowsTableCreateCompanionBuilder,
          $$StudyDocumentRowsTableUpdateCompanionBuilder,
          (StudyDocumentRecord, $$StudyDocumentRowsTableReferences),
          StudyDocumentRecord,
          PrefetchHooks Function({bool folderId})
        > {
  $$StudyDocumentRowsTableTableManager(
    _$AppDatabase db,
    $StudyDocumentRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyDocumentRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyDocumentRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyDocumentRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> folderId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> sourcePath = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String> extractedText = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyDocumentRowsCompanion(
                id: id,
                folderId: folderId,
                title: title,
                kind: kind,
                sourcePath: sourcePath,
                category: category,
                extractedText: extractedText,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String folderId,
                required String title,
                required String kind,
                required String sourcePath,
                Value<String?> category = const Value.absent(),
                Value<String> extractedText = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StudyDocumentRowsCompanion.insert(
                id: id,
                folderId: folderId,
                title: title,
                kind: kind,
                sourcePath: sourcePath,
                category: category,
                extractedText: extractedText,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudyDocumentRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({folderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (folderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.folderId,
                                referencedTable:
                                    $$StudyDocumentRowsTableReferences
                                        ._folderIdTable(db),
                                referencedColumn:
                                    $$StudyDocumentRowsTableReferences
                                        ._folderIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StudyDocumentRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudyDocumentRowsTable,
      StudyDocumentRecord,
      $$StudyDocumentRowsTableFilterComposer,
      $$StudyDocumentRowsTableOrderingComposer,
      $$StudyDocumentRowsTableAnnotationComposer,
      $$StudyDocumentRowsTableCreateCompanionBuilder,
      $$StudyDocumentRowsTableUpdateCompanionBuilder,
      (StudyDocumentRecord, $$StudyDocumentRowsTableReferences),
      StudyDocumentRecord,
      PrefetchHooks Function({bool folderId})
    >;
typedef $$StudyMeetingLinkRowsTableCreateCompanionBuilder =
    StudyMeetingLinkRowsCompanion Function({
      required String id,
      required String folderId,
      required String meetingId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$StudyMeetingLinkRowsTableUpdateCompanionBuilder =
    StudyMeetingLinkRowsCompanion Function({
      Value<String> id,
      Value<String> folderId,
      Value<String> meetingId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$StudyMeetingLinkRowsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $StudyMeetingLinkRowsTable,
          StudyMeetingLinkRecord
        > {
  $$StudyMeetingLinkRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudyFolderRowsTable _folderIdTable(_$AppDatabase db) =>
      db.studyFolderRows.createAlias(
        $_aliasNameGenerator(
          db.studyMeetingLinkRows.folderId,
          db.studyFolderRows.id,
        ),
      );

  $$StudyFolderRowsTableProcessedTableManager get folderId {
    final $_column = $_itemColumn<String>('folder_id')!;

    final manager = $$StudyFolderRowsTableTableManager(
      $_db,
      $_db.studyFolderRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_folderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MeetingRowsTable _meetingIdTable(_$AppDatabase db) =>
      db.meetingRows.createAlias(
        $_aliasNameGenerator(
          db.studyMeetingLinkRows.meetingId,
          db.meetingRows.id,
        ),
      );

  $$MeetingRowsTableProcessedTableManager get meetingId {
    final $_column = $_itemColumn<String>('meeting_id')!;

    final manager = $$MeetingRowsTableTableManager(
      $_db,
      $_db.meetingRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_meetingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StudyMeetingLinkRowsTableFilterComposer
    extends Composer<_$AppDatabase, $StudyMeetingLinkRowsTable> {
  $$StudyMeetingLinkRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StudyFolderRowsTableFilterComposer get folderId {
    final $$StudyFolderRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.studyFolderRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyFolderRowsTableFilterComposer(
            $db: $db,
            $table: $db.studyFolderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MeetingRowsTableFilterComposer get meetingId {
    final $$MeetingRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableFilterComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyMeetingLinkRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyMeetingLinkRowsTable> {
  $$StudyMeetingLinkRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudyFolderRowsTableOrderingComposer get folderId {
    final $$StudyFolderRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.studyFolderRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyFolderRowsTableOrderingComposer(
            $db: $db,
            $table: $db.studyFolderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MeetingRowsTableOrderingComposer get meetingId {
    final $$MeetingRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableOrderingComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyMeetingLinkRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyMeetingLinkRowsTable> {
  $$StudyMeetingLinkRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$StudyFolderRowsTableAnnotationComposer get folderId {
    final $$StudyFolderRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.studyFolderRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyFolderRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.studyFolderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MeetingRowsTableAnnotationComposer get meetingId {
    final $$MeetingRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.meetingId,
      referencedTable: $db.meetingRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeetingRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.meetingRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyMeetingLinkRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudyMeetingLinkRowsTable,
          StudyMeetingLinkRecord,
          $$StudyMeetingLinkRowsTableFilterComposer,
          $$StudyMeetingLinkRowsTableOrderingComposer,
          $$StudyMeetingLinkRowsTableAnnotationComposer,
          $$StudyMeetingLinkRowsTableCreateCompanionBuilder,
          $$StudyMeetingLinkRowsTableUpdateCompanionBuilder,
          (StudyMeetingLinkRecord, $$StudyMeetingLinkRowsTableReferences),
          StudyMeetingLinkRecord,
          PrefetchHooks Function({bool folderId, bool meetingId})
        > {
  $$StudyMeetingLinkRowsTableTableManager(
    _$AppDatabase db,
    $StudyMeetingLinkRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyMeetingLinkRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyMeetingLinkRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StudyMeetingLinkRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> folderId = const Value.absent(),
                Value<String> meetingId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyMeetingLinkRowsCompanion(
                id: id,
                folderId: folderId,
                meetingId: meetingId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String folderId,
                required String meetingId,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StudyMeetingLinkRowsCompanion.insert(
                id: id,
                folderId: folderId,
                meetingId: meetingId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudyMeetingLinkRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({folderId = false, meetingId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (folderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.folderId,
                                referencedTable:
                                    $$StudyMeetingLinkRowsTableReferences
                                        ._folderIdTable(db),
                                referencedColumn:
                                    $$StudyMeetingLinkRowsTableReferences
                                        ._folderIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (meetingId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.meetingId,
                                referencedTable:
                                    $$StudyMeetingLinkRowsTableReferences
                                        ._meetingIdTable(db),
                                referencedColumn:
                                    $$StudyMeetingLinkRowsTableReferences
                                        ._meetingIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StudyMeetingLinkRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudyMeetingLinkRowsTable,
      StudyMeetingLinkRecord,
      $$StudyMeetingLinkRowsTableFilterComposer,
      $$StudyMeetingLinkRowsTableOrderingComposer,
      $$StudyMeetingLinkRowsTableAnnotationComposer,
      $$StudyMeetingLinkRowsTableCreateCompanionBuilder,
      $$StudyMeetingLinkRowsTableUpdateCompanionBuilder,
      (StudyMeetingLinkRecord, $$StudyMeetingLinkRowsTableReferences),
      StudyMeetingLinkRecord,
      PrefetchHooks Function({bool folderId, bool meetingId})
    >;
typedef $$StudyChatRowsTableCreateCompanionBuilder =
    StudyChatRowsCompanion Function({
      required String id,
      required String folderId,
      required String role,
      required String content,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$StudyChatRowsTableUpdateCompanionBuilder =
    StudyChatRowsCompanion Function({
      Value<String> id,
      Value<String> folderId,
      Value<String> role,
      Value<String> content,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$StudyChatRowsTableReferences
    extends
        BaseReferences<_$AppDatabase, $StudyChatRowsTable, StudyChatRecord> {
  $$StudyChatRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudyFolderRowsTable _folderIdTable(_$AppDatabase db) =>
      db.studyFolderRows.createAlias(
        $_aliasNameGenerator(db.studyChatRows.folderId, db.studyFolderRows.id),
      );

  $$StudyFolderRowsTableProcessedTableManager get folderId {
    final $_column = $_itemColumn<String>('folder_id')!;

    final manager = $$StudyFolderRowsTableTableManager(
      $_db,
      $_db.studyFolderRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_folderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StudyChatRowsTableFilterComposer
    extends Composer<_$AppDatabase, $StudyChatRowsTable> {
  $$StudyChatRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StudyFolderRowsTableFilterComposer get folderId {
    final $$StudyFolderRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.studyFolderRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyFolderRowsTableFilterComposer(
            $db: $db,
            $table: $db.studyFolderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyChatRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyChatRowsTable> {
  $$StudyChatRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudyFolderRowsTableOrderingComposer get folderId {
    final $$StudyFolderRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.studyFolderRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyFolderRowsTableOrderingComposer(
            $db: $db,
            $table: $db.studyFolderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyChatRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyChatRowsTable> {
  $$StudyChatRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$StudyFolderRowsTableAnnotationComposer get folderId {
    final $$StudyFolderRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.studyFolderRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyFolderRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.studyFolderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyChatRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudyChatRowsTable,
          StudyChatRecord,
          $$StudyChatRowsTableFilterComposer,
          $$StudyChatRowsTableOrderingComposer,
          $$StudyChatRowsTableAnnotationComposer,
          $$StudyChatRowsTableCreateCompanionBuilder,
          $$StudyChatRowsTableUpdateCompanionBuilder,
          (StudyChatRecord, $$StudyChatRowsTableReferences),
          StudyChatRecord,
          PrefetchHooks Function({bool folderId})
        > {
  $$StudyChatRowsTableTableManager(_$AppDatabase db, $StudyChatRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyChatRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyChatRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyChatRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> folderId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyChatRowsCompanion(
                id: id,
                folderId: folderId,
                role: role,
                content: content,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String folderId,
                required String role,
                required String content,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StudyChatRowsCompanion.insert(
                id: id,
                folderId: folderId,
                role: role,
                content: content,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudyChatRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({folderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (folderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.folderId,
                                referencedTable: $$StudyChatRowsTableReferences
                                    ._folderIdTable(db),
                                referencedColumn: $$StudyChatRowsTableReferences
                                    ._folderIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StudyChatRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudyChatRowsTable,
      StudyChatRecord,
      $$StudyChatRowsTableFilterComposer,
      $$StudyChatRowsTableOrderingComposer,
      $$StudyChatRowsTableAnnotationComposer,
      $$StudyChatRowsTableCreateCompanionBuilder,
      $$StudyChatRowsTableUpdateCompanionBuilder,
      (StudyChatRecord, $$StudyChatRowsTableReferences),
      StudyChatRecord,
      PrefetchHooks Function({bool folderId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MeetingRowsTableTableManager get meetingRows =>
      $$MeetingRowsTableTableManager(_db, _db.meetingRows);
  $$AudioAssetRowsTableTableManager get audioAssetRows =>
      $$AudioAssetRowsTableTableManager(_db, _db.audioAssetRows);
  $$TranscriptSegmentRowsTableTableManager get transcriptSegmentRows =>
      $$TranscriptSegmentRowsTableTableManager(_db, _db.transcriptSegmentRows);
  $$SummaryRowsTableTableManager get summaryRows =>
      $$SummaryRowsTableTableManager(_db, _db.summaryRows);
  $$ActionItemRowsTableTableManager get actionItemRows =>
      $$ActionItemRowsTableTableManager(_db, _db.actionItemRows);
  $$DecisionRowsTableTableManager get decisionRows =>
      $$DecisionRowsTableTableManager(_db, _db.decisionRows);
  $$ChatMessageRowsTableTableManager get chatMessageRows =>
      $$ChatMessageRowsTableTableManager(_db, _db.chatMessageRows);
  $$TodoRowsTableTableManager get todoRows =>
      $$TodoRowsTableTableManager(_db, _db.todoRows);
  $$SettingRowsTableTableManager get settingRows =>
      $$SettingRowsTableTableManager(_db, _db.settingRows);
  $$StudyFolderRowsTableTableManager get studyFolderRows =>
      $$StudyFolderRowsTableTableManager(_db, _db.studyFolderRows);
  $$StudyDocumentRowsTableTableManager get studyDocumentRows =>
      $$StudyDocumentRowsTableTableManager(_db, _db.studyDocumentRows);
  $$StudyMeetingLinkRowsTableTableManager get studyMeetingLinkRows =>
      $$StudyMeetingLinkRowsTableTableManager(_db, _db.studyMeetingLinkRows);
  $$StudyChatRowsTableTableManager get studyChatRows =>
      $$StudyChatRowsTableTableManager(_db, _db.studyChatRows);
}
