import 'package:flutter/material.dart';

class ThesisPage extends StatelessWidget {
  const ThesisPage({super.key});

  Widget infoText(String label, String value, {Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 17, color: Colors.black),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
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
        title: const Text('Thông tin khoá luận'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            infoText('Mã đề tài', 'DT001', color: Colors.indigo),

            infoText(
              'Tên đề tài',
              'Xây dựng ứng dụng quản lý cửa hàng thú cưng',
              color: Colors.blue,
            ),

            infoText('Số lượng sinh viên tối đa', '3 sinh viên'),

            infoText('Chuyên ngành', 'Kỹ thuật phần mềm', color: Colors.green),

            infoText(
              'Giảng viên hướng dẫn',
              'ThS. Nguyễn Văn A',
              color: Colors.deepPurple,
            ),

            infoText(
              'Yêu cầu đề tài',
              'Sinh viên có kiến thức về Flutter, '
                  'Dart, cơ sở dữ liệu và phân tích thiết kế hệ thống.',
            ),
          ],
        ),
      ),
    );
  }
}
