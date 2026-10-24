// Trần Dương Gia Bảo - 2001240039
import 'package:flutter/material.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';
import 'task_detail.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TaskController _taskController = TaskController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<Task> _tasks = [];
  bool _loading = true;
  bool _saving = false;
  bool _loadError = false;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _fetchTasks() async {
    try {
      final tasks = await _taskController.fetchTasks();
      if (!mounted) return;
      setState(() {
        _tasks = tasks;
        _loadError = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loadError = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _addTask() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      _showMessage('Vui lòng nhập Title.');
      return;
    }
    setState(() => _saving = true);
    try {
      if (await _taskController.isTaskExist(title)) {
        if (mounted) _showMessage('Công việc này đã tồn tại.');
        return;
      }
      await _taskController.insertTask(
        Task(title: title, description: _descriptionController.text.trim()),
      );
      if (!mounted) return;
      _titleController.clear();
      _descriptionController.clear();
      FocusScope.of(context).unfocus();
      await _fetchTasks();
    } catch (_) {
      if (mounted) _showMessage('Không thể thêm công việc. Vui lòng thử lại.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _deleteLastTask() async {
    if (_tasks.isEmpty) return;
    setState(() => _saving = true);
    try {
      // Delete Task xóa công việc cuối danh sách, đúng code mẫu trong đề.
      await _taskController.deleteTask(_tasks.last.id!);
      await _fetchTasks();
    } catch (_) {
      if (mounted) _showMessage('Không thể xóa công việc. Vui lòng thử lại.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _openDetails(Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetail(task: task)),
    );
    // Đọc lại SQLite để màu thẻ phản ánh trạng thái Completed mới.
    if (mounted) await _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        automaticallyImplyLeading: false,
      ),
      // ListView giúp form vẫn cuộn được khi bàn phím xuất hiện.
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 15),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _saving || _loading || _loadError
                      ? null
                      : _addTask,
                  child: const Text('Add Task'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saving || _tasks.isEmpty ? null : _deleteLastTask,
                  child: const Text('Delete Task'),
                ),
              ),
            ],
          ),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_loadError)
            TextButton(
              onPressed: _fetchTasks,
              child: const Text('Không đọc được dữ liệu. Nhấn để thử lại.'),
            )
          else if (_tasks.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('Chưa có công việc.', textAlign: TextAlign.center),
            ),
          for (final task in _tasks)
            Card(
              color: task.isCompleted ? Colors.green[100] : Colors.white,
              elevation: 2,
              child: ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: IconButton(
                  tooltip: 'Task Details',
                  icon: const Icon(Icons.edit),
                  onPressed: _saving ? null : () => _openDetails(task),
                ),
                onTap: () {
                  _titleController.text = task.title;
                  _descriptionController.text = task.description;
                },
              ),
            ),
        ],
      ),
    );
  }
}
