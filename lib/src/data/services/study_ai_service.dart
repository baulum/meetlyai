import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

import '../../domain/models/study_models.dart';
import '../../domain/services/settings_repository.dart';

class StudyAiService {
  StudyAiService(this._settings, {Dio? dio})
    : _dio =
          dio ?? Dio(BaseOptions(connectTimeout: const Duration(seconds: 20)));

  final SettingsRepository _settings;
  final Dio _dio;
  static const pdfVisionHeading = '## Visuelle PDF-Analyse';
  static const pdfVisionFailureHeading =
      '## Visuelle PDF-Analyse nicht verfügbar';
  static const _inlinePdfLimitBytes = 18 * 1024 * 1024;
  static const _maxPdfVisionBytes = 50 * 1024 * 1024;

  Future<String> answer({
    required String question,
    required List<StudyContextItem> context,
    required List<StudyChatMessage> history,
  }) {
    return _generate(
      instruction:
          'Beantworte die Frage ausschliesslich anhand des bereitgestellten Lern-Kontexts. '
          'Dateien und Meetings sind gleichwertige Quellen. '
          'Wenn die Antwort nicht im Kontext steht, sage genau das. '
          'Antworte immer als GitHub-Flavored Markdown mit passenden Ueberschriften und Unterthemen. Mache diese Fett.'
          'Nutze Bulletpoints und Tabellen, wenn sie beim Lernen helfen. Zitiere Quellen mit [Quelle: Titel].',
      task: question,
      context: context,
      history: history,
      temperature: 0.15,
    );
  }

  Future<List<StudyFlashcard>> createFlashcards({
    required List<StudyContextItem> context,
  }) async {
    final raw = await _generate(
      instruction:
          'Erstelle Lernkarten ausschliesslich aus dem Kontext. Antworte ausschliesslich als JSON Array. '
          'Jedes Element hat question, answer, source. Keine Informationen ausserhalb der Quellen verwenden.',
      task:
          'Erstelle 12 gute Lernkarten als JSON Array im Format [{"question":"...","answer":"...","source":"..."}].',
      context: context,
      history: const [],
      temperature: 0.2,
    );
    return _flashcardsFromJson(raw);
  }

  Future<List<StudyQuizQuestion>> createQuiz({
    required List<StudyContextItem> context,
  }) async {
    final raw = await _generate(
      instruction:
          'Erstelle ein Quiz ausschliesslich aus dem Kontext. Antworte ausschliesslich als JSON Array. '
          'Jedes Element hat question, options, correctIndex, explanation, source. Keine Informationen ausserhalb der Quellen verwenden.',
      task:
          'Erstelle 8 Multiple-Choice-Fragen als JSON Array im Format [{"question":"...","options":["..."],"correctIndex":0,"explanation":"...","source":"..."}].',
      context: context,
      history: const [],
      temperature: 0.2,
    );
    return _quizFromJson(raw);
  }

  Future<String> createStudyNote({required List<StudyContextItem> context}) {
    return _generate(
      instruction:
          'Erstelle einen vollstaendigen Lernzettel ausschliesslich aus den Datei-Quellen. '
          'Lasse inhaltlich nichts Wesentliches weg. Strukturiere mit Markdown-Ueberschriften, Stichpunkten, Definitionen, Beispielen und Merksaetzen. '
          'Meetings duerfen fuer Lernzettel nicht verwendet werden.',
      task:
          'Erstelle einen gut formatierten, vollstaendigen Lernzettel. Nutze klare Themen-Ueberschriften, kurze Abschnitte, Bullet Points und falls sinnvoll Tabellen in Markdown.',
      context: context
          .where((item) => item.kind.startsWith('file/'))
          .toList(growable: false),
      history: const [],
      temperature: 0.15,
      maxSourceChars: 90000,
    );
  }

  Future<String> analyzePdfVision({
    required String pdfPath,
    String localText = '',
  }) async {
    final file = File(pdfPath);
    if (!await file.exists()) {
      throw StateError('PDF file not found: $pdfPath');
    }
    final apiKey = await _settings.getGeminiApiKey();
    if (apiKey == null || apiKey.trim().isEmpty) {
      throw StateError('Gemini API key is missing.');
    }
    final model = (await _settings.getGeminiModel()) ?? 'gemini-2.5-flash';
    final normalizedModel = model.replaceFirst('models/', '');
    final bytes = await file.readAsBytes();
    if (bytes.length > _maxPdfVisionBytes) {
      throw StateError('PDF is larger than the Gemini 50 MB document limit.');
    }
    final prompt = _pdfVisionPrompt(localText: localText);
    final parts = bytes.length <= _inlinePdfLimitBytes
        ? <Map<String, Object?>>[
            {
              'inline_data': {
                'mime_type': 'application/pdf',
                'data': base64Encode(bytes),
              },
            },
            {'text': prompt},
          ]
        : <Map<String, Object?>>[
            {
              'file_data': {
                'mime_type': 'application/pdf',
                'file_uri': await _uploadGeminiFile(
                  apiKey: apiKey.trim(),
                  bytes: bytes,
                  displayName: p.basename(pdfPath),
                ),
              },
            },
            {'text': prompt},
          ];
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://generativelanguage.googleapis.com',
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(minutes: 5),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    final response = await dio.post<Map<String, Object?>>(
      '/v1beta/models/$normalizedModel:generateContent',
      queryParameters: {'key': apiKey.trim()},
      data: {
        'contents': [
          {'role': 'user', 'parts': parts},
        ],
        'generationConfig': {'temperature': 0.1},
      },
    );
    final text = _extractGeminiText(response.data).trim();
    if (text.isEmpty) {
      throw StateError('Gemini returned an empty PDF vision response.');
    }
    return text;
  }

  Future<String> _uploadGeminiFile({
    required String apiKey,
    required List<int> bytes,
    required String displayName,
  }) async {
    final uploadDio = Dio(
      BaseOptions(
        baseUrl: 'https://generativelanguage.googleapis.com',
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(minutes: 5),
      ),
    );
    final startResponse = await uploadDio.post<Object?>(
      '/upload/v1beta/files',
      options: Options(
        headers: {
          'x-goog-api-key': apiKey,
          'X-Goog-Upload-Protocol': 'resumable',
          'X-Goog-Upload-Command': 'start',
          'X-Goog-Upload-Header-Content-Length': bytes.length.toString(),
          'X-Goog-Upload-Header-Content-Type': 'application/pdf',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'file': {'display_name': displayName},
      },
    );
    final uploadUrl = startResponse.headers.value('x-goog-upload-url');
    if (uploadUrl == null || uploadUrl.isEmpty) {
      throw StateError('Gemini did not return a file upload URL.');
    }
    final finalizeResponse = await Dio().post<Map<String, Object?>>(
      uploadUrl,
      options: Options(
        headers: {
          'Content-Length': bytes.length.toString(),
          'Content-Type': 'application/pdf',
          'X-Goog-Upload-Offset': '0',
          'X-Goog-Upload-Command': 'upload, finalize',
        },
      ),
      data: Stream<List<int>>.value(bytes),
    );
    final file = finalizeResponse.data?['file'];
    if (file is Map<String, Object?>) {
      final uri = file['uri'];
      if (uri is String && uri.isNotEmpty) {
        return uri;
      }
    }
    throw StateError('Gemini file upload did not return a file URI.');
  }

  Future<String> _generate({
    required String instruction,
    required String task,
    required List<StudyContextItem> context,
    required List<StudyChatMessage> history,
    required double temperature,
    int maxSourceChars = 12000,
  }) async {
    if (context.every((item) => item.content.trim().isEmpty)) {
      return 'Ich brauche zuerst analysierbare Unterlagen oder verknuepfte Meetings in diesem Lernordner.';
    }

    final provider = await _settings.getLlmProvider();
    if (provider == 'openai_compatible') {
      return _generateOpenAiCompatible(
        instruction: instruction,
        task: task,
        context: context,
        history: history,
        temperature: temperature,
        maxSourceChars: maxSourceChars,
      );
    }
    return _generateGemini(
      instruction: instruction,
      task: task,
      context: context,
      history: history,
      temperature: temperature,
      maxSourceChars: maxSourceChars,
    );
  }

  Future<String> _generateGemini({
    required String instruction,
    required String task,
    required List<StudyContextItem> context,
    required List<StudyChatMessage> history,
    required double temperature,
    required int maxSourceChars,
  }) async {
    final apiKey = await _settings.getGeminiApiKey();
    if (apiKey == null || apiKey.trim().isEmpty) {
      throw StateError('Gemini API key is missing.');
    }
    final model = (await _settings.getGeminiModel()) ?? 'gemini-2.5-flash';
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://generativelanguage.googleapis.com',
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(minutes: 3),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    final response = await dio.post<Map<String, Object?>>(
      '/v1beta/models/${model.replaceFirst('models/', '')}:generateContent',
      queryParameters: {'key': apiKey.trim()},
      data: {
        'contents': [
          {
            'role': 'user',
            'parts': [
              {
                'text': _prompt(
                  instruction,
                  task,
                  context,
                  history,
                  maxSourceChars: maxSourceChars,
                ),
              },
            ],
          },
        ],
        'generationConfig': {'temperature': temperature},
      },
    );
    return _extractGeminiText(response.data).trim();
  }

  Future<String> _generateOpenAiCompatible({
    required String instruction,
    required String task,
    required List<StudyContextItem> context,
    required List<StudyChatMessage> history,
    required double temperature,
    required int maxSourceChars,
  }) async {
    final apiKey = await _settings.getOpenAiApiKey();
    final baseUrl = await _settings.getOpenAiBaseUrl();
    final model = await _settings.getOpenAiModelName();
    if (baseUrl == null ||
        baseUrl.trim().isEmpty ||
        model == null ||
        model.trim().isEmpty) {
      throw StateError('OpenAI-compatible configuration is incomplete.');
    }
    final response = await _dio.post<Map<String, Object?>>(
      '${baseUrl.trim().replaceAll(RegExp(r'/$'), '')}/chat/completions',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          if (apiKey != null && apiKey.trim().isNotEmpty)
            'Authorization': 'Bearer ${apiKey.trim()}',
        },
      ),
      data: {
        'model': model.trim(),
        'messages': [
          {
            'role': 'user',
            'content': _prompt(
              instruction,
              task,
              context,
              history,
              maxSourceChars: maxSourceChars,
            ),
          },
        ],
        'temperature': temperature,
      },
    );
    final choices = response.data?['choices'];
    if (choices is List && choices.isNotEmpty) {
      final first = choices.first;
      if (first is Map<String, Object?>) {
        final message = first['message'];
        if (message is Map<String, Object?>) {
          return (message['content'] as String? ?? '').trim();
        }
      }
    }
    return '';
  }

  String _prompt(
    String instruction,
    String task,
    List<StudyContextItem> context,
    List<StudyChatMessage> history, {
    required int maxSourceChars,
  }) {
    final sources = context
        .where((item) => item.content.trim().isNotEmpty)
        .map(
          (item) =>
              '### Quelle: ${item.title} (${item.kind})\n${_truncate(item.content, maxSourceChars)}',
        )
        .join('\n\n');
    final chat = history
        .take(12)
        .map((message) => '${message.role.name}: ${message.content}')
        .join('\n');
    return '''
Du bist MeetlyAI Lernen.

Regeln:
- $instruction
- Nutze nur die Quellen unten und den bisherigen Chat als Kontext.
- Datei-Quellen und Meeting-Quellen sind beide gueltige Evidence.
- Kein Weltwissen, keine Annahmen, keine Inhalte ausserhalb der Quellen.
- Wenn Quellen nicht reichen, sage: "Das steht nicht in den bereitgestellten Unterlagen."
- Formatiere normale Chat-Antworten immer als GitHub-Flavored Markdown.
- Strukturiere Chat-Antworten mit passenden kurzen Ueberschriften und Unterthemen, z.B. "Kurzantwort", "Erklaerung", "Beispiele", "Merksatz" oder "Quellen".
- Nutze Bulletpoints fuer scanbare Inhalte und Markdown-Tabellen fuer Vergleiche, Begriffe, Schritte oder strukturierte Daten.
- Keine unformatierten Fliesstext-Bloecke.

Quellen:
$sources

Bisheriger Chat:
$chat

Aufgabe:
$task
''';
  }

  String _pdfVisionPrompt({required String localText}) {
    final textHint = localText.trim().isEmpty
        ? 'Es wurde kein eingebetteter Text lokal extrahiert.'
        : 'Lokal extrahierter eingebetteter Text ist vorhanden. Wiederhole ihn nur, wenn es fuer Tabellen, Layout oder Bildbezug noetig ist.';
    return '''
Analysiere dieses PDF fuer eine Lern-App. Nutze native Vision und beruecksichtige Bilder, Diagramme, Tabellen, Formeln, Screenshots, Layout, Beschriftungen und Handschrift.

Regeln:
- Antworte auf Deutsch.
- Nutze ausschliesslich Inhalte aus dem PDF.
- Erfinde keine Details. Wenn Handschrift oder ein Bild unklar ist, markiere es als unsicher.
- Gliedere seitenweise, falls sinnvoll.
- Liefere Markdown mit exakt diesen passenden Abschnittsarten:
  ## Seite N
  ### Erkannter Text
  ### Handschrift
  ### Diagramme und Bilder
  ### Tabellen/Formeln
  ### Lernrelevante Kernaussagen
- Wenn eine Abschnittsart auf einer Seite nicht vorkommt, schreibe kurz "Nicht vorhanden" oder "Nicht sicher erkennbar".

Hinweis: $textHint
''';
  }

  String _extractGeminiText(Map<String, Object?>? data) {
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

  String _truncate(String value, int maxLength) {
    if (value.length <= maxLength) {
      return value;
    }
    return '${value.substring(0, maxLength)}\n[gekürzt]';
  }

  List<StudyFlashcard> _flashcardsFromJson(String raw) {
    final decoded = _extractJsonArray(raw);
    return decoded
        .whereType<Map<String, Object?>>()
        .map(
          (item) => StudyFlashcard(
            question: item['question'] as String? ?? '',
            answer: item['answer'] as String? ?? '',
            source: item['source'] as String? ?? 'Quelle',
          ),
        )
        .where((card) => card.question.isNotEmpty && card.answer.isNotEmpty)
        .toList(growable: false);
  }

  List<StudyQuizQuestion> _quizFromJson(String raw) {
    final decoded = _extractJsonArray(raw);
    return decoded
        .whereType<Map<String, Object?>>()
        .map((item) {
          final options =
              (item['options'] as List?)?.whereType<String>().toList(
                growable: false,
              ) ??
              const <String>[];
          return StudyQuizQuestion(
            question: item['question'] as String? ?? '',
            options: options,
            correctIndex: item['correctIndex'] is int
                ? item['correctIndex'] as int
                : int.tryParse('${item['correctIndex']}') ?? 0,
            explanation: item['explanation'] as String? ?? '',
            source: item['source'] as String? ?? 'Quelle',
          );
        })
        .where(
          (question) =>
              question.question.isNotEmpty &&
              question.options.length >= 2 &&
              question.correctIndex >= 0 &&
              question.correctIndex < question.options.length,
        )
        .toList(growable: false);
  }

  List<Object?> _extractJsonArray(String raw) {
    final trimmed = raw.trim();
    final start = trimmed.indexOf('[');
    final end = trimmed.lastIndexOf(']');
    if (start == -1 || end == -1 || end <= start) {
      throw const FormatException('AI did not return a JSON array.');
    }
    final decoded = jsonDecode(trimmed.substring(start, end + 1));
    if (decoded is List) {
      return decoded;
    }
    throw const FormatException('AI did not return a JSON array.');
  }
}

class StudyFlashcard {
  const StudyFlashcard({
    required this.question,
    required this.answer,
    required this.source,
  });

  final String question;
  final String answer;
  final String source;
}

class StudyQuizQuestion {
  const StudyQuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.source,
  });

  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String source;
}
