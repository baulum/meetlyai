import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../application/providers.dart';
import '../../domain/models/meeting_models.dart';

class GlobalTodosView extends ConsumerStatefulWidget {
  const GlobalTodosView({super.key, this.onClose});

  final VoidCallback? onClose;

  @override
  ConsumerState<GlobalTodosView> createState() => _GlobalTodosViewState();
}

class _GlobalTodosViewState extends ConsumerState<GlobalTodosView> {
  final _controller = TextEditingController();
  final _uuid = const Uuid();
  String? _selectedMeetingId;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todosAsync = ref.watch(allTodosProvider);
    final meetingsAsync = ref.watch(allMeetingsProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 0, 26, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TodosHeader(onClose: widget.onClose),
          const SizedBox(height: 16),
          meetingsAsync.when(
            data: (meetings) => _TodoComposer(
              controller: _controller,
              meetings: meetings,
              selectedMeetingId: _selectedMeetingId,
              onMeetingChanged: (value) {
                setState(() => _selectedMeetingId = value);
              },
              onAdd: _addTodo,
            ),
            loading: () =>
                _TodoComposer.loading(controller: _controller, onAdd: _addTodo),
            error: (error, _) => _TodoComposer.error(
              controller: _controller,
              error: error,
              onAdd: _addTodo,
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: todosAsync.when(
              data: (todos) => meetingsAsync.when(
                data: (meetings) =>
                    _TodoList(todos: todos, meetings: meetings, owner: this),
                loading: () => const _TodoLoading(),
                error: (error, _) => _TodoError(error: error),
              ),
              loading: () => const _TodoLoading(),
              error: (error, _) => _TodoError(error: error),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addTodo() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      return;
    }

    final todo = Todo(
      id: _uuid.v7(),
      meetingId: _selectedMeetingId,
      content: text,
      createdAt: DateTime.now(),
    );

    await ref.read(meetingRepositoryProvider).upsertTodo(todo);
    _controller.clear();
  }

  Future<void> _toggleTodo(Todo todo, bool done) {
    return ref
        .read(meetingRepositoryProvider)
        .upsertTodo(todo.copyWith(done: done));
  }

  Future<void> _deleteTodo(Todo todo) {
    return ref.read(meetingRepositoryProvider).deleteTodo(todo.id);
  }
}

class _TodosHeader extends StatelessWidget {
  const _TodosHeader({this.onClose});

  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF111419),
        border: Border.all(color: const Color(0xFF252B33)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.checklist_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Todos',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  'Track follow-ups across meetings and general work.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF9AA4B2),
                  ),
                ),
              ],
            ),
          ),
          if (onClose != null)
            IconButton(
              tooltip: 'Close todos',
              onPressed: onClose,
              icon: const Icon(Icons.close),
            ),
        ],
      ),
    );
  }
}

class _TodoComposer extends StatelessWidget {
  const _TodoComposer({
    required this.controller,
    required this.meetings,
    required this.selectedMeetingId,
    required this.onMeetingChanged,
    required this.onAdd,
  }) : placeholder = null;

  const _TodoComposer.loading({required this.controller, required this.onAdd})
    : meetings = const [],
      selectedMeetingId = null,
      onMeetingChanged = null,
      placeholder = 'Loading meetings...';

  const _TodoComposer.error({
    required this.controller,
    required Object error,
    required this.onAdd,
  }) : meetings = const [],
       selectedMeetingId = null,
       onMeetingChanged = null,
       placeholder = 'Meetings unavailable';

  final TextEditingController controller;
  final List<Meeting> meetings;
  final String? selectedMeetingId;
  final ValueChanged<String?>? onMeetingChanged;
  final VoidCallback onAdd;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1217),
        border: Border.all(color: const Color(0xFF252B33)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 720;
          final input = TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Add a todo...',
              prefixIcon: Icon(Icons.add_task),
            ),
            onSubmitted: (_) => onAdd(),
          );
          final scope = _scopeDropdown();
          final button = FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                input,
                const SizedBox(height: 10),
                scope,
                const SizedBox(height: 10),
                Align(alignment: Alignment.centerRight, child: button),
              ],
            );
          }

          return Row(
            children: [
              Expanded(flex: 2, child: input),
              const SizedBox(width: 12),
              Expanded(child: scope),
              const SizedBox(width: 12),
              button,
            ],
          );
        },
      ),
    );
  }

  Widget _scopeDropdown() {
    Widget label(String text) {
      return Text(text, maxLines: 1, overflow: TextOverflow.ellipsis);
    }

    return DropdownButtonFormField<String?>(
      initialValue: selectedMeetingId,
      isExpanded: true,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.forum_outlined),
        labelText: 'Scope',
      ),
      selectedItemBuilder: (context) => [
        label('General'),
        for (final meeting in meetings) label(meeting.title),
      ],
      items: [
        DropdownMenuItem<String?>(value: null, child: label('General')),
        for (final meeting in meetings)
          DropdownMenuItem<String?>(
            value: meeting.id,
            child: label(meeting.title),
          ),
      ],
      onChanged: onMeetingChanged,
      hint: placeholder == null ? null : label(placeholder!),
    );
  }
}

class _TodoList extends StatelessWidget {
  const _TodoList({
    required this.todos,
    required this.meetings,
    required this.owner,
  });

  final List<Todo> todos;
  final List<Meeting> meetings;
  final _GlobalTodosViewState owner;

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return const _EmptyTodos();
    }

    final meetingTitles = {
      for (final meeting in meetings) meeting.id: meeting.title,
    };
    final grouped = <String, List<Todo>>{};
    for (final todo in todos) {
      grouped.putIfAbsent(todo.meetingId ?? 'general', () => []).add(todo);
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 18),
      children: [
        for (final entry in grouped.entries) ...[
          _TodoGroupHeader(
            title: entry.key == 'general'
                ? 'General'
                : meetingTitles[entry.key] ?? 'Unknown meeting',
            todos: entry.value,
          ),
          const SizedBox(height: 8),
          for (final todo in entry.value)
            _TodoTile(
              todo: todo,
              meetingTitle: todo.meetingId == null
                  ? null
                  : meetingTitles[todo.meetingId!],
              onToggle: (done) => owner._toggleTodo(todo, done),
              onDelete: () => owner._deleteTodo(todo),
            ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _TodoGroupHeader extends StatelessWidget {
  const _TodoGroupHeader({required this.title, required this.todos});

  final String title;
  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    final doneCount = todos.where((todo) => todo.done).length;
    return Row(
      children: [
        Icon(Icons.folder_outlined, size: 17, color: const Color(0xFF9AA4B2)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFFE7EAEE),
            ),
          ),
        ),
        _ProgressPill(doneCount: doneCount, totalCount: todos.length),
      ],
    );
  }
}

class _ProgressPill extends StatelessWidget {
  const _ProgressPill({required this.doneCount, required this.totalCount});

  final int doneCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF151A21),
        border: Border.all(color: const Color(0xFF2B333D)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$doneCount/$totalCount',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: const Color(0xFFB8C0CC),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TodoTile extends StatelessWidget {
  const _TodoTile({
    required this.todo,
    required this.meetingTitle,
    required this.onToggle,
    required this.onDelete,
  });

  final Todo todo;
  final String? meetingTitle;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
        decoration: BoxDecoration(
          color: todo.done ? const Color(0xFF0D1015) : const Color(0xFF111419),
          border: Border.all(color: const Color(0xFF252B33)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: todo.done,
              onChanged: (value) => onToggle(value ?? false),
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.35,
                      decoration: todo.done ? TextDecoration.lineThrough : null,
                      color: todo.done
                          ? const Color(0xFF6B7280)
                          : const Color(0xFFE7EAEE),
                    ),
                  ),
                  if (meetingTitle != null) ...[
                    const SizedBox(height: 5),
                    Text(
                      meetingTitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: const Color(0xFF9AA4B2),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              tooltip: 'Delete todo',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyTodos extends StatelessWidget {
  const _EmptyTodos();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No todos yet.',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF9AA4B2)),
      ),
    );
  }
}

class _TodoLoading extends StatelessWidget {
  const _TodoLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
  }
}

class _TodoError extends StatelessWidget {
  const _TodoError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Could not load todos: $error'));
  }
}
