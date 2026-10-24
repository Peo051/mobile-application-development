// Trần Dương Gia Bảo - 2001240039
import 'package:flutter/material.dart';

import 'chi_tieu_screen.dart';
import 'sign_in_screen.dart';
import 'sinh_vien_screen.dart';
import 'task_screen.dart';

class Bai9MenuScreen extends StatelessWidget {
  const Bai9MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bài 09: Cơ sở dữ liệu SQLite')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Chọn phần thực hành',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _exercise(
            context,
            'Quản lý công việc',
            'Bài hướng dẫn và bài tập tại lớp 1',
            Icons.checklist,
            const TaskScreen(),
          ),
          _exercise(
            context,
            'Quản lý sinh viên',
            'Bài tập tại lớp 2',
            Icons.school_outlined,
            const SinhVienScreen(),
          ),
          _exercise(
            context,
            'Quản lý chi tiêu',
            'Bài tập về nhà 1',
            Icons.payments_outlined,
            const ChiTieuScreen(),
          ),
          _exercise(
            context,
            'Đăng nhập và đăng ký',
            'Bài tập về nhà 2',
            Icons.person_outline,
            const SignInScreen(),
          ),
        ],
      ),
    );
  }

  Widget _exercise(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Widget screen,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        ),
      ),
    );
  }
}
