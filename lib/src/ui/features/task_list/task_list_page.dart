import 'package:flutter/material.dart';
import 'task_list_view.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});
  static const String path = '/';
  static const String name = 'TaskList';

  @override
  Widget build(BuildContext context) {
    return const TaskListView();
  }
}