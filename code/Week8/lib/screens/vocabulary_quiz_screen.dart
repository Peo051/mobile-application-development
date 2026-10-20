import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/vocabulary_word.dart';
import '../services/file_service.dart';

class VocabularyQuizScreen extends StatefulWidget {
  const VocabularyQuizScreen({super.key, required this.onExit});

  final VoidCallback onExit;

  @override
  State<VocabularyQuizScreen> createState() => _VocabularyQuizScreenState();
}

class _VocabularyQuizScreenState extends State<VocabularyQuizScreen> {
  final FileService _fileService = FileService();
  final Random _random = Random();
  List<_QuizQuestion> _questions = [];
  int _questionIndex = 0;
  int _correct = 0;
  int _incorrect = 0;
  bool _loading = true;
  bool _finished = false;
  bool _summaryShown = false;
  String? _loadError;
  String? _notEnoughWordsMessage;

  @override
  void initState() {
    super.initState();
    _startQuiz();
  }

  Future<void> _startQuiz() async {
    setState(() {
      _loading = true;
      _loadError = null;
      _notEnoughWordsMessage = null;
      _finished = false;
      _summaryShown = false;
      _questionIndex = 0;
      _correct = 0;
      _incorrect = 0;
    });
    try {
      final words = await _fileService.loadVocabulary();
      final distinctMeanings = words
          .map((word) => _normalize(word.meaning))
          .toSet()
          .length;
      if (words.length < 2 || distinctMeanings < 2) {
        if (mounted) {
          setState(() {
            _notEnoughWordsMessage = 'Cần ít nhất 2 từ có nghĩa khác nhau để tạo câu hỏi trắc nghiệm.';
          });
        }
        return;
      }

      final shuffledWords = List<VocabularyWord>.from(words)..shuffle(_random);
      final questions = <_QuizQuestion>[];
      for (final word in shuffledWords) {
        final distractors = words
            .where(
              (candidate) =>
                  candidate.id != word.id &&
                  _normalize(candidate.meaning) != _normalize(word.meaning),
            )
            .toList();
        final showCorrectMeaning = _random.nextBool();
        final shownMeaning = showCorrectMeaning
            ? word.meaning
            : distractors[_random.nextInt(distractors.length)].meaning;
        questions.add(
          _QuizQuestion(
            word: word.word,
            shownMeaning: shownMeaning,
            isMeaningCorrect:
                _normalize(shownMeaning) == _normalize(word.meaning),
          ),
        );
      }
      if (mounted) setState(() => _questions = questions);
    } catch (error) {
      if (mounted) setState(() => _loadError = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _answer(bool answerIsCorrect) async {
    if (_finished || _questions.isEmpty) return;

    final question = _questions[_questionIndex];
    final isCorrect = answerIsCorrect == question.isMeaningCorrect;
    final lastQuestion = _questionIndex == _questions.length - 1;
    setState(() {
      if (isCorrect) {
        _correct++;
      } else {
        _incorrect++;
      }
      if (lastQuestion) {
        _finished = true;
      } else {
        _questionIndex++;
      }
    });

    if (lastQuestion) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showSummary();
      });
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 700),
            content: Text(isCorrect ? 'Chính xác!' : 'Chưa chính xác.'),
            backgroundColor: isCorrect ? Colors.green : Colors.red,
          ),
        );
    }
  }

  Future<void> _showSummary() async {
    if (_summaryShown) return;
    _summaryShown = true;
    final percentage = _questions.isEmpty
        ? 0
        : (_correct * 100 / _questions.length).round();
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Kết thúc bài kiểm tra'),
        content: Text(
          'Tổng số câu: ${_questions.length}\n'
          'Đúng: $_correct\n'
          'Sai: $_incorrect\n'
          'Tỉ lệ chính xác: $percentage%',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _startQuiz();
            },
            child: const Text('Làm lại'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              widget.onExit();
            },
            child: const Text('Thoát'),
          ),
        ],
      ),
    );
  }

  String _normalize(String value) =>
      value.trim().toLowerCase().split(RegExp(r'\s+')).join(' ');

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Bài kiểm tra sử dụng bộ từ đã lưu trên thiết bị.'),
        ),
      );
    }
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_loadError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Không tạo được bài kiểm tra.\n$_loadError'),
            TextButton(onPressed: _startQuiz, child: const Text('Thử lại')),
          ],
        ),
      );
    }
    if (_notEnoughWordsMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_notEnoughWordsMessage!, textAlign: TextAlign.center),
        ),
      );
    }
    if (_finished) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Bài kiểm tra đã hoàn thành.'),
            TextButton(onPressed: _startQuiz, child: const Text('Làm lại')),
          ],
        ),
      );
    }

    final question = _questions[_questionIndex];
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _QuizScore(label: 'Đúng: $_correct', color: Colors.green),
              Text('${_questionIndex + 1}/${_questions.length}'),
              _QuizScore(label: 'Sai: $_incorrect', color: Colors.orange),
            ],
          ),
          const Spacer(),
          Text(
            question.word,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(question.shownMeaning, textAlign: TextAlign.center),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilledButton.icon(
                onPressed: () => _answer(true),
                style: FilledButton.styleFrom(backgroundColor: Colors.green),
                icon: const Icon(Icons.check),
                label: const Text('Đúng'),
              ),
              FilledButton.icon(
                onPressed: () => _answer(false),
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                icon: const Icon(Icons.close),
                label: const Text('Sai'),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _QuizQuestion {
  const _QuizQuestion({
    required this.word,
    required this.shownMeaning,
    required this.isMeaningCorrect,
  });

  final String word;
  final String shownMeaning;
  final bool isMeaningCorrect;
}

class _QuizScore extends StatelessWidget {
  const _QuizScore({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
