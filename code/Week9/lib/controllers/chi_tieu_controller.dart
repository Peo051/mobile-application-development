// Trần Dương Gia Bảo - 2001240039

import '../models/chi_tieu.dart';
import '../utils/database_helper.dart';

class ChiTieuController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<ChiTieu>> fetchChiTieu() async {
    final db = await _dbHelper.database;
    final rows = await db.query('chi_tieu', orderBy: 'id DESC');
    return rows.map((row) => ChiTieu.fromMap(row)).toList();
  }

  Future<int> insertChiTieu(ChiTieu chiTieu) async {
    final db = await _dbHelper.database;
    return db.insert('chi_tieu', chiTieu.toMap());
  }

  Future<int> updateChiTieu(ChiTieu chiTieu) async {
    if (chiTieu.id == null) {
      throw ArgumentError('Khoản chi cần có id để cập nhật.');
    }
    final db = await _dbHelper.database;
    return db.update(
      'chi_tieu',
      chiTieu.toMap(),
      where: 'id = ?',
      whereArgs: [chiTieu.id],
    );
  }

  Future<int> deleteChiTieu(int id) async {
    final db = await _dbHelper.database;
    return db.delete('chi_tieu', where: 'id = ?', whereArgs: [id]);
  }
}
