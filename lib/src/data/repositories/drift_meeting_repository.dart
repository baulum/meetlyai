import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/meeting_models.dart';
import '../../domain/services/meeting_repository.dart';
import '../database/app_database.dart';

class DriftMeetingRepository implements MeetingRepository {
  DriftMeetingRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  @override
  Stream<List<Meeting>> watchMeetings({String query = ''}) {
    final statement = _db.select(_db.meetingRows)
      ..orderBy([
        (row) =>
            OrderingTerm(expression: row.isPinned, mode: OrderingMode.desc),
        (row) =>
            OrderingTerm(expression: row.createdAt, mode: OrderingMode.desc),
      ]);

    final trimmed = query.trim().toLowerCase();

    return statement.watch().asyncMap((rows) async {
      if (trimmed.isEmpty) {
        return rows.map(_meetingFromRecord).toList(growable: false);
      }

      // Filter meetings by title or summary content
      final meetings = rows.map(_meetingFromRecord).toList();
      final filtered = <Meeting>[];

      for (final meeting in meetings) {
        // Check if title matches
        if (meeting.title.toLowerCase().contains(trimmed)) {
          filtered.add(meeting);
          continue;
        }

        // Check if summary overview matches
        final summary = await getSummary(meeting.id);
        if (summary != null &&
            (summary.overview.toLowerCase().contains(trimmed) ||
                summary.tags.any(
                  (tag) => tag.toLowerCase().contains(trimmed),
                ))) {
          filtered.add(meeting);
          continue;
        }
      }

      return filtered;
    });
  }

  @override
  Stream<List<TranscriptSegment>> watchTranscript(String meetingId) {
    final statement = _db.select(_db.transcriptSegmentRows)
      ..where((row) => row.meetingId.equals(meetingId))
      ..orderBy([
        (row) => OrderingTerm(expression: row.startMs),
        (row) => OrderingTerm(expression: row.endMs),
      ]);

    return statement.watch().map(
      (rows) => rows.map(_segmentFromRecord).toList(growable: false),
    );
  }

  @override
  Stream<MeetingSummary?> watchSummary(String meetingId) {
    final statement = _db.select(_db.summaryRows)
      ..where((row) => row.meetingId.equals(meetingId));
    return statement.watchSingleOrNull().map((row) {
      if (row == null) {
        return null;
      }
      return MeetingSummary.fromJson(
        jsonDecode(row.summaryJson) as Map<String, Object?>,
      );
    });
  }

  @override
  Stream<List<ChatMessage>> watchChatMessages(String meetingId) {
    final statement = _db.select(_db.chatMessageRows)
      ..where((row) => row.meetingId.equals(meetingId))
      ..orderBy([(row) => OrderingTerm(expression: row.createdAt)]);

    return statement.watch().map(
      (rows) => rows.map(_chatFromRecord).toList(growable: false),
    );
  }

  @override
  Future<Meeting?> getMeeting(String id) async {
    final row = await (_db.select(
      _db.meetingRows,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    return row == null ? null : _meetingFromRecord(row);
  }

  @override
  Future<MeetingSummary?> getSummary(String meetingId) async {
    final row = await (_db.select(
      _db.summaryRows,
    )..where((table) => table.meetingId.equals(meetingId))).getSingleOrNull();
    if (row == null) {
      return null;
    }

    return MeetingSummary.fromJson(
      jsonDecode(row.summaryJson) as Map<String, Object?>,
    );
  }

  @override
  Future<List<TranscriptSegment>> getTranscript(String meetingId) async {
    final rows =
        await (_db.select(_db.transcriptSegmentRows)
              ..where((row) => row.meetingId.equals(meetingId))
              ..orderBy([
                (row) => OrderingTerm(expression: row.startMs),
                (row) => OrderingTerm(expression: row.endMs),
              ]))
            .get();
    return rows.map(_segmentFromRecord).toList(growable: false);
  }

  @override
  Future<List<TranscriptSegment>> searchTranscript(
    String meetingId,
    String query,
  ) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return getTranscript(meetingId);
    }

    // Simple substring search using LIKE - works reliably across all content
    final like = '%$trimmed%';

    // Search in transcript segments content (case-insensitive)
    final rows =
        await (_db.select(_db.transcriptSegmentRows)
              ..where(
                (row) =>
                    row.meetingId.equals(meetingId) & row.content.like(like),
              )
              ..orderBy([(row) => OrderingTerm(expression: row.startMs)]))
            .get();

    final results = rows.map(_segmentFromRecord).toList(growable: false);

    // If no results found, try FTS as fallback for better matching
    if (results.isEmpty) {
      final ftsQuery = _ftsQuery(trimmed);
      if (ftsQuery.isNotEmpty) {
        try {
          final ftsRows = await _db
              .customSelect(
                '''
                SELECT segment_id
                FROM transcript_segments_fts
                WHERE text MATCH ? AND meeting_id = ?
                LIMIT 80
                ''',
                variables: [
                  Variable.withString(ftsQuery),
                  Variable.withString(meetingId),
                ],
                readsFrom: {_db.transcriptSegmentRows},
              )
              .get();
          final ids = ftsRows
              .map((row) => row.read<String>('segment_id'))
              .toList(growable: false);

          if (ids.isNotEmpty) {
            final segments = await (_db.select(
              _db.transcriptSegmentRows,
            )..where((row) => row.id.isIn(ids))).get();
            final byId = {for (final segment in segments) segment.id: segment};
            return ids
                .map(byId.get)
                .nonNulls
                .map(_segmentFromRecord)
                .toList(growable: false);
          }
        } on Object {
          // FTS failed, return empty results
        }
      }
    }

    return results;
  }

  @override
  Future<List<ChatMessage>> getChatMessages(String meetingId) async {
    final rows =
        await (_db.select(_db.chatMessageRows)
              ..where((row) => row.meetingId.equals(meetingId))
              ..orderBy([(row) => OrderingTerm(expression: row.createdAt)]))
            .get();
    return rows.map(_chatFromRecord).toList(growable: false);
  }

  @override
  Future<Meeting> createMeeting({String? title}) async {
    final now = DateTime.now();
    final meeting = Meeting(
      id: _uuid.v7(),
      title: title?.trim().isNotEmpty == true ? title!.trim() : 'New meeting',
      createdAt: now,
      status: MeetingStatus.draft,
    );
    await upsertMeeting(meeting);
    return meeting;
  }

  @override
  Future<void> upsertMeeting(Meeting meeting) {
    return _db
        .into(_db.meetingRows)
        .insertOnConflictUpdate(
          MeetingRowsCompanion(
            id: Value(meeting.id),
            title: Value(meeting.title),
            createdAt: Value(meeting.createdAt),
            startedAt: Value(meeting.startedAt),
            endedAt: Value(meeting.endedAt),
            durationMs: Value(meeting.durationMs),
            status: Value(meeting.status.name),
            isPinned: Value(meeting.isPinned),
            isFavorite: Value(meeting.isFavorite),
            languageCode: Value(meeting.languageCode),
            summaryPreview: Value(meeting.summaryPreview),
            tagsJson: Value(jsonEncode(meeting.tags)),
          ),
        );
  }

  @override
  Future<void> saveAudioAsset(AudioAsset asset) {
    return _db
        .into(_db.audioAssetRows)
        .insertOnConflictUpdate(
          AudioAssetRowsCompanion(
            id: Value(asset.id),
            meetingId: Value(asset.meetingId),
            source: Value(asset.source.name),
            path: Value(asset.path),
            sampleRate: Value(asset.sampleRate),
            channels: Value(asset.channels),
            durationMs: Value(asset.durationMs),
            byteSize: Value(asset.byteSize),
            createdAt: Value(asset.createdAt),
          ),
        );
  }

  @override
  Future<void> saveTranscriptSegment(TranscriptSegment segment) async {
    await _db
        .into(_db.transcriptSegmentRows)
        .insertOnConflictUpdate(
          TranscriptSegmentRowsCompanion(
            id: Value(segment.id),
            meetingId: Value(segment.meetingId),
            source: Value(segment.source.name),
            speakerLabel: Value(segment.speakerLabel),
            startMs: Value(segment.startMs),
            endMs: Value(segment.endMs),
            content: Value(segment.text),
            confidence: Value(segment.confidence),
            isFinal: Value(segment.isFinal),
            tagsJson: Value(jsonEncode(segment.tags)),
          ),
        );

    await _db.customStatement(
      '''
      INSERT OR REPLACE INTO transcript_segments_fts(
        rowid,
        segment_id,
        meeting_id,
        text
      )
      VALUES (
        (SELECT rowid FROM transcript_segments_fts WHERE segment_id = ?),
        ?,
        ?,
        ?
      )
      ''',
      [segment.id, segment.id, segment.meetingId, segment.text],
    );
  }

  @override
  Future<void> updateSpeakerLabel({
    required String meetingId,
    required String oldLabel,
    required String newLabel,
  }) {
    return (_db.update(_db.transcriptSegmentRows)..where(
          (row) =>
              row.meetingId.equals(meetingId) &
              row.speakerLabel.equals(oldLabel),
        ))
        .write(TranscriptSegmentRowsCompanion(speakerLabel: Value(newLabel)));
  }

  @override
  Future<void> assignDefaultSpeakerLabels(String meetingId) async {
    final rows = await (_db.select(
      _db.transcriptSegmentRows,
    )..where((row) => row.meetingId.equals(meetingId))).get();
    await _db.batch((batch) {
      for (final row in rows) {
        final existing = row.speakerLabel?.trim();
        if (existing != null &&
            existing.isNotEmpty &&
            !existing.startsWith('Mic') &&
            !existing.startsWith('System')) {
          continue;
        }
        final label = switch (_enumByName(AudioSourceKind.values, row.source)) {
          AudioSourceKind.mic => 'Speaker 1',
          AudioSourceKind.system => 'Speaker 2',
          AudioSourceKind.mixed => 'Speaker 1',
        };
        batch.update(
          _db.transcriptSegmentRows,
          TranscriptSegmentRowsCompanion(speakerLabel: Value(label)),
          where: (table) => table.id.equals(row.id),
        );
      }
    });
  }

  @override
  Future<void> saveSummary(MeetingSummary summary) async {
    await _db.transaction(() async {
      await _db
          .into(_db.summaryRows)
          .insertOnConflictUpdate(
            SummaryRowsCompanion(
              meetingId: Value(summary.meetingId),
              generatedTitle: Value(summary.generatedTitle),
              overview: Value(summary.overview),
              summaryJson: Value(jsonEncode(summary.toJson())),
              createdAt: Value(summary.createdAt),
            ),
          );

      await (_db.delete(
        _db.actionItemRows,
      )..where((row) => row.meetingId.equals(summary.meetingId))).go();
      await (_db.delete(
        _db.decisionRows,
      )..where((row) => row.meetingId.equals(summary.meetingId))).go();

      await _db.batch((batch) {
        batch.insertAll(
          _db.actionItemRows,
          summary.actionItems.map(
            (item) => ActionItemRowsCompanion(
              id: Value(item.id),
              meetingId: Value(summary.meetingId),
              content: Value(item.text),
              owner: Value(item.owner),
              dueDate: Value(item.dueDate),
              done: Value(item.done),
              evidenceJson: Value(jsonEncode(item.evidenceSegmentIds)),
            ),
          ),
          mode: InsertMode.insertOrReplace,
        );
        batch.insertAll(
          _db.decisionRows,
          summary.decisions.map(
            (decision) => DecisionRowsCompanion(
              id: Value(decision.id),
              meetingId: Value(summary.meetingId),
              content: Value(decision.text),
              rationale: Value(decision.rationale),
              evidenceJson: Value(jsonEncode(decision.evidenceSegmentIds)),
            ),
          ),
          mode: InsertMode.insertOrReplace,
        );
        batch.insertAll(
          _db.todoRows,
          summary.actionItems.indexed.map(
            (entry) => TodoRowsCompanion(
              id: Value(_summaryTodoId(summary.meetingId, entry.$2.id)),
              meetingId: Value(summary.meetingId),
              content: Value(entry.$2.text),
              done: Value(entry.$2.done),
              createdAt: Value(summary.createdAt),
              dueDate: Value(_parseDueDate(entry.$2.dueDate)),
              notes: Value(entry.$2.owner),
              sortOrder: Value(entry.$1),
            ),
          ),
          mode: InsertMode.insertOrReplace,
        );
      });

      final meeting = await getMeeting(summary.meetingId);
      if (meeting != null) {
        await upsertMeeting(
          meeting.copyWith(
            title: summary.generatedTitle,
            status: MeetingStatus.ready,
            summaryPreview: summary.overview,
            tags: summary.tags,
          ),
        );
      }
    });
  }

  @override
  Future<void> saveChatMessage(ChatMessage message) {
    return _db
        .into(_db.chatMessageRows)
        .insertOnConflictUpdate(
          ChatMessageRowsCompanion(
            id: Value(message.id),
            meetingId: Value(message.meetingId),
            role: Value(message.role.name),
            content: Value(message.content),
            createdAt: Value(message.createdAt),
            isStreaming: Value(message.isStreaming),
            evidenceJson: Value(jsonEncode(message.evidenceSegmentIds)),
          ),
        );
  }

  @override
  Stream<List<Todo>> watchTodos({String? meetingId}) {
    final statement = _db.select(_db.todoRows)
      ..orderBy([
        (row) => OrderingTerm(expression: row.done, mode: OrderingMode.asc),
        (row) =>
            OrderingTerm(expression: row.sortOrder, mode: OrderingMode.asc),
        (row) =>
            OrderingTerm(expression: row.createdAt, mode: OrderingMode.desc),
      ]);

    if (meetingId != null) {
      statement.where((row) => row.meetingId.equals(meetingId));
    }

    return statement.watch().map(
      (rows) => rows.map(_todoFromRecord).toList(growable: false),
    );
  }

  @override
  Future<List<Todo>> getTodos({String? meetingId}) async {
    final statement = _db.select(_db.todoRows)
      ..orderBy([
        (row) => OrderingTerm(expression: row.done, mode: OrderingMode.asc),
        (row) =>
            OrderingTerm(expression: row.sortOrder, mode: OrderingMode.asc),
        (row) =>
            OrderingTerm(expression: row.createdAt, mode: OrderingMode.desc),
      ]);

    if (meetingId != null) {
      statement.where((row) => row.meetingId.equals(meetingId));
    }

    final rows = await statement.get();
    return rows.map(_todoFromRecord).toList(growable: false);
  }

  @override
  Future<Todo> createTodo(Todo todo) {
    final newTodo = todo.copyWith(id: _uuid.v7(), createdAt: DateTime.now());
    return upsertTodo(newTodo).then((_) => newTodo);
  }

  @override
  Future<void> upsertTodo(Todo todo) {
    return _db
        .into(_db.todoRows)
        .insertOnConflictUpdate(
          TodoRowsCompanion(
            id: Value(todo.id),
            meetingId: Value(todo.meetingId),
            content: Value(todo.content),
            done: Value(todo.done),
            createdAt: Value(todo.createdAt),
            dueDate: Value(todo.dueDate),
            notes: Value(todo.notes),
            sortOrder: Value(todo.sortOrder),
          ),
        );
  }

  @override
  Future<void> deleteTodo(String id) {
    return (_db.delete(_db.todoRows)..where((row) => row.id.equals(id))).go();
  }

  @override
  Future<void> deleteMeeting(String id) async {
    final audioAssets = await (_db.select(
      _db.audioAssetRows,
    )..where((row) => row.meetingId.equals(id))).get();

    await _db.transaction(() async {
      await _db.customStatement(
        'DELETE FROM transcript_segments_fts WHERE meeting_id = ?',
        [id],
      );
      await (_db.delete(
        _db.chatMessageRows,
      )..where((row) => row.meetingId.equals(id))).go();
      await (_db.delete(
        _db.decisionRows,
      )..where((row) => row.meetingId.equals(id))).go();
      await (_db.delete(
        _db.actionItemRows,
      )..where((row) => row.meetingId.equals(id))).go();
      await (_db.delete(
        _db.summaryRows,
      )..where((row) => row.meetingId.equals(id))).go();
      await (_db.delete(
        _db.transcriptSegmentRows,
      )..where((row) => row.meetingId.equals(id))).go();
      await (_db.delete(
        _db.audioAssetRows,
      )..where((row) => row.meetingId.equals(id))).go();
      await (_db.delete(
        _db.todoRows,
      )..where((row) => row.meetingId.equals(id))).go();
      await (_db.delete(
        _db.studyMeetingLinkRows,
      )..where((row) => row.meetingId.equals(id))).go();
      await (_db.delete(
        _db.meetingRows,
      )..where((row) => row.id.equals(id))).go();
    });

    final meetingDirectories = <String>{};
    for (final asset in audioAssets) {
      final meetingDirectory = _meetingDirectoryFromAssetPath(asset.path, id);
      if (meetingDirectory != null) {
        meetingDirectories.add(meetingDirectory);
      }
      try {
        final file = File(asset.path);
        if (await file.exists()) {
          await file.delete();
        }
      } on FileSystemException {
        // Keep the database delete successful even if a file was already moved
        // or cannot be removed due to OS permissions.
      }
    }

    for (final path in meetingDirectories) {
      try {
        final directory = Directory(path);
        if (await directory.exists()) {
          await directory.delete(recursive: true);
        }
      } on FileSystemException {
        // The database delete is authoritative. Leftover files can be cleaned
        // manually if the OS keeps a handle open while a recording is closing.
      }
    }
  }

  String? _meetingDirectoryFromAssetPath(String assetPath, String meetingId) {
    final normalized = assetPath.replaceAll('\\', '/');
    final marker = '/meetings/$meetingId/';
    final markerIndex = normalized.indexOf(marker);
    if (markerIndex == -1) {
      return null;
    }
    return normalized.substring(0, markerIndex + marker.length - 1);
  }

  Meeting _meetingFromRecord(MeetingRecord record) {
    return Meeting(
      id: record.id,
      title: record.title,
      createdAt: record.createdAt,
      startedAt: record.startedAt,
      endedAt: record.endedAt,
      durationMs: record.durationMs,
      status: _enumByName(MeetingStatus.values, record.status),
      isPinned: record.isPinned,
      isFavorite: record.isFavorite,
      languageCode: record.languageCode,
      summaryPreview: record.summaryPreview,
      tags: _decodeStringList(record.tagsJson),
    );
  }

  TranscriptSegment _segmentFromRecord(TranscriptSegmentRecord record) {
    return TranscriptSegment(
      id: record.id,
      meetingId: record.meetingId,
      source: _enumByName(AudioSourceKind.values, record.source),
      speakerLabel: record.speakerLabel,
      startMs: record.startMs,
      endMs: record.endMs,
      text: record.content,
      confidence: record.confidence,
      isFinal: record.isFinal,
      tags: _decodeStringList(record.tagsJson),
    );
  }

  ChatMessage _chatFromRecord(ChatMessageRecord record) {
    return ChatMessage(
      id: record.id,
      meetingId: record.meetingId,
      role: _enumByName(ChatRole.values, record.role),
      content: record.content,
      createdAt: record.createdAt,
      isStreaming: record.isStreaming,
      evidenceSegmentIds: _decodeStringList(record.evidenceJson),
    );
  }

  Todo _todoFromRecord(TodoRecord record) {
    return Todo(
      id: record.id,
      meetingId: record.meetingId,
      content: record.content,
      done: record.done,
      createdAt: record.createdAt,
      dueDate: record.dueDate,
      notes: record.notes,
      sortOrder: record.sortOrder,
    );
  }

  List<String> _decodeStringList(String value) {
    final decoded = jsonDecode(value);
    if (decoded is List) {
      return decoded.whereType<String>().toList(growable: false);
    }
    return const [];
  }

  String _summaryTodoId(String meetingId, String actionItemId) {
    final normalized = actionItemId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '-');
    return 'summary-todo-$meetingId-$normalized';
  }

  DateTime? _parseDueDate(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return DateTime.tryParse(trimmed);
  }

  T _enumByName<T extends Enum>(List<T> values, String name) {
    return values.firstWhere((value) => value.name == name);
  }

  String _ftsQuery(String raw) {
    return raw
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '"${part.replaceAll('"', '""')}"')
        .join(' ');
  }
}

extension<K, V> on Map<K, V> {
  V? get(K key) => this[key];
}
