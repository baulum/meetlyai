import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../application/providers.dart';
import '../../domain/models/meeting_models.dart';

class MeetingTodoList extends ConsumerWidget {
  const MeetingTodoList({super.key, required this.meetingId});

  final String meetingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(meetingTodosProvider(meetingId));

    return todosAsync.when(
      data: (todos) => _EditableTodoTable(meetingId: meetingId, todos: todos),
      loading: () => const _TodoShell(
        child: SizedBox(
          height: 52,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      ),
      error: (error, _) => _TodoShell(
        child: Text(
          'Could not load todos: $error',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}

class _EditableTodoTable extends ConsumerWidget {
  const _EditableTodoTable({required this.meetingId, required this.todos});

  final String meetingId;
  final List<Todo> todos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _TodoShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.checklist_outlined,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Todos',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: () => _editTodo(context, ref, null),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (todos.isEmpty)
            Text(
              'No todos yet. Gemini action items appear here after summary generation.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: const Color(0xFF9AA4B2)),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 38,
                dataRowMinHeight: 46,
                dataRowMaxHeight: 78,
                columnSpacing: 22,
                horizontalMargin: 0,
                dividerThickness: 0.6,
                headingTextStyle: Theme.of(context).textTheme.labelMedium
                    ?.copyWith(
                      color: const Color(0xFF9AA4B2),
                      fontWeight: FontWeight.w700,
                    ),
                dataTextStyle: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFFE7EAEE)),
                columns: const [
                  DataColumn(label: Text('Done')),
                  DataColumn(label: Text('Task')),
                  DataColumn(label: Text('Owner')),
                  DataColumn(label: Text('Due')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: [
                  for (final todo in todos)
                    DataRow(
                      cells: [
                        DataCell(
                          Checkbox(
                            value: todo.done,
                            onChanged: (value) => ref
                                .read(meetingRepositoryProvider)
                                .upsertTodo(
                                  todo.copyWith(done: value ?? false),
                                ),
                          ),
                        ),
                        DataCell(
                          _EditableCell(
                            value: todo.content,
                            maxWidth: 360,
                            onTap: () => _editTodo(context, ref, todo),
                          ),
                        ),
                        DataCell(
                          _EditableCell(
                            value: todo.notes?.trim().isNotEmpty == true
                                ? todo.notes!.trim()
                                : 'Unassigned',
                            maxWidth: 180,
                            muted: todo.notes?.trim().isNotEmpty != true,
                            onTap: () => _editTodo(context, ref, todo),
                          ),
                        ),
                        DataCell(
                          _EditableCell(
                            value: _dateLabel(todo.dueDate),
                            maxWidth: 140,
                            muted: todo.dueDate == null,
                            onTap: () => _editTodo(context, ref, todo),
                          ),
                        ),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Edit todo',
                                onPressed: () => _editTodo(context, ref, todo),
                                icon: const Icon(Icons.edit_outlined, size: 18),
                              ),
                              IconButton(
                                tooltip: 'Delete todo',
                                onPressed: () => ref
                                    .read(meetingRepositoryProvider)
                                    .deleteTodo(todo.id),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                ),
                              ),
                            ],
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

  Future<void> _editTodo(
    BuildContext context,
    WidgetRef ref,
    Todo? todo,
  ) async {
    final taskController = TextEditingController(text: todo?.content ?? '');
    final ownerController = TextEditingController(text: todo?.notes ?? '');
    final dueController = TextEditingController(
      text: todo?.dueDate == null ? '' : _dateInput(todo!.dueDate!),
    );
    var done = todo?.done ?? false;

    final saved = await showDialog<Todo>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(todo == null ? 'Add todo' : 'Edit todo'),
            content: SizedBox(
              width: 460,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: taskController,
                    autofocus: true,
                    minLines: 1,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Task',
                      prefixIcon: Icon(Icons.task_alt_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: ownerController,
                    decoration: const InputDecoration(
                      labelText: 'Owner',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: dueController,
                    decoration: const InputDecoration(
                      labelText: 'Due date',
                      hintText: 'YYYY-MM-DD',
                      prefixIcon: Icon(Icons.event_outlined),
                    ),
                  ),
                  const SizedBox(height: 8),
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
                onPressed: () {
                  final task = taskController.text.trim();
                  if (task.isEmpty) {
                    return;
                  }
                  Navigator.of(context).pop(
                    Todo(
                      id: todo?.id ?? const Uuid().v7(),
                      meetingId: meetingId,
                      content: task,
                      done: done,
                      createdAt: todo?.createdAt ?? DateTime.now(),
                      dueDate: _parseDate(dueController.text),
                      notes: ownerController.text.trim().isEmpty
                          ? null
                          : ownerController.text.trim(),
                      sortOrder: todo?.sortOrder ?? todos.length,
                    ),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );

    taskController.dispose();
    ownerController.dispose();
    dueController.dispose();

    if (saved != null) {
      await ref.read(meetingRepositoryProvider).upsertTodo(saved);
    }
  }
}

class _TodoShell extends StatelessWidget {
  const _TodoShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111419),
        border: Border.all(color: const Color(0xFF2B333D)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}

class _EditableCell extends StatelessWidget {
  const _EditableCell({
    required this.value,
    required this.maxWidth,
    required this.onTap,
    this.muted = false,
  });

  final String value;
  final double maxWidth;
  final VoidCallback onTap;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 90, maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            value,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: muted ? const Color(0xFF9AA4B2) : null),
          ),
        ),
      ),
    );
  }
}

String _dateLabel(DateTime? date) => date == null ? '-' : _dateInput(date);

String _dateInput(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

DateTime? _parseDate(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  return DateTime.tryParse(trimmed);
}
