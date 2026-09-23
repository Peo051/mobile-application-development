import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week5/main.dart';
import 'package:week5/bai_03.dart';

void main() {
  testWidgets('Kiem tra luong hoat dong Bai tap 04 - Cua hang dien thoai', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // 1. Kiem tra Man hinh Gioi thieu
    expect(find.text('Cửa hàng điện thoại'), findsOneWidget);
    expect(
      find.text('140 Lê Trọng Tấn, Tân Phú, TP.Hồ Chí Minh'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);

    // 2. Bam nut mui ten de vao Cua hang
    await tester.tap(find.byIcon(Icons.arrow_forward));
    await tester.pumpAndSettle();

    // 3. Kiem tra Man hinh Cua hang
    expect(find.text('Cửa hàng điện thoại'), findsOneWidget);
    expect(find.text('Chọn sản phẩm bạn muốn sử dụng'), findsOneWidget);
    expect(find.text('Sản phẩm được lựa chọn nhiều nhất'), findsOneWidget);
    expect(find.text('Điện thoại 01'), findsOneWidget);
    expect(find.text('1200.0'), findsOneWidget);

    // 4. Them san pham vao gio hang (bam nut + dau tien)
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pumpAndSettle();

    // Kiem tra Dialog Xac nhan
    expect(find.text('Xác nhận'), findsOneWidget);
    expect(find.text('Bạn vừa thêm sản phẩm vào Giỏ hàng'), findsOneWidget);
    expect(find.text('Không'), findsOneWidget);
    expect(find.text('Đồng ý'), findsOneWidget);

    // Bam Dong y
    await tester.tap(find.text('Đồng ý'));
    await tester.pumpAndSettle();

    // 5. Mo Gio hang tu AppBar
    await tester.tap(find.byIcon(Icons.shopping_cart));
    await tester.pumpAndSettle();

    // Kiem tra Man hinh Gio hang
    expect(
      find.text('Giỏ hàng của bạn'),
      findsNWidgets(2),
    ); // AppBar va subheader
    expect(find.text('Điện thoại 01'), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);
    expect(find.text('Thanh toán'), findsOneWidget);

    // 6. Bam nut Thanh toan
    await tester.tap(find.text('Thanh toán'));
    await tester.pumpAndSettle();

    expect(find.text('Thanh toán'), findsNWidgets(2)); // Tieu de dialog va nut
    expect(find.text('Bạn đã thanh toán xong giỏ hàng'), findsOneWidget);

    // Dong dialog thanh toan
    await tester.tap(find.text('Đồng ý'));
    await tester.pumpAndSettle();

    // Gio hang tro ve rong
    expect(
      find.text('Bạn chưa có sản phẩm nào vô giỏ hàng!!!!'),
      findsOneWidget,
    );

    // 7. Quay lai Cua hang
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // 8. Mo Drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Kiem tra Drawer
    expect(find.text('Vũ Văn Vĩnh'), findsOneWidget);
    expect(find.text('vinhvv@huit.edu.vn'), findsOneWidget);
    expect(find.text('Cửa hàng'), findsOneWidget);
    expect(find.text('Giỏ hàng'), findsOneWidget);
    expect(find.text('Thoát'), findsOneWidget);

    // Bam Thoat de ve man hinh Gioi thieu
    await tester.tap(find.text('Thoát'));
    await tester.pumpAndSettle();

    expect(
      find.text('140 Lê Trọng Tấn, Tân Phú, TP.Hồ Chí Minh'),
      findsOneWidget,
    );
  });

  testWidgets('Kiem tra render giao dien Bai tap 03 - Qua cua Vinh', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: Bai03Page()));
    await tester.pumpAndSettle();

    expect(find.text('Quà của Vinh (7)'), findsOneWidget);
    expect(find.text('1.955 Xu'), findsOneWidget);
    expect(find.text('4 thẻ quà'), findsOneWidget);
    expect(find.text('CGV -'), findsOneWidget);
  });
}
