class DailyTask {
  const DailyTask({
    required this.id,
    required this.title,
    required this.reminderTime,
    required this.completed,
    this.notificationId,
  });

  final String id;
  final String title;
  final DateTime reminderTime;
  final bool completed;
  final int? notificationId;

  DailyTask copyWith({
    bool? completed,
    int? notificationId,
    bool clearNotificationId = false,
  }) {
    return DailyTask(
      id: id,
      title: title,
      reminderTime: reminderTime,
      completed: completed ?? this.completed,
      notificationId: clearNotificationId
          ? null
          : notificationId ?? this.notificationId,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'reminderTime': reminderTime.toIso8601String(),
    'completed': completed,
    'notificationId': notificationId,
  };

  static DailyTask? tryFromJson(Object? value) {
    if (value is! Map<String, dynamic>) return null;

    final id = value['id'];
    final title = value['title'];
    final reminderTimeText = value['reminderTime'];
    final completed = value['completed'];
    final notificationId = value['notificationId'];
    if (id is! String || title is! String || reminderTimeText is! String) {
      return null;
    }
    if (completed is! bool ||
        (notificationId != null && notificationId is! int)) {
      return null;
    }

    final reminderTime = DateTime.tryParse(reminderTimeText);
    if (id.isEmpty || title.trim().isEmpty || reminderTime == null) return null;

    return DailyTask(
      id: id,
      title: title.trim(),
      reminderTime: reminderTime,
      completed: completed,
      notificationId: notificationId as int?,
    );
  }
}
