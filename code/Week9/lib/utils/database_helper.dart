// Trần Dương Gia Bảo - 2001240039
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Dùng chung một kết nối SQLite cho các bài trong Week9.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._init();
  Database? _database;

  DatabaseHelper._init();
  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;

    // join tạo đường dẫn đúng, không ghép thiếu dấu / như ví dụ trong đề.
    final path = join(await getDatabasesPath(), 'week9.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            isCompleted INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE sinh_vien (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE chi_tieu (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            noiDung TEXT NOT NULL,
            soTien REAL NOT NULL CHECK(soTien > 0),
            ghiChu TEXT NOT NULL DEFAULT ''
          )
        ''');
        await db.execute('''
          CREATE TABLE tai_khoan (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT NOT NULL COLLATE NOCASE UNIQUE,
            passwordHash TEXT NOT NULL,
            salt TEXT NOT NULL
          )
        ''');
      },
    );
    return _database!;
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
