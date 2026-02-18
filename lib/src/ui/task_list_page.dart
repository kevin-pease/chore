import 'package:chore/src/ui/tasklist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:format/format.dart';
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

                  // TODO: magic numbers?
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.surface,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        leading: CircleAvatar(
                          backgroundColor: color,
                          radius: 10,
                        ),
                        title: Text(format('{} {}', task.title, _formatFrequency(task.frequency))),
                        onTap: () {
                          context.read<TaskListCubit>().markDone(task.id);
                        }
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