import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cơ sở vật chất HUIT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      home: const HuitHomePage(),
    );
  }
}

class HuitHomePage extends StatefulWidget {
  const HuitHomePage({super.key});

  @override
  State<HuitHomePage> createState() => _HuitHomePageState();
}

class _HuitHomePageState extends State<HuitHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [TongQuanPage(), CoSoPage(), TienIchPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cơ sở vật chất HUIT',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Tổng quan'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Cơ sở'),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Tiện ích',
          ),
        ],
      ),
    );
  }
}

// =======================================================
// TRANG 1: TỔNG QUAN
// =======================================================

class TongQuanPage extends StatelessWidget {
  const TongQuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh đầu trang
          Image.asset(
            'assets/images/hinh-cong-truong-huit.jpg',
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 220,
                color: Colors.blue.shade100,
                alignment: Alignment.center,
                child: const Text(
                  'HUIT',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Giới thiệu cơ sở vật chất',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Trường Đại học Công Thương Thành phố Hồ Chí Minh '
                  '(HUIT) hiện có 7 cơ sở giáo dục, đào tạo và dịch vụ '
                  'với tổng diện tích đất hơn 6 ha.',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    _infoBox(
                      icon: Icons.location_city,
                      number: '7',
                      title: 'Cơ sở',
                    ),
                    const SizedBox(width: 10),
                    _infoBox(
                      icon: Icons.landscape,
                      number: '> 6',
                      title: 'Ha đất',
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    _infoBox(
                      icon: Icons.meeting_room,
                      number: '120',
                      title: 'Phòng học LT',
                    ),
                    const SizedBox(width: 10),
                    _infoBox(
                      icon: Icons.computer,
                      number: '21',
                      title: 'Phòng TH CNTT',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox({
    required IconData icon,
    required String number,
    required String title,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade100),
        ),
        child: Column(
          children: [
            Icon(icon, size: 35, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              number,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// =======================================================
// TRANG 2: CƠ SỞ
// =======================================================

class CoSoPage extends StatelessWidget {
  const CoSoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _campusCard(
          icon: Icons.school,
          title: 'Cơ sở 1',
          subtitle: 'Trụ sở chính',
          address: '140 Lê Trọng Tấn, P. Tây Thạnh',
          description:
              '120 phòng học lý thuyết, 21 phòng thực hành CNTT, '
              'thư viện và các không gian học tập.',
        ),

        _campusCard(
          icon: Icons.science,
          title: 'Cơ sở 2',
          subtitle: 'Trung tâm Thí nghiệm - Thực hành',
          address: '93 Tân Kỳ Tân Quý, P. Tân Sơn Nhì',
          description:
              'Diện tích khoảng 4.000 m², có khoảng 70 phòng '
              'thực hành và thí nghiệm.',
        ),

        _campusCard(
          icon: Icons.sports_soccer,
          title: 'Cơ sở 3',
          subtitle: 'Giáo dục thể chất và Quốc phòng an ninh',
          address: '73/1 Nguyễn Đỗ Cung, P. Tây Thạnh',
          description:
              'Có sân bóng mini, 2 sân bóng chuyền và nhà '
              'thi đấu cầu lông.',
        ),

        _campusCard(
          icon: Icons.apartment,
          title: 'Cơ sở 7',
          subtitle: 'Trung tâm Ký túc xá',
          address: '102-104-106 Nguyễn Quý Anh',
          description:
              'Tòa nhà 9 tầng với 96 phòng ở sinh viên, '
              'có điện, nước và Wi-Fi.',
        ),
      ],
    );
  }

  Widget _campusCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String address,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(blurRadius: 4, offset: Offset(0, 2), color: Colors.black12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 38, color: Colors.blue),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text('Địa chỉ: $address', style: const TextStyle(fontSize: 14)),

          const SizedBox(height: 8),

          Text(description, style: const TextStyle(fontSize: 15, height: 1.4)),
        ],
      ),
    );
  }
}

// =======================================================
// TRANG 3: TIỆN ÍCH
// =======================================================

class TienIchPage extends StatelessWidget {
  const TienIchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text(
          'Các tiện ích nổi bật',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),

        const SizedBox(height: 15),

        _utilityCard(
          Icons.menu_book,
          'Thư viện',
          'Khu tự học, khu đọc sách, phòng máy tính, '
              'hơn 10.000 đầu sách và thư viện điện tử.',
        ),

        _utilityCard(
          Icons.computer,
          'Phòng thực hành CNTT',
          'Cơ sở 1 có 21 phòng thực hành CNTT với khoảng '
              '1.000 máy tính kết nối mạng.',
        ),

        _utilityCard(
          Icons.sports,
          'Khu thể thao',
          'Cơ sở 3 có sân bóng mini, sân bóng chuyền '
              'và nhà thi đấu cầu lông.',
        ),

        _utilityCard(
          Icons.bed,
          'Ký túc xá',
          'Ký túc xá có 96 phòng ở sinh viên, '
              'cùng các tiện ích phục vụ sinh hoạt.',
        ),

        _utilityCard(
          Icons.meeting_room,
          'Phòng học',
          'Các phòng học được trang bị máy lạnh, '
              'máy chiếu và Wi-Fi tốc độ cao.',
        ),
      ],
    );
  }

  Widget _utilityCard(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 35, color: Colors.blue),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,
                  style: const TextStyle(fontSize: 15, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
