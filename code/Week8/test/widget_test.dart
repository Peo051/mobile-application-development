import 'package:flutter_test/flutter_test.dart';
import 'package:week8/main.dart';
import 'package:week8/services/notification_service.dart';

void main() {
  testWidgets('Hiển thị menu Bài 08', (tester) async {
    await tester.pumpWidget(
      Week8App(notificationService: NotificationService.instance),
    );

    expect(find.text('Bài 08: Notification và File'), findsOneWidget);
    expect(find.text('Bài tập 1: Thông báo'), findsOneWidget);
    expect(find.text('Bài tập 2: Todo lưu vào file'), findsOneWidget);
  });
}
