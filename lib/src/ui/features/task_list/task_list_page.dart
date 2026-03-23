import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/repositories/task_repository.dart';
import 'cubit/tasklist_cubit.dart';
import 'task_list_view.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key, required this.repository});
  final TaskRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskListCubit(repository)..loadInitialTasks(),
      child: const TaskListView(),
    );
  }
}