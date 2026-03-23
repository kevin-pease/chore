import '../entities/task.dart';

abstract interface class TaskRepository {
  // Returns a list of all tasks.
  Future<List<Task>> getAll();

  // Saves a new task in the list.
  Future<void> save(Task task);

  // Updates a task in the list.
  Future<void> update(Task task);

  // Deletes a task with an particular ID from the list.
  Future<void> delete(Task task);
}