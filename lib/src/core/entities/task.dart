class Task {
  final String id;
  final String title;
  final DateTime? lastDoneAt;
  final Duration? frequency;


  Task copyWith({
    String? id,
    String? title,
    DateTime? lastDoneAt,
    Duration? frequency,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      lastDoneAt: lastDoneAt ?? this.lastDoneAt,
      frequency: frequency ?? this.frequency,
    );
  }

  Task({
    required this.id,
    required this.title,
    this.lastDoneAt,
    this.frequency,
  });

}