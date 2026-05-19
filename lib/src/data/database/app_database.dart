import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('MeetingRecord')
class MeetingRows extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get durationMs => integer().withDefault(const Constant(0))();
  TextColumn get status => text()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  TextColumn get languageCode => text().withDefault(const Constant('auto'))();
  TextColumn get summaryPreview => text().nullable()();
  TextColumn get tagsJson => text().withDefault(const Constant('[]'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('AudioAssetRecord')
class AudioAssetRows extends Table {
  TextColumn get id => text()();
  TextColumn get meetingId => text().references(MeetingRows, #id)();
  TextColumn get source => text()();
  TextColumn get path => text()();
  IntColumn get sampleRate => integer()();
  IntColumn get channels => integer()();
  IntColumn get durationMs => integer().withDefault(const Constant(0))();
  IntColumn get byteSize => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('TranscriptSegmentRecord')
class TranscriptSegmentRows extends Table {
  TextColumn get id => text()();
  TextColumn get meetingId => text().references(MeetingRows, #id)();
  TextColumn get source => text()();
  TextColumn get speakerLabel => text().nullable()();
  IntColumn get startMs => integer()();
  IntColumn get endMs => integer()();
  TextColumn get content => text().named('text')();
  RealColumn get confidence => real().nullable()();
  BoolColumn get isFinal => boolean().withDefault(const Constant(true))();
  TextColumn get tagsJson => text().withDefault(const Constant('[]'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('SummaryRecord')
class SummaryRows extends Table {
  TextColumn get meetingId => text().references(MeetingRows, #id)();
  TextColumn get generatedTitle => text()();
  TextColumn get overview => text()();
  TextColumn get summaryJson => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {meetingId};
}

@DataClassName('ActionItemRecord')
class ActionItemRows extends Table {
  TextColumn get id => text()();
  TextColumn get meetingId => text().references(MeetingRows, #id)();
  TextColumn get content => text().named('text')();
  TextColumn get owner => text().nullable()();
  TextColumn get dueDate => text().nullable()();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  TextColumn get evidenceJson => text().withDefault(const Constant('[]'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('DecisionRecord')
class DecisionRows extends Table {
  TextColumn get id => text()();
  TextColumn get meetingId => text().references(MeetingRows, #id)();
  TextColumn get content => text().named('text')();
  TextColumn get rationale => text().nullable()();
  TextColumn get evidenceJson => text().withDefault(const Constant('[]'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ChatMessageRecord')
class ChatMessageRows extends Table {
  TextColumn get id => text()();
  TextColumn get meetingId => text().references(MeetingRows, #id)();
  TextColumn get role => text()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isStreaming => boolean().withDefault(const Constant(false))();
  TextColumn get evidenceJson => text().withDefault(const Constant('[]'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('TodoRecord')
class TodoRows extends Table {
  TextColumn get id => text()();
  TextColumn get meetingId => text().references(MeetingRows, #id).nullable()();
  TextColumn get content => text().named('text')();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('SettingRecord')
class SettingRows extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    MeetingRows,
    AudioAssetRows,
    TranscriptSegmentRows,
    SummaryRows,
    ActionItemRows,
    DecisionRows,
    ChatMessageRows,
    TodoRows,
    SettingRows,
  ],
)
final class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(
        executor ??
            driftDatabase(
              name: 'meetlyai',
              native: const DriftNativeOptions(shareAcrossIsolates: true),
            ),
      );

  AppDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await _createFtsIndex();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await _createFtsIndex();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(todoRows);
      }
    },
  );

  Future<void> _createFtsIndex() {
    return customStatement('''
      CREATE VIRTUAL TABLE IF NOT EXISTS transcript_segments_fts
      USING fts5(
        segment_id UNINDEXED,
        meeting_id UNINDEXED,
        text
      );
    ''');
  }
}
