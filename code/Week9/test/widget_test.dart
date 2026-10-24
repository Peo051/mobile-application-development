// Trần Dương Gia Bảo - 2001240039
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:week9/controllers/chi_tieu_controller.dart';
import 'package:week9/controllers/sinh_vien_controller.dart';
import 'package:week9/controllers/task_controller.dart';
import 'package:week9/main.dart';
import 'package:week9/utils/database_helper.dart';

final _captureKey = GlobalKey();

// SQLite FFI chạy thật ngoài fake clock của widget test.
Future<void> waitFor(WidgetTester tester, bool Function() ready) async {
  for (var count = 0; count < 200; count++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 25)),
    );
    await tester.pump(const Duration(milliseconds: 50));
    if (find.byType(CircularProgressIndicator).evaluate().isEmpty && ready()) {
      await tester.pumpAndSettle();
      return;
    }
  }
  fail('Giao diện không đạt trạng thái mong đợi.');
}

Finder rowText(String text) =>
    find.descendant(of: find.byType(ListTile), matching: find.text(text));

Future<void> tap(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

Future<void> fillForm(WidgetTester tester, List<String> values) async {
  for (var i = 0; i < values.length; i++) {
    await tester.enterText(find.byType(TextFormField).at(i), values[i]);
  }
}

Future<void> openApp(WidgetTester tester) async {
  if (Platform.environment['WEEK9_SCREENSHOT_DIR'] != null) {
    debugDisableShadows = false;
  }
  tester.view.physicalSize = const Size(400, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    RepaintBoundary(key: _captureKey, child: const Week9App()),
  );
  await tester.pumpAndSettle();
}

// Chỉ xuất ảnh khi người chạy test đặt WEEK9_SCREENSHOT_DIR.
Future<void> capture(WidgetTester tester, String name) async {
  final directory = Platform.environment['WEEK9_SCREENSHOT_DIR'];
  if (directory == null) return;
  FocusManager.instance.primaryFocus?.unfocus();
  tester.testTextInput.hide();
  await tester.pumpAndSettle();
  final boundary =
      _captureKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    await Directory(directory).create(recursive: true);
    await File('$directory/$name.png').writeAsBytes(data!.buffer.asUint8List());
    image.dispose();
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDirectory;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    // Dùng font có sẵn trong Flutter SDK để test kích thước màn hình chính xác.
    final sdk = Platform.environment['WEEK9_FLUTTER_SDK'];
    final fontDirectory = sdk != null
        ? '$sdk/bin/cache/artifacts/material_fonts'
        : '${File(Platform.resolvedExecutable).parent.parent.parent.path}/material_fonts';
    final icons = FontLoader('MaterialIcons');
    icons.addFont(
      Future.value(
        ByteData.sublistView(
          File('$fontDirectory/MaterialIcons-Regular.otf').readAsBytesSync(),
        ),
      ),
    );
    await icons.load();
    final loader = FontLoader('Roboto');
    for (final name in ['Roboto-Regular.ttf', 'Roboto-Medium.ttf']) {
      final bytes = File('$fontDirectory/$name').readAsBytesSync();
      loader.addFont(Future.value(ByteData.sublistView(bytes)));
    }
    await loader.load();
  });

  setUp(() async {
    await DatabaseHelper().close();
    tempDirectory = await Directory.systemTemp.createTemp('week9_widget_');
    await databaseFactory.setDatabasesPath(tempDirectory.path);
  });

  tearDown(() async {
    await DatabaseHelper().close();
    await tempDirectory.delete(recursive: true);
  });

  testWidgets('Task thêm, chặn trùng, hoàn thành, đổi màu và xóa', (
    tester,
  ) async {
    await openApp(tester);
    await capture(tester, '01_menu');
    await tap(tester, find.text('Quản lý công việc'));
    await waitFor(
      tester,
      () => find.text('Chưa có công việc.').evaluate().isNotEmpty,
    );
    await tap(tester, find.text('Add Task'));
    expect(find.text('Vui lòng nhập Title.'), findsOneWidget);
    ScaffoldMessenger.of(
      tester.element(find.byType(Scaffold).last),
    ).removeCurrentSnackBar();

    Future<void> addTask(String title, String description) async {
      await tester.enterText(find.byType(TextField).at(0), title);
      await tester.enterText(find.byType(TextField).at(1), description);
      await tester.tap(find.text('Add Task'));
      await waitFor(tester, () => rowText(title).evaluate().isNotEmpty);
    }

    await addTask('Học Flutter', 'Hoàn thành bài thực hành SQLite');
    await addTask('Ôn tập CSDL', 'Ôn các câu lệnh thêm, sửa, xóa');
    await capture(tester, '02_task_list');
    await tester.enterText(find.byType(TextField).at(0), 'Học Flutter');
    await tester.tap(find.text('Add Task'));
    await waitFor(
      tester,
      () => find.text('Công việc này đã tồn tại.').evaluate().isNotEmpty,
    );
    expect(
      (await tester.runAsync(() => TaskController().fetchTasks()))!.length,
      2,
    );
    ScaffoldMessenger.of(
      tester.element(find.byType(Scaffold).last),
    ).removeCurrentSnackBar();
    await tester.enterText(find.byType(TextField).at(0), '');
    await tap(tester, find.byTooltip('Task Details').first);
    expect(find.text('Task Details'), findsOneWidget);
    expect(find.text('Hoàn thành bài thực hành SQLite'), findsOneWidget);
    await capture(tester, '03_task_detail');
    await tester.tap(find.byType(Checkbox));
    await waitFor(
      tester,
      () =>
          find.text('Task List').evaluate().isNotEmpty &&
          tester
                  .widget<Card>(
                    find.ancestor(
                      of: rowText('Học Flutter'),
                      matching: find.byType(Card),
                    ),
                  )
                  .color ==
              Colors.green[100],
    );
    expect(
      (await tester.runAsync(
        () => TaskController().fetchTasks(),
      ))!.first.isCompleted,
      isTrue,
    );
    final card = tester.widget<Card>(
      find.ancestor(of: rowText('Học Flutter'), matching: find.byType(Card)),
    );
    expect(card.color, Colors.green[100]);
    await capture(tester, '04_task_completed');
    await tester.tap(find.text('Delete Task'));
    await waitFor(tester, () => rowText('Ôn tập CSDL').evaluate().isEmpty);
    expect(rowText('Học Flutter'), findsOneWidget);
    await tester.tap(find.text('Delete Task'));
    await waitFor(
      tester,
      () => find.text('Chưa có công việc.').evaluate().isNotEmpty,
    );
    expect(
      tester
          .widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Delete Task'),
          )
          .onPressed,
      isNull,
    );
    expect(tester.takeException(), isNull);
    debugDisableShadows = true;
  });

  testWidgets('Sinh viên kiểm tra form, hủy, thêm, tìm, cập nhật và xóa', (
    tester,
  ) async {
    await openApp(tester);
    await tap(tester, find.text('Quản lý sinh viên'));
    await waitFor(
      tester,
      () => find.text('Chưa có sinh viên.').evaluate().isNotEmpty,
    );
    await tap(tester, find.byTooltip('Thêm Sinh Viên'));
    await tap(tester, find.text('Lưu'));
    expect(find.text('Vui lòng nhập tên sinh viên.'), findsOneWidget);
    expect(find.text('Vui lòng nhập email hợp lệ.'), findsOneWidget);
    await tap(tester, find.text('Hủy'));

    Future<void> addForm(String name, String email) async {
      await tap(tester, find.byTooltip('Thêm Sinh Viên'));
      await fillForm(tester, [name, email]);
    }

    await addForm('Nguyễn Văn A', 'nva@example.com');
    await capture(tester, '06_student_add');
    await tap(tester, find.text('Hủy'));
    expect(
      (await tester.runAsync(() => SinhVienController().fetchSinhVien()))!,
      isEmpty,
    );
    await addForm('Nguyễn Văn A', 'nva@example.com');
    await tester.tap(find.text('Lưu'));
    await waitFor(tester, () => rowText('Nguyễn Văn A').evaluate().isNotEmpty);
    await addForm('Trần Thị B', 'tranb@example.com');
    await tester.tap(find.text('Lưu'));
    await waitFor(tester, () => rowText('Trần Thị B').evaluate().isNotEmpty);
    await capture(tester, '05_student_list');
    await tester.enterText(find.byType(TextField).first, 'tranb@');
    await waitFor(tester, () => rowText('Nguyễn Văn A').evaluate().isEmpty);
    expect(rowText('Trần Thị B'), findsOneWidget);
    await tester.tap(find.byTooltip('Xóa tìm kiếm'));
    await waitFor(tester, () => rowText('Nguyễn Văn A').evaluate().isNotEmpty);
    await tap(tester, rowText('Trần Thị B'));
    await capture(tester, '07_student_detail');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'tranb.new@example.com',
    );
    await tester.tap(find.text('Cập nhật'));
    await waitFor(
      tester,
      () => rowText('tranb.new@example.com').evaluate().isNotEmpty,
    );
    expect(
      (await tester.runAsync(
        () => SinhVienController().fetchSinhVien(),
      ))!.last.email,
      'tranb.new@example.com',
    );
    await tap(tester, rowText('Trần Thị B'));
    await tester.enterText(find.byType(TextFormField).at(0), 'Tên chưa lưu');
    await tap(tester, find.text('Hủy'));
    expect(rowText('Trần Thị B'), findsOneWidget);
    expect(rowText('Tên chưa lưu'), findsNothing);
    await tester.tap(find.byTooltip('Xóa sinh viên').first);
    await waitFor(tester, () => rowText('Nguyễn Văn A').evaluate().isEmpty);
    await tester.tap(find.byTooltip('Xóa sinh viên'));
    await waitFor(
      tester,
      () => find.text('Chưa có sinh viên.').evaluate().isNotEmpty,
    );
    expect(tester.takeException(), isNull);
    debugDisableShadows = true;
  });

  testWidgets('Chi tiêu kiểm tra số tiền, thêm, sửa tổng tiền và xóa', (
    tester,
  ) async {
    await openApp(tester);
    await tap(tester, find.text('Quản lý chi tiêu'));
    await waitFor(
      tester,
      () => find.text('Chưa có khoản chi nào.').evaluate().isNotEmpty,
    );
    await tap(tester, find.byTooltip('Thêm khoản chi'));
    await tap(tester, find.text('Lưu'));
    expect(find.text('Vui lòng nhập nội dung chi tiêu.'), findsOneWidget);
    expect(find.text('Số tiền phải là số lớn hơn 0.'), findsOneWidget);
    await fillForm(tester, ['Ăn trưa', '0', '']);
    await tap(tester, find.text('Lưu'));
    expect(find.text('Số tiền phải là số lớn hơn 0.'), findsOneWidget);
    await tap(tester, find.text('Hủy'));

    Future<void> addForm(String name, String money, String note) async {
      await tap(tester, find.byTooltip('Thêm khoản chi'));
      await fillForm(tester, [name, money, note]);
    }

    await addForm('Ăn trưa', '35000', 'Cơm văn phòng');
    await capture(tester, '09_expense_add');
    await tester.tap(find.text('Lưu'));
    await waitFor(tester, () => rowText('Ăn trưa').evaluate().isNotEmpty);
    await addForm('Đi lại', '15000', 'Xe buýt');
    await tester.tap(find.text('Lưu'));
    await waitFor(tester, () => rowText('Đi lại').evaluate().isNotEmpty);
    expect(find.text('Tổng chi tiêu: 50.000 đ'), findsOneWidget);
    await capture(tester, '08_expense_list');
    await tap(tester, rowText('Ăn trưa'));
    await tester.enterText(find.byType(TextFormField).at(1), '40000,5');
    await tester.tap(find.text('Lưu'));
    await waitFor(
      tester,
      () => find.text('Tổng chi tiêu: 55.000,5 đ').evaluate().isNotEmpty,
    );
    expect(
      (await tester.runAsync(
        () => ChiTieuController().fetchChiTieu(),
      ))!.last.soTien,
      40000.5,
    );
    await tester.tap(find.byTooltip('Xóa khoản chi').last);
    await waitFor(tester, () => rowText('Ăn trưa').evaluate().isEmpty);
    expect(find.text('Tổng chi tiêu: 15.000 đ'), findsOneWidget);
    await tester.tap(find.byTooltip('Xóa khoản chi'));
    await waitFor(
      tester,
      () => find.text('Chưa có khoản chi nào.').evaluate().isNotEmpty,
    );
    expect(find.text('Tổng chi tiêu: 0 đ'), findsOneWidget);
    expect(tester.takeException(), isNull);
    debugDisableShadows = true;
  });

  testWidgets('Đăng ký, xác nhận mật khẩu, trùng email và đăng nhập đúng/sai', (
    tester,
  ) async {
    await openApp(tester);
    await tap(tester, find.text('Đăng nhập và đăng ký'));
    await capture(tester, '10_sign_in');
    await tap(tester, find.text('Sign in'));
    expect(find.text('Vui lòng nhập email.'), findsOneWidget);
    expect(find.text('Vui lòng nhập mật khẩu.'), findsOneWidget);
    final registerButton = find.widgetWithText(ElevatedButton, 'Register');
    await tap(tester, registerButton);
    await fillForm(tester, ['giabao@example.com', 'Bao123', 'Bao123']);
    await capture(tester, '11_register');
    await tester.enterText(find.byType(TextFormField).at(2), 'KhongKhop');
    await tap(tester, registerButton);
    expect(find.text('Mật khẩu xác nhận không khớp.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(2), 'Bao123');
    await tester.tap(registerButton);
    await waitFor(
      tester,
      () => find
          .text('Đăng ký thành công. Vui lòng đăng nhập.')
          .evaluate()
          .isNotEmpty,
    );
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).first)
          .controller!
          .text,
      'giabao@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'MatKhauSai');
    tester.view.physicalSize = const Size(320, 640);
    await tester.pump();
    await tester.tap(find.text('Sign in'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    await waitFor(
      tester,
      () => find.text('Email hoặc mật khẩu không đúng.').evaluate().isNotEmpty,
    );
    tester.view.physicalSize = const Size(400, 800);
    await tester.pump();
    await tap(tester, registerButton);
    await fillForm(tester, ['GIABAO@example.com', 'Bao123', 'Bao123']);
    await tester.tap(registerButton);
    await waitFor(
      tester,
      () => find.text('Email này đã được đăng ký.').evaluate().isNotEmpty,
    );
    await tap(tester, find.text('Hủy'));
    await tester.enterText(find.byType(TextFormField).at(1), 'Bao123');
    await tester.tap(find.text('Sign in'));
    await waitFor(
      tester,
      () => find.text('Đăng nhập thành công.').evaluate().isNotEmpty,
    );
    await capture(tester, '12_sign_in_success');
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).at(1))
          .controller!
          .text,
      isEmpty,
    );
    expect(tester.takeException(), isNull);
    debugDisableShadows = true;
  });
}
