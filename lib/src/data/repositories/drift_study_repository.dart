import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/study_models.dart';
import '../../domain/services/study_repository.dart';
import '../database/app_database.dart';

class DriftStudyRepository implements StudyRepository {
  DriftStudyRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;
  bool _studyFolderParentColumnChecked = false;

  @override
  Stream<List<StudyFolder>> watchFolders() async* {
    await _ensureStudyFolderParentColumn();
    final statement = _db.select(_db.studyFolderRows)
      ..orderBy([(row) => OrderingTerm(expression: row.createdAt)]);
    yield* statement.watch().map(
      (rows) => rows.map(_folderFromRecord).toList(growable: false),
    );
  }

  @override
  Future<List<StudyFolder>> getFolders() async {
    await _ensureStudyFolderParentColumn();
    final rows = await (_db.select(
      _db.studyFolderRows,
    )..orderBy([(row) => OrderingTerm(expression: row.createdAt)])).get();
    return rows.map(_folderFromRecord).toList(growable: false);
  }

  @override
  Stream<List<StudyDocument>> watchDocuments(String folderId) {
    final statement = _db.select(_db.studyDocumentRows)
      ..where((row) => row.folderId.equals(folderId))
      ..orderBy([(row) => OrderingTerm(expression: row.createdAt)]);
    return statement.watch().map(
      (rows) => rows.map(_documentFromRecord).toList(growable: false),
    );
  }

  @override
  Stream<List<StudyMeetingLink>> watchMeetingLinks(String folderId) {
    final statement = _db.select(_db.studyMeetingLinkRows)
      ..where((row) => row.folderId.equals(folderId))
      ..orderBy([(row) => OrderingTerm(expression: row.createdAt)]);
    return statement.watch().map(
      (rows) => rows.map(_meetingLinkFromRecord).toList(growable: false),
    );
  }

  @override
  Stream<List<StudyChatMessage>> watchChat(String folderId) {
    final statement = _db.select(_db.studyChatRows)
      ..where((row) => row.folderId.equals(folderId))
      ..orderBy([(row) => OrderingTerm(expression: row.createdAt)]);
    return statement.watch().map(
      (rows) => rows.map(_chatFromRecord).toList(growable: false),
    );
  }

  @override
  Future<List<StudyDocument>> getDocuments(String folderId) async {
    final rows =
        await (_db.select(_db.studyDocumentRows)
              ..where((row) => row.folderId.equals(folderId))
              ..orderBy([(row) => OrderingTerm(expression: row.createdAt)]))
            .get();
    return rows.map(_documentFromRecord).toList(growable: false);
  }

  @override
  Future<StudyFolder> createFolder({
    required String name,
    String? parentId,
  }) async {
    final folder = StudyFolder(
      id: _uuid.v7(),
      name: name.trim().isEmpty ? 'New folder' : name.trim(),
      parentId: parentId,
      createdAt: DateTime.now(),
    );
    await upsertFolder(folder);
    return folder;
  }

  @override
  Future<void> upsertFolder(StudyFolder folder) {
    return _ensureStudyFolderParentColumn().then(
      (_) => _db
          .into(_db.studyFolderRows)
          .insertOnConflictUpdate(
            StudyFolderRowsCompanion(
              id: Value(folder.id),
              parentId: Value(folder.parentId),
              name: Value(folder.name),
              description: Value(folder.description),
              color: Value(folder.color),
              createdAt: Value(folder.createdAt),
            ),
          ),
    );
  }

  Future<void> _ensureStudyFolderParentColumn() async {
    if (_studyFolderParentColumnChecked) {
      return;
    }
    final tableInfo = await _db
        .customSelect('PRAGMA table_info(study_folder_rows)')
        .get();
    if (tableInfo.isEmpty) {
      _studyFolderParentColumnChecked = true;
      return;
    }
    final hasParentId = tableInfo.any((row) => row.data['name'] == 'parent_id');
    if (!hasParentId) {
      try {
        await _db.customStatement(
          'ALTER TABLE study_folder_rows ADD COLUMN parent_id TEXT NULL',
        );
      } catch (e) {
        final msg = e.toString();
        if (msg.contains('duplicate column name') || msg.contains('already exists')) {
          // another connection already added the column; continue
        } else {
          rethrow;
        }
      }
    }
    _studyFolderParentColumnChecked = true;
  }

  @override
  Future<void> deleteFolder(String folderId) async {
    await _ensureStudyFolderParentColumn();
    final children = await (_db.select(
      _db.studyFolderRows,
    )..where((row) => row.parentId.equals(folderId))).get();
    for (final child in children) {
      await deleteFolder(child.id);
    }
    await (_db.delete(
      _db.studyChatRows,
    )..where((row) => row.folderId.equals(folderId))).go();
    await (_db.delete(
      _db.studyMeetingLinkRows,
    )..where((row) => row.folderId.equals(folderId))).go();
    await (_db.delete(
      _db.studyDocumentRows,
    )..where((row) => row.folderId.equals(folderId))).go();
    await (_db.delete(
      _db.studyFolderRows,
    )..where((row) => row.id.equals(folderId))).go();
  }

  @override
  Future<void> upsertDocument(StudyDocument document) {
    return _db
        .into(_db.studyDocumentRows)
        .insertOnConflictUpdate(
          StudyDocumentRowsCompanion(
            id: Value(document.id),
            folderId: Value(document.folderId),
            title: Value(document.title),
            kind: Value(document.kind.name),
            sourcePath: Value(document.sourcePath),
            category: Value(document.category),
            extractedText: Value(document.extractedText),
            createdAt: Value(document.createdAt),
          ),
        );
  }

  @override
  Future<void> deleteDocument(String documentId) {
    return (_db.delete(
      _db.studyDocumentRows,
    )..where((row) => row.id.equals(documentId))).go();
  }

  @override
  Future<void> linkMeeting(String folderId, String meetingId) {
    return _db
        .into(_db.studyMeetingLinkRows)
        .insertOnConflictUpdate(
          StudyMeetingLinkRowsCompanion(
            id: Value(_uuid.v7()),
            folderId: Value(folderId),
            meetingId: Value(meetingId),
            createdAt: Value(DateTime.now()),
          ),
        );
  }

  @override
  Future<void> unlinkMeeting(String linkId) {
    return (_db.delete(
      _db.studyMeetingLinkRows,
    )..where((row) => row.id.equals(linkId))).go();
  }

  @override
  Future<void> saveChatMessage(StudyChatMessage message) {
    return _db
        .into(_db.studyChatRows)
        .insertOnConflictUpdate(
          StudyChatRowsCompanion(
            id: Value(message.id),
            folderId: Value(message.folderId),
            role: Value(message.role.name),
            content: Value(message.content),
            createdAt: Value(message.createdAt),
          ),
        );
  }

  @override
  Future<void> clearChat(String folderId) {
    return (_db.delete(
      _db.studyChatRows,
    )..where((row) => row.folderId.equals(folderId))).go();
  }

  StudyFolder _folderFromRecord(StudyFolderRecord record) {
    return StudyFolder(
      id: record.id,
      name: record.name,
      parentId: record.parentId,
      description: record.description,
      color: record.color,
      createdAt: record.createdAt,
    );
  }

  StudyDocument _documentFromRecord(StudyDocumentRecord record) {
    return StudyDocument(
      id: record.id,
      folderId: record.folderId,
      title: record.title,
      kind: StudyDocumentKind.values.firstWhere(
        (kind) => kind.name == record.kind,
        orElse: () => StudyDocumentKind.other,
      ),
      sourcePath: record.sourcePath,
      category: record.category,
      extractedText: record.extractedText,
      createdAt: record.createdAt,
    );
  }

  StudyMeetingLink _meetingLinkFromRecord(StudyMeetingLinkRecord record) {
    return StudyMeetingLink(
      id: record.id,
      folderId: record.folderId,
      meetingId: record.meetingId,
      createdAt: record.createdAt,
    );
  }

  StudyChatMessage _chatFromRecord(StudyChatRecord record) {
    return StudyChatMessage(
      id: record.id,
      folderId: record.folderId,
      role: StudyChatRole.values.firstWhere(
        (role) => role.name == record.role,
        orElse: () => StudyChatRole.assistant,
      ),
      content: record.content,
      createdAt: record.createdAt,
    );
  }
}
