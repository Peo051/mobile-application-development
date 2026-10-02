import 'package:flutter_test/flutter_test.dart';
import 'package:week6/main.dart';

void main() {
  testWidgets('Week 6 Multimedia smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const Week6MultimediaApp());
    expect(find.text('Tuần 6: Multimedia'), findsOneWidget);
    expect(find.text('Bài tập 1: Media Picker App'), findsOneWidget);
  });
}
