enum StudyDocumentKind { pdf, markdown, text, other }

enum StudyChatRole { user, assistant }

class StudyFolder {
  const StudyFolder({
    required this.id,
    required this.name,
    required this.createdAt,
    this.parentId,
    this.description,
    this.color = 'teal',
  });

  final String id;
  final String name;
  final DateTime createdAt;
  final String? parentId;
  final String? description;
  final String color;
}

class StudyDocument {
  const StudyDocument({
    required this.id,
    required this.folderId,
    required this.title,
    required this.kind,
    required this.sourcePath,
    required this.createdAt,
    this.category,
    this.extractedText = '',
  });

  final String id;
  final String folderId;
  final String title;
  final StudyDocumentKind kind;
  final String sourcePath;
  final DateTime createdAt;
  final String? category;
  final String extractedText;
}

class StudyMeetingLink {
  const StudyMeetingLink({
    required this.id,
    required this.folderId,
    required this.meetingId,
    required this.createdAt,
  });

  final String id;
  final String folderId;
  final String meetingId;
  final DateTime createdAt;
}

class StudyChatMessage {
  const StudyChatMessage({
    required this.id,
    required this.folderId,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String folderId;
  final StudyChatRole role;
  final String content;
  final DateTime createdAt;
}

class StudyContextItem {
  const StudyContextItem({
    required this.title,
    required this.kind,
    required this.content,
  });

  final String title;
  final String kind;
  final String content;
}
