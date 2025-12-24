/// Models for English language exercises

/// Type of English exercise
enum EnglishExerciseType {
  readingComprehension,
  vocabulary,
}

/// Difficulty level for English exercises
enum EnglishDifficultyLevel {
  level1, // Primary 4-5 (Ages 9-10)
  level2, // Primary 6 (Age 11)
  level3, // Secondary 1-2 (Ages 12-13)
}

extension EnglishDifficultyLevelExtension on EnglishDifficultyLevel {
  String get description {
    switch (this) {
      case EnglishDifficultyLevel.level1:
        return 'Primary 4-5';
      case EnglishDifficultyLevel.level2:
        return 'Primary 6';
      case EnglishDifficultyLevel.level3:
        return 'Secondary 1-2';
    }
  }
}

/// Reading comprehension exercise
class ReadingComprehensionExercise {
  final String id;
  final String passage;
  final List<ComprehensionQuestion> questions;
  final EnglishDifficultyLevel difficulty;
  final String title;

  const ReadingComprehensionExercise({
    required this.id,
    required this.passage,
    required this.questions,
    required this.difficulty,
    required this.title,
  });
}

/// A comprehension question with multiple choice answers
class ComprehensionQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;

  const ComprehensionQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
  });
}

/// Vocabulary exercise
class VocabularyExercise {
  final String id;
  final String word;
  final String definition;
  final List<String> exampleSentences;
  final VocabularyQuestionType questionType;
  final List<String> options;
  final int correctAnswerIndex;
  final EnglishDifficultyLevel difficulty;

  const VocabularyExercise({
    required this.id,
    required this.word,
    required this.definition,
    required this.exampleSentences,
    required this.questionType,
    required this.options,
    required this.correctAnswerIndex,
    required this.difficulty,
  });
}

/// Type of vocabulary question
enum VocabularyQuestionType {
  definition, // Choose the correct definition
  usage, // Fill in the blank
  synonym, // Choose the synonym
  antonym, // Choose the antonym
}

extension VocabularyQuestionTypeExtension on VocabularyQuestionType {
  String get description {
    switch (this) {
      case VocabularyQuestionType.definition:
        return 'Choose the correct definition';
      case VocabularyQuestionType.usage:
        return 'Use the word correctly';
      case VocabularyQuestionType.synonym:
        return 'Find the synonym';
      case VocabularyQuestionType.antonym:
        return 'Find the antonym';
    }
  }
}

/// Result of an English exercise attempt
class EnglishExerciseAttempt {
  final String exerciseId;
  final EnglishExerciseType type;
  final int? userAnswerIndex;
  final int correctAnswerIndex;
  final bool isCorrect;
  final DateTime attemptTime;

  const EnglishExerciseAttempt({
    required this.exerciseId,
    required this.type,
    required this.userAnswerIndex,
    required this.correctAnswerIndex,
    required this.isCorrect,
    required this.attemptTime,
  });
}
