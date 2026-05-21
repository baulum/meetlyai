import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../domain/models/llm_config.dart';
import '../../domain/models/meeting_models.dart';
import '../../domain/services/llm_service.dart';

class OpenAiCompatibleLlmService implements LlmService {
  OpenAiCompatibleLlmService(this._config, {Dio? dio})
    : assert(
        _config.apiKey != null && _config.apiKey!.isNotEmpty,
        'API key required',
      ),
      assert(
        _config.baseUrl != null && _config.baseUrl!.isNotEmpty,
        'Base URL required',
      ),
      assert(
        _config.modelName != null && _config.modelName!.isNotEmpty,
        'Model name required',
      ),
      _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: _config.baseUrl!,
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(minutes: 3),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ${_config.apiKey}',
              },
            ),
          );

  final LlmProviderConfig _config;
  final Dio _dio;

  @override
  Future<MeetingSummary> summarizeMeeting({
    required Meeting meeting,
    required List<TranscriptSegment> transcript,
  }) async {
    final prompt = _summaryPrompt(meeting, transcript);
    final response = await _createChatCompletion(
      messages: [
        {'role': 'user', 'content': prompt},
      ],
      temperature: 0.3,
      maxTokens: 2000,
    );

    final responseData = response as Map<String, dynamic>?;
    final choices = responseData?['choices'] as List<dynamic>?;
    final firstChoice = choices?.first as Map<String, dynamic>?;
    final message = firstChoice?['message'] as Map<String, dynamic>?;
    final content = message?['content'] as String?;

    if (content == null || content.isEmpty) {
      throw StateError('Empty response from LLM');
    }

    return _summaryFromJson(meeting.id, content);
  }

  @override
  Stream<String> streamMeetingAnswer(MeetingChatRequest request) async* {
    final systemPrompt = _chatSystemPrompt(request);
    final userMessage = request.question;

    final messages = <Map<String, String>>[
      if (request.summary != null) {'role': 'system', 'content': systemPrompt},
      ...request.messages.map(
        (msg) => {
          'role': msg.role == ChatRole.user ? 'user' : 'assistant',
          'content': msg.content,
        },
      ),
      {'role': 'user', 'content': userMessage},
    ];

    try {
      final response = await _streamChatCompletion(
        messages: messages,
        temperature: 0.7,
        maxTokens: 1000,
      );
      yield response;
    } on Object catch (error) {
      yield 'Error generating response: $error';
    }
  }

  Future<Map<String, Object?>> _createChatCompletion({
    required List<Map<String, String>> messages,
    required double temperature,
    required int maxTokens,
  }) async {
    final payload = {
      'model': _config.modelName,
      'messages': messages,
      'temperature': temperature,
      'max_tokens': maxTokens,
    };

    try {
      final response = await _dio.post<Map<String, Object?>>(
        '/chat/completions',
        data: payload,
      );

      return response.data ?? {};
    } on DioException catch (error) {
      throw StateError(_dioErrorMessage('Chat completion failed', error));
    }
  }

  Future<String> _streamChatCompletion({
    required List<Map<String, String>> messages,
    required double temperature,
    required int maxTokens,
  }) async {
    final payload = {
      'model': _config.modelName,
      'messages': messages,
      'temperature': temperature,
      'max_tokens': maxTokens,
      'stream': true,
    };

    try {
      final response = await _dio.post<ResponseBody>(
        '/chat/completions',
        options: Options(responseType: ResponseType.stream),
        data: payload,
      );

      final body = response.data;
      if (body == null) {
        return '';
      }

      final buffer = StringBuffer();
      await for (final line
          in body.stream
              .map<List<int>>((chunk) => chunk)
              .transform(utf8.decoder)
              .transform(const LineSplitter())) {
        if (!line.startsWith('data:')) {
          continue;
        }

        final dataLine = line.substring(5).trim();
        if (dataLine.isEmpty || dataLine == '[DONE]') {
          continue;
        }

        try {
          final decoded = jsonDecode(dataLine) as Map<String, dynamic>;
          final choices = decoded['choices'] as List<dynamic>?;
          if (choices != null && choices.isNotEmpty) {
            final delta = choices[0] as Map<String, dynamic>?;
            final content = delta?['delta']?['content'] as String?;
            if (content != null && content.isNotEmpty) {
              buffer.write(content);
            }
          }
        } catch (_) {
          // Skip invalid JSON lines
          continue;
        }
      }

      return buffer.toString();
    } on DioException catch (error) {
      throw StateError(
        _dioErrorMessage('Stream chat completion failed', error),
      );
    }
  }

  String _summaryPrompt(Meeting meeting, List<TranscriptSegment> transcript) {
    final transcriptText = transcript
        .map((seg) => '${seg.speakerLabel ?? 'Unknown'}: ${seg.text}')
        .join('\n');

    return '''Analysiere diesen Meeting-Transkript und erstelle eine strukturierte Zusammenfassung.

Transkript:
$transcriptText

Erstelle eine JSON-Zusammenfassung mit dieser Struktur:
{
  "generatedTitle": "Titel des Meetings",
  "overview": "Kurze Übersicht",
  "chapters": [
    {
      "id": "uuid",
      "title": "Kapitel Titel",
      "summary": "Zusammenfassung",
      "startMs": 0,
      "endMs": 0,
      "evidenceSegmentIds": []
    }
  ],
  "actionItems": [
    {
      "id": "uuid",
      "text": "Aufgabe",
      "owner": null,
      "dueDate": null,
      "done": false,
      "evidenceSegmentIds": []
    }
  ],
  "decisions": [],
  "openQuestions": [],
  "followUpSuggestions": [],
  "tags": []
}''';
  }

  String _chatSystemPrompt(MeetingChatRequest request) {
    final summary = request.summary;
    if (summary == null) {
      return '''Du bist ein hilfreicher Meeting-Assistent.
Antworte immer als GitHub-Flavored Markdown.
Strukturiere jede Antwort mit passenden kurzen Ueberschriften und Unterthemen.
Nutze Bulletpoints und Markdown-Tabellen, wenn sie die Antwort klarer machen.''';
    }

    final context = request.transcriptContext
        .map((seg) => '${seg.speakerLabel ?? 'Unknown'}: ${seg.text}')
        .join('\n');

    return '''Du bist ein Meeting-Assistent. Antworte basierend auf folgendem Kontext:

Zusammenfassung: ${summary.overview}

Relevant Transkript-Ausschnitte:
$context

Gib präzise, hilfreiche Antworten basierend auf dem Meeting-Inhalt.
Antworte immer als GitHub-Flavored Markdown.
Strukturiere jede Antwort mit passenden kurzen Ueberschriften und Unterthemen, wie z.B. "Kurzantwort", "Wichtige Punkte", "Aufgaben", "Risiken" oder "Belege". Mache diese fett.
Nutze Bulletpoints fuer scanbare Inhalte und Markdown-Tabellen fuer Vergleiche, Aufgabenlisten, Status, Owner, Termine oder strukturierte Daten.
Keine unformatierten Fliesstext-Bloecke.''';
  }

  MeetingSummary _summaryFromJson(String meetingId, String jsonText) {
    try {
      final json = jsonDecode(jsonText) as Map<String, Object?>;
      return MeetingSummary(
        meetingId: meetingId,
        generatedTitle: json['generatedTitle'] as String? ?? 'Untitled',
        overview: json['overview'] as String? ?? '',
        chapters:
            (json['chapters'] as List<Object?>?)?.map((chapter) {
              final c = chapter as Map<String, Object?>?;
              return SummaryChapter(
                id: c?['id'] as String? ?? '',
                title: c?['title'] as String? ?? '',
                summary: c?['summary'] as String? ?? '',
              );
            }).toList() ??
            [],
        actionItems:
            (json['actionItems'] as List<Object?>?)?.map((item) {
              final i = item as Map<String, Object?>?;
              return ActionItem(
                id: i?['id'] as String? ?? '',
                text: i?['text'] as String? ?? '',
              );
            }).toList() ??
            [],
        createdAt: DateTime.now(),
      );
    } on Object {
      return MeetingSummary(
        meetingId: meetingId,
        generatedTitle: 'Zusammenfassung',
        overview: jsonText,
        createdAt: DateTime.now(),
      );
    }
  }

  String _dioErrorMessage(String operation, DioException error) {
    return '''$operation failed:
Status: ${error.response?.statusCode}
Message: ${error.message}
Response: ${error.response?.data}''';
  }
}
