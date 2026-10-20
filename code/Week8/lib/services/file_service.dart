import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../models/daily_task.dart';
import '../models/todo.dart';
import '../models/vocabulary_word.dart';

class FileService {
  Future<File> _file(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File(path.join(directory.path, fileName));
  }

  Future<TodoLoadResult> loadTodos({required bool withReminders}) async {
    final file = await _file(
      withReminders ? 'todo_reminders.json' : 'todo.txt',
    );
    if (!await file.exists()) {
      return const TodoLoadResult(todos: [], invalidRows: 0);
    }

    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      return const TodoLoadResult(todos: [], invalidRows: 0);
    }

    if (!withReminders) {
      final todos = <Todo>[];
      var invalidRows = 0;
      for (final line in content.split(RegExp(r'\r?\n'))) {
        if (line.trim().isEmpty) continue;
        final todo = Todo.tryFromFileLine(line);
        if (todo == null) {
          invalidRows++;
        } else {
          todos.add(todo);
        }
      }
      return TodoLoadResult(todos: todos, invalidRows: invalidRows);
    }

    try {
      final decoded = jsonDecode(content);
      if (decoded is! List) {
        return const TodoLoadResult(todos: [], invalidRows: 1);
      }

      final todos = <Todo>[];
      var invalidRows = 0;
      for (final row in decoded) {
        final todo = Todo.tryFromJson(row);
        if (todo == null) {
          invalidRows++;
        } else {
          todos.add(todo);
        }
      }
      return TodoLoadResult(todos: todos, invalidRows: invalidRows);
    } on FormatException {
      return const TodoLoadResult(todos: [], invalidRows: 1);
    }
  }

  Future<void> saveTodos(
    List<Todo> todos, {
    required bool withReminders,
  }) async {
    final file = await _file(
      withReminders ? 'todo_reminders.json' : 'todo.txt',
    );
    final content = withReminders
        ? jsonEncode(todos.map((todo) => todo.toJson()).toList())
        : todos.map((todo) => todo.toFileLine()).join('\n');
    await file.writeAsString(content, flush: true);
  }

  Future<List<VocabularyWord>> loadVocabulary() async {
    final file = await _file('vocabulary.json');
    if (!await file.exists()) return [];

    final content = await file.readAsString();
    if (content.trim().isEmpty) return [];
    final decoded = jsonDecode(content);
    if (decoded is! List) return [];

    return decoded
        .map(VocabularyWord.tryFromJson)
        .whereType<VocabularyWord>()
        .toList();
  }

  Future<void> saveVocabulary(List<VocabularyWord> words) async {
    final file = await _file('vocabulary.json');
    await file.writeAsString(
      jsonEncode(words.map((word) => word.toJson()).toList()),
      flush: true,
    );
  }

  Future<VocabularyStats> loadVocabularyStats() async {
    final file = await _file('vocabulary_stats.json');
    if (!await file.exists()) return const VocabularyStats();

    final content = await file.readAsString();
    if (content.trim().isEmpty) return const VocabularyStats();
    try {
      return VocabularyStats.fromJson(jsonDecode(content));
    } on FormatException {
      return const VocabularyStats();
    }
  }

  Future<void> saveVocabularyStats(VocabularyStats stats) async {
    final file = await _file('vocabulary_stats.json');
    await file.writeAsString(jsonEncode(stats.toJson()), flush: true);
  }

  Future<List<DailyTask>> loadDailyTasks() async {
    final file = await _file('daily_tasks.json');
    if (!await file.exists()) return [];

    final content = await file.readAsString();
    if (content.trim().isEmpty) return [];
    final decoded = jsonDecode(content);
    if (decoded is! List) return [];

    return decoded.map(DailyTask.tryFromJson).whereType<DailyTask>().toList();
  }

  Future<void> saveDailyTasks(List<DailyTask> tasks) async {
    final file = await _file('daily_tasks.json');
    await file.writeAsString(
      jsonEncode(tasks.map((task) => task.toJson()).toList()),
      flush: true,
    );
  }
}
