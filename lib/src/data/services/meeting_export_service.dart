import 'dart:convert';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../domain/models/meeting_models.dart';
import '../../domain/services/export_service.dart';

class MeetingExportService implements ExportService {
  static const _ink = PdfColor.fromInt(0xFF111827);
  static const _muted = PdfColor.fromInt(0xFF6B7280);
  static const _line = PdfColor.fromInt(0xFFE5E7EB);
  static const _soft = PdfColor.fromInt(0xFFF8FAFC);
  static const _accent = PdfColor.fromInt(0xFF0F766E);

  @override
  Future<ExportArtifact> exportMeeting({
    required ExportFormat format,
    required Meeting meeting,
    MeetingSummary? summary,
    required List<TranscriptSegment> transcript,
    required List<ChatMessage> chatMessages,
  }) async {
    final markdownBody = _markdown(meeting, summary, transcript, chatMessages);
    final baseName = _safeFileName(meeting.title);

    return switch (format) {
      ExportFormat.markdown => ExportArtifact(
        fileName: '$baseName.md',
        format: format,
        bytes: Uint8List.fromList(utf8.encode(markdownBody)),
        mimeType: 'text/markdown',
      ),
      ExportFormat.text => ExportArtifact(
        fileName: '$baseName.txt',
        format: format,
        bytes: Uint8List.fromList(utf8.encode(_plainText(markdownBody))),
        mimeType: 'text/plain',
      ),
      ExportFormat.pdf => ExportArtifact(
        fileName: '$baseName.pdf',
        format: format,
        bytes: Uint8List.fromList(
          await _pdfBytes(meeting, summary, transcript, chatMessages),
        ),
        mimeType: 'application/pdf',
      ),
    };
  }

  String _markdown(
    Meeting meeting,
    MeetingSummary? summary,
    List<TranscriptSegment> transcript,
    List<ChatMessage> chatMessages,
  ) {
    final buffer = StringBuffer()
      ..writeln('# ${meeting.title}')
      ..writeln()
      ..writeln('| Field | Value |')
      ..writeln('| --- | --- |')
      ..writeln('| Created | ${meeting.createdAt.toIso8601String()} |')
      ..writeln('| Duration | ${_duration(meeting.durationMs)} |')
      ..writeln('| Status | ${meeting.status.name} |')
      ..writeln();

    if (summary != null) {
      buffer
        ..writeln('## Summary')
        ..writeln();
      _writeMarkdownBullets(buffer, summary.overview);
      buffer.writeln();

      if (summary.tags.isNotEmpty) {
        buffer
          ..writeln(
            '**Tags:** ${summary.tags.map((tag) => '`$tag`').join(' ')}',
          )
          ..writeln();
      }

      if (summary.chapters.isNotEmpty) {
        buffer
          ..writeln('## Topics')
          ..writeln();
        for (final chapter in summary.chapters) {
          buffer
            ..writeln('### ${chapter.title}')
            ..writeln();
          _writeMarkdownBullets(buffer, chapter.summary);
          if (chapter.evidenceSegmentIds.isNotEmpty) {
            buffer.writeln(
              '\n_Evidence: ${chapter.evidenceSegmentIds.join(', ')}_',
            );
          }
          buffer.writeln();
        }
      }

      if (summary.actionItems.isNotEmpty) {
        buffer
          ..writeln('## Action Items')
          ..writeln()
          ..writeln('| Task | Owner | Due | Status | Evidence |')
          ..writeln('| --- | --- | --- | --- | --- |');
        for (final item in summary.actionItems) {
          buffer.writeln(
            '| ${_escapeTable(item.text)} | ${_escapeTable(item.owner ?? 'Unassigned')} | ${_escapeTable(item.dueDate ?? '-')} | ${item.done ? 'Done' : 'Open'} | ${_escapeTable(item.evidenceSegmentIds.join(', '))} |',
          );
        }
        buffer.writeln();
      }

      if (summary.decisions.isNotEmpty) {
        buffer
          ..writeln('## Decisions')
          ..writeln()
          ..writeln('| Decision | Rationale | Evidence |')
          ..writeln('| --- | --- | --- |');
        for (final decision in summary.decisions) {
          buffer.writeln(
            '| ${_escapeTable(decision.text)} | ${_escapeTable(decision.rationale ?? '-')} | ${_escapeTable(decision.evidenceSegmentIds.join(', '))} |',
          );
        }
        buffer.writeln();
      }

      if (summary.openQuestions.isNotEmpty) {
        buffer
          ..writeln('## Open Questions')
          ..writeln()
          ..writeln('| Question | Owner | Evidence |')
          ..writeln('| --- | --- | --- |');
        for (final question in summary.openQuestions) {
          buffer.writeln(
            '| ${_escapeTable(question.text)} | ${_escapeTable(question.owner ?? 'Unassigned')} | ${_escapeTable(question.evidenceSegmentIds.join(', '))} |',
          );
        }
        buffer.writeln();
      }

      if (summary.followUpSuggestions.isNotEmpty) {
        buffer
          ..writeln('## Follow-ups')
          ..writeln();
        for (final suggestion in summary.followUpSuggestions) {
          buffer.writeln('- $suggestion');
        }
        buffer.writeln();
      }
    }

    if (transcript.isNotEmpty) {
      buffer
        ..writeln('## Transcript')
        ..writeln()
        ..writeln('| Time | Source | Text |')
        ..writeln('| --- | --- | --- |');
      for (final segment in transcript) {
        buffer.writeln(
          '| ${_time(segment.startMs)} | ${segment.source.name} | ${_escapeTable(segment.text)} |',
        );
      }
      buffer.writeln();
    }

    if (chatMessages.isNotEmpty) {
      buffer
        ..writeln('## Meeting Chat')
        ..writeln();
      for (final message in chatMessages) {
        buffer
          ..writeln('### ${message.role.name}')
          ..writeln()
          ..writeln(message.content)
          ..writeln();
      }
    }

    return buffer.toString();
  }

  String _plainText(String markdownBody) {
    return markdownBody
        .replaceAll(RegExp(r'[`*_#|]'), '')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }

  void _writeMarkdownBullets(StringBuffer buffer, String value) {
    for (final bullet in _bulletLines(value)) {
      buffer.writeln('- $bullet');
    }
  }

  Future<List<int>> _pdfBytes(
    Meeting meeting,
    MeetingSummary? summary,
    List<TranscriptSegment> transcript,
    List<ChatMessage> chatMessages,
  ) async {
    final regularFont = await PdfGoogleFonts.notoSansRegular();
    final boldFont = await PdfGoogleFonts.notoSansBold();
    final italicFont = await PdfGoogleFonts.notoSansItalic();
    final document = pw.Document();
    document.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(
          base: regularFont,
          bold: boldFont,
          italic: italicFont,
        ),
        header: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          padding: const pw.EdgeInsets.only(bottom: 12),
          child: pw.Text(
            'MeetlyAI',
            style: pw.TextStyle(
              color: _accent,
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            '${context.pageNumber} / ${context.pagesCount}',
            style: const pw.TextStyle(color: _muted, fontSize: 9),
          ),
        ),
        build: (context) => [
          _pdfHero(meeting),
          if (summary != null) ...[
            _pdfSectionTitle('Summary'),
            _pdfCard([_pdfBulletList(_bulletLines(summary.overview))]),
            if (summary.tags.isNotEmpty) _pdfTags(summary.tags),
            if (summary.chapters.isNotEmpty) ..._pdfTopics(summary.chapters),
            if (summary.actionItems.isNotEmpty)
              _pdfTable(
                'Action Items',
                ['Task', 'Owner', 'Due', 'Status'],
                summary.actionItems
                    .map(
                      (item) => [
                        item.text,
                        item.owner ?? 'Unassigned',
                        item.dueDate ?? '-',
                        item.done ? 'Done' : 'Open',
                      ],
                    )
                    .toList(growable: false),
              ),
            if (summary.decisions.isNotEmpty)
              _pdfTable(
                'Decisions',
                ['Decision', 'Rationale'],
                summary.decisions
                    .map(
                      (decision) => [decision.text, decision.rationale ?? '-'],
                    )
                    .toList(growable: false),
              ),
            if (summary.openQuestions.isNotEmpty)
              _pdfTable(
                'Open Questions',
                ['Question', 'Owner'],
                summary.openQuestions
                    .map(
                      (question) => [
                        question.text,
                        question.owner ?? 'Unassigned',
                      ],
                    )
                    .toList(growable: false),
              ),
          ],
          if (transcript.isNotEmpty) ..._pdfTranscript(transcript),
          if (chatMessages.isNotEmpty) ..._pdfChat(chatMessages),
        ],
      ),
    );
    return document.save();
  }

  pw.Widget _pdfHero(Meeting meeting) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(18),
      decoration: pw.BoxDecoration(
        color: _ink,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            meeting.title,
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            '${meeting.createdAt.toIso8601String()}  |  ${_duration(meeting.durationMs)}  |  ${meeting.status.name}',
            style: const pw.TextStyle(
              color: PdfColor.fromInt(0xFFCBD5E1),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfSectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 20, bottom: 8),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          color: _ink,
          fontSize: 16,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _pdfCard(List<pw.Widget> children) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: _soft,
        border: pw.Border.all(color: _line),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  pw.Widget _pdfTags(List<String> tags) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 10),
      child: pw.Wrap(
        spacing: 6,
        runSpacing: 6,
        children: tags
            .map(
              (tag) => pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: pw.BoxDecoration(
                  color: const PdfColor.fromInt(0xFFE6FFFA),
                  borderRadius: pw.BorderRadius.circular(12),
                ),
                child: pw.Text(
                  tag,
                  style: const pw.TextStyle(color: _accent, fontSize: 9),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  List<pw.Widget> _pdfTopics(List<SummaryChapter> chapters) {
    return [
      pw.Padding(
        padding: const pw.EdgeInsets.only(top: 16, bottom: 8),
        child: pw.Text(
          'Topics',
          style: pw.TextStyle(
            color: _ink,
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
      for (final chapter in chapters) ...[
        _pdfSmallHeading(chapter.title),
        _pdfBulletList(_bulletLines(chapter.summary)),
        if (chapter.evidenceSegmentIds.isNotEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 3, bottom: 8),
            child: pw.Text(
              'Evidence: ${chapter.evidenceSegmentIds.take(4).join(', ')}',
              style: const pw.TextStyle(color: _muted, fontSize: 8),
            ),
          )
        else
          pw.SizedBox(height: 8),
      ],
    ];
  }

  pw.Widget _pdfSmallHeading(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 8, bottom: 5),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          color: _ink,
          fontSize: 11,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _pdfBulletList(List<String> bullets) {
    if (bullets.isEmpty) {
      return pw.Text('-', style: _bodyStyle());
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        for (final bullet in bullets)
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 5),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 4,
                  height: 4,
                  margin: const pw.EdgeInsets.only(top: 4),
                  decoration: const pw.BoxDecoration(
                    color: _accent,
                    shape: pw.BoxShape.circle,
                  ),
                ),
                pw.SizedBox(width: 7),
                pw.Expanded(
                  child: pw.Text(bullet, style: _bodyStyle(fontSize: 9.5)),
                ),
              ],
            ),
          ),
      ],
    );
  }

  pw.Widget _pdfTable(
    String title,
    List<String> headers,
    List<List<String>> rows, {
    double fontSize = 9,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 14),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              color: _ink,
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.TableHelper.fromTextArray(
            headers: headers,
            data: rows,
            border: pw.TableBorder.all(color: _line, width: 0.5),
            headerDecoration: const pw.BoxDecoration(color: _ink),
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontSize: fontSize,
              fontWeight: pw.FontWeight.bold,
            ),
            cellStyle: pw.TextStyle(color: _ink, fontSize: fontSize),
            cellDecoration: (index, data, rowNum) => pw.BoxDecoration(
              color: rowNum.isEven ? PdfColors.white : _soft,
            ),
            cellPadding: const pw.EdgeInsets.all(7),
          ),
        ],
      ),
    );
  }

  List<pw.Widget> _pdfTranscript(List<TranscriptSegment> transcript) {
    return [
      _pdfSectionTitle('Transcript'),
      for (final segment in transcript)
        for (final chunk in _textChunks(segment.text, maxChars: 850))
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 6),
            child: pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: '${_time(segment.startMs)}  ${segment.source.name}  ',
                    style: pw.TextStyle(
                      color: _muted,
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.TextSpan(text: chunk, style: _bodyStyle(fontSize: 8.5)),
                ],
              ),
            ),
          ),
    ];
  }

  List<pw.Widget> _pdfChat(List<ChatMessage> messages) {
    return [
      _pdfSectionTitle('Meeting Chat'),
      for (final message in messages) ...[
        _pdfSmallHeading(message.role.name.toUpperCase()),
        for (final chunk in _textChunks(message.content, maxChars: 950))
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 6),
            child: pw.Text(chunk, style: _bodyStyle(fontSize: 9)),
          ),
      ],
    ];
  }

  pw.TextStyle _bodyStyle({double fontSize = 10}) {
    return pw.TextStyle(color: _ink, fontSize: fontSize, lineSpacing: 2);
  }

  String _escapeTable(String value) {
    return value.replaceAll('|', r'\|').replaceAll('\n', '<br>');
  }

  List<String> _bulletLines(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return const [];
    }

    final lines = normalized
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .map((line) => line.replaceFirst(RegExp(r'^[-*•]\s*'), '').trim())
        .where((line) => line.isNotEmpty)
        .toList(growable: false);
    if (lines.length > 1) {
      return lines;
    }

    final sentenceLines = normalized
        .replaceFirst(RegExp(r'^[-*•]\s*'), '')
        .split(RegExp(r'(?<=[.!?])\s+'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList(growable: false);
    return sentenceLines.isEmpty ? [normalized] : sentenceLines;
  }

  List<String> _textChunks(String value, {required int maxChars}) {
    final normalized = value.trim();
    if (normalized.length <= maxChars) {
      return normalized.isEmpty ? const [] : [normalized];
    }

    final chunks = <String>[];
    var remaining = normalized;
    while (remaining.length > maxChars) {
      var splitAt = remaining.lastIndexOf(RegExp(r'\s'), maxChars);
      if (splitAt < maxChars ~/ 2) {
        splitAt = maxChars;
      }
      chunks.add(remaining.substring(0, splitAt).trim());
      remaining = remaining.substring(splitAt).trim();
    }
    if (remaining.isNotEmpty) {
      chunks.add(remaining);
    }
    return chunks;
  }

  String _duration(int ms) {
    final duration = Duration(milliseconds: ms);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  String _time(int ms) {
    final duration = Duration(milliseconds: ms);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _safeFileName(String title) {
    final sanitized = title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return sanitized.isEmpty ? 'meeting' : sanitized;
  }
}
