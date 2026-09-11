import 'package:flutter/material.dart';

class MajorPage extends StatelessWidget {
  const MajorPage({super.key});

  Widget majorCard({
    required IconData icon,
    required String name,
    required String code,
    required String description,
    required String knowledge,
    required String jobs,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Icon(icon, size: 70, color: Colors.blue)),

            const SizedBox(height: 12),

            Center(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),

            const SizedBox(height: 15),

            infoText('Mã ngành', code),
            infoText('Giới thiệu', description),
            infoText('Kiến thức đào tạo', knowledge),
            infoText('Cơ hội nghề nghiệp', jobs),
          ],
        ),
      ),
    );
  }

  Widget infoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Giới thiệu ngành học'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'KHOA CÔNG NGHỆ THÔNG TIN',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Trường Đại học Công Thương\nThành phố Hồ Chí Minh',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 25),

            // Ngành CNTT
            majorCard(
              icon: Icons.computer,
              name: 'CÔNG NGHỆ THÔNG TIN',
              code: '7480201',
              description:
                  'Ngành Công nghệ Thông tin đào tạo kiến thức và kỹ năng '
                  'về phát triển phần mềm, hệ thống thông tin, cơ sở dữ liệu, '
                  'mạng máy tính và các công nghệ hiện đại.',
              knowledge:
                  'Lập trình, cơ sở dữ liệu, phát triển Web/Mobile, '
                  'phân tích thiết kế hệ thống, trí tuệ nhân tạo và '
                  'công nghệ phần mềm.',
              jobs:
                  'Lập trình viên, kỹ sư phần mềm, Web Developer, '
                  'Mobile Developer, kiểm thử phần mềm, quản trị hệ thống...',
            ),

            majorCard(
              icon: Icons.security,
              name: 'AN TOÀN THÔNG TIN',
              code: '7480202',
              description:
                  'Ngành An toàn Thông tin đào tạo kiến thức về bảo vệ '
                  'hệ thống máy tính, mạng và dữ liệu trước các nguy cơ '
                  'tấn công và truy cập trái phép.',
              knowledge:
                  'An ninh mạng, mật mã học, bảo mật hệ thống, '
                  'bảo mật Web, kiểm thử xâm nhập và quản lý '
                  'an toàn thông tin.',
              jobs:
                  'Kỹ sư an ninh mạng, chuyên viên bảo mật, '
                  'Security Engineer, SOC Analyst, Pentester...',
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
