import 'package:chore/src/ui/features/task_list/cubit/task_cubit.dart';
import 'package:chore/src/ui/features/task_list/cubit/tasklist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/repositories/repositories.dart';
import '../../../../core/services/sorting.dart';
import '../../../../core/entities/task.dart';

class TaskListCubit extends Cubit<TaskListState> {
  TaskListCubit(this._repository) : super(const TaskListState());
  final TaskRepository _repository;

  void loadInitialTasks([List<Task>? tasks]) async {
    emit(state.copyWith(isLoading: true));
    // TODO: remove hardcoded tasks
    try {
      final loaded = tasks ?? [
        Task(id: '1', title: 'Afwassen', frequency: Duration(days: 1)),
        Task(id: '2', title: 'Stofzuigen', frequency: Duration(days: 7)),
        Task(id: '3', title: '60-graden was'),
      ];
      final cubits = loaded.map((t) => TaskCubit(t, _repository)).toList();
      cubits.sort((a, b) => sortTasksByRecency(a.state.task, b.state.task));
      emit(state.copyWith(
        tasksCubits: cubits,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> markDone(String id) async {
    final cubit = state.tasksCubits.firstWhere((c) => c.state.task.id == id);
    await cubit.markDone();
    final sorted = [...state.tasksCubits]
      ..sort((a, b) => sortTasksByRecency(a.state.task, b.state.task));

    emit(state.copyWith(tasksCubits: sorted));
  }

  Future<void> addTask(Task task) async {
    final newTaskCubit = TaskCubit(task, _repository);
    await newTaskCubit.update(task);
    final updated = [...state.tasksCubits, newTaskCubit];

    emit(state.copyWith(tasksCubits: updated));
  }

  Future<void> editTask(Task updatedTask) async {
    final cubit = state.tasksCubits
        .firstWhere((c) => c.state.task.id == updatedTask.id);
    await cubit.update(updatedTask);

    emit(state.copyWith(tasksCubits: [...state.tasksCubits]));
  }

  Future<void> deleteTask(Task task) async {
    await _repository.delete(task);
    final updated = state.tasksCubits
        .where((c) => c.state.task.id != task.id)
        .toList();

    emit(state.copyWith(tasksCubits: updated));
  }
}