import 'package:flutter/material.dart';

import 'screens/bai1_map_navigator_screen.dart';
import 'screens/bai2_route_finder_screen.dart';
import 'screens/bai4_route_finder_pro_screen.dart';

void main() {
  runApp(const MapApp());
}

class MapApp extends StatelessWidget {
  const MapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bài 07: Google Maps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 07: Google Maps Navigation'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Tiêu đề giới thiệu
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thực Hành Lập Trình Di Động',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Chương 4: Multimedia - Bài 07: Google Maps & Điều hướng tuyến đường',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Chọn một bài tập bên dưới để trải nghiệm:',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Mục Bài tập 1
            _buildExerciseCard(
              context: context,
              title: 'Bài tập 1: Map Navigator',
              subtitle: 'Hiển thị bản đồ Google Maps, vị trí mặc định TP.HCM, định vị GPS vị trí hiện tại và di chuyển camera.',
              icon: Icons.map,
              color: Colors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Bai1MapNavigatorScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // Mục Bài tập 2
            _buildExerciseCard(
              context: context,
              title: 'Bài tập 2: Route Finder',
              subtitle: 'Nhập tọa độ điểm đi và điểm đến, kiểm tra hợp lệ, hiển thị Markers và vẽ đường Polyline (Directions API).',
              icon: Icons.alt_route,
              color: Colors.indigo,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Bai2RouteFinderScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // Mục Bài tập 4 trên lớp & Bài tập về nhà
            _buildExerciseCard(
              context: context,
              title: 'Bài 4 Trên Lớp & Về Nhà (Toàn diện)',
              subtitle: '• Lấy GPS làm điểm đích\n• Chạm bản đồ chọn điểm\n• Tìm địa điểm (Places API)\n• Geocoding địa chỉ văn bản\n• Chọn phương tiện (ô tô, xe máy, đi bộ)\n• Hiển thị khoảng cách, thời gian\n• Lưu / xem / xóa tuyến yêu thích bằng SQLite',
              icon: Icons.navigation,
              color: Colors.deepOrange,
              isHighlight: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Bai4RouteFinderProScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isHighlight = false,
  }) {
    return Card(
      elevation: isHighlight ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isHighlight
            ? BorderSide(color: color.withValues(alpha: 0.5), width: 1.5)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isHighlight ? color : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
