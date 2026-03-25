import '../../../../core/entities/task.dart';

enum TaskStatus { idle, loading, saving, error }

class TaskState {
  final Task task;
  final TaskStatus status;
  final String? error;

  const TaskState({
    required this.task,
    this.status = TaskStatus.idle,
    this.error,
  });

  TaskState copyWith({
    Task? task,
    TaskStatus? status,
    String? error,
  }) {
    return TaskState(
      task: task ?? this.task,
      status: status ?? this.status,
      error: error,
    );
  }
}