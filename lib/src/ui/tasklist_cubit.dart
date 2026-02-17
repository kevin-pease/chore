import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/sorting.dart';
import '../data/models/task.dart';

class TaskListCubit extends Cubit<List<Task>> {
  TaskListCubit() : super(const []);

void loadInitialTasks() {
  emit([
    Task(id: '1', title: 'Dishes'),
    Task(id: '2', title: 'Laundry'),
    Task(id: '3', title: 'Vacuum'),
  ]);
}

  void markDone(String id) {
    final updated = state.map((task) {
      if (task.id == id) {
        return Task(
          id: task.id,
          title: task.title,
          lastDoneAt: DateTime.now(),
        );
      }
      return task;
    }).toList();

    updated.sort(sortTasksByRecency);

    emit(updated);
  }
  }