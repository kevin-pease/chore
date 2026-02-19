import 'package:flutter/material.dart';
import 'task_list_view.dart';

/// The page displaying the task list.
class TaskListPage extends StatelessWidget {
  /// Creates a new instance of [TaskListPage].
  const TaskListPage({super.key});

  /// The path of the [TaskListPage] route.
  static const String path = '/';

  /// The name of the [TaskListPage] route.
  static const String name = 'TaskList';

  @override
  Widget build(BuildContext context) {
    return const TaskListView();
  }
}