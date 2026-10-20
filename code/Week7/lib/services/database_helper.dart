import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/favorite_route.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Bộ nhớ đệm tạm thời khi chạy trên Web (do sqflite thuần chỉ hỗ trợ Mobile)
  static final List<FavoriteRoute> _webInMemoryRoutes = [];
  static int _webIdCounter = 1;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('favorite_routes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorite_routes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        origin_address TEXT,
        destination_address TEXT,
        origin_lat REAL NOT NULL,
        origin_lng REAL NOT NULL,
        dest_lat REAL NOT NULL,
        dest_lng REAL NOT NULL,
        transport_mode TEXT NOT NULL,
        distance TEXT,
        duration TEXT,
        encoded_polyline TEXT,
        created_at TEXT NOT NULL
      )
    ''');
  }

  // Thêm tuyến đường yêu thích
  Future<int> insertRoute(FavoriteRoute route) async {
    if (kIsWeb) {
      final newId = _webIdCounter++;
      final webRoute = FavoriteRoute(
        id: newId,
        title: route.title,
        originAddress: route.originAddress,
        destinationAddress: route.destinationAddress,
        originLat: route.originLat,
        originLng: route.originLng,
        destLat: route.destLat,
        destLng: route.destLng,
        transportMode: route.transportMode,
        distance: route.distance,
        duration: route.duration,
        encodedPolyline: route.encodedPolyline,
        createdAt: route.createdAt,
      );
      _webInMemoryRoutes.insert(0, webRoute);
      return newId;
    }

    final db = await database;
    return await db.insert('favorite_routes', route.toMap());
  }

  // Lấy toàn bộ danh sách tuyến đường yêu thích
  Future<List<FavoriteRoute>> getAllRoutes() async {
    if (kIsWeb) {
      return List.from(_webInMemoryRoutes);
    }

    final db = await database;
    final result = await db.query('favorite_routes', orderBy: 'id DESC');
    return result.map((map) => FavoriteRoute.fromMap(map)).toList();
  }

  // Xóa tuyến đường theo ID
  Future<int> deleteRoute(int id) async {
    if (kIsWeb) {
      _webInMemoryRoutes.removeWhere((r) => r.id == id);
      return 1;
    }

    final db = await database;
    return await db.delete('favorite_routes', where: 'id = ?', whereArgs: [id]);
  }

  // Đóng database
  Future<void> close() async {
    if (kIsWeb) return;
    final db = await database;
    db.close();
  }
}
