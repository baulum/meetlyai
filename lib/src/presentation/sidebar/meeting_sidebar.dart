import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/models/meeting_models.dart';
import '../../utils/formatters.dart';
import '../widgets/status_badge.dart';

class MeetingSidebar extends ConsumerWidget {
  const MeetingSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meetings = ref.watch(meetingsProvider);
    final selectedId = ref.watch(selectedMeetingIdProvider);

    return Container(
      width: 306,
      decoration: const BoxDecoration(
        color: Color(0xFF101318),
        border: Border(right: BorderSide(color: Color(0xFF252B33))),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.graphic_eq,
                      color: Color(0xFF06110D),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'MeetlyAI',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Settings',
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    icon: const Icon(Icons.tune),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: FilledButton.icon(
                onPressed: () => ref
                    .read(recordingControllerProvider.notifier)
                    .startNewMeeting(),
                icon: const Icon(Icons.add),
                label: const Text('New session'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
              child: TextField(
                onChanged: (value) =>
                    ref.read(meetingSearchProvider.notifier).setQuery(value),
                decoration: const InputDecoration(
                  hintText: 'Search meetings',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: meetings.when(
                data: (items) {
                  if (items.isEmpty) {
                    return const _EmptyMeetings();
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(10, 2, 10, 16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final meeting = items[index];
                      return _MeetingTile(
                        meeting: meeting,
                        selected: meeting.id == selectedId,
                        onTap: () {
                          ref
                              .read(selectedMeetingIdProvider.notifier)
                              .select(meeting.id);
                        },
                        onPin: () => ref
                            .read(recordingControllerProvider.notifier)
                            .togglePin(meeting),
                        onFavorite: () => ref
                            .read(recordingControllerProvider.notifier)
                            .toggleFavorite(meeting),
                        onRename: () => _renameMeeting(context, ref, meeting),
                        onDelete: () => _deleteMeeting(context, ref, meeting),
                      );
                    },
                  );
                },
                error: (error, _) => Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text('Could not load meetings: $error'),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _renameMeeting(
    BuildContext context,
    WidgetRef ref,
    Meeting meeting,
  ) async {
    final controller = TextEditingController(text: meeting.title);
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename meeting'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Meeting title',
            prefixIcon: Icon(Icons.title),
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
    if (title == null) {
      return;
    }
    await ref
        .read(recordingControllerProvider.notifier)
        .renameMeeting(meeting, title);
  }

  Future<void> _deleteMeeting(
    BuildContext context,
    WidgetRef ref,
    Meeting meeting,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete meeting?'),
        content: Text(
          'This removes "${meeting.title}" from the local database. Audio files on disk are not deleted yet.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.delete),
            label: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    await ref
        .read(recordingControllerProvider.notifier)
        .deleteMeeting(meeting.id);
  }
}

class _MeetingTile extends StatelessWidget {
  const _MeetingTile({
    required this.meeting,
    required this.selected,
    required this.onTap,
    required this.onPin,
    required this.onFavorite,
    required this.onRename,
    required this.onDelete,
  });

  final Meeting meeting;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onPin;
  final VoidCallback onFavorite;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
        : Colors.transparent;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.24)
                  : Colors.transparent,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      meeting.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: meeting.isPinned ? 'Unpin' : 'Pin',
                    onPressed: onPin,
                    icon: Icon(
                      meeting.isPinned
                          ? Icons.push_pin
                          : Icons.push_pin_outlined,
                      size: 18,
                    ),
                  ),
                  IconButton(
                    tooltip: meeting.isFavorite ? 'Unfavorite' : 'Favorite',
                    onPressed: onFavorite,
                    icon: Icon(
                      meeting.isFavorite ? Icons.star : Icons.star_border,
                      size: 18,
                    ),
                  ),
                  PopupMenuButton<_MeetingAction>(
                    tooltip: 'More',
                    icon: const Icon(Icons.more_horiz, size: 18),
                    onSelected: (action) {
                      switch (action) {
                        case _MeetingAction.rename:
                          onRename();
                        case _MeetingAction.delete:
                          onDelete();
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: _MeetingAction.rename,
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 10),
                            Text('Rename'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: _MeetingAction.delete,
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, size: 18),
                            SizedBox(width: 10),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      compactDate(meeting.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF9AA4B2),
                      ),
                    ),
                  ),
                  StatusBadge(status: meeting.status),
                ],
              ),
              if (meeting.summaryPreview != null) ...[
                const SizedBox(height: 8),
                Text(
                  meeting.summaryPreview!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFB8C0CC),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

enum _MeetingAction { rename, delete }

class _EmptyMeetings extends StatelessWidget {
  const _EmptyMeetings();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Text(
          'Start a meeting to create your first local transcript.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF9AA4B2)),
        ),
      ),
    );
  }
}
