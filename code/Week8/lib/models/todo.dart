class Todo {
  const Todo({required this.title, required this.time, this.notificationId});

  final String title;
  final DateTime time;
  final int? notificationId;

  String toFileLine() => '$title|${time.toIso8601String()}';

  Todo withoutReminder() => Todo(title: title, time: time);

  static Todo? tryFromFileLine(String line) {
    final separator = line.lastIndexOf('|');
    if (separator <= 0 || separator == line.length - 1) return null;

    final title = line.substring(0, separator).trim();
    final time = DateTime.tryParse(line.substring(separator + 1).trim());
    if (title.isEmpty || time == null) return null;

    return Todo(title: title, time: time);
  }

  Map<String, Object?> toJson() => {
    'title': title,
    'time': time.toIso8601String(),
    'notificationId': notificationId,
  };

  static Todo? tryFromJson(Object? value) {
    if (value is! Map<String, dynamic>) return null;

    final title = value['title'];
    final timeText = value['time'];
    final notificationId = value['notificationId'];
    if (title is! String || timeText is! String) return null;

    final time = DateTime.tryParse(timeText);
    if (title.trim().isEmpty || time == null) return null;
    if (notificationId != null && notificationId is! int) return null;

    return Todo(
      title: title.trim(),
      time: time,
      notificationId: notificationId as int?,
    );
  }
}

class TodoLoadResult {
  const TodoLoadResult({required this.todos, required this.invalidRows});

  final List<Todo> todos;
  final int invalidRows;
}
