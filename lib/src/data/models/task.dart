class Task {
  final String id;
  final String title;
  final DateTime? lastDoneAt;
  final Duration? frequency;

  Task({
    required this.id,
    required this.title,
    this.lastDoneAt,
    this.frequency,
  });
}