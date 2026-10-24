// Trần Dương Gia Bảo - 2001240039
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:week9/controllers/chi_tieu_controller.dart';
import 'package:week9/controllers/sinh_vien_controller.dart';
import 'package:week9/controllers/tai_khoan_controller.dart';
import 'package:week9/controllers/task_controller.dart';
import 'package:week9/models/chi_tieu.dart';
import 'package:week9/models/sinh_vien.dart';
import 'package:week9/models/task.dart';
import 'package:week9/utils/database_helper.dart';

void main() {
  late Directory tempDirectory;
  final helper = DatabaseHelper();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    await helper.close();
    tempDirectory = await Directory.systemTemp.createTemp('week9_database_');
    await databaseFactory.setDatabasesPath(tempDirectory.path);
  });

  tearDown(() async {
    await helper.close();
    await tempDirectory.delete(recursive: true);
  });

  test('Task thêm, tìm, cập nhật, xóa và tự tăng id sau khi xóa', () async {
    final controller = TaskController();
    final firstId = await controller.insertTask(
      const Task(title: "Học 'SQLite'", description: 'Thực hành tại lớp'),
    );
    final secondId = await controller.insertTask(
      const Task(title: 'Bài tập về nhà', description: 'Hoàn thành tuần 9'),
    );
    expect(secondId, greaterThan(firstId));
    expect(await controller.isTaskExist("Học 'SQLite'"), isTrue);
    expect(await controller.isTaskExist("' OR 1=1 --"), isFalse);
    expect((await controller.searchTasks('tuần 9')).single.id, secondId);

    await controller.updateTask(
      Task(
        id: firstId,
        title: "Học 'SQLite'",
        description: 'Đã hoàn thành',
        isCompleted: true,
      ),
    );
    final updated = (await controller.fetchTasks()).first;
    expect(updated.isCompleted, isTrue);
    expect(updated.description, 'Đã hoàn thành');

    await controller.deleteTask(secondId);
    final newId = await controller.insertTask(
      const Task(title: 'Công việc mới', description: ''),
    );
    expect(newId, greaterThan(secondId));
    expect((await controller.fetchTasks()).length, 2);
    await controller.deleteTask(firstId);
    await controller.deleteTask(newId);
    expect(await controller.fetchTasks(), isEmpty);
  });

  test(
    'Sinh viên CRUD và tìm theo tên hoặc email, câu SQL có tham số',
    () async {
      final controller = SinhVienController();
      final id = await controller.insertSinhVien(
        SinhVien(name: "Nguyễn O'An", email: 'an@example.com'),
      );
      await controller.insertSinhVien(
        SinhVien(name: 'Trần Thị B', email: 'binh@example.com'),
      );
      expect((await controller.searchSinhVien("O'An")).single.id, id);
      expect(
        (await controller.searchSinhVien('binh@')).single.name,
        'Trần Thị B',
      );
      expect(await controller.searchSinhVien("' OR 1=1 --"), isEmpty);

      await controller.updateSinhVien(
        SinhVien(id: id, name: 'Nguyễn Văn An', email: 'an.new@example.com'),
      );
      final updated = (await controller.fetchSinhVien()).first;
      expect(updated.name, 'Nguyễn Văn An');
      expect(updated.email, 'an.new@example.com');
      expect(updated.id, id);

      await controller.deleteSinhVien(id);
      expect((await controller.fetchSinhVien()).single.name, 'Trần Thị B');
    },
  );

  test(
    'Chi tiêu giữ số thập phân và chặn số tiền không dương trong DB',
    () async {
      final controller = ChiTieuController();
      final id = await controller.insertChiTieu(
        ChiTieu(noiDung: 'Mua vở', soTien: 25000.5, ghiChu: 'Hai quyển'),
      );
      expect((await controller.fetchChiTieu()).single.soTien, 25000.5);

      await controller.updateChiTieu(
        ChiTieu(id: id, noiDung: 'Mua sách', soTien: 55000, ghiChu: ''),
      );
      final updated = (await controller.fetchChiTieu()).single;
      expect(updated.noiDung, 'Mua sách');
      expect(updated.soTien, 55000);
      expect(updated.ghiChu, isEmpty);

      await expectLater(
        controller.insertChiTieu(ChiTieu(noiDung: 'Không hợp lệ', soTien: 0)),
        throwsA(isA<DatabaseException>()),
      );
      await controller.deleteChiTieu(id);
      expect(await controller.fetchChiTieu(), isEmpty);
    },
  );

  test(
    'Đăng ký, đăng nhập đúng/sai, email trùng và mật khẩu có salt',
    () async {
      final controller = TaiKhoanController();
      const password = "MatKhau'123";
      expect(
        await controller.register('  Bao@example.com  ', password),
        isTrue,
      );
      expect(await controller.isEmailExist('BAO@EXAMPLE.COM'), isTrue);
      expect(await controller.register('bao@example.com', 'Khac123'), isFalse);
      expect(await controller.signIn('BAO@EXAMPLE.COM', password), isTrue);
      expect(await controller.signIn('bao@example.com', 'sai'), isFalse);
      expect(await controller.signIn('chuaco@example.com', password), isFalse);
      expect(await controller.signIn("' OR 1=1 --", password), isFalse);
      expect(
        await controller.signIn('bao@example.com', "' OR 1=1 --"),
        isFalse,
      );

      expect(await controller.register('ban@example.com', password), isTrue);
      final rows = await (await helper.database).query(
        'tai_khoan',
        orderBy: 'id',
      );
      expect(rows.length, 2);
      expect(rows.first.containsKey('password'), isFalse);
      expect(rows.first['passwordHash'], isNot(password));
      expect(rows.first['passwordHash'], isNot(rows.last['passwordHash']));
      expect(rows.first['salt'], isNot(rows.last['salt']));
    },
  );

  test('Dữ liệu của cả bốn bài vẫn còn sau khi đóng và mở database', () async {
    await TaskController().insertTask(
      const Task(title: 'SQLite', description: 'Dữ liệu lưu bền vững'),
    );
    await SinhVienController().insertSinhVien(
      SinhVien(name: 'Trần Dương Gia Bảo', email: 'bao@example.com'),
    );
    await ChiTieuController().insertChiTieu(
      ChiTieu(noiDung: 'Ăn trưa', soTien: 35000),
    );
    await TaiKhoanController().register('giabao@example.com', 'Bao123');
    await helper.close();

    expect((await TaskController().fetchTasks()).single.title, 'SQLite');
    expect(
      (await SinhVienController().fetchSinhVien()).single.name,
      'Trần Dương Gia Bảo',
    );
    expect((await ChiTieuController().fetchChiTieu()).single.soTien, 35000);
    expect(
      await TaiKhoanController().signIn('giabao@example.com', 'Bao123'),
      isTrue,
    );
    expect(File('${tempDirectory.path}/week9.db').existsSync(), isTrue);
  });
}
