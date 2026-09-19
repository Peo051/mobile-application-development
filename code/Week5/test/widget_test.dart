import 'package:flutter_test/flutter_test.dart';
import 'package:week5/main.dart';

void main() {
  testWidgets('Kiem tra render giao dien Qua cua Vinh', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Kiem tra tieu de tren AppBar
    expect(find.text('Quà của Vinh (7)'), findsOneWidget);

    // Kiem tra 2 the thong tin
    expect(find.text('1.955 Xu'), findsOneWidget);
    expect(find.text('4 thẻ quà'), findsOneWidget);

    // Kiem tra cac the qua
    expect(find.text('CGV -'), findsOneWidget);
    expect(find.text('Giảm 100K'), findsOneWidget);
    expect(find.text('Tặng 100k'), findsOneWidget);
    expect(find.text('Hoàn 15k'), findsOneWidget);
    expect(find.text('Giảm 10K'), findsOneWidget);
    expect(find.text('Thu thập'), findsOneWidget);
  });
}
