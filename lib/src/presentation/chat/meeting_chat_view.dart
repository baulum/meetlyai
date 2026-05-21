import 'dart:io';

import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../application/providers.dart';
import '../../domain/models/meeting_models.dart';
import '../../utils/formatters.dart';
import '../widgets/chat_markdown.dart';

enum _MeetingTab { transcript, summary, chat }

class MeetingChatView extends ConsumerStatefulWidget {
  const MeetingChatView({super.key, required this.meetingId});

  final String meetingId;

  @override
  ConsumerState<MeetingChatView> createState() => _MeetingChatViewState();
}

class _MeetingChatViewState extends ConsumerState<MeetingChatView> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _chatScrollController = ScrollController();
  _MeetingTab _selectedTab = _MeetingTab.transcript;
  int _lastTranscriptSegmentCount = 0;
  int _lastChatMessageCount = 0;
  bool _transcriptStickToBottom = true;
  bool _showTranscriptJumpToBottom = false;
  bool _showChatJumpToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleTranscriptScroll);
    _chatScrollController.addListener(_handleChatScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleTranscriptScroll);
    _chatScrollController.removeListener(_handleChatScroll);
    _controller.dispose();
    _scrollController.dispose();
    _chatScrollController.dispose();
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
    _scheduleTranscriptAutoScroll(transcript.length);
    _scheduleChatAutoScroll(messages.length);

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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 0, 26, 24),
            child: Stack(
              children: [
                Positioned.fill(
                  top: 62,
                  child: switch (_selectedTab) {
                    _MeetingTab.transcript => Stack(
                      key: const ValueKey('transcript-tab'),
                      fit: StackFit.expand,
                      children: [
                        ListView(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(bottom: 64),
                          children: [
                            _TranscriptBlock(
                              meetingId: widget.meetingId,
                              status: meeting?.status,
                              segments: transcript,
                            ),
                          ],
                        ),
                        if (_showTranscriptJumpToBottom)
                          Positioned(
                            right: 18,
                            bottom: 18,
                            child: _JumpToBottomButton(
                              onPressed: () => _scrollTranscriptToBottom(),
                            ),
                          ),
                      ],
                    ),
                    _MeetingTab.summary => ListView(
                      key: const ValueKey('summary-tab'),
                      children: [
                        if (meeting?.status == MeetingStatus.summarizing &&
                            summary == null)
                          const _SummaryLoadingSection()
                        else if (summary == null)
                          const _EmptyTabSection(
                            title: 'AI Summary',
                            icon: Icons.auto_awesome,
                            message:
                                'The AI summary appears here after the meeting has been transcribed and analyzed.',
                          )
                        else
                          _SummaryBlock(
                            summary: summary,
                            transcript: transcript,
                            onSummaryChanged: (updated) => ref
                                .read(meetingRepositoryProvider)
                                .saveSummary(updated),
                            onRegenerate: () => ref
                                .read(recordingControllerProvider.notifier)
                                .regenerateSummary(widget.meetingId),
                          ),
                      ],
                    ),
                    _MeetingTab.chat => Stack(
                      key: const ValueKey('chat-tab'),
                      fit: StackFit.expand,
                      children: [
                        Positioned.fill(
                          child: _ChatBlock(
                            messages: messages,
                            transcript: transcript,
                            controller: _controller,
                            scrollController: _chatScrollController,
                            showJumpToBottom: _showChatJumpToBottom,
                            onJumpToBottom: () => _scrollChatToBottom(),
                            onSend: () => _sendQuestion(),
                          ),
                        ),
                      ],
                    ),
                  },
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _FloatingMeetingTabs(
                    selected: _selectedTab,
                    transcriptCount: transcript.length,
                    hasSummary: summary != null,
                    chatCount: messages.length,
                    onSelected: (tab) {
                      setState(() => _selectedTab = tab);
                      if (tab == _MeetingTab.transcript &&
                          _transcriptStickToBottom) {
                        _scrollTranscriptToBottom();
                      }
                      if (tab == _MeetingTab.chat) {
                        _scrollChatToBottom();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _scheduleTranscriptAutoScroll(int segmentCount) {
    if (_selectedTab != _MeetingTab.transcript) {
      _lastTranscriptSegmentCount = segmentCount;
      return;
    }
    final changed = segmentCount != _lastTranscriptSegmentCount;
    _lastTranscriptSegmentCount = segmentCount;
    if (changed && _transcriptStickToBottom) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollTranscriptToBottom(),
      );
    }
  }

  Future<void> _scrollTranscriptToBottom({int attempt = 0}) async {
    if (!_scrollController.hasClients || !mounted) {
      return;
    }
    final position = _scrollController.position;
    final target = _safeMaxScrollExtent(position);
    if (target == null) {
      if (attempt >= 8) {
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollTranscriptToBottom(attempt: attempt + 1),
      );
      return;
    }
    _transcriptStickToBottom = true;
    if (_showTranscriptJumpToBottom && mounted) {
      setState(() => _showTranscriptJumpToBottom = false);
    }
    await _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  Future<void> _sendQuestion() async {
    final text = _controller.text;
    _controller.clear();
    await ref
        .read(recordingControllerProvider.notifier)
        .sendQuestion(widget.meetingId, text);
    _scrollChatToBottom();
  }

  void _scheduleChatAutoScroll(int messageCount) {
    if (_selectedTab != _MeetingTab.chat) {
      _lastChatMessageCount = messageCount;
      return;
    }
    final changed = messageCount != _lastChatMessageCount;
    _lastChatMessageCount = messageCount;
    if (changed || !_chatScrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollChatToBottom(),
      );
    }
  }

  Future<void> _scrollChatToBottom({int attempt = 0}) async {
    if (!_chatScrollController.hasClients || !mounted) {
      return;
    }
    final position = _chatScrollController.position;
    final target = _safeMaxScrollExtent(position);
    if (target == null) {
      if (attempt >= 8) {
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollChatToBottom(attempt: attempt + 1),
      );
      return;
    }
    await _chatScrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  void _handleTranscriptScroll() {
    if (!_scrollController.hasClients ||
        _safeMaxScrollExtent(_scrollController.position) == null) {
      return;
    }
    final position = _scrollController.position;
    final distanceFromBottom =
        _safeMaxScrollExtent(position)! - position.pixels;
    final isAwayFromBottom = distanceFromBottom > 120;
    _transcriptStickToBottom = !isAwayFromBottom;
    if (isAwayFromBottom != _showTranscriptJumpToBottom && mounted) {
      setState(() => _showTranscriptJumpToBottom = isAwayFromBottom);
    }
  }

  void _handleChatScroll() {
    if (!_chatScrollController.hasClients ||
        _safeMaxScrollExtent(_chatScrollController.position) == null) {
      return;
    }
    final position = _chatScrollController.position;
    final show = _safeMaxScrollExtent(position)! - position.pixels > 120;
    if (show != _showChatJumpToBottom && mounted) {
      setState(() => _showChatJumpToBottom = show);
    }
  }

  double? _safeMaxScrollExtent(ScrollPosition position) {
    if (!position.hasContentDimensions) {
      return null;
    }
    try {
      return position.maxScrollExtent;
    } on Object {
      return null;
    }
  }
}

class _FloatingMeetingTabs extends StatelessWidget {
  const _FloatingMeetingTabs({
    required this.selected,
    required this.transcriptCount,
    required this.hasSummary,
    required this.chatCount,
    required this.onSelected,
  });

  final _MeetingTab selected;
  final int transcriptCount;
  final bool hasSummary;
  final int chatCount;
  final ValueChanged<_MeetingTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xE60F1217),
            border: Border.all(color: const Color(0xFF252B33)),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.24),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SegmentedButton<_MeetingTab>(
            showSelectedIcon: false,
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              side: const WidgetStatePropertyAll(BorderSide.none),
            ),
            segments: [
              ButtonSegment(
                value: _MeetingTab.transcript,
                icon: const Icon(Icons.subject, size: 18),
                label: Text(
                  transcriptCount > 0
                      ? 'Transcript $transcriptCount'
                      : 'Transcript',
                ),
              ),
              ButtonSegment(
                value: _MeetingTab.summary,
                icon: Icon(
                  hasSummary ? Icons.auto_awesome : Icons.auto_awesome_outlined,
                  size: 18,
                ),
                label: const Text('AI Summary'),
              ),
              ButtonSegment(
                value: _MeetingTab.chat,
                icon: const Icon(Icons.forum_outlined, size: 18),
                label: Text(chatCount > 0 ? 'Chat $chatCount' : 'Chat'),
              ),
            ],
            selected: {selected},
            onSelectionChanged: (selection) => onSelected(selection.first),
          ),
        ),
      ),
    );
  }
}

class _EmptyTabSection extends StatelessWidget {
  const _EmptyTabSection({
    required this.title,
    required this.icon,
    required this.message,
  });

  final String title;
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: title,
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: const Color(0xFFB8C0CC)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryLoadingSection extends StatelessWidget {
  const _SummaryLoadingSection();

  @override
  Widget build(BuildContext context) {
    return const _Section(title: 'AI Summary', child: _SummaryLoadingInline());
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
      final finalDirectory =
          selectedPath ??
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

class _SummaryLoadingInline extends StatelessWidget {
  const _SummaryLoadingInline();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox.square(
          dimension: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Creating summary...',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: const Color(0xFFB8C0CC)),
        ),
      ],
    );
  }
}

class _SummaryBlock extends StatelessWidget {
  const _SummaryBlock({
    required this.summary,
    required this.transcript,
    required this.onSummaryChanged,
    required this.onRegenerate,
  });

  final MeetingSummary summary;
  final List<TranscriptSegment> transcript;
  final Future<void> Function(MeetingSummary summary) onSummaryChanged;
  final Future<void> Function() onRegenerate;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'AI Summary',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _editSummaryDetails(
                    context: context,
                    summary: summary,
                    onSaved: onSummaryChanged,
                  ),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit details'),
                ),
                FilledButton.tonalIcon(
                  onPressed: onRegenerate,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Regenerate'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _BulletCard(
            title: 'Key points',
            icon: Icons.auto_awesome,
            text: _replaceEvidenceIds(summary.overview, transcript),
            onEdit: () => _editLongText(
              context: context,
              title: 'Edit key points',
              initialValue: summary.overview,
              onSaved: (value) =>
                  onSummaryChanged(summary.copyWith(overview: value)),
            ),
          ),
          if (summary.chapters.isNotEmpty) ...[
            const SizedBox(height: 20),
            _TopicCards(
              chapters: summary.chapters,
              transcript: transcript,
              onChanged: (chapters) =>
                  onSummaryChanged(summary.copyWith(chapters: chapters)),
            ),
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
            _ActionItemsTable(
              items: summary.actionItems,
              transcript: transcript,
              onChanged: (items) =>
                  onSummaryChanged(summary.copyWith(actionItems: items)),
            ),
          ],
          if (summary.decisions.isNotEmpty) ...[
            const SizedBox(height: 20),
            _DecisionsTable(
              decisions: summary.decisions,
              transcript: transcript,
              onChanged: (decisions) =>
                  onSummaryChanged(summary.copyWith(decisions: decisions)),
            ),
          ],
          if (summary.openQuestions.isNotEmpty) ...[
            const SizedBox(height: 20),
            _OpenQuestionsTable(
              questions: summary.openQuestions,
              transcript: transcript,
              onChanged: (questions) =>
                  onSummaryChanged(summary.copyWith(openQuestions: questions)),
            ),
          ],
          if (summary.followUpSuggestions.isNotEmpty) ...[
            const SizedBox(height: 20),
            _FollowUpTable(
              suggestions: summary.followUpSuggestions,
              onChanged: (suggestions) => onSummaryChanged(
                summary.copyWith(followUpSuggestions: suggestions),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TopicCards extends StatelessWidget {
  const _TopicCards({
    required this.chapters,
    required this.transcript,
    required this.onChanged,
  });

  final List<SummaryChapter> chapters;
  final List<TranscriptSegment> transcript;
  final Future<void> Function(List<SummaryChapter> chapters) onChanged;

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
                      child: _TopicCard(
                        chapter: chapter,
                        transcript: transcript,
                        onChanged: (updated) =>
                            _replaceChapter(chapter, updated),
                      ),
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
                    child: _TopicCard(
                      chapter: chapter,
                      transcript: transcript,
                      onChanged: (updated) => _replaceChapter(chapter, updated),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Future<void> _replaceChapter(
    SummaryChapter oldChapter,
    SummaryChapter updated,
  ) {
    return onChanged([
      for (final chapter in chapters)
        if (chapter.id == oldChapter.id) updated else chapter,
    ]);
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({
    required this.chapter,
    required this.transcript,
    required this.onChanged,
  });

  final SummaryChapter chapter;
  final List<TranscriptSegment> transcript;
  final Future<void> Function(SummaryChapter chapter) onChanged;

  @override
  Widget build(BuildContext context) {
    final references = _referenceLabels(chapter.evidenceSegmentIds, transcript);
    return _BulletCard(
      title: chapter.title,
      icon: Icons.topic_outlined,
      text: _replaceEvidenceIds(chapter.summary, transcript),
      footer: references.isEmpty
          ? null
          : 'References: ${references.join(', ')}',
      onEdit: () => _editChapter(context, chapter, onChanged),
    );
  }
}

class _BulletCard extends StatelessWidget {
  const _BulletCard({
    required this.title,
    required this.icon,
    required this.text,
    this.footer,
    this.onEdit,
  });

  final String title;
  final IconData icon;
  final String text;
  final String? footer;
  final VoidCallback? onEdit;

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
              if (onEdit != null)
                IconButton(
                  tooltip: 'Edit',
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 18),
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

class _ActionItemsTable extends StatelessWidget {
  const _ActionItemsTable({
    required this.items,
    required this.transcript,
    required this.onChanged,
  });

  final List<ActionItem> items;
  final List<TranscriptSegment> transcript;
  final Future<void> Function(List<ActionItem> items) onChanged;

  @override
  Widget build(BuildContext context) {
    return _SummaryTable(
      title: 'Action items',
      icon: Icons.check_circle_outline,
      columns: const ['Task', 'Owner', 'Due', 'Status', 'Reference', 'Edit'],
      rows: items
          .mapIndexed(
            (index, item) => _SummaryTableRow(
              values: [
                _replaceEvidenceIds(item.text, transcript),
                item.owner ?? 'Unassigned',
                item.dueDate ?? '-',
                item.done ? 'Done' : 'Open',
                _referenceLabels(
                  item.evidenceSegmentIds,
                  transcript,
                ).firstOrDash,
              ],
              onEdit: () => _editActionItem(context, item, (updated) {
                final next = [...items]..[index] = updated;
                return onChanged(next);
              }),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _DecisionsTable extends StatelessWidget {
  const _DecisionsTable({
    required this.decisions,
    required this.transcript,
    required this.onChanged,
  });

  final List<DecisionItem> decisions;
  final List<TranscriptSegment> transcript;
  final Future<void> Function(List<DecisionItem> decisions) onChanged;

  @override
  Widget build(BuildContext context) {
    return _SummaryTable(
      title: 'Decisions',
      icon: Icons.gavel_outlined,
      columns: const ['Decision', 'Rationale', 'Reference', 'Edit'],
      rows: decisions
          .mapIndexed(
            (index, decision) => _SummaryTableRow(
              values: [
                _replaceEvidenceIds(decision.text, transcript),
                _replaceEvidenceIds(decision.rationale ?? '-', transcript),
                _referenceLabels(
                  decision.evidenceSegmentIds,
                  transcript,
                ).firstOrDash,
              ],
              onEdit: () => _editDecision(context, decision, (updated) {
                final next = [...decisions]..[index] = updated;
                return onChanged(next);
              }),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _OpenQuestionsTable extends StatelessWidget {
  const _OpenQuestionsTable({
    required this.questions,
    required this.transcript,
    required this.onChanged,
  });

  final List<OpenQuestion> questions;
  final List<TranscriptSegment> transcript;
  final Future<void> Function(List<OpenQuestion> questions) onChanged;

  @override
  Widget build(BuildContext context) {
    return _SummaryTable(
      title: 'Open questions',
      icon: Icons.help_outline,
      columns: const ['Question', 'Owner', 'Reference', 'Edit'],
      rows: questions
          .mapIndexed(
            (index, question) => _SummaryTableRow(
              values: [
                _replaceEvidenceIds(question.text, transcript),
                question.owner ?? 'Unassigned',
                _referenceLabels(
                  question.evidenceSegmentIds,
                  transcript,
                ).firstOrDash,
              ],
              onEdit: () => _editOpenQuestion(context, question, (updated) {
                final next = [...questions]..[index] = updated;
                return onChanged(next);
              }),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _FollowUpTable extends StatelessWidget {
  const _FollowUpTable({required this.suggestions, required this.onChanged});

  final List<String> suggestions;
  final Future<void> Function(List<String> suggestions) onChanged;

  @override
  Widget build(BuildContext context) {
    return _SummaryTable(
      title: 'Follow-ups',
      icon: Icons.trending_up,
      columns: const ['Suggestion', 'Edit'],
      rows: suggestions.indexed
          .map(
            (entry) => _SummaryTableRow(
              values: [entry.$2],
              onEdit: () => _editLongText(
                context: context,
                title: 'Edit follow-up',
                initialValue: entry.$2,
                onSaved: (value) {
                  final next = [...suggestions]..[entry.$1] = value;
                  return onChanged(next);
                },
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _SummaryTableRow {
  const _SummaryTableRow({required this.values, this.onEdit});

  final List<String> values;
  final VoidCallback? onEdit;
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
  final List<_SummaryTableRow> rows;

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
                      for (final value in row.values)
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 90,
                              maxWidth: 360,
                            ),
                            child: Text(value),
                          ),
                        ),
                      if (row.onEdit != null)
                        DataCell(
                          IconButton(
                            tooltip: 'Edit',
                            onPressed: row.onEdit,
                            icon: const Icon(Icons.edit_outlined, size: 18),
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

Future<void> _editLongText({
  required BuildContext context,
  required String title,
  required String initialValue,
  required Future<void> Function(String value) onSaved,
}) async {
  final controller = TextEditingController(text: initialValue);
  final value = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 520,
        child: TextField(
          controller: controller,
          autofocus: true,
          minLines: 4,
          maxLines: 10,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(controller.text.trim()),
          child: const Text('Save'),
        ),
      ],
    ),
  );
  controller.dispose();
  if (value != null) {
    await onSaved(value);
  }
}

Future<void> _editSummaryDetails({
  required BuildContext context,
  required MeetingSummary summary,
  required Future<void> Function(MeetingSummary summary) onSaved,
}) async {
  final titleController = TextEditingController(text: summary.generatedTitle);
  final tagsController = TextEditingController(text: summary.tags.join(', '));
  final updated = await showDialog<MeetingSummary>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit summary details'),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Generated title',
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags',
                hintText: 'budget, roadmap, hiring',
                prefixIcon: Icon(Icons.sell_outlined),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final title = titleController.text.trim();
            final tags = tagsController.text
                .split(',')
                .map((tag) => tag.trim())
                .where((tag) => tag.isNotEmpty)
                .toList(growable: false);
            Navigator.of(context).pop(
              summary.copyWith(
                generatedTitle: title.isEmpty ? summary.generatedTitle : title,
                tags: tags,
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
  titleController.dispose();
  tagsController.dispose();
  if (updated != null) {
    await onSaved(updated);
  }
}

Future<void> _editChapter(
  BuildContext context,
  SummaryChapter chapter,
  Future<void> Function(SummaryChapter chapter) onSaved,
) async {
  final titleController = TextEditingController(text: chapter.title);
  final summaryController = TextEditingController(text: chapter.summary);
  final updated = await showDialog<SummaryChapter>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit topic'),
      content: SizedBox(
        width: 560,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: summaryController,
              minLines: 4,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: 'Bullet points',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(
            chapter.copyWith(
              title: titleController.text.trim().isEmpty
                  ? chapter.title
                  : titleController.text.trim(),
              summary: summaryController.text.trim(),
            ),
          ),
          child: const Text('Save'),
        ),
      ],
    ),
  );
  titleController.dispose();
  summaryController.dispose();
  if (updated != null) {
    await onSaved(updated);
  }
}

Future<void> _editActionItem(
  BuildContext context,
  ActionItem item,
  Future<void> Function(ActionItem item) onSaved,
) async {
  final taskController = TextEditingController(text: item.text);
  final ownerController = TextEditingController(text: item.owner ?? '');
  final dueController = TextEditingController(text: item.dueDate ?? '');
  var done = item.done;
  final updated = await showDialog<ActionItem>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: const Text('Edit action item'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskController,
                autofocus: true,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Task'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ownerController,
                decoration: const InputDecoration(labelText: 'Owner'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: dueController,
                decoration: const InputDecoration(labelText: 'Due'),
              ),
              CheckboxListTile(
                value: done,
                onChanged: (value) =>
                    setDialogState(() => done = value ?? false),
                contentPadding: EdgeInsets.zero,
                title: const Text('Done'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(
              item.copyWith(
                text: taskController.text.trim(),
                owner: ownerController.text.trim().isEmpty
                    ? null
                    : ownerController.text.trim(),
                dueDate: dueController.text.trim().isEmpty
                    ? null
                    : dueController.text.trim(),
                done: done,
              ),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
  taskController.dispose();
  ownerController.dispose();
  dueController.dispose();
  if (updated != null && updated.text.trim().isNotEmpty) {
    await onSaved(updated);
  }
}

Future<void> _editDecision(
  BuildContext context,
  DecisionItem decision,
  Future<void> Function(DecisionItem decision) onSaved,
) async {
  final textController = TextEditingController(text: decision.text);
  final rationaleController = TextEditingController(
    text: decision.rationale ?? '',
  );
  final updated = await showDialog<DecisionItem>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit decision'),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              autofocus: true,
              minLines: 1,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Decision'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: rationaleController,
              minLines: 2,
              maxLines: 6,
              decoration: const InputDecoration(labelText: 'Rationale'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(
            decision.copyWith(
              text: textController.text.trim(),
              rationale: rationaleController.text.trim().isEmpty
                  ? null
                  : rationaleController.text.trim(),
            ),
          ),
          child: const Text('Save'),
        ),
      ],
    ),
  );
  textController.dispose();
  rationaleController.dispose();
  if (updated != null && updated.text.trim().isNotEmpty) {
    await onSaved(updated);
  }
}

Future<void> _editOpenQuestion(
  BuildContext context,
  OpenQuestion question,
  Future<void> Function(OpenQuestion question) onSaved,
) async {
  final textController = TextEditingController(text: question.text);
  final ownerController = TextEditingController(text: question.owner ?? '');
  final updated = await showDialog<OpenQuestion>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit open question'),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              autofocus: true,
              minLines: 1,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ownerController,
              decoration: const InputDecoration(labelText: 'Owner'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(
            question.copyWith(
              text: textController.text.trim(),
              owner: ownerController.text.trim().isEmpty
                  ? null
                  : ownerController.text.trim(),
            ),
          ),
          child: const Text('Save'),
        ),
      ],
    ),
  );
  textController.dispose();
  ownerController.dispose();
  if (updated != null && updated.text.trim().isNotEmpty) {
    await onSaved(updated);
  }
}

class _TranscriptBlock extends ConsumerWidget {
  const _TranscriptBlock({
    required this.meetingId,
    required this.status,
    required this.segments,
  });

  final String meetingId;
  final MeetingStatus? status;
  final List<TranscriptSegment> segments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _Section(
      title: 'Transcript',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SpeakerToolbar(
            meetingId: meetingId,
            segments: segments,
            onRename: (oldLabel, newLabel) => ref
                .read(recordingControllerProvider.notifier)
                .renameSpeaker(
                  meetingId: meetingId,
                  oldLabel: oldLabel,
                  newLabel: newLabel,
                ),
            onRegenerateSummary: () => ref
                .read(recordingControllerProvider.notifier)
                .regenerateSummary(meetingId),
          ),
          const SizedBox(height: 12),
          if (segments.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF111419),
                border: Border.all(color: const Color(0xFF252B33)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                switch (status) {
                  MeetingStatus.recording || MeetingStatus.paused =>
                    'Transcript chunks will appear while the meeting is recorded.',
                  MeetingStatus.transcribing =>
                    'Local transcription is running.',
                  _ => 'No transcript available yet.',
                },
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF9AA4B2),
                ),
              ),
            )
          else
            for (final segment in segments)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF111419),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF2B333D)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 76,
                      child: Text(
                        transcriptTime(segment.startMs),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF9AA4B2),
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _speakerName(segment),
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            segment.text,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: const Color(0xFFE7EAEE),
                                  height: 1.45,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

String _speakerName(TranscriptSegment segment) {
  final label = segment.speakerLabel?.trim();
  if (label != null && label.isNotEmpty) {
    return label;
  }
  return switch (segment.source) {
    AudioSourceKind.mic => 'Speaker 1',
    AudioSourceKind.system => 'Speaker 2',
    AudioSourceKind.mixed => 'Speaker 1',
  };
}

List<String> _referenceLabels(
  List<String> ids,
  List<TranscriptSegment> transcript,
) {
  if (ids.isEmpty || transcript.isEmpty) {
    return const [];
  }
  final byId = {for (final segment in transcript) segment.id: segment};
  final labels = <String>[];
  for (final id in ids) {
    final segment = byId[id];
    if (segment == null) {
      continue;
    }
    labels.add('${transcriptTime(segment.startMs)} · ${_speakerName(segment)}');
    if (labels.length == 4) {
      break;
    }
  }
  return labels;
}

String _replaceEvidenceIds(String value, List<TranscriptSegment> transcript) {
  if (value.isEmpty || transcript.isEmpty) {
    return value;
  }
  final byId = {for (final segment in transcript) segment.id: segment};
  return value.replaceAllMapped(RegExp(r'\[([^\]]+)\]'), (match) {
    final ids = match
        .group(1)!
        .split(RegExp(r'[\s,;]+'))
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty);
    final references = <String>[];
    for (final id in ids) {
      final segment = byId[id];
      if (segment != null) {
        references.add(
          '${transcriptTime(segment.startMs)} · ${_speakerName(segment)}',
        );
      }
    }
    if (references.isEmpty) {
      return match.group(0) ?? '';
    }
    return '[${references.join(', ')}]';
  });
}

extension on List<String> {
  String get firstOrDash => isEmpty ? '-' : first;
}

class _SpeakerToolbar extends StatelessWidget {
  const _SpeakerToolbar({
    required this.meetingId,
    required this.segments,
    required this.onRename,
    required this.onRegenerateSummary,
  });

  final String meetingId;
  final List<TranscriptSegment> segments;
  final Future<void> Function(String oldLabel, String newLabel) onRename;
  final Future<void> Function() onRegenerateSummary;

  @override
  Widget build(BuildContext context) {
    final labels =
        segments
            .map((segment) => segment.speakerLabel?.trim())
            .whereType<String>()
            .where((label) => label.isNotEmpty)
            .toSet()
            .toList()
          ..sort();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1217),
        border: Border.all(color: const Color(0xFF252B33)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 560;
          final chips = Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final label in labels)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: compact ? constraints.maxWidth : 180,
                  ),
                  child: ActionChip(
                    avatar: const Icon(Icons.person_outline, size: 16),
                    label: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: () => _renameSpeaker(context, label),
                  ),
                ),
              if (labels.isEmpty)
                Text(
                  'No speakers assigned yet.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF9AA4B2),
                  ),
                ),
            ],
          );
          final actions = Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: compact ? WrapAlignment.end : WrapAlignment.start,
            children: [
              FilledButton.tonalIcon(
                onPressed: segments.isEmpty ? null : onRegenerateSummary,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Regenerate summary'),
              ),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                chips,
                const SizedBox(height: 10),
                Align(alignment: Alignment.centerRight, child: actions),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: chips),
              const SizedBox(width: 10),
              actions,
            ],
          );
        },
      ),
    );
  }

  Future<void> _renameSpeaker(BuildContext context, String label) async {
    final controller = TextEditingController(text: label);
    final newLabel = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename speaker'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Speaker name',
            prefixIcon: Icon(Icons.person_outline),
          ),
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (newLabel == null) {
      return;
    }
    await onRename(label, newLabel);
  }
}

class _ChatBlock extends StatelessWidget {
  const _ChatBlock({
    required this.messages,
    required this.transcript,
    required this.controller,
    required this.scrollController,
    required this.showJumpToBottom,
    required this.onJumpToBottom,
    required this.onSend,
  });

  final List<ChatMessage> messages;
  final List<TranscriptSegment> transcript;
  final TextEditingController controller;
  final ScrollController scrollController;
  final bool showJumpToBottom;
  final VoidCallback onJumpToBottom;
  final Future<void> Function() onSend;

  @override
  Widget build(BuildContext context) {
    return _ChatSection(
      title: 'Meeting chat',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.only(bottom: 58),
                  children: [
                    if (messages.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Text(
                          'Ask about tasks, decisions, owners, budget, or risks.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: const Color(0xFFB8C0CC)),
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
                                  ? Theme.of(context).colorScheme.secondary
                                        .withValues(alpha: 0.13)
                                  : const Color(0xFF111419),
                              border: Border.all(
                                color: const Color(0xFF2B333D),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: message.role == ChatRole.assistant
                                ? ChatMarkdown(
                                    message.isStreaming &&
                                            message.content.isEmpty
                                        ? 'Thinking...'
                                        : _replaceEvidenceIds(
                                            message.content,
                                            transcript,
                                          ),
                                  )
                                : Text(
                                    message.content,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: const Color(0xFFE7EAEE),
                                          height: 1.42,
                                        ),
                                  ),
                          ),
                        ),
                  ],
                ),
                if (showJumpToBottom)
                  Positioned(
                    right: 14,
                    bottom: 14,
                    child: _JumpToBottomButton(onPressed: onJumpToBottom),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF15191F),
              border: Border(top: BorderSide(color: Color(0xFF262D36))),
            ),
            child: _ChatComposer(controller: controller, onSend: onSend),
          ),
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
            child: CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.enter): () => onSend(),
              },
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: const InputDecoration(
                  hintText: 'Ask about decisions, budget, owners, or risks...',
                  prefixIcon: Icon(Icons.auto_awesome),
                ),
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

class _JumpToBottomButton extends StatelessWidget {
  const _JumpToBottomButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: IconButton.filledTonal(
        tooltip: 'Nach unten',
        onPressed: onPressed,
        icon: const Icon(Icons.keyboard_arrow_down),
      ),
    );
  }
}

class _ChatSection extends StatelessWidget {
  const _ChatSection({required this.title, required this.child});

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
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF15191F),
                border: Border.all(color: const Color(0xFF262D36)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: child,
            ),
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
