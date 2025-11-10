/// Mathematical problem model
class MathProblem {
  final String id;
  final ProblemType type;
  final DifficultyLevel difficulty;
  final int operand1;
  final int operand2;
  final int correctAnswer;
  final String displayText;

  const MathProblem({
    required this.id,
    required this.type,
    required this.difficulty,
    required this.operand1,
    required this.operand2,
    required this.correctAnswer,
    required this.displayText,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'difficulty': difficulty.level,
      'operand1': operand1,
      'operand2': operand2,
      'correctAnswer': correctAnswer,
      'displayText': displayText,
    };
  }

  factory MathProblem.fromJson(Map<String, dynamic> json) {
    return MathProblem(
      id: json['id'] as String,
      type: ProblemType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      difficulty: DifficultyLevel.fromLevel(json['difficulty'] as int),
      operand1: json['operand1'] as int,
      operand2: json['operand2'] as int,
      correctAnswer: json['correctAnswer'] as int,
      displayText: json['displayText'] as String,
    );
  }
}

/// Types of math problems
enum ProblemType {
  addition,
  subtraction;

  String get symbol {
    switch (this) {
      case addition:
        return '+';
      case subtraction:
        return '-';
    }
  }
}

/// Difficulty levels for progressive learning
enum DifficultyLevel {
  level1, // 2-column addition, no carrying
  level2, // 2-column addition, with carrying
  level3, // 2-column subtraction, no borrowing
  level4, // 2-column subtraction, with borrowing
  level5, // 3-column addition, no carrying
  level6, // 3-column addition, with carrying
  level7, // 3-column subtraction, no borrowing
  level8; // 3-column subtraction, with borrowing

  int get level {
    return index + 1;
  }

  static DifficultyLevel fromLevel(int level) {
    return DifficultyLevel.values[level - 1];
  }

  String get description {
    switch (this) {
      case level1:
        return '2-Column Addition (No Carrying)';
      case level2:
        return '2-Column Addition (With Carrying)';
      case level3:
        return '2-Column Subtraction (No Borrowing)';
      case level4:
        return '2-Column Subtraction (With Borrowing)';
      case level5:
        return '3-Column Addition (No Carrying)';
      case level6:
        return '3-Column Addition (With Carrying)';
      case level7:
        return '3-Column Subtraction (No Borrowing)';
      case level8:
        return '3-Column Subtraction (With Borrowing)';
    }
  }

  bool get isAddition {
    return this == level1 ||
        this == level2 ||
        this == level5 ||
        this == level6;
  }

  bool get isSubtraction => !isAddition;

  bool get isTwoColumn {
    return this == level1 ||
        this == level2 ||
        this == level3 ||
        this == level4;
  }

  bool get isThreeColumn => !isTwoColumn;

  bool get requiresCarrying {
    return this == level2 || this == level6;
  }

  bool get requiresBorrowing {
    return this == level4 || this == level8;
  }
}
