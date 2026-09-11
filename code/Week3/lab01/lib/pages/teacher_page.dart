import 'package:flutter/material.dart';

class TeacherPage extends StatelessWidget {
  const TeacherPage({super.key});

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
        title: const Text('Thông tin giảng viên'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Center(
                child: Image.asset(
                  'assets/images/teacher.jpg',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 25),

              infoText('Giảng viên Trần Thị A', color: Colors.indigo),

              infoText('Khoa: Công nghệ Thông tin', color: Colors.red),

              infoText('Học hàm: Thạc sỹ', color: Colors.red),

              infoText('Chuyên ngành: CNPM', color: Colors.green),

              infoText(
                'Giảng dạy: Nhập môn lập trình,\n'
                'Lập trình Windows, Lập trình web...',
                color: Colors.blue,
              ),

              const SizedBox(height: 30),

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
