import 'package:flutter/material.dart';

import '../services/notification_service.dart';
import 'daily_tasks_screen.dart';
import 'notification_demo_screen.dart';
import 'todo_screen.dart';
import 'vocabulary_app_screen.dart';

class Bai8MenuScreen extends StatelessWidget {
  const Bai8MenuScreen({super.key, required this.notificationService});

  final NotificationService notificationService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 08: Notification và File'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Chọn phần thực hành',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _ExerciseCard(
            title: 'Bài tập 1: Thông báo',
            subtitle: 'Gửi thông báo ngay, sau 2 phút và sau 10 phút.',
            icon: Icons.notifications_active_outlined,
            color: Colors.indigo,
            onTap: () => _open(
              context,
              NotificationDemoScreen(notificationService: notificationService),
            ),
          ),
          _ExerciseCard(
            title: 'Bài tập 2: Todo lưu vào file',
            subtitle: 'Chọn thời gian và lưu công việc vào todo.txt.',
            icon: Icons.checklist,
            color: Colors.teal,
            onTap: () => _open(
              context,
              TodoScreen(notificationService: notificationService),
            ),
          ),
          _ExerciseCard(
            title: 'Bài tập 3: Todo có nhắc việc',
            subtitle: 'Lưu công việc, lên lịch và hủy lời nhắc.',
            icon: Icons.alarm,
            color: Colors.deepOrange,
            onTap: () => _open(
              context,
              TodoScreen(
                notificationService: notificationService,
                withReminders: true,
              ),
            ),
          ),
          _ExerciseCard(
            title: 'Bài tập 4A: Học từ vựng',
            subtitle: 'Lưu từ, luyện tập, kiểm tra và quản lý lịch nhắc.',
            icon: Icons.menu_book_outlined,
            color: Colors.blue,
            onTap: () => _open(
              context,
              VocabularyAppScreen(notificationService: notificationService),
            ),
          ),
          _ExerciseCard(
            title: 'Bài tập 4B: Nhiệm vụ mỗi ngày',
            subtitle: 'Thêm nhiệm vụ, đặt giờ nhắc và xác nhận hoàn thành.',
            icon: Icons.today_outlined,
            color: Colors.purple,
            onTap: () => _open(
              context,
              DailyTasksScreen(notificationService: notificationService),
            ),
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.13),
          foregroundColor: color,
          child: Icon(icon),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
