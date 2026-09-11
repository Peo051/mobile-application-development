import 'package:flutter/material.dart';

class StudentPage extends StatelessWidget {
  const StudentPage({super.key});

  Widget infoText(String text, {required Color color, bool bold = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: color,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
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
        title: const Text('Thông tin sinh viên'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Ảnh sinh viên
              Center(
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/student.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              infoText('Họ và tên: Nguyễn Văn A', color: Colors.indigo),

              infoText('MSSV: 2001221234', color: Colors.red),

              infoText('Lớp: 13DHTH02', color: Colors.red),

              infoText('Khóa: 13 Đại học', color: Colors.red),

              infoText('Ngành: Công nghệ thông tin', color: Colors.red),

              infoText(
                'Trường: Đại học Công Thương\nThành phố Hồ Chí Minh',
                color: Colors.red,
                bold: false,
              ),

              const SizedBox(height: 25),

              Center(
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Trở về'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
