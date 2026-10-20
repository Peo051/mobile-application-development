import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/vocabulary_word.dart';
import '../services/file_service.dart';
import '../services/notification_service.dart';

class VocabularyHomeScreen extends StatefulWidget {
  const VocabularyHomeScreen({super.key, required this.notificationService});

  final NotificationService notificationService;

  @override
  State<VocabularyHomeScreen> createState() => _VocabularyHomeScreenState();
}

class _VocabularyHomeScreenState extends State<VocabularyHomeScreen> {
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final FileService _fileService = FileService();
  bool _saving = false;

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    super.dispose();
  }

  Future<void> _saveWord() async {
    final word = _wordController.text.trim();
    final meaning = _meaningController.text.trim();
    if (word.isEmpty || meaning.isEmpty) {
      _showMessage('Vui lòng nhập đầy đủ từ và nghĩa của từ.');
      return;
    }

    setState(() => _saving = true);
    NotificationReceipt? receipt;
    String? reminderError;
    final reminderAt = DateTime.now().add(const Duration(minutes: 10));
    try {
      try {
        receipt = await widget.notificationService.scheduleAt(
          title: 'Ôn tập từ mới',
          body: 'Hãy ôn tập từ "$word".',
          scheduledAt: reminderAt,
          payload: 'vocabulary:$word',
        );
      } catch (error) {
        reminderError = error.toString();
      }

      final words = await _fileService.loadVocabulary();
      final vocabularyWord = VocabularyWord(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        word: word,
        meaning: meaning,
        reminderId: receipt?.id,
        reminderAt: receipt == null ? null : reminderAt,
      );
      try {
        await _fileService.saveVocabulary([...words, vocabularyWord]);
      } catch (_) {
        if (receipt != null) {
          await widget.notificationService.cancel(receipt.id);
        }
        rethrow;
      }

      if (!mounted) return;
      _wordController.clear();
      _meaningController.clear();
      if (reminderError != null) {
        _showMessage('Đã lưu từ nhưng chưa đặt được nhắc học: $reminderError');
      } else if (receipt != null && !receipt.exactTime) {
        _showMessage(
          'Đã lưu từ và đặt lịch sau 10 phút. Android có thể giao thông báo trễ khi máy ở chế độ tiết kiệm pin.',
        );
      } else {
        _showMessage('Đã lưu từ và đặt lịch nhắc học sau 10 phút.');
      }
    } catch (error) {
      if (mounted) _showMessage('Không thể lưu từ vựng: $error');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Phần lưu file và nhắc học cần chạy trên Android, iOS hoặc máy tính để bàn.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      children: [
        TextField(
          controller: _wordController,
          decoration: const InputDecoration(
            labelText: 'Từ',
            border: UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _meaningController,
          decoration: const InputDecoration(
            labelText: 'Nghĩa',
            border: UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 18),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: _saving ? null : _saveWord,
            child: Text(_saving ? 'Đang lưu...' : 'Lưu & Nhắc học sau 10 phút'),
          ),
        ),
      ],
    );
  }
}
