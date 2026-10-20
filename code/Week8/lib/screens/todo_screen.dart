import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../services/file_service.dart';
import '../services/notification_service.dart';
import '../utils/date_formatters.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({
    super.key,
    required this.notificationService,
    this.withReminders = false,
  });

  final NotificationService notificationService;
  final bool withReminders;

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final FileService _fileService = FileService();
  final List<Color> _cardColors = [
    Colors.red.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.yellow.shade100,
    Colors.purple.shade100,
  ];

  List<Todo> _todos = [];
  DateTime? _selectedTime;
  bool _loading = true;
  bool _saving = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _loadTodos() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final result = await _fileService.loadTodos(
        withReminders: widget.withReminders,
      );
      if (!mounted) return;
      setState(() => _todos = result.todos);
      if (result.invalidRows > 0) {
        _showMessage(
          'Đã bỏ qua ${result.invalidRows} dòng dữ liệu không hợp lệ.',
        );
      }
    } catch (error) {
      if (mounted) setState(() => _loadError = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (time == null || !mounted) return;

    setState(() {
      _selectedTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _addTodo() async {
    final title = _titleController.text.trim();
    final selectedTime = _selectedTime;
    if (title.isEmpty) {
      _showMessage('Vui lòng nhập tên công việc.');
      return;
    }
    if (selectedTime == null) {
      _showMessage('Vui lòng chọn ngày và giờ thực hiện.');
      return;
    }
    if (widget.withReminders && !selectedTime.isAfter(DateTime.now())) {
      _showMessage('Thời gian nhắc phải ở tương lai.');
      return;
    }

    setState(() => _saving = true);
    NotificationReceipt? receipt;
    var reminderUnavailable = false;
    try {
      if (widget.withReminders) {
        try {
          receipt = await widget.notificationService.scheduleAt(
            title: 'Nhắc công việc',
            body: title,
            scheduledAt: selectedTime,
            payload: 'todo',
          );
        } on NotificationPermissionDeniedException {
          reminderUnavailable = true;
        } on NotificationFeatureUnsupportedException {
          reminderUnavailable = true;
        }
      }

      final todo = Todo(
        title: title,
        time: selectedTime,
        notificationId: receipt?.id,
      );
      final updatedTodos = [..._todos, todo];
      try {
        await _fileService.saveTodos(
          updatedTodos,
          withReminders: widget.withReminders,
        );
      } catch (_) {
        if (receipt != null) {
          await widget.notificationService.cancel(receipt.id);
        }
        rethrow;
      }

      if (!mounted) return;
      setState(() {
        _todos = updatedTodos;
        _selectedTime = null;
        _titleController.clear();
      });
      if (reminderUnavailable) {
        _showMessage(
          'Đã lưu công việc nhưng chưa tạo được nhắc việc. Hãy bật quyền thông báo trong Cài đặt.',
        );
      } else if (receipt != null && !receipt.exactTime) {
        _showMessage(
          'Đã lưu và đặt nhắc việc. Android có thể giao thông báo trễ khi máy ở chế độ tiết kiệm pin.',
        );
      } else if (receipt != null) {
        _showMessage('Đã lưu công việc và lên lịch nhắc việc.');
      } else {
        _showMessage('Đã lưu công việc vào todo.txt.');
      }
    } catch (error) {
      if (mounted) _showMessage('Không thể lưu công việc: $error');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _cancelReminder(Todo todo) async {
    final notificationId = todo.notificationId;
    if (notificationId == null) return;

    try {
      await widget.notificationService.cancel(notificationId);
      final updatedTodos = _todos
          .map((item) => identical(item, todo) ? item.withoutReminder() : item)
          .toList();
      await _fileService.saveTodos(
        updatedTodos,
        withReminders: widget.withReminders,
      );
      if (!mounted) return;
      setState(() => _todos = updatedTodos);
      _showMessage('Đã hủy lời nhắc cho công việc.');
    } catch (error) {
      if (mounted) _showMessage('Không thể hủy lời nhắc: $error');
    }
  }

  Future<void> _deleteTodo(Todo todo) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa công việc'),
        content: Text('Bạn có muốn xóa "${todo.title}" không?'),
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
    if (shouldDelete != true) return;

    final updatedTodos = List<Todo>.from(_todos)..remove(todo);
    try {
      await _fileService.saveTodos(
        updatedTodos,
        withReminders: widget.withReminders,
      );
      if (todo.notificationId != null) {
        await widget.notificationService.cancel(todo.notificationId!);
      }
      if (!mounted) return;
      setState(() => _todos = updatedTodos);
      _showMessage('Đã xóa công việc.');
    } catch (error) {
      if (mounted) _showMessage('Không thể xóa công việc: $error');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.withReminders ? 'Todo App - Nhắc việc' : 'Todo App';
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(title: Text(title), centerTitle: true),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Phần lưu file cần chạy trên Android, iOS hoặc máy tính để bàn.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Tên công việc',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedTime == null
                        ? 'Chưa chọn thời gian'
                        : formatDateTime(_selectedTime!),
                  ),
                ),
                OutlinedButton(
                  onPressed: _saving ? null : _pickDateTime,
                  child: const Text('Chọn thời gian'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saving ? null : _addTodo,
              child: Text(_saving ? 'Đang lưu...' : 'Lưu'),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildTodoList()),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoList() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_loadError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Không đọc được danh sách công việc.\n$_loadError'),
            const SizedBox(height: 8),
            TextButton(onPressed: _loadTodos, child: const Text('Thử lại')),
          ],
        ),
      );
    }
    if (_todos.isEmpty) {
      return const Center(child: Text('Chưa có công việc nào.'));
    }

    return ListView.builder(
      itemCount: _todos.length,
      itemBuilder: (context, index) {
        final todo = _todos[index];
        final background = _cardColors[index % _cardColors.length];
        return Card(
          color: background,
          child: ListTile(
            leading: const Icon(Icons.task_alt),
            title: Text(
              todo.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(formatDateTime(todo.time)),
            trailing: widget.withReminders
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (todo.notificationId != null)
                        IconButton(
                          tooltip: 'Hủy lời nhắc',
                          onPressed: () => _cancelReminder(todo),
                          icon: const Icon(Icons.notifications_off_outlined),
                        ),
                      IconButton(
                        tooltip: 'Xóa công việc',
                        onPressed: () => _deleteTodo(todo),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  )
                : null,
          ),
        );
      },
    );
  }
}
