import 'package:flutter/material.dart';
import '../../../data/models/task.dart';
import 'add_edit_task_view.dart';

class AddEditTaskPage extends StatelessWidget {
  final Task? existingTask;
  const AddEditTaskPage({super.key, this.existingTask});

  @override
  Widget build(BuildContext context) {
    return AddEditTaskView(existingTask: existingTask);
  }
}
