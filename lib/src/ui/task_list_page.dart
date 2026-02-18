import 'package:chore/src/ui/tasklist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:format/format.dart';
import 'dart:ui';
import '../data/models/task.dart'; // TODO: is this wise?

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TaskListCubit, List<Task>>(
        builder: (context, tasks) {
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final color = _colorForTask(task);

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
                      radius: 6,
                    ),
                    title: Text(task.title),
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
    );
  }
}

Color _colorForTask(Task task) {
  if (task.lastDoneAt == null) return Colors.grey;
  final hours = DateTime.now().difference(task.lastDoneAt!).inHours;
  if (hours < 24) return Colors.green;
  if (hours < 48) return Colors.orange;
  return Colors.red;
}
