import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/vocabulary_word.dart';
import '../services/file_service.dart';
import '../services/notification_service.dart';

class VocabularyStudyScreen extends StatefulWidget {
  const VocabularyStudyScreen({super.key, required this.notificationService});

  final NotificationService notificationService;

  @override
  State<VocabularyStudyScreen> createState() => _VocabularyStudyScreenState();
}

class _VocabularyStudyScreenState extends State<VocabularyStudyScreen> {
  final TextEditingController _answerController = TextEditingController();
  final FileService _fileService = FileService();
  List<VocabularyWord> _words = [];
  VocabularyStats _stats = const VocabularyStats();
  int _answerCount = 0;
  bool _loading = true;
  bool _checking = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final words = await _fileService.loadVocabulary();
      final stats = await _fileService.loadVocabularyStats();
      if (!mounted) return;
      setState(() {
        _words = words;
        _stats = stats;
        _answerCount = stats.correct + stats.incorrect;
      });
    } catch (error) {
      if (mounted) setState(() => _loadError = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _checkAnswer() async {
    final answer = _answerController.text.trim();
    if (answer.isEmpty) {
      _showMessage('Vui lòng nhập nghĩa của từ.');
      return;
    }
    if (_words.isEmpty) return;

    final currentWord = _words[_answerCount % _words.length];
    final isCorrect = _normalize(answer) == _normalize(currentWord.meaning);
    final newCorrectCount = _stats.correct + (isCorrect ? 1 : 0);
    final newIncorrectCount = _stats.incorrect + (isCorrect ? 0 : 1);
    final reachedNotificationMilestone =
        !isCorrect &&
        newIncorrectCount % 3 == 0 &&
        newIncorrectCount > _stats.lastNotifiedIncorrectCount;
    final updatedStats = _stats.copyWith(
      correct: newCorrectCount,
      incorrect: newIncorrectCount,
      lastNotifiedIncorrectCount: reachedNotificationMilestone
          ? newIncorrectCount
          : _stats.lastNotifiedIncorrectCount,
    );

    setState(() => _checking = true);
    String? notificationError;
    try {
      await _fileService.saveVocabularyStats(updatedStats);
      if (reachedNotificationMilestone) {
        try {
          await widget.notificationService.showNow(
            title: 'Cố gắng ôn lại từ vựng',
            body:
                'Bạn đã trả lời sai $newIncorrectCount lần. Hãy tiếp tục luyện tập!',
            payload: 'vocabulary-wrong:$newIncorrectCount',
          );
        } catch (error) {
          notificationError = error.toString();
        }
      }

      if (!mounted) return;
      setState(() {
        _stats = updatedStats;
        _answerCount++;
        _answerController.clear();
      });
      if (isCorrect) {
        _showMessage('Chính xác!');
      } else if (notificationError != null) {
        _showMessage(
          'Sai rồi! Đáp án: ${currentWord.meaning}. Không gửi được thông báo: $notificationError',
        );
      } else {
        _showMessage('Sai rồi! Đáp án: ${currentWord.meaning}.');
      }
    } catch (error) {
      if (mounted) _showMessage('Không thể cập nhật kết quả: $error');
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  String _normalize(String value) =>
      value.trim().toLowerCase().split(RegExp(r'\s+')).join(' ');

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: message.startsWith('Chính xác')
              ? Colors.green
              : message.startsWith('Sai rồi')
              ? Colors.red
              : null,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Phần học từ vựng dùng dữ liệu file trên thiết bị.'),
        ),
      );
    }
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_loadError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Không đọc được dữ liệu từ vựng.\n$_loadError'),
            TextButton(onPressed: _loadData, child: const Text('Thử lại')),
          ],
        ),
      );
    }
    if (_words.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Chưa có từ vựng. Hãy thêm từ ở mục Trang chính.'),
        ),
      );
    }

    final currentWord = _words[_answerCount % _words.length];
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ScoreBadge(
              label: '${_stats.correct} từ',
              color: Colors.green,
              icon: Icons.check,
            ),
            _ScoreBadge(
              label: '${_stats.incorrect} từ',
              color: Colors.orange,
              icon: Icons.close,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Text(
                currentWord.word,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _answerController,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _checking ? null : _checkAnswer(),
                decoration: const InputDecoration(
                  hintText: 'Nhập nghĩa tiếng Việt',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _checking ? null : _checkAnswer,
                child: Text(_checking ? 'Đang kiểm tra...' : 'Check'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
