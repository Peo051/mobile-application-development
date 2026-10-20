import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/daily_task.dart';
import '../services/file_service.dart';
import '../services/notification_service.dart';
import '../utils/date_formatters.dart';
import 'daily_task_form_screen.dart';

class DailyTasksScreen extends StatefulWidget {
  const DailyTasksScreen({super.key, required this.notificationService});

  final NotificationService notificationService;

  @override
  State<DailyTasksScreen> createState() => _DailyTasksScreenState();
}

class _DailyTasksScreenState extends State<DailyTasksScreen> {
  final FileService _fileService = FileService();
  List<DailyTask> _tasks = [];
  bool _loading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final tasks = await _fileService.loadDailyTasks();
      if (mounted) setState(() => _tasks = tasks);
    } catch (error) {
      if (mounted) setState(() => _loadError = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openAddTask() async {
    final draft = await Navigator.of(context).push<DailyTask>(
      MaterialPageRoute<DailyTask>(builder: (_) => const DailyTaskFormScreen()),
    );
    if (draft == null || !mounted) return;

    NotificationReceipt? receipt;
    var reminderUnavailable = false;
    try {
      final reminderAt = _nextOccurrence(draft.reminderTime);
      try {
        receipt = await widget.notificationService.scheduleAt(
          title: 'Nhắc nhiệm vụ',
          body: draft.title,
          scheduledAt: reminderAt,
          payload: 'daily-task:${draft.id}',
        );
      } on NotificationPermissionDeniedException {
        reminderUnavailable = true;
      } on NotificationFeatureUnsupportedException {
        reminderUnavailable = true;
      }

      final task = DailyTask(
        id: draft.id,
        title: draft.title,
        reminderTime: reminderAt,
        completed: false,
        notificationId: receipt?.id,
      );
      final updatedTasks = [..._tasks, task];
      try {
        await _fileService.saveDailyTasks(updatedTasks);
      } catch (_) {
        if (receipt != null) {
          await widget.notificationService.cancel(receipt.id);
        }
        rethrow;
      }

      if (!mounted) return;
      setState(() => _tasks = updatedTasks);
      if (reminderUnavailable) {
        _showMessage(
          'Đã lưu nhiệm vụ nhưng chưa tạo được thông báo. Hãy bật quyền thông báo trong Cài đặt.',
        );
      } else if (receipt != null && !receipt.exactTime) {
        _showMessage(
          'Đã lưu nhiệm vụ. Android có thể giao thông báo trễ khi máy ở chế độ tiết kiệm pin.',
        );
      } else {
        _showMessage('Đã lưu nhiệm vụ và đặt giờ nhắc.');
      }
    } catch (error) {
      if (mounted) _showMessage('Không thể lưu nhiệm vụ: $error');
    }
  }

  DateTime _nextOccurrence(DateTime selectedTime) {
    final now = DateTime.now();
    var candidate = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    if (!candidate.isAfter(now)) {
      candidate = DateTime(
        now.year,
        now.month,
        now.day + 1,
        selectedTime.hour,
        selectedTime.minute,
      );
    }
    return candidate;
  }

  Future<void> _confirmCompletion(DailyTask task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận hoàn thành'),
        content: Text('Bạn đã hoàn thành nhiệm vụ "${task.title}" chưa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Chưa'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Đã hoàn thành'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final updatedTasks = _tasks
        .map(
          (item) => item.id == task.id
              ? item.copyWith(completed: true, clearNotificationId: true)
              : item,
        )
        .toList();
    try {
      await _fileService.saveDailyTasks(updatedTasks);
      if (task.notificationId != null) {
        await widget.notificationService.cancel(task.notificationId!);
      }
      if (!mounted) return;
      setState(() => _tasks = updatedTasks);

      final completedCount = updatedTasks
          .where((item) => item.completed)
          .length;
      try {
        await widget.notificationService.showNow(
          title: 'Nhiệm vụ hoàn thành',
          body: 'Bạn đã hoàn thành $completedCount nhiệm vụ.',
          payload: 'daily-task-completed:$completedCount',
        );
        if (mounted) {
          _showMessage('Đã cập nhật trạng thái và gửi thông báo hoàn thành.');
        }
      } catch (error) {
        if (mounted) {
          _showMessage(
            'Đã cập nhật trạng thái, nhưng không gửi được thông báo: $error',
          );
        }
      }
    } catch (error) {
      if (mounted) _showMessage('Không thể cập nhật nhiệm vụ: $error');
    }
  }

  Future<void> _deleteTask(DailyTask task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa nhiệm vụ'),
        content: Text('Bạn có muốn xóa "${task.title}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final updatedTasks = List<DailyTask>.from(_tasks)
      ..removeWhere((item) => item.id == task.id);
    try {
      await _fileService.saveDailyTasks(updatedTasks);
      if (task.notificationId != null) {
        await widget.notificationService.cancel(task.notificationId!);
      }
      if (!mounted) return;
      setState(() => _tasks = updatedTasks);
      _showMessage('Đã xóa nhiệm vụ và hủy lời nhắc.');
    } catch (error) {
      if (mounted) _showMessage('Không thể xóa nhiệm vụ: $error');
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
      return Scaffold(
        appBar: AppBar(title: const Text('Nhiệm vụ mỗi ngày')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Phần lưu file và nhắc việc cần chạy trên Android, iOS hoặc máy tính để bàn.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhiệm vụ mỗi ngày'),
        actions: [
          IconButton(
            tooltip: 'Số nhiệm vụ hoàn thành',
            onPressed: _tasks.isEmpty
                ? null
                : () => _showMessage(
                    'Đã hoàn thành ${_tasks.where((task) => task.completed).length} trong ${_tasks.length} nhiệm vụ.',
                  ),
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: _buildTaskList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _loading ? null : _openAddTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_loadError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Không đọc được danh sách nhiệm vụ.\n$_loadError'),
            TextButton(onPressed: _loadTasks, child: const Text('Thử lại')),
          ],
        ),
      );
    }
    if (_tasks.isEmpty) {
      return const Center(child: Text('Chưa có nhiệm vụ nào.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 84),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return Card(
          color: task.completed ? Colors.green.shade50 : Colors.white,
          child: ListTile(
            leading: Checkbox(
              value: task.completed,
              onChanged: task.completed
                  ? null
                  : (_) => _confirmCompletion(task),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                decoration: task.completed ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text('Nhắc lúc ${formatTime(task.reminderTime)}'),
            trailing: IconButton(
              tooltip: 'Xóa nhiệm vụ',
              onPressed: () => _deleteTask(task),
              icon: const Icon(Icons.delete_outline),
            ),
          ),
        );
      },
    );
  }
}
