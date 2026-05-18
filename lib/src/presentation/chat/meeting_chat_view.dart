import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../application/providers.dart';
import '../../domain/models/meeting_models.dart';
import '../../utils/formatters.dart';

class MeetingChatView extends ConsumerStatefulWidget {
  const MeetingChatView({super.key, required this.meetingId});

  final String meetingId;

  @override
  ConsumerState<MeetingChatView> createState() => _MeetingChatViewState();
}

class _MeetingChatViewState extends ConsumerState<MeetingChatView> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _showTranscript = false;
  bool _showChat = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meetingAsync = ref.watch(selectedMeetingProvider);
    final summaryAsync = ref.watch(meetingSummaryProvider(widget.meetingId));
    final transcriptAsync = ref.watch(transcriptProvider(widget.meetingId));
    final chatAsync = ref.watch(chatMessagesProvider(widget.meetingId));

    final meeting = meetingAsync.value;
    final summary = summaryAsync.value;
    final transcript = transcriptAsync.value ?? const [];
    final messages = chatAsync.value ?? const [];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(26, 22, 26, 14),
          child: _Header(
            meeting: meeting,
            summary: summary,
            transcript: transcript,
            messages: messages,
          ),
        ),
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(26, 0, 26, 24),
            children: [
              if (summary != null)
                _SummaryBlock(summary: summary)
              else if (meeting?.status == MeetingStatus.summarizing)
                const _SummaryLoadingBlock(),
              _TranscriptToggle(
                status: meeting?.status,
                segmentCount: transcript.length,
                showTranscript: _showTranscript,
                onToggle: transcript.isEmpty
                    ? null
                    : () => setState(() => _showTranscript = !_showTranscript),
              ),
              if (_showTranscript && transcript.isNotEmpty)
                _TranscriptBlock(segments: transcript),
              _ChatToggle(
                messageCount: messages.length,
                showChat: _showChat,
                onToggle: () => setState(() => _showChat = !_showChat),
              ),
              if (_showChat)
                _ChatBlock(
                  messages: messages,
                  controller: _controller,
                  onSend: () => _sendQuestion(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _sendQuestion() async {
    final text = _controller.text;
    _controller.clear();
    if (!_showChat) {
      setState(() => _showChat = true);
    }
    await ref
        .read(recordingControllerProvider.notifier)
        .sendQuestion(widget.meetingId, text);
    if (_scrollController.hasClients) {
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.meeting,
    required this.summary,
    required this.transcript,
    required this.messages,
  });

  final Meeting? meeting;
  final MeetingSummary? summary;
  final List<TranscriptSegment> transcript;
  final List<ChatMessage> messages;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meeting?.title ?? 'Meeting',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                meeting == null
                    ? 'Local transcript and AI analysis'
                    : '${compactDate(meeting!.createdAt)} · ${durationLabel(Duration(milliseconds: meeting!.durationMs))}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFF9AA4B2)),
              ),
            ],
          ),
        ),
        Consumer(
          builder: (context, ref, _) => PopupMenuButton<ExportFormat>(
            tooltip: 'Export',
            enabled: meeting != null,
            icon: const Icon(Icons.ios_share),
            onSelected: (format) => _exportMeeting(context, ref, format),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: ExportFormat.markdown,
                child: Row(
                  children: [
                    Icon(Icons.description_outlined, size: 18),
                    SizedBox(width: 10),
                    Text('Markdown'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: ExportFormat.text,
                child: Row(
                  children: [
                    Icon(Icons.notes, size: 18),
                    SizedBox(width: 10),
                    Text('Text'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: ExportFormat.pdf,
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf_outlined, size: 18),
                    SizedBox(width: 10),
                    Text('PDF'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _exportMeeting(
    BuildContext context,
    WidgetRef ref,
    ExportFormat format,
  ) async {
    final currentMeeting = meeting;
    if (currentMeeting == null) {
      return;
    }

    try {
      final artifact = await ref
          .read(exportServiceProvider)
          .exportMeeting(
            format: format,
            meeting: currentMeeting,
            summary: summary,
            transcript: transcript,
            chatMessages: messages,
          );

      // Try to open file picker to let user choose save location
      String? selectedPath;
      try {
        selectedPath = await FilePicker.getDirectoryPath();
      } on MissingPluginException catch (_) {
        // File picker plugin not available - fall back to default location
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'File picker not available on this platform. Saving to Documents/MeetlyAI/exports/',
            ),
          ),
        );
      }

      // If user selected a location, use it; otherwise use default location
      final finalDirectory = selectedPath ??
          p.join(
            (await getApplicationDocumentsDirectory()).path,
            'MeetlyAI',
            'exports',
          );

      final dir = Directory(finalDirectory);
      await dir.create(recursive: true);
      final file = File(p.join(finalDirectory, artifact.fileName));
      await file.writeAsBytes(artifact.bytes, flush: true);

      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Exported to ${file.path}')));
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Export failed: $error')));
    }
  }
}

class _SummaryLoadingBlock extends StatelessWidget {
  const _SummaryLoadingBlock();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Summary',
      child: Row(
        children: [
          SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Creating structured summary...',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFFB8C0CC)),
          ),
        ],
      ),
    );
  }
}

class _SummaryBlock extends StatelessWidget {
  const _SummaryBlock({required this.summary});

  final MeetingSummary summary;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Summary',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BulletCard(
            title: 'Key points',
            icon: Icons.auto_awesome,
            text: summary.overview,
          ),
          if (summary.chapters.isNotEmpty) ...[
            const SizedBox(height: 20),
            _TopicCards(chapters: summary.chapters),
          ],
          if (summary.tags.isNotEmpty) ...[
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: summary.tags
                  .map(
                    (tag) => Chip(
                      label: Text(tag),
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
          if (summary.actionItems.isNotEmpty) ...[
            const SizedBox(height: 20),
            _ActionItemsTable(items: summary.actionItems),
          ],
          if (summary.decisions.isNotEmpty) ...[
            const SizedBox(height: 20),
            _DecisionsTable(decisions: summary.decisions),
          ],
          if (summary.openQuestions.isNotEmpty) ...[
            const SizedBox(height: 20),
            _OpenQuestionsTable(questions: summary.openQuestions),
          ],
          if (summary.followUpSuggestions.isNotEmpty) ...[
            const SizedBox(height: 20),
            _FollowUpTable(suggestions: summary.followUpSuggestions),
          ],
        ],
      ),
    );
  }
}

class _TopicCards extends StatelessWidget {
  const _TopicCards({required this.chapters});

  final List<SummaryChapter> chapters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Topics',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final useGrid = constraints.maxWidth >= 860;
            if (!useGrid) {
              return Column(
                children: [
                  for (final chapter in chapters)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _TopicCard(chapter: chapter),
                    ),
                ],
              );
            }

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final chapter in chapters)
                  SizedBox(
                    width: (constraints.maxWidth - 12) / 2,
                    child: _TopicCard(chapter: chapter),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({required this.chapter});

  final SummaryChapter chapter;

  @override
  Widget build(BuildContext context) {
    return _BulletCard(
      title: chapter.title,
      icon: Icons.topic_outlined,
      text: chapter.summary,
      footer: chapter.evidenceSegmentIds.isEmpty
          ? null
          : 'Evidence: ${chapter.evidenceSegmentIds.take(4).join(', ')}',
    );
  }
}

class _BulletCard extends StatelessWidget {
  const _BulletCard({
    required this.title,
    required this.icon,
    required this.text,
    this.footer,
  });

  final String title;
  final IconData icon;
  final String text;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    final bullets = _bulletLines(text);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111419),
        border: Border.all(color: const Color(0xFF2B333D)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final bullet in bullets)
            Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.only(top: 7),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      bullet,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFE7EAEE),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (footer != null) ...[
            const SizedBox(height: 4),
            Text(
              footer!,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: const Color(0xFF9AA4B2)),
            ),
          ],
        ],
      ),
    );
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
    return normalized
        .replaceFirst(RegExp(r'^[-*•]\s*'), '')
        .split(RegExp(r'(?<=[.!?])\s+'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList(growable: false);
  }
}

class _TranscriptToggle extends StatelessWidget {
  const _TranscriptToggle({
    required this.status,
    required this.segmentCount,
    required this.showTranscript,
    required this.onToggle,
  });

  final MeetingStatus? status;
  final int segmentCount;
  final bool showTranscript;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final hasTranscript = segmentCount > 0;
    final message = hasTranscript
        ? '$segmentCount transcript segments available'
        : switch (status) {
            MeetingStatus.recording || MeetingStatus.paused =>
              'Transcript chunks will appear after local transcription.',
            MeetingStatus.transcribing => 'Local transcription is running.',
            MeetingStatus.failed =>
              'Transcription failed. Check recording diagnostics.',
            MeetingStatus.ready => 'No transcript was produced.',
            _ => 'Start recording to capture mic audio locally.',
          };

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF111419),
          border: Border.all(color: const Color(0xFF252B33)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              hasTranscript ? Icons.article_outlined : Icons.info_outline,
              size: 18,
              color: const Color(0xFF9AA4B2),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFFB8C0CC)),
              ),
            ),
            OutlinedButton.icon(
              onPressed: onToggle,
              icon: Icon(
                showTranscript
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 18,
              ),
              label: Text(
                showTranscript ? 'Hide transcript' : 'Show transcript',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatToggle extends StatelessWidget {
  const _ChatToggle({
    required this.messageCount,
    required this.showChat,
    required this.onToggle,
  });

  final int messageCount;
  final bool showChat;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF111419),
          border: Border.all(color: const Color(0xFF252B33)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.forum_outlined,
              size: 18,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                messageCount == 0
                    ? 'Ask questions about this meeting'
                    : '$messageCount chat messages',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFFB8C0CC)),
              ),
            ),
            FilledButton.tonalIcon(
              onPressed: onToggle,
              icon: Icon(
                showChat ? Icons.close_fullscreen : Icons.chat_bubble_outline,
                size: 18,
              ),
              label: Text(showChat ? 'Close chat' : 'Open chat'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionItemsTable extends StatelessWidget {
  const _ActionItemsTable({required this.items});

  final List<ActionItem> items;

  @override
  Widget build(BuildContext context) {
    return _SummaryTable(
      title: 'Action items',
      icon: Icons.check_circle_outline,
      columns: const ['Task', 'Owner', 'Due', 'Status'],
      rows: items
          .map(
            (item) => [
              item.text,
              item.owner ?? 'Unassigned',
              item.dueDate ?? '-',
              item.done ? 'Done' : 'Open',
            ],
          )
          .toList(growable: false),
    );
  }
}

class _DecisionsTable extends StatelessWidget {
  const _DecisionsTable({required this.decisions});

  final List<DecisionItem> decisions;

  @override
  Widget build(BuildContext context) {
    return _SummaryTable(
      title: 'Decisions',
      icon: Icons.gavel_outlined,
      columns: const ['Decision', 'Rationale'],
      rows: decisions
          .map((decision) => [decision.text, decision.rationale ?? '-'])
          .toList(growable: false),
    );
  }
}

class _OpenQuestionsTable extends StatelessWidget {
  const _OpenQuestionsTable({required this.questions});

  final List<OpenQuestion> questions;

  @override
  Widget build(BuildContext context) {
    return _SummaryTable(
      title: 'Open questions',
      icon: Icons.help_outline,
      columns: const ['Question', 'Owner'],
      rows: questions
          .map((question) => [question.text, question.owner ?? 'Unassigned'])
          .toList(growable: false),
    );
  }
}

class _FollowUpTable extends StatelessWidget {
  const _FollowUpTable({required this.suggestions});

  final List<String> suggestions;

  @override
  Widget build(BuildContext context) {
    return _SummaryTable(
      title: 'Follow-ups',
      icon: Icons.trending_up,
      columns: const ['Suggestion'],
      rows: suggestions
          .map((suggestion) => [suggestion])
          .toList(growable: false),
    );
  }
}

class _SummaryTable extends StatelessWidget {
  const _SummaryTable({
    required this.title,
    required this.icon,
    required this.columns,
    required this.rows,
  });

  final String title;
  final IconData icon;
  final List<String> columns;
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111419),
        border: Border.all(color: const Color(0xFF2B333D)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 38,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 76,
              columnSpacing: 24,
              horizontalMargin: 14,
              dividerThickness: 0.6,
              headingTextStyle: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(
                    color: const Color(0xFF9AA4B2),
                    fontWeight: FontWeight.w700,
                  ),
              dataTextStyle: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: const Color(0xFFE7EAEE)),
              columns: [
                for (final column in columns) DataColumn(label: Text(column)),
              ],
              rows: [
                for (final row in rows)
                  DataRow(
                    cells: [
                      for (final value in row)
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 90,
                              maxWidth: 360,
                            ),
                            child: Text(value),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TranscriptBlock extends StatelessWidget {
  const _TranscriptBlock({required this.segments});

  final List<TranscriptSegment> segments;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Live transcript',
      child: Column(
        children: [
          for (final segment in segments)
            Align(
              alignment: segment.source == AudioSourceKind.mic
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: segment.source == AudioSourceKind.mic
                        ? Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.14)
                        : const Color(0xFF1D2229),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF2B333D)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${segment.speakerLabel ?? segment.source.name} · ${transcriptTime(segment.startMs)}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF9AA4B2),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(segment.text),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChatBlock extends StatelessWidget {
  const _ChatBlock({
    required this.messages,
    required this.controller,
    required this.onSend,
  });

  final List<ChatMessage> messages;
  final TextEditingController controller;
  final Future<void> Function() onSend;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Meeting chat',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (messages.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(
                'Ask about tasks, decisions, owners, budget, or risks.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFB8C0CC),
                ),
              ),
            )
          else
            for (final message in messages)
              Align(
                alignment: message.role == ChatRole.user
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 720),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: message.role == ChatRole.user
                        ? Theme.of(
                            context,
                          ).colorScheme.secondary.withValues(alpha: 0.13)
                        : const Color(0xFF111419),
                    border: Border.all(color: const Color(0xFF2B333D)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    message.isStreaming && message.content.isEmpty
                        ? 'Thinking...'
                        : message.content,
                  ),
                ),
              ),
          const SizedBox(height: 12),
          _ChatComposer(controller: controller, onSend: onSend),
        ],
      ),
    );
  }
}

class _ChatComposer extends StatelessWidget {
  const _ChatComposer({required this.controller, required this.onSend});

  final TextEditingController controller;
  final Future<void> Function() onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0F12),
        border: Border.all(color: const Color(0xFF252B33)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              onSubmitted: (_) => onSend(),
              decoration: const InputDecoration(
                hintText: 'Ask about decisions, budget, owners, or risks...',
                prefixIcon: Icon(Icons.auto_awesome),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton.filled(
            tooltip: 'Send',
            onPressed: () => onSend(),
            icon: const Icon(Icons.arrow_upward),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF15191F),
              border: Border.all(color: const Color(0xFF262D36)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
