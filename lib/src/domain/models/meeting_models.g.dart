// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Meeting _$MeetingFromJson(Map<String, dynamic> json) => _Meeting(
  id: json['id'] as String,
  title: json['title'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  endedAt: json['endedAt'] == null
      ? null
      : DateTime.parse(json['endedAt'] as String),
  durationMs: (json['durationMs'] as num?)?.toInt() ?? 0,
  status:
      $enumDecodeNullable(_$MeetingStatusEnumMap, json['status']) ??
      MeetingStatus.draft,
  isPinned: json['isPinned'] as bool? ?? false,
  isFavorite: json['isFavorite'] as bool? ?? false,
  languageCode: json['languageCode'] as String? ?? 'auto',
  summaryPreview: json['summaryPreview'] as String?,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$MeetingToJson(_Meeting instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'createdAt': instance.createdAt.toIso8601String(),
  'startedAt': instance.startedAt?.toIso8601String(),
  'endedAt': instance.endedAt?.toIso8601String(),
  'durationMs': instance.durationMs,
  'status': _$MeetingStatusEnumMap[instance.status]!,
  'isPinned': instance.isPinned,
  'isFavorite': instance.isFavorite,
  'languageCode': instance.languageCode,
  'summaryPreview': instance.summaryPreview,
  'tags': instance.tags,
};

const _$MeetingStatusEnumMap = {
  MeetingStatus.draft: 'draft',
  MeetingStatus.recording: 'recording',
  MeetingStatus.paused: 'paused',
  MeetingStatus.transcribing: 'transcribing',
  MeetingStatus.summarizing: 'summarizing',
  MeetingStatus.ready: 'ready',
  MeetingStatus.failed: 'failed',
};

_AudioAsset _$AudioAssetFromJson(Map<String, dynamic> json) => _AudioAsset(
  id: json['id'] as String,
  meetingId: json['meetingId'] as String,
  source: $enumDecode(_$AudioSourceKindEnumMap, json['source']),
  path: json['path'] as String,
  sampleRate: (json['sampleRate'] as num).toInt(),
  channels: (json['channels'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  durationMs: (json['durationMs'] as num?)?.toInt() ?? 0,
  byteSize: (json['byteSize'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AudioAssetToJson(_AudioAsset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'meetingId': instance.meetingId,
      'source': _$AudioSourceKindEnumMap[instance.source]!,
      'path': instance.path,
      'sampleRate': instance.sampleRate,
      'channels': instance.channels,
      'createdAt': instance.createdAt.toIso8601String(),
      'durationMs': instance.durationMs,
      'byteSize': instance.byteSize,
    };

const _$AudioSourceKindEnumMap = {
  AudioSourceKind.mic: 'mic',
  AudioSourceKind.system: 'system',
  AudioSourceKind.mixed: 'mixed',
};

_TranscriptSegment _$TranscriptSegmentFromJson(Map<String, dynamic> json) =>
    _TranscriptSegment(
      id: json['id'] as String,
      meetingId: json['meetingId'] as String,
      source: $enumDecode(_$AudioSourceKindEnumMap, json['source']),
      startMs: (json['startMs'] as num).toInt(),
      endMs: (json['endMs'] as num).toInt(),
      text: json['text'] as String,
      speakerLabel: json['speakerLabel'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
      isFinal: json['isFinal'] as bool? ?? true,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
    );

Map<String, dynamic> _$TranscriptSegmentToJson(_TranscriptSegment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'meetingId': instance.meetingId,
      'source': _$AudioSourceKindEnumMap[instance.source]!,
      'startMs': instance.startMs,
      'endMs': instance.endMs,
      'text': instance.text,
      'speakerLabel': instance.speakerLabel,
      'confidence': instance.confidence,
      'isFinal': instance.isFinal,
      'tags': instance.tags,
    };

_SummaryChapter _$SummaryChapterFromJson(Map<String, dynamic> json) =>
    _SummaryChapter(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      startMs: (json['startMs'] as num?)?.toInt() ?? 0,
      endMs: (json['endMs'] as num?)?.toInt() ?? 0,
      evidenceSegmentIds:
          (json['evidenceSegmentIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$SummaryChapterToJson(_SummaryChapter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'summary': instance.summary,
      'startMs': instance.startMs,
      'endMs': instance.endMs,
      'evidenceSegmentIds': instance.evidenceSegmentIds,
    };

_ActionItem _$ActionItemFromJson(Map<String, dynamic> json) => _ActionItem(
  id: json['id'] as String,
  text: json['text'] as String,
  owner: json['owner'] as String?,
  dueDate: json['dueDate'] as String?,
  done: json['done'] as bool? ?? false,
  evidenceSegmentIds:
      (json['evidenceSegmentIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$ActionItemToJson(_ActionItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'owner': instance.owner,
      'dueDate': instance.dueDate,
      'done': instance.done,
      'evidenceSegmentIds': instance.evidenceSegmentIds,
    };

_DecisionItem _$DecisionItemFromJson(Map<String, dynamic> json) =>
    _DecisionItem(
      id: json['id'] as String,
      text: json['text'] as String,
      rationale: json['rationale'] as String?,
      evidenceSegmentIds:
          (json['evidenceSegmentIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$DecisionItemToJson(_DecisionItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'rationale': instance.rationale,
      'evidenceSegmentIds': instance.evidenceSegmentIds,
    };

_OpenQuestion _$OpenQuestionFromJson(Map<String, dynamic> json) =>
    _OpenQuestion(
      id: json['id'] as String,
      text: json['text'] as String,
      owner: json['owner'] as String?,
      evidenceSegmentIds:
          (json['evidenceSegmentIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$OpenQuestionToJson(_OpenQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'owner': instance.owner,
      'evidenceSegmentIds': instance.evidenceSegmentIds,
    };

_MeetingSummary _$MeetingSummaryFromJson(Map<String, dynamic> json) =>
    _MeetingSummary(
      meetingId: json['meetingId'] as String,
      generatedTitle: json['generatedTitle'] as String,
      overview: json['overview'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      chapters:
          (json['chapters'] as List<dynamic>?)
              ?.map((e) => SummaryChapter.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SummaryChapter>[],
      actionItems:
          (json['actionItems'] as List<dynamic>?)
              ?.map((e) => ActionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ActionItem>[],
      decisions:
          (json['decisions'] as List<dynamic>?)
              ?.map((e) => DecisionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <DecisionItem>[],
      openQuestions:
          (json['openQuestions'] as List<dynamic>?)
              ?.map((e) => OpenQuestion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <OpenQuestion>[],
      followUpSuggestions:
          (json['followUpSuggestions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
    );

Map<String, dynamic> _$MeetingSummaryToJson(_MeetingSummary instance) =>
    <String, dynamic>{
      'meetingId': instance.meetingId,
      'generatedTitle': instance.generatedTitle,
      'overview': instance.overview,
      'createdAt': instance.createdAt.toIso8601String(),
      'chapters': instance.chapters.map((e) => e.toJson()).toList(),
      'actionItems': instance.actionItems.map((e) => e.toJson()).toList(),
      'decisions': instance.decisions.map((e) => e.toJson()).toList(),
      'openQuestions': instance.openQuestions.map((e) => e.toJson()).toList(),
      'followUpSuggestions': instance.followUpSuggestions,
      'tags': instance.tags,
    };

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  id: json['id'] as String,
  meetingId: json['meetingId'] as String,
  role: $enumDecode(_$ChatRoleEnumMap, json['role']),
  content: json['content'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  isStreaming: json['isStreaming'] as bool? ?? false,
  evidenceSegmentIds:
      (json['evidenceSegmentIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'meetingId': instance.meetingId,
      'role': _$ChatRoleEnumMap[instance.role]!,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'isStreaming': instance.isStreaming,
      'evidenceSegmentIds': instance.evidenceSegmentIds,
    };

const _$ChatRoleEnumMap = {
  ChatRole.user: 'user',
  ChatRole.assistant: 'assistant',
  ChatRole.system: 'system',
};

_Todo _$TodoFromJson(Map<String, dynamic> json) => _Todo(
  id: json['id'] as String,
  meetingId: json['meetingId'] as String?,
  content: json['content'] as String,
  done: json['done'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  notes: json['notes'] as String?,
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TodoToJson(_Todo instance) => <String, dynamic>{
  'id': instance.id,
  'meetingId': instance.meetingId,
  'content': instance.content,
  'done': instance.done,
  'createdAt': instance.createdAt.toIso8601String(),
  'dueDate': instance.dueDate?.toIso8601String(),
  'notes': instance.notes,
  'sortOrder': instance.sortOrder,
};
