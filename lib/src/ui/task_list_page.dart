import 'package:chore/src/ui/tasklist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:format/format.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import '../data/models/task.dart';
import 'add_task_page.dart'; // TODO: is this wise?

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppBar')),
      body: Column(
        children: [
          Expanded(
            child:
              BlocBuilder<TaskListCubit, List<Task>>(
            builder: (context, tasks) {
              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final color = _colorForTask(task);
                  final formatter = DateFormat('dd-MM-yyyy HH:mm');
                  final lastDoneFormatted = task.lastDoneAt != null
                      ? formatter.format(task.lastDoneAt!.toLocal())
                      : 'nog nooit';
                  final timeUnitsAgo = _getTimeUnitsAgo(task.lastDoneAt);
                  // TODO: magic numbers?
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.surface,
                      child: InkWell(
                        child:
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          leading: CircleAvatar(
                            backgroundColor: color,
                            radius: 10,
                          ),
                          title: Row(
                            children: [
                              Text(
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  task.title),
                              Text(_formatFrequency(task.frequency)),
                            ],
                          ),
                          onLongPress: () {
                            context.read<TaskListCubit>().markDone(task.id);
                            // TODO create bar in bottom and ask for confirmation
                          },
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddTaskPage(existingTask: task),
                                )
                            );
                          },
                          trailing: Column(
                            children: [
                              Text('Laatst gedaan:'),
                              Text(lastDoneFormatted),
                              Text(timeUnitsAgo),
                          ]
                          ),
                        ),
                      ),
                      ),
                    );
                },
              );
            },
          ),
        ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const SizedBox(width: 16),
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddTaskPage(),
                  )
                  );
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
      ],
      ),

    );
  }
}

Color _colorForTask(Task task) {
  if (task.lastDoneAt == null || task.frequency == null) return Colors.grey;

  final hours = DateTime.now().difference(task.lastDoneAt!).inHours;
  final int freq = task.frequency!.inDays;
  if (hours < freq) return Colors.green;
  if (hours < freq) return Colors.orange;
  return Colors.red;
}

String _formatFrequency(Duration? frequency) {
  if (frequency == null) return '';
  final days = frequency.inDays;
  if (days == 1) {
    return ' (dagelijks)';
  }
  return ' (elke $days dagen)';
}

enum TaskAction { select, edit, delete }

Future<void> _showMenu(
    BuildContext context,
    Offset position,
    Task task,
    ) async {
  final selected = await showMenu<TaskAction>(
    context: context,
    menuPadding:  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      position: RelativeRect.fromLTRB(
      position.dx,
      position.dy,
      position.dx,
      position.dy,
    ),
    items: [
      PopupMenuItem(
        value: TaskAction.select,
        child: Text('Selecteren'),
      ),
      PopupMenuItem(
        value: TaskAction.edit,
        child: Text('Bewerken'),
      ),
      PopupMenuItem(
        value: TaskAction.delete,
        child: Text('Verwijderen'),
      ),
    ],
  );

  if (selected != null) {
    _handleAction(context, selected, task);
  }
}

void _handleAction(
    BuildContext context,
    TaskAction action,
    Task task,
    ) {
  switch (action) {
    case TaskAction.select:
      break;

    case TaskAction.edit:
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTaskPage(existingTask: task),
          ));

    case TaskAction.delete:
      context.read<TaskListCubit>().deleteTask(task);
      break;
  }
}

String _getTimeUnitsAgo(DateTime? date) {
  if (date == null) return '';

  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inSeconds < 60) return 'zojuist';
  if (difference.inMinutes < 60) return '${difference.inMinutes}m geleden';
  if (difference.inHours < 24) return '${difference.inHours}u geleden';
  if (difference.inDays < 7) return '${difference.inDays} dagen geleden';
  if (difference.inDays < 30) return '${(difference.inDays / 7).floor()} weken geleden';
  if (difference.inDays < 365) return '${(difference.inDays / 30).floor()} maanden geleden';
  return '${(difference.inDays / 365).floor()} jaar geleden';
}
