import '../../data/models/task.dart';

int sortTasksByRecency(Task a, Task b) {
  if (a.lastDoneAt == null && b.lastDoneAt == null) return 0;
  if (a.lastDoneAt == null) return 1;
  if (b.lastDoneAt == null) return -1;
  return b.lastDoneAt!.compareTo(a.lastDoneAt!);
}
