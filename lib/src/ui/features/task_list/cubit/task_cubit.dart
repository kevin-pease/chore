import 'package:chore/src/ui/features/task_list/cubit/task_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/entities/task.dart';
import '../../../../core/repositories/repositories.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit(Task task, this._repository): super(TaskState(task: task));
  final TaskRepository _repository;

  Future<void> markDone() async {
    emit(state.copyWith(status: TaskStatus.saving));
    try {
      final updated = state.task.copyWith(lastDoneAt: DateTime.now());
      await _repository.save(updated);
      emit(state.copyWith(task: updated, status: TaskStatus.idle));
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error, error: e.toString()));
    }
  }

  Future<void> update(Task updated) async {
    emit(state.copyWith(status: TaskStatus.saving));
    try {
      await _repository.save(updated);
      emit(state.copyWith(task: updated, status: TaskStatus.idle));
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error, error: e.toString()));
    }
  }
}