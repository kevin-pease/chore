import 'package:chore/src/ui/features/task_list/cubit/tasklist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/sorting.dart';
import '../../../../core/entities/task.dart';

class TaskListCubit extends Cubit<TaskListState> {
  TaskListCubit() : super(const TaskListState());

  void loadInitialTasks([List<Task>? tasks]) async {
    emit(state.copyWith(isLoading: true));

    try {
      final loaded = tasks ?? [
        Task(id: '1', title: 'Afwassen', frequency: Duration(days: 1)),
        Task(id: '2', title: 'Stofzuigen', frequency: Duration(days: 7)),
        Task(id: '3', title: '60-graden was'),
      ];

      emit(state.copyWith(
        tasks: loaded,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void markDone(String id) {
    final updated = state.tasks.map((task) {
      if (task.id == id) {
        return Task(
          id: task.id,
          title: task.title,
          lastDoneAt: DateTime.now(),
          frequency: task.frequency,
        );
      }
      return task;
    }).toList();

    updated.sort(sortTasksByRecency);
    emit(state.copyWith(tasks: updated));
  }

  void addTask(Task task) {
    final updatedTask = [...state.tasks, task];
    emit(state.copyWith(tasks: updatedTask));
  }


  void editTask(Task updatedTask) {
    final updated = state.tasks.map((task) {
      if (task.id == updatedTask.id) {
        return Task(
          id: updatedTask.id,
          title: updatedTask.title,
          lastDoneAt: updatedTask.lastDoneAt,
          frequency: updatedTask.frequency,
        );
      }
      return task;
    }).toList();

    emit(state.copyWith(tasks: updated));
  }

  void deleteTask(Task task) {
    final updated = List<Task>.from(state.tasks)..remove(task);
    emit(state.copyWith(tasks: updated));
  }
}