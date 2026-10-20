import 'package:flutter/material.dart';

import '../services/notification_service.dart';
import 'vocabulary_home_screen.dart';
import 'vocabulary_quiz_screen.dart';
import 'vocabulary_reminders_screen.dart';
import 'vocabulary_study_screen.dart';

class VocabularyAppScreen extends StatefulWidget {
  const VocabularyAppScreen({super.key, required this.notificationService});

  final NotificationService notificationService;

  @override
  State<VocabularyAppScreen> createState() => _VocabularyAppScreenState();
}

class _VocabularyAppScreenState extends State<VocabularyAppScreen> {
  static const List<String> _menuItems = [
    'Trang chính',
    'Học từ',
    'Kiểm tra từ',
    'Lịch nhắc',
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final title = switch (_selectedIndex) {
      0 => 'Ứng dụng học từ vựng',
      1 => 'Ôn tập từ mới',
      2 => 'Trắc nghiệm Đúng / Sai',
      _ => 'Lịch nhắc',
    };

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    child: Icon(Icons.school_outlined),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Trợ lý học từ vựng',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            for (var index = 0; index < _menuItems.length; index++)
              ListTile(
                selected: _selectedIndex == index,
                leading: Icon(_iconForMenu(index)),
                title: Text(_menuItems[index]),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = index);
                },
              ),
          ],
        ),
      ),
      body: KeyedSubtree(key: ValueKey(_selectedIndex), child: _buildContent()),
    );
  }

  IconData _iconForMenu(int index) {
    return switch (index) {
      0 => Icons.home_outlined,
      1 => Icons.format_list_bulleted,
      2 => Icons.fact_check_outlined,
      _ => Icons.notifications_none,
    };
  }

  Widget _buildContent() {
    return switch (_selectedIndex) {
      0 => VocabularyHomeScreen(
        notificationService: widget.notificationService,
      ),
      1 => VocabularyStudyScreen(
        notificationService: widget.notificationService,
      ),
      2 => VocabularyQuizScreen(
        onExit: () => setState(() => _selectedIndex = 0),
      ),
      _ => VocabularyRemindersScreen(
        notificationService: widget.notificationService,
      ),
    };
  }
}
