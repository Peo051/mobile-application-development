import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/daily_task.dart';
import '../utils/date_formatters.dart';

class DailyTaskFormScreen extends StatefulWidget {
  const DailyTaskFormScreen({super.key});

  @override
  State<DailyTaskFormScreen> createState() => _DailyTaskFormScreenState();
}

class _DailyTaskFormScreenState extends State<DailyTaskFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null && mounted) setState(() => _selectedTime = time);
  }

  void _saveTask() {
    final title = _titleController.text.trim();
    final selectedTime = _selectedTime;
    if (title.isEmpty) {
      _showMessage('Vui lòng nhập tên nhiệm vụ.');
      return;
    }
    if (selectedTime == null) {
      _showMessage('Vui lòng chọn giờ nhắc.');
      return;
    }

    final now = DateTime.now();
    final reminderTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    Navigator.of(context).pop(
      DailyTask(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        reminderTime: reminderTime,
        completed: false,
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm nhiệm vụ mới')),
      body: kIsWeb
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Phần lưu file cần chạy trên Android, iOS hoặc máy tính để bàn.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _titleController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Tên nhiệm vụ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _pickTime,
                    icon: const Icon(Icons.notifications_none),
                    label: Text(
                      _selectedTime == null
                          ? 'Giờ nhắc'
                          : 'Nhắc lúc ${formatTime(DateTime(2000, 1, 1, _selectedTime!.hour, _selectedTime!.minute))}',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: _saveTask,
                      child: const Text('Lưu nhiệm vụ'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
