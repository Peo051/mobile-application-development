// Trần Dương Gia Bảo - 2001240039
import '../models/sinh_vien.dart';
import '../utils/database_helper.dart';

class SinhVienController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertSinhVien(SinhVien sinhVien) async {
    final db = await _dbHelper.database;
    return db.insert('sinh_vien', sinhVien.toMap());
  }

  Future<List<SinhVien>> fetchSinhVien() async {
    final db = await _dbHelper.database;
    final rows = await db.query('sinh_vien', orderBy: 'id ASC');
    return rows.map(SinhVien.fromMap).toList();
  }

  Future<List<SinhVien>> searchSinhVien(String query) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'sinh_vien',
      where: 'name LIKE ? OR email LIKE ?',
      whereArgs: ['%${query.trim()}%', '%${query.trim()}%'],
      orderBy: 'id ASC',
    );
    return rows.map(SinhVien.fromMap).toList();
  }

  Future<int> updateSinhVien(SinhVien sinhVien) async {
    final db = await _dbHelper.database;
    return db.update(
      'sinh_vien',
      sinhVien.toMap(),
      where: 'id = ?',
      whereArgs: [sinhVien.id],
    );
  }

  Future<int> deleteSinhVien(int id) async {
    final db = await _dbHelper.database;
    return db.delete('sinh_vien', where: 'id = ?', whereArgs: [id]);
  }
}
