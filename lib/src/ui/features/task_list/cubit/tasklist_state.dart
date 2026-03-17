import '../../../../core/entities/task.dart';

class TaskListState {
  final List<Task> tasks;
  final bool isLoading;
  final String? error;

  const TaskListState({
    this.tasks = const [],
    this.isLoading = false,
    this.error,
  });

  TaskListState copyWith({
    List<Task>? tasks,
    bool? isLoading,
    String? error,
  }) {
    return TaskListState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}