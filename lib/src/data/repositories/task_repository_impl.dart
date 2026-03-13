import '../../core/entities/task.dart';
import 'package:chore/src/core/repositories/repositories.dart';

class TaskRepositoryImpl implements TaskRepository {
  final List<Task> _tasks = [];

  @override
  Future<List<Task>> getAll() async => _tasks;

  @override
  Future<void> save(Task task) async => _tasks.add(task);

  @override
  Future<void> update(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) _tasks[index] = task;
  }

  @override
  Future<void> delete(String id) async => _tasks.removeWhere((t) => t.id == id);
}