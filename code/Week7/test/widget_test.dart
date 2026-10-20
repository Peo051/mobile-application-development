import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:week7/main.dart';
import 'package:week7/models/favorite_route.dart';
import 'package:week7/services/map_service.dart';

void main() {
  testWidgets('Kiểm tra hiển thị giao diện chính MapApp', (WidgetTester tester) async {
    // Khởi tạo app
    await tester.pumpWidget(const MapApp());

    // Kiểm tra AppBar
    expect(find.text('Bài 07: Google Maps Navigation'), findsOneWidget);

    // Kiểm tra danh sách các bài tập
    expect(find.text('Bài tập 1: Map Navigator'), findsOneWidget);
    expect(find.text('Bài tập 2: Route Finder'), findsOneWidget);
    expect(find.text('Bài 4 Trên Lớp & Về Nhà (Toàn diện)'), findsOneWidget);
  });

  test('Kiểm tra thuật toán giải mã Polyline (decodePolyline)', () {
    // Chuỗi polyline mẫu Google đã mã hóa
    // "_p~iF~ps|U_ulLnnqC_mqNvxq`@"
    const sampleEncoded = '_p~iF~ps|U_ulLnnqC_mqNvxq`@';
    final points = MapService.decodePolyline(sampleEncoded);

    expect(points.isNotEmpty, true);
    expect(points.first, isA<LatLng>());
  });

  test('Kiểm tra FavoriteRoute toMap và fromMap', () {
    final route = FavoriteRoute(
      id: 1,
      title: 'Nhà đến Trường',
      originAddress: 'Quận 1',
      destinationAddress: 'Thủ Đức',
      originLat: 10.7769,
      originLng: 106.7009,
      destLat: 10.8500,
      destLng: 106.7700,
      transportMode: 'driving',
      distance: '15 km',
      duration: '30 mins',
      encodedPolyline: 'test_poly',
      createdAt: '2026-10-13 12:00',
    );

    final map = route.toMap();
    expect(map['title'], 'Nhà đến Trường');
    expect(map['origin_lat'], 10.7769);

    final restored = FavoriteRoute.fromMap(map);
    expect(restored.title, route.title);
    expect(restored.destLat, 10.8500);
    expect(restored.transportMode, 'driving');
  });
}
