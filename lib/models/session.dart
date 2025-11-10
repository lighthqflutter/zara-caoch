import 'package:cloud_firestore/cloud_firestore.dart';
import 'problem.dart';

/// Learning session model
class LearningSession {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final DifficultyLevel difficultyLevel;
  final List<ProblemAttempt> attempts;
  final double? accuracy;

  const LearningSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.difficultyLevel,
    required this.attempts,
    this.accuracy,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'difficultyLevel': difficultyLevel.level,
      'attempts': attempts.map((a) => a.toJson()).toList(),
      'accuracy': accuracy,
    };
  }

  factory LearningSession.fromJson(Map<String, dynamic> json) {
    return LearningSession(
      id: json['id'] as String,
      startTime: (json['startTime'] as Timestamp).toDate(),
      endTime: json['endTime'] != null
          ? (json['endTime'] as Timestamp).toDate()
          : null,
      difficultyLevel: DifficultyLevel.fromLevel(json['difficultyLevel'] as int),
      attempts: (json['attempts'] as List)
          .map((a) => ProblemAttempt.fromJson(a as Map<String, dynamic>))
          .toList(),
      accuracy: json['accuracy'] as double?,
    );
  }

  /// Calculate session accuracy
  double calculateAccuracy() {
    if (attempts.isEmpty) return 0.0;
    final correct = attempts.where((a) => a.isCorrect).length;
    return (correct / attempts.length) * 100;
  }

  /// Create a copy with updated fields
  LearningSession copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    DifficultyLevel? difficultyLevel,
    List<ProblemAttempt>? attempts,
    double? accuracy,
  }) {
    return LearningSession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      attempts: attempts ?? this.attempts,
      accuracy: accuracy ?? this.accuracy,
    );
  }
}

/// Individual problem attempt within a session
class ProblemAttempt {
  final MathProblem problem;
  final int? userAnswer;
  final bool isCorrect;
  final String? photoUrl;
  final String? errorType;
  final String? feedback;
  final DateTime attemptTime;

  const ProblemAttempt({
    required this.problem,
    this.userAnswer,
    required this.isCorrect,
    this.photoUrl,
    this.errorType,
    this.feedback,
    required this.attemptTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'problem': problem.toJson(),
      'userAnswer': userAnswer,
      'isCorrect': isCorrect,
      'photoUrl': photoUrl,
      'errorType': errorType,
      'feedback': feedback,
      'attemptTime': Timestamp.fromDate(attemptTime),
    };
  }

  factory ProblemAttempt.fromJson(Map<String, dynamic> json) {
    return ProblemAttempt(
      problem: MathProblem.fromJson(json['problem'] as Map<String, dynamic>),
      userAnswer: json['userAnswer'] as int?,
      isCorrect: json['isCorrect'] as bool,
      photoUrl: json['photoUrl'] as String?,
      errorType: json['errorType'] as String?,
      feedback: json['feedback'] as String?,
      attemptTime: (json['attemptTime'] as Timestamp).toDate(),
    );
  }

  /// Create a copy with updated fields
  ProblemAttempt copyWith({
    MathProblem? problem,
    int? userAnswer,
    bool? isCorrect,
    String? photoUrl,
    String? errorType,
    String? feedback,
    DateTime? attemptTime,
  }) {
    return ProblemAttempt(
      problem: problem ?? this.problem,
      userAnswer: userAnswer ?? this.userAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
      photoUrl: photoUrl ?? this.photoUrl,
      errorType: errorType ?? this.errorType,
      feedback: feedback ?? this.feedback,
      attemptTime: attemptTime ?? this.attemptTime,
    );
  }
}

/// Error types for targeted feedback
enum ErrorType {
  carrying('Forgot to carry'),
  borrowing('Forgot to borrow'),
  alignment('Column alignment issue'),
  basicArithmetic('Basic arithmetic error'),
  unknown('Unknown error');

  final String description;
  const ErrorType(this.description);
}
