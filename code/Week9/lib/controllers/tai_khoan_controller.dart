// Trần Dương Gia Bảo - 2001240039

import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:sqflite/sqflite.dart';

import '../models/tai_khoan.dart';
import '../utils/database_helper.dart';

class TaiKhoanController {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final Pbkdf2 _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 100000,
    bits: 256,
  );

  Future<bool> isEmailExist(String email) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'tai_khoan',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  // Lưu giá trị băm và salt; không lưu mật khẩu gốc trong SQLite.
  Future<String> _hashPassword(String password, List<int> salt) async {
    final key = await _pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );
    return base64Encode(await key.extractBytes());
  }

  // Trả về false khi email đã được đăng ký.
  Future<bool> register(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (await isEmailExist(normalizedEmail)) return false;

    final random = Random.secure();
    final salt = List<int>.generate(16, (_) => random.nextInt(256));
    final taiKhoan = TaiKhoan(
      email: normalizedEmail,
      passwordHash: await _hashPassword(password, salt),
      salt: base64Encode(salt),
    );
    final db = await _dbHelper.database;
    try {
      await db.insert('tai_khoan', taiKhoan.toMap());
      return true;
    } on DatabaseException catch (error) {
      // Ràng buộc UNIQUE cũng chặn hai lần đăng ký cùng một email.
      if (error.isUniqueConstraintError()) return false;
      rethrow;
    }
  }

  Future<bool> signIn(String email, String password) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'tai_khoan',
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );
    if (rows.isEmpty) return false;

    final taiKhoan = TaiKhoan.fromMap(rows.first);
    final hash = await _hashPassword(password, base64Decode(taiKhoan.salt));
    return hash == taiKhoan.passwordHash;
  }
}
