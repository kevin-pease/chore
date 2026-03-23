import 'package:flutter/material.dart';
import '../../../core/entities/task.dart';
import 'add_edit_task_view.dart';

class AddEditTaskPage extends StatelessWidget {
  final Task? existingTask;
  final void Function(Task) onSave;
  final void Function(Task)? onDelete;

  const AddEditTaskPage({
    super.key,
    this.existingTask,
    required this.onSave,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AddEditTaskView(
      existingTask: existingTask,
      onSave: onSave,
      onDelete: onDelete,
    );
  }
}