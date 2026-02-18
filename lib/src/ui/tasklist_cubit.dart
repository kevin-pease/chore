import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/services/sorting.dart';
import '../data/models/task.dart';

class TaskListCubit extends Cubit<List<Task>> {
  TaskListCubit() : super(const []);

  void loadInitialTasks() {
    emit([
      Task(id: '1', title: 'Afwassen', frequency: Duration(days: 1)),
      Task(id: '2', title: 'Stofzuigen', frequency: Duration(days: 7)),
      Task(id: '3', title: '60-graden was'),
    ]);
  }

  void markDone(String id) {
    final updated = state.map((task) {
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
    emit(updated);
  }

  void addTask(Task task) {
    print(state);
  }
}