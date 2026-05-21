import '../models/study_models.dart';

abstract interface class StudyRepository {
  Stream<List<StudyFolder>> watchFolders();

  Future<List<StudyFolder>> getFolders();

  Stream<List<StudyDocument>> watchDocuments(String folderId);

  Stream<List<StudyMeetingLink>> watchMeetingLinks(String folderId);

  Stream<List<StudyChatMessage>> watchChat(String folderId);

  Future<List<StudyDocument>> getDocuments(String folderId);

  Future<StudyFolder> createFolder({required String name, String? parentId});

  Future<void> upsertFolder(StudyFolder folder);

  Future<void> deleteFolder(String folderId);

  Future<void> upsertDocument(StudyDocument document);

  Future<void> deleteDocument(String documentId);

  Future<void> linkMeeting(String folderId, String meetingId);

  Future<void> unlinkMeeting(String linkId);

  Future<void> saveChatMessage(StudyChatMessage message);

  Future<void> clearChat(String folderId);
}
