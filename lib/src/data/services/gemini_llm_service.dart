import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../domain/models/meeting_models.dart';
import '../../domain/services/llm_service.dart';
import '../../domain/services/settings_repository.dart';

class GeminiLlmService implements LlmService {
  GeminiLlmService(this._settings, {Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://generativelanguage.googleapis.com',
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(minutes: 3),
              headers: {'Content-Type': 'application/json'},
            ),
          );

  final SettingsRepository _settings;
  final Dio _dio;

  @override
  Future<MeetingSummary> summarizeMeeting({
    required Meeting meeting,
    required List<TranscriptSegment> transcript,
  }) async {
    final apiKey = await _requiredApiKey();
    final model = await _configuredModel();
    final payload = _summaryPayload(meeting, transcript, includeSchema: true);
    Map<String, Object?>? responseData;
    try {
      final response = await _dio.post<Map<String, Object?>>(
        '/v1beta/models/$model:generateContent',
        queryParameters: {'key': apiKey},
        data: payload,
      );
      responseData = response.data;
    } on DioException catch (error) {
      if (error.response?.statusCode != 400) {
        throw StateError(_dioErrorMessage('Gemini summary failed', error));
      }

      final retryResponse = await _dio.post<Map<String, Object?>>(
        '/v1beta/models/$model:generateContent',
        queryParameters: {'key': apiKey},
        data: _summaryPayload(meeting, transcript, includeSchema: false),
      );
      responseData = retryResponse.data;
    }

    final raw = _extractText(responseData);
    return _summaryFromJson(meeting.id, raw);
  }

  @override
  Stream<String> streamMeetingAnswer(MeetingChatRequest request) async* {
    final apiKey = await _requiredApiKey();
    final model = await _configuredModel();
    final payload = _chatPayload(request);
    final Response<ResponseBody> response;
    try {
      response = await _dio.post<ResponseBody>(
        '/v1beta/models/$model:streamGenerateContent',
        queryParameters: {'key': apiKey, 'alt': 'sse'},
        options: Options(responseType: ResponseType.stream),
        data: payload,
      );
    } on DioException catch (error) {
      final fallback = await _generateChatAnswer(
        apiKey: apiKey,
        model: model,
        payload: payload,
        previousError: error,
      );
      yield fallback;
      return;
    }

    final body = response.data;
    if (body == null) {
      return;
    }

    await for (final line
        in body.stream
            .map<List<int>>((chunk) => chunk)
            .transform(utf8.decoder)
            .transform(const LineSplitter())) {
      if (!line.startsWith('data:')) {
        continue;
      }
      final payload = line.substring(5).trim();
      if (payload.isEmpty || payload == '[DONE]') {
        continue;
      }
      final decoded = jsonDecode(payload) as Map<String, Object?>;
      final text = _extractText(decoded);
      if (text.isNotEmpty) {
        yield text;
      }
    }
  }

  Future<String> _generateChatAnswer({
    required String apiKey,
    required String model,
    required Map<String, Object?> payload,
    required DioException previousError,
  }) async {
    try {
      final response = await _dio.post<Map<String, Object?>>(
        '/v1beta/models/$model:generateContent',
        queryParameters: {'key': apiKey},
        data: payload,
      );
      final text = _extractText(response.data).trim();
      if (text.isNotEmpty) {
        return text;
      }
      throw StateError('Gemini returned an empty chat response.');
    } on DioException catch (fallbackError) {
      throw StateError(
        [
          _dioErrorMessage('Gemini chat failed', fallbackError),
          'Streaming fallback reason:',
          _dioErrorMessage('Gemini streaming failed', previousError),
        ].join('\n'),
      );
    }
  }

  Future<String> _requiredApiKey() async {
    final key = await _settings.getGeminiApiKey();
    if (key == null || key.trim().isEmpty) {
      throw StateError('Gemini API key is missing.');
    }
    return key.trim();
  }

  Future<String> _configuredModel() async {
    final configured = await _settings.getGeminiModel();
    final trimmed = configured?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return 'gemini-2.5-flash';
    }
    return trimmed.startsWith('models/') ? trimmed.substring(7) : trimmed;
  }

  Map<String, Object?> _summaryPayload(
    Meeting meeting,
    List<TranscriptSegment> transcript, {
    required bool includeSchema,
  }) {
    return {
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': _summaryPrompt(meeting, transcript)},
          ],
        },
      ],
      'generationConfig': {
        'temperature': 0.15,
        'responseMimeType': 'application/json',
        if (includeSchema) 'responseSchema': _summarySchema,
      },
    };
  }

  Map<String, Object?> _chatPayload(MeetingChatRequest request) {
    return {
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': _chatPrompt(request)},
          ],
        },
      ],
      'generationConfig': {'temperature': 0.25},
    };
  }

  String _dioErrorMessage(String prefix, DioException error) {
    final status = error.response?.statusCode;
    final body = error.response?.data;
    final bodyText = switch (body) {
      null => '',
      final String value => value,
      final ResponseBody value => 'Stream response body (${value.statusCode})',
      _ => const JsonEncoder.withIndent('  ').convert(body),
    };
    return [
      prefix,
      if (status != null) 'HTTP $status',
      if (bodyText.trim().isNotEmpty) bodyText.trim(),
      if (bodyText.trim().isEmpty) error.message,
    ].join('\n');
  }

  String _extractText(Map<String, Object?>? data) {
    final candidates = data?['candidates'];
    if (candidates is! List || candidates.isEmpty) {
      return '';
    }
    final first = candidates.first;
    if (first is! Map<String, Object?>) {
      return '';
    }
    final content = first['content'];
    if (content is! Map<String, Object?>) {
      return '';
    }
    final parts = content['parts'];
    if (parts is! List) {
      return '';
    }
    return parts
        .whereType<Map<String, Object?>>()
        .map((part) => part['text'])
        .whereType<String>()
        .join();
  }

  String _summaryPrompt(Meeting meeting, List<TranscriptSegment> transcript) {
    final transcriptText = transcript
        .map((segment) {
          final source = switch (segment.source) {
            AudioSourceKind.mic => 'Mic',
            AudioSourceKind.system => 'System',
            AudioSourceKind.mixed => 'Mixed',
          };
          final speaker = segment.speakerLabel?.trim().isNotEmpty == true
              ? segment.speakerLabel!.trim()
              : source;
          return '[${segment.id}] ${_time(segment.startMs)}-$speaker/$source: '
              '${segment.text}';
        })
        .join('\n');

    return '''
Du bist MeetlyAI. Analysiere dieses Meeting und antworte ausschliesslich als JSON nach dem bereitgestellten Schema.

Ziele:
- Erzeuge einen praegnanten Meeting-Titel.
- Schreibe die Zusammenfassung als gut scanbare Stichpunkte, nicht als Fliesstext. Filter unnötige Sachen raus.
- Gib "overview" als 4 bis 7 Bulletpoints aus. Jeder Bulletpoint beginnt mit "- ".
- Teile das Meeting in sinnvolle Themen/Kapitel auf. Jedes Kapitel hat eine klare Ueberschrift.
- Gib "chapters[].summary" ebenfalls als 3 bis 6 Bulletpoints aus. Jeder Bulletpoint beginnt mit "- ".
- Themen sollen inhaltlich gruppiert sein, z.B. Ziele, technische Entscheidungen, Risiken, Budget, Timing, offene Punkte.
- Erkenne alle Todos/Action Items mit konkreter Aufgabe, Owner, Due Date und Status, wenn erkennbar.
- Schreibe Todos ausschliesslich in "actionItems"; diese werden in der App als editierbare Todo-Tabelle angezeigt.
- Falls kein Owner, kein Due Date oder kein Status genannt wird, nutze null bzw. false statt zu raten.
- Extrahiere Entscheidungen, offene Fragen, Follow-ups und Tags.
- Nutze evidenceSegmentIds, um Aussagen auf Transcript-Segmente zurueckzufuehren.
- Schreibe kurz, konkret und produktiv. Keine langen Absaetze.

Meeting: ${meeting.title}
Sprache: ${meeting.languageCode}

Transkript:
$transcriptText
''';
  }

  String _chatPrompt(MeetingChatRequest request) {
    final summary = request.summary == null
        ? 'Keine Zusammenfassung vorhanden.'
        : jsonEncode(request.summary!.toJson());
    final context = request.transcriptContext
        .map((segment) {
          return '[${segment.id}] ${_time(segment.startMs)} '
              '${segment.speakerLabel ?? segment.source.name}: ${segment.text}';
        })
        .join('\n');
    final history = request.messages
        .take(20)
        .map((message) {
          return '${message.role.name}: ${message.content}';
        })
        .join('\n');

    return '''
Du bist MeetlyAI und beantwortest Fragen zu einem lokalen Meeting.
Antworte knapp, belege konkrete Aussagen mit Segment-IDs in eckigen Klammern, und erfinde keine Inhalte.
Antworte immer als GitHub-Flavored Markdown.
Strukturiere jede Antwort mit passenden kurzen Ueberschriften und Unterthemen, wie z.B. "Kurzantwort", "Wichtige Punkte", "Aufgaben", "Risiken" oder "Belege". Mache diese fett.
Nutze Bulletpoints fuer scanbare Inhalte und Markdown-Tabellen fuer Vergleiche, Aufgabenlisten, Status, Owner, Termine oder strukturierte Daten.
Keine unformatierten Fliesstext-Bloecke.

Meeting: ${request.meeting.title}
Zusammenfassung: $summary

Relevanter Transkript-Kontext:
$context

Bisheriger Chat:
$history

Frage:
${request.question}
''';
  }

  MeetingSummary _summaryFromJson(String meetingId, String rawJson) {
    final json =
        jsonDecode(_extractJsonObject(rawJson)) as Map<String, Object?>;
    final now = DateTime.now();
    return MeetingSummary(
      meetingId: meetingId,
      generatedTitle: _string(json['generatedTitle'], 'Untitled meeting'),
      overview: _string(json['overview'], ''),
      createdAt: now,
      chapters: _list(json['chapters']).indexed
          .map((entry) {
            final value = entry.$2;
            return SummaryChapter(
              id: _string(value['id'], 'chapter-${entry.$1 + 1}'),
              title: _string(value['title'], 'Chapter ${entry.$1 + 1}'),
              summary: _string(value['summary'], ''),
              startMs: _int(value['startMs']),
              endMs: _int(value['endMs']),
              evidenceSegmentIds: _stringList(value['evidenceSegmentIds']),
            );
          })
          .toList(growable: false),
      actionItems: _list(json['actionItems']).indexed
          .map((entry) {
            final value = entry.$2;
            return ActionItem(
              id: _string(value['id'], 'action-${entry.$1 + 1}'),
              text: _string(value['text'], ''),
              owner: _nullableString(value['owner']),
              dueDate: _nullableString(value['dueDate']),
              evidenceSegmentIds: _stringList(value['evidenceSegmentIds']),
            );
          })
          .toList(growable: false),
      decisions: _list(json['decisions']).indexed
          .map((entry) {
            final value = entry.$2;
            return DecisionItem(
              id: _string(value['id'], 'decision-${entry.$1 + 1}'),
              text: _string(value['text'], ''),
              rationale: _nullableString(value['rationale']),
              evidenceSegmentIds: _stringList(value['evidenceSegmentIds']),
            );
          })
          .toList(growable: false),
      openQuestions: _list(json['openQuestions']).indexed
          .map((entry) {
            final value = entry.$2;
            return OpenQuestion(
              id: _string(value['id'], 'question-${entry.$1 + 1}'),
              text: _string(value['text'], ''),
              owner: _nullableString(value['owner']),
              evidenceSegmentIds: _stringList(value['evidenceSegmentIds']),
            );
          })
          .toList(growable: false),
      followUpSuggestions: _stringList(json['followUpSuggestions']),
      tags: _stringList(json['tags']),
    );
  }

  String _extractJsonObject(String raw) {
    final trimmed = raw.trim();
    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      return trimmed;
    }
    final start = trimmed.indexOf('{');
    final end = trimmed.lastIndexOf('}');
    if (start >= 0 && end > start) {
      return trimmed.substring(start, end + 1);
    }
    throw const FormatException('Gemini did not return a JSON object.');
  }

  String _time(int ms) {
    final duration = Duration(milliseconds: ms);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _string(Object? value, String fallback) {
    return value is String && value.trim().isNotEmpty ? value.trim() : fallback;
  }

  String? _nullableString(Object? value) {
    return value is String && value.trim().isNotEmpty ? value.trim() : null;
  }

  int _int(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.round();
    }
    return 0;
  }

  List<Map<String, Object?>> _list(Object? value) {
    if (value is! List) {
      return const [];
    }
    return value.whereType<Map<String, Object?>>().toList(growable: false);
  }

  List<String> _stringList(Object? value) {
    if (value is! List) {
      return const [];
    }
    return value.whereType<String>().toList(growable: false);
  }
}

const Map<String, Object?> _summarySchema = {
  'type': 'OBJECT',
  'required': [
    'generatedTitle',
    'overview',
    'chapters',
    'actionItems',
    'decisions',
    'openQuestions',
    'followUpSuggestions',
    'tags',
  ],
  'properties': {
    'generatedTitle': {'type': 'STRING'},
    'overview': {'type': 'STRING'},
    'chapters': {
      'type': 'ARRAY',
      'items': {
        'type': 'OBJECT',
        'required': ['title', 'summary', 'evidenceSegmentIds'],
        'properties': {
          'id': {'type': 'STRING'},
          'title': {'type': 'STRING'},
          'summary': {'type': 'STRING'},
          'startMs': {'type': 'INTEGER'},
          'endMs': {'type': 'INTEGER'},
          'evidenceSegmentIds': {
            'type': 'ARRAY',
            'items': {'type': 'STRING'},
          },
        },
      },
    },
    'actionItems': {
      'type': 'ARRAY',
      'items': {
        'type': 'OBJECT',
        'required': ['text', 'evidenceSegmentIds'],
        'properties': {
          'id': {'type': 'STRING'},
          'text': {'type': 'STRING'},
          'owner': {'type': 'STRING', 'nullable': true},
          'dueDate': {'type': 'STRING', 'nullable': true},
          'evidenceSegmentIds': {
            'type': 'ARRAY',
            'items': {'type': 'STRING'},
          },
        },
      },
    },
    'decisions': {
      'type': 'ARRAY',
      'items': {
        'type': 'OBJECT',
        'required': ['text', 'evidenceSegmentIds'],
        'properties': {
          'id': {'type': 'STRING'},
          'text': {'type': 'STRING'},
          'rationale': {'type': 'STRING', 'nullable': true},
          'evidenceSegmentIds': {
            'type': 'ARRAY',
            'items': {'type': 'STRING'},
          },
        },
      },
    },
    'openQuestions': {
      'type': 'ARRAY',
      'items': {
        'type': 'OBJECT',
        'required': ['text', 'evidenceSegmentIds'],
        'properties': {
          'id': {'type': 'STRING'},
          'text': {'type': 'STRING'},
          'owner': {'type': 'STRING', 'nullable': true},
          'evidenceSegmentIds': {
            'type': 'ARRAY',
            'items': {'type': 'STRING'},
          },
        },
      },
    },
    'followUpSuggestions': {
      'type': 'ARRAY',
      'items': {'type': 'STRING'},
    },
    'tags': {
      'type': 'ARRAY',
      'items': {'type': 'STRING'},
    },
  },
};
