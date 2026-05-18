import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_models.freezed.dart';
part 'meeting_models.g.dart';

enum MeetingStatus {
  draft,
  recording,
  paused,
  transcribing,
  summarizing,
  ready,
  failed,
}

enum AudioSourceKind { mic, system, mixed }

enum ChatRole { user, assistant, system }

enum ExportFormat { markdown, text, pdf }

@freezed
abstract class Meeting with _$Meeting {
  const factory Meeting({
    required String id,
    required String title,
    required DateTime createdAt,
    DateTime? startedAt,
    DateTime? endedAt,
    @Default(0) int durationMs,
    @Default(MeetingStatus.draft) MeetingStatus status,
    @Default(false) bool isPinned,
    @Default(false) bool isFavorite,
    @Default('auto') String languageCode,
    String? summaryPreview,
    @Default(<String>[]) List<String> tags,
  }) = _Meeting;

  factory Meeting.fromJson(Map<String, Object?> json) =>
      _$MeetingFromJson(json);
}

@freezed
abstract class AudioAsset with _$AudioAsset {
  const factory AudioAsset({
    required String id,
    required String meetingId,
    required AudioSourceKind source,
    required String path,
    required int sampleRate,
    required int channels,
    required DateTime createdAt,
    @Default(0) int durationMs,
    @Default(0) int byteSize,
  }) = _AudioAsset;

  factory AudioAsset.fromJson(Map<String, Object?> json) =>
      _$AudioAssetFromJson(json);
}

@freezed
abstract class TranscriptSegment with _$TranscriptSegment {
  const factory TranscriptSegment({
    required String id,
    required String meetingId,
    required AudioSourceKind source,
    required int startMs,
    required int endMs,
    required String text,
    String? speakerLabel,
    double? confidence,
    @Default(true) bool isFinal,
    @Default(<String>[]) List<String> tags,
  }) = _TranscriptSegment;

  factory TranscriptSegment.fromJson(Map<String, Object?> json) =>
      _$TranscriptSegmentFromJson(json);
}

@freezed
abstract class SummaryChapter with _$SummaryChapter {
  const factory SummaryChapter({
    required String id,
    required String title,
    required String summary,
    @Default(0) int startMs,
    @Default(0) int endMs,
    @Default(<String>[]) List<String> evidenceSegmentIds,
  }) = _SummaryChapter;

  factory SummaryChapter.fromJson(Map<String, Object?> json) =>
      _$SummaryChapterFromJson(json);
}

@freezed
abstract class ActionItem with _$ActionItem {
  const factory ActionItem({
    required String id,
    required String text,
    String? owner,
    String? dueDate,
    @Default(false) bool done,
    @Default(<String>[]) List<String> evidenceSegmentIds,
  }) = _ActionItem;

  factory ActionItem.fromJson(Map<String, Object?> json) =>
      _$ActionItemFromJson(json);
}

@freezed
abstract class DecisionItem with _$DecisionItem {
  const factory DecisionItem({
    required String id,
    required String text,
    String? rationale,
    @Default(<String>[]) List<String> evidenceSegmentIds,
  }) = _DecisionItem;

  factory DecisionItem.fromJson(Map<String, Object?> json) =>
      _$DecisionItemFromJson(json);
}

@freezed
abstract class OpenQuestion with _$OpenQuestion {
  const factory OpenQuestion({
    required String id,
    required String text,
    String? owner,
    @Default(<String>[]) List<String> evidenceSegmentIds,
  }) = _OpenQuestion;

  factory OpenQuestion.fromJson(Map<String, Object?> json) =>
      _$OpenQuestionFromJson(json);
}

@freezed
abstract class MeetingSummary with _$MeetingSummary {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory MeetingSummary({
    required String meetingId,
    required String generatedTitle,
    required String overview,
    required DateTime createdAt,
    @Default(<SummaryChapter>[]) List<SummaryChapter> chapters,
    @Default(<ActionItem>[]) List<ActionItem> actionItems,
    @Default(<DecisionItem>[]) List<DecisionItem> decisions,
    @Default(<OpenQuestion>[]) List<OpenQuestion> openQuestions,
    @Default(<String>[]) List<String> followUpSuggestions,
    @Default(<String>[]) List<String> tags,
  }) = _MeetingSummary;

  factory MeetingSummary.fromJson(Map<String, Object?> json) =>
      _$MeetingSummaryFromJson(json);
}

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String meetingId,
    required ChatRole role,
    required String content,
    required DateTime createdAt,
    @Default(false) bool isStreaming,
    @Default(<String>[]) List<String> evidenceSegmentIds,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, Object?> json) =>
      _$ChatMessageFromJson(json);
}

@freezed
abstract class AudioDeviceInfo with _$AudioDeviceInfo {
  const factory AudioDeviceInfo({
    required String id,
    required String name,
    required AudioSourceKind source,
    @Default(false) bool isDefault,
    @Default(1) int channels,
  }) = _AudioDeviceInfo;
}

@freezed
abstract class AudioLevelFrame with _$AudioLevelFrame {
  const factory AudioLevelFrame({
    required double micLevel,
    required double systemLevel,
    required double mixedLevel,
    required DateTime capturedAt,
  }) = _AudioLevelFrame;
}

@freezed
abstract class RecordingSnapshot with _$RecordingSnapshot {
  const factory RecordingSnapshot({
    required String meetingId,
    required Duration elapsed,
    required AudioLevelFrame levels,
    @Default(MeetingStatus.recording) MeetingStatus status,
    @Default('Ready') String statusMessage,
  }) = _RecordingSnapshot;
}

class AudioPcmFrame {
  const AudioPcmFrame({
    required this.meetingId,
    required this.source,
    required this.bytes,
    required this.sampleRate,
    required this.channels,
    required this.timestamp,
  });

  final String meetingId;
  final AudioSourceKind source;
  final Uint8List bytes;
  final int sampleRate;
  final int channels;
  final Duration timestamp;
}

@freezed
abstract class ExportArtifact with _$ExportArtifact {
  const factory ExportArtifact({
    required String fileName,
    required ExportFormat format,
    required Uint8List bytes,
    required String mimeType,
  }) = _ExportArtifact;
}
