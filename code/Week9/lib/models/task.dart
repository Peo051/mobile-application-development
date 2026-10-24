// Trần Dương Gia Bảo - 2001240039
class Task {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;

  const Task({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      // SQLite lưu trạng thái bool bằng số 0 hoặc 1.
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
