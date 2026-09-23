import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/study_models.dart';

class StudyDocumentImporter {
  const StudyDocumentImporter({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  Future<StudyDocument> importFile({
    required String folderId,
    required String sourcePath,
    String? category,
  }) async {
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw StateError('File not found: $sourcePath');
    }

    final docs = await getApplicationDocumentsDirectory();
    final targetDirectory = Directory(
      p.join(docs.path, 'MeetlyAI', 'study', folderId),
    );
    await targetDirectory.create(recursive: true);

    final id = _uuid.v7();
    final targetPath = p.join(
      targetDirectory.path,
      '$id${p.extension(sourcePath).toLowerCase()}',
    );
    await source.copy(targetPath);

    final kind = _kindForPath(sourcePath);
    final extractedText = await extractTextFromPath(targetPath);
    return StudyDocument(
      id: id,
      folderId: folderId,
      title: p.basenameWithoutExtension(sourcePath),
      kind: kind,
      sourcePath: targetPath,
      category: category?.trim().isEmpty == true ? null : category?.trim(),
      extractedText: extractedText,
      createdAt: DateTime.now(),
    );
  }

  Future<String> extractTextFromPath(String sourcePath) async {
    final file = File(sourcePath);
    if (!await file.exists()) {
      return '';
    }
    return _extractText(file, _kindForPath(sourcePath));
  }

  StudyDocumentKind _kindForPath(String path) {
    return switch (p.extension(path).toLowerCase()) {
      '.pdf' => StudyDocumentKind.pdf,
      '.md' || '.markdown' => StudyDocumentKind.markdown,
      '.txt' ||
      '.text' ||
      '.csv' ||
      '.tsv' ||
      '.json' ||
      '.jsonl' ||
      '.yaml' ||
      '.yml' ||
      '.xml' ||
      '.html' ||
      '.htm' ||
      '.rtf' ||
      '.dart' ||
      '.js' ||
      '.ts' ||
      '.jsx' ||
      '.tsx' ||
      '.py' ||
      '.java' ||
      '.kt' ||
      '.swift' ||
      '.c' ||
      '.h' ||
      '.cpp' ||
      '.hpp' ||
      '.cs' ||
      '.go' ||
      '.rs' ||
      '.php' ||
      '.rb' ||
      '.sh' ||
      '.zsh' ||
      '.bash' ||
      '.sql' ||
      '.toml' ||
      '.ini' ||
      '.log' => StudyDocumentKind.text,
      _ => StudyDocumentKind.other,
    };
  }

  Future<String> _extractText(File file, StudyDocumentKind kind) async {
    return switch (kind) {
      StudyDocumentKind.pdf => _extractPdfText(file),
      StudyDocumentKind.markdown ||
      StudyDocumentKind.text => file.readAsString(encoding: utf8),
      StudyDocumentKind.other => _tryExtractPlainText(file),
    };
  }

  Future<String> _tryExtractPlainText(File file) async {
    final length = await file.length();
    if (length == 0) {
      return '';
    }
    if (length > 8 * 1024 * 1024) {
      return 'Datei wurde gespeichert, ist aber zu groß für lokale Textvorschau. Nutze ein textbasiertes Format oder füge später eine passende Analyse-Pipeline hinzu.';
    }
    final bytes = await file.readAsBytes();
    final zeroBytes = bytes.where((byte) => byte == 0).length;
    if (zeroBytes > bytes.length * 0.01) {
      return 'Datei wurde gespeichert. Für diesen Dateityp ist aktuell keine lokale Textextraktion verfügbar.';
    }
    try {
      final text = utf8.decode(bytes, allowMalformed: false).trim();
      if (text.isEmpty) {
        return '';
      }
      final printable = text.runes.where((rune) {
        return rune == 9 || rune == 10 || rune == 13 || rune >= 32;
      }).length;
      if (printable < text.runes.length * 0.85) {
        return 'Datei wurde gespeichert. Für diesen Dateityp ist aktuell keine lokale Textextraktion verfügbar.';
      }
      return text;
    } on FormatException {
      return 'Datei wurde gespeichert. Für diesen Dateityp ist aktuell keine lokale Textextraktion verfügbar.';
    }
  }

  Future<String> _extractPdfText(File file) async {
    final internalText = await _extractPdfTextWithDart(file);
    if (internalText.trim().isNotEmpty) {
      return internalText.trim();
    }

    final tool = await _findPdfToText();
    if (tool == null) {
      return 'PDF konnte importiert werden, aber es wurde kein eingebetteter Text gefunden. Falls das ein Scan ist, braucht die Datei OCR-Text.';
    }
    final result = await Process.run(tool, [
      '-layout',
      file.path,
      '-',
    ], runInShell: false);
    if (result.exitCode != 0) {
      return 'PDF text extraction failed: ${result.stderr}';
    }
    return result.stdout.toString().trim();
  }

  Future<String> _extractPdfTextWithDart(File file) async {
    PdfDocument? document;
    try {
      document = PdfDocument(inputBytes: await file.readAsBytes());
      return PdfTextExtractor(document).extractText();
    } catch (_) {
      return '';
    } finally {
      document?.dispose();
    }
  }

  Future<String?> _findPdfToText() async {
    const candidates = [
      '/opt/homebrew/bin/pdftotext',
      '/usr/local/bin/pdftotext',
      'pdftotext',
    ];
    for (final candidate in candidates) {
      if (candidate.contains('/')) {
        if (await File(candidate).exists()) {
          return candidate;
        }
        continue;
      }
      final result = await Process.run('/usr/bin/env', [
        'which',
        candidate,
      ], runInShell: false);
      if (result.exitCode == 0) {
        final path = result.stdout.toString().trim();
        if (path.isNotEmpty) {
          return path;
        }
      }
    }
    return null;
  }
}
