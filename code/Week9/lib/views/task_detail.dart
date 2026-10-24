// Trần Dương Gia Bảo - 2001240039
import 'package:flutter/material.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';

class TaskDetail extends StatefulWidget {
  const TaskDetail({super.key, required this.task});

  final Task task;

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  bool _saving = false;

  Future<void> _changeCompleted(bool? value) async {
    if (value == null || _saving) return;
    setState(() => _saving = true);
    try {
      await TaskController().updateTask(
        Task(
          id: widget.task.id,
          title: widget.task.title,
          description: widget.task.description,
          isCompleted: value,
        ),
      );
      // Checkbox vừa lưu xong thì quay về TaskScreen theo yêu cầu bài 1.
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể cập nhật trạng thái.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Title', style: labelStyle),
            const SizedBox(height: 12),
            Text(widget.task.title, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            const Text('Description', style: labelStyle),
            const SizedBox(height: 12),
            Text(widget.task.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text('Completed', style: labelStyle),
                const SizedBox(width: 8),
                Checkbox(
                  value: widget.task.isCompleted,
                  onChanged: _saving ? null : _changeCompleted,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
