import 'package:flutter/material.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  Widget infoText(
    String label,
    String value, {
    Color valueColor = Colors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
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
              style: TextStyle(color: valueColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget wImage(String path) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(path, fit: BoxFit.cover),
      ),
    );
  }

  Widget memberCard({
    required String mssv,
    required String name,
    required String role,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            infoText('Mã sinh viên', mssv, valueColor: Colors.indigo),
            infoText('Tên sinh viên', name, valueColor: Colors.blue),
            infoText(
              'Vai trò',
              role,
              valueColor: role == 'Nhóm trưởng' ? Colors.orange : Colors.green,
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
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Thông tin nhóm'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              infoText('Mã nhóm', 'NHOM01', valueColor: Colors.indigo),

              infoText(
                'Tên nhóm',
                'Nhóm phát triển phần mềm',
                valueColor: Colors.blue,
              ),

              infoText('Số lượng thành viên', '3', valueColor: Colors.green),

              const SizedBox(height: 20),

              const Text(
                'Danh sách thành viên',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 15),

              memberCard(
                mssv: '2001230001',
                name: 'Nguyễn Văn A',
                role: 'Nhóm trưởng',
              ),

              memberCard(
                mssv: '2001230002',
                name: 'Trần Thị B',
                role: 'Thành viên',
              ),

              memberCard(
                mssv: '2001230003',
                name: 'Lê Văn C',
                role: 'Thành viên',
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
