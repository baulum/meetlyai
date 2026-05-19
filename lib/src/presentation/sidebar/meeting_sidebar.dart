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
    final section = ref.watch(appSectionProvider);
    final collapsed = ref.watch(sidebarCollapsedProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      width: collapsed ? 76 : 306,
      decoration: const BoxDecoration(
        color: Color(0xFF101318),
        border: Border(right: BorderSide(color: Color(0xFF252B33))),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final effectiveCollapsed = collapsed || constraints.maxWidth < 220;

          return SafeArea(
            child: Column(
              children: [
                _SidebarHeader(
                  collapsed: effectiveCollapsed,
                  onToggle: () =>
                      ref.read(sidebarCollapsedProvider.notifier).toggle(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      _NavItem(
                        collapsed: effectiveCollapsed,
                        selected: section == AppSection.meetings,
                        icon: Icons.forum_outlined,
                        label: 'Meetings',
                        onTap: () => ref
                            .read(appSectionProvider.notifier)
                            .showMeetings(),
                      ),
                      _NavItem(
                        collapsed: effectiveCollapsed,
                        selected: section == AppSection.todos,
                        icon: Icons.checklist_outlined,
                        label: 'Todos',
                        onTap: () =>
                            ref.read(appSectionProvider.notifier).showTodos(),
                      ),
                      _NavItem(
                        collapsed: effectiveCollapsed,
                        selected: section == AppSection.settings,
                        icon: Icons.tune,
                        label: 'Settings',
                        onTap: () => ref
                            .read(appSectionProvider.notifier)
                            .showSettings(),
                      ),
                    ],
                  ),
                ),
                if (!effectiveCollapsed && section == AppSection.meetings) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
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
                      onChanged: (value) => ref
                          .read(meetingSearchProvider.notifier)
                          .setQuery(value),
                      decoration: const InputDecoration(
                        hintText: 'Search meetings',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ] else
                  const SizedBox(height: 14),
                Expanded(
                  child: effectiveCollapsed || section != AppSection.meetings
                      ? const SizedBox.shrink()
                      : meetings.when(
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
                                        .read(appSectionProvider.notifier)
                                        .showMeetings();
                                    ref
                                        .read(
                                          selectedMeetingIdProvider.notifier,
                                        )
                                        .select(meeting.id);
                                  },
                                  onPin: () => ref
                                      .read(
                                        recordingControllerProvider.notifier,
                                      )
                                      .togglePin(meeting),
                                  onFavorite: () => ref
                                      .read(
                                        recordingControllerProvider.notifier,
                                      )
                                      .toggleFavorite(meeting),
                                  onRename: () =>
                                      _renameMeeting(context, ref, meeting),
                                  onDelete: () =>
                                      _deleteMeeting(context, ref, meeting),
                                );
                              },
                            );
                          },
                          error: (error, _) => Padding(
                            padding: const EdgeInsets.all(18),
                            child: Text('Could not load meetings: $error'),
                          ),
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                ),
              ],
            ),
          );
        },
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

class _SidebarHeader extends StatelessWidget {
  const _SidebarHeader({required this.collapsed, required this.onToggle});

  final bool collapsed;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final logo = Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.graphic_eq, color: Color(0xFF06110D), size: 20),
    );
    final toggle = IconButton(
      tooltip: collapsed ? 'Expand sidebar' : 'Collapse sidebar',
      onPressed: onToggle,
      icon: Icon(
        collapsed
            ? Icons.keyboard_double_arrow_right
            : Icons.keyboard_double_arrow_left,
      ),
    );

    if (collapsed) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 14, 10, 10),
        child: Column(
          children: [
            logo,
            const SizedBox(height: 8),
            SizedBox.square(dimension: 40, child: toggle),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      child: Row(
        children: [
          logo,
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'MeetlyAI',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          toggle,
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.collapsed,
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool collapsed;
  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.14)
        : Colors.transparent;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Tooltip(
        message: collapsed ? label : '',
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 42,
            padding: EdgeInsets.symmetric(horizontal: collapsed ? 0 : 12),
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
            child: Row(
              mainAxisAlignment: collapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Icon(icon, size: 20),
                if (!collapsed) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
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
