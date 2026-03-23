import 'package:chore/src/ui/features/task_list/cubit/task_cubit.dart';

class TaskListState {
  final List<TaskCubit> tasksCubits;
  final bool isLoading;
  final String? error;

  const TaskListState({
    this.tasksCubits = const [],
    this.isLoading = false,
    this.error,
  });

  TaskListState copyWith({
    List<TaskCubit>? tasksCubits,
    bool? isLoading,
    String? error,
  }) {
    return TaskListState(
      tasksCubits: tasksCubits ?? this.tasksCubits,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}