class Task {
  final String id;
  final String title;
  final DateTime? lastDoneAt;

  Task({
    required this.id,
    required this.title,
    this.lastDoneAt,
  });
}