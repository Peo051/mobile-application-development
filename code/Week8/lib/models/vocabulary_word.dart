class VocabularyWord {
  const VocabularyWord({
    required this.id,
    required this.word,
    required this.meaning,
    this.reminderId,
    this.reminderAt,
  });

  final String id;
  final String word;
  final String meaning;
  final int? reminderId;
  final DateTime? reminderAt;

  Map<String, Object?> toJson() => {
    'id': id,
    'word': word,
    'meaning': meaning,
    'reminderId': reminderId,
    'reminderAt': reminderAt?.toIso8601String(),
  };

  static VocabularyWord? tryFromJson(Object? value) {
    if (value is! Map<String, dynamic>) return null;

    final id = value['id'];
    final word = value['word'];
    final meaning = value['meaning'];
    final reminderId = value['reminderId'];
    final reminderAtText = value['reminderAt'];
    if (id is! String || word is! String || meaning is! String) return null;
    if (reminderId != null && reminderId is! int) return null;
    if (reminderAtText != null && reminderAtText is! String) return null;

    final reminderAt = reminderAtText == null
        ? null
        : DateTime.tryParse(reminderAtText as String);
    if (reminderAtText != null && reminderAt == null) return null;
    if (id.isEmpty || word.trim().isEmpty || meaning.trim().isEmpty) {
      return null;
    }

    return VocabularyWord(
      id: id,
      word: word.trim(),
      meaning: meaning.trim(),
      reminderId: reminderId as int?,
      reminderAt: reminderAt,
    );
  }

  VocabularyWord withoutReminder() =>
      VocabularyWord(id: id, word: word, meaning: meaning);
}

class VocabularyStats {
  const VocabularyStats({
    this.correct = 0,
    this.incorrect = 0,
    this.lastNotifiedIncorrectCount = 0,
  });

  final int correct;
  final int incorrect;
  final int lastNotifiedIncorrectCount;

  VocabularyStats copyWith({
    int? correct,
    int? incorrect,
    int? lastNotifiedIncorrectCount,
  }) {
    return VocabularyStats(
      correct: correct ?? this.correct,
      incorrect: incorrect ?? this.incorrect,
      lastNotifiedIncorrectCount:
          lastNotifiedIncorrectCount ?? this.lastNotifiedIncorrectCount,
    );
  }

  Map<String, Object?> toJson() => {
    'correct': correct,
    'incorrect': incorrect,
    'lastNotifiedIncorrectCount': lastNotifiedIncorrectCount,
  };

  static VocabularyStats fromJson(Object? value) {
    if (value is! Map<String, dynamic>) return const VocabularyStats();

    final correct = value['correct'];
    final incorrect = value['incorrect'];
    final lastNotified = value['lastNotifiedIncorrectCount'];
    return VocabularyStats(
      correct: correct is int && correct >= 0 ? correct : 0,
      incorrect: incorrect is int && incorrect >= 0 ? incorrect : 0,
      lastNotifiedIncorrectCount: lastNotified is int && lastNotified >= 0
          ? lastNotified
          : 0,
    );
  }
}
