import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/vocabulary_word.dart';
import '../services/file_service.dart';
import '../services/notification_service.dart';
import '../utils/date_formatters.dart';

class VocabularyRemindersScreen extends StatefulWidget {
  const VocabularyRemindersScreen({
    super.key,
    required this.notificationService,
  });

  final NotificationService notificationService;

  @override
  State<VocabularyRemindersScreen> createState() =>
      _VocabularyRemindersScreenState();
}

class _VocabularyRemindersScreenState extends State<VocabularyRemindersScreen> {
  final FileService _fileService = FileService();
  List<VocabularyWord> _reminders = [];
  bool _loading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final words = await _fileService.loadVocabulary();
      final pending = await widget.notificationService.pendingNotifications();
      final pendingIds = pending.map((item) => item.id).toSet();
      final reminders =
          words
              .where(
                (word) =>
                    word.reminderId != null &&
                    word.reminderAt != null &&
                    pendingIds.contains(word.reminderId),
              )
              .toList()
            ..sort((a, b) => a.reminderAt!.compareTo(b.reminderAt!));
      if (mounted) setState(() => _reminders = reminders);
    } catch (error) {
      if (mounted) setState(() => _loadError = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _cancelReminder(VocabularyWord word) async {
    final reminderId = word.reminderId;
    if (reminderId == null) return;

    try {
      await widget.notificationService.cancel(reminderId);
      final words = await _fileService.loadVocabulary();
      final updatedWords = words
          .map((item) => item.id == word.id ? item.withoutReminder() : item)
          .toList();
      await _fileService.saveVocabulary(updatedWords);
      if (!mounted) return;
      setState(() => _reminders.removeWhere((item) => item.id == word.id));
      _showMessage('Đã hủy lịch nhắc cho từ "${word.word}".');
    } catch (error) {
      if (mounted) _showMessage('Không thể hủy lịch nhắc: $error');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Lịch nhắc được lưu trên thiết bị Android hoặc iOS.'),
        ),
      );
    }
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_loadError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Không đọc được lịch nhắc.\n$_loadError'),
            TextButton(onPressed: _loadReminders, child: const Text('Thử lại')),
          ],
        ),
      );
    }
    if (_reminders.isEmpty) {
      return const Center(child: Text('Không có lời nhắc nào đang chờ.'));
    }

    return RefreshIndicator(
      onRefresh: _loadReminders,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _reminders.length,
        itemBuilder: (context, index) {
          final word = _reminders[index];
          return ListTile(
            leading: const Icon(Icons.alarm),
            title: Text('Ôn từ mới: ${word.word}'),
            subtitle: Text(
              '${word.meaning} • ${formatDateTime(word.reminderAt!)}',
            ),
            trailing: IconButton(
              tooltip: 'Hủy lời nhắc',
              onPressed: () => _cancelReminder(word),
              icon: const Icon(Icons.cancel_outlined, color: Colors.red),
            ),
          );
        },
      ),
    );
  }
}
