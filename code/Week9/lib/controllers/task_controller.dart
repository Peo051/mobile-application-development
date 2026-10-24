// Trần Dương Gia Bảo - 2001240039
import '../models/task.dart';
import '../utils/database_helper.dart';

class TaskController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertTask(Task task) async {
    final db = await _dbHelper.database;
    // id null để SQLite tự tăng, không tự lấy id cuối + 1.
    return db.insert('tasks', task.toMap());
  }

  Future<int> updateTask(Task task) async {
    final db = await _dbHelper.database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await _dbHelper.database;
    return db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isTaskExist(String title) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'tasks',
      where: 'title = ?',
      whereArgs: [title.trim()],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  Future<List<Task>> searchTasks(String query) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'tasks',
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%${query.trim()}%', '%${query.trim()}%'],
      orderBy: 'id ASC',
    );
    return rows.map(Task.fromMap).toList();
  }

  Future<List<Task>> fetchTasks() async {
    final db = await _dbHelper.database;
    final rows = await db.query('tasks', orderBy: 'id ASC');
    return rows.map(Task.fromMap).toList();
  }
}
