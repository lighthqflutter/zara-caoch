import 'dart:math';
import '../../models/problem.dart';

/// Service for generating math problems at various difficulty levels
class ProblemGenerator {
  final Random _random = Random();

  /// Generate a specified number of problems at a given difficulty level
  List<MathProblem> generateProblems({
    required DifficultyLevel difficulty,
    required int count,
  }) {
    final problems = <MathProblem>[];
    for (int i = 0; i < count; i++) {
      problems.add(_generateProblem(difficulty, i));
    }
    return problems;
  }

  /// Generate a single problem at the specified difficulty
  MathProblem _generateProblem(DifficultyLevel difficulty, int index) {
    final id = 'problem_${DateTime.now().millisecondsSinceEpoch}_$index';

    switch (difficulty) {
      case DifficultyLevel.level1:
        return _generate2ColumnAdditionNoCarrying(id);
      case DifficultyLevel.level2:
        return _generate2ColumnAdditionWithCarrying(id);
      case DifficultyLevel.level3:
        return _generate2ColumnSubtractionNoBorrowing(id);
      case DifficultyLevel.level4:
        return _generate2ColumnSubtractionWithBorrowing(id);
      case DifficultyLevel.level5:
        return _generate3ColumnAdditionNoCarrying(id);
      case DifficultyLevel.level6:
        return _generate3ColumnAdditionWithCarrying(id);
      case DifficultyLevel.level7:
        return _generate3ColumnSubtractionNoBorrowing(id);
      case DifficultyLevel.level8:
        return _generate3ColumnSubtractionWithBorrowing(id);
    }
  }

  /// Level 1: 2-column addition (no carrying)
  MathProblem _generate2ColumnAdditionNoCarrying(String id) {
    int operand1, operand2;
    do {
      // Generate 2-digit numbers where sum of each column < 10
      final tens1 = _random.nextInt(5) + 1; // 1-5
      final ones1 = _random.nextInt(9) + 1; // 1-9
      operand1 = tens1 * 10 + ones1;

      final tens2 = _random.nextInt(10 - tens1); // Ensure tens sum < 10
      final ones2 = _random.nextInt(10 - ones1); // Ensure ones sum < 10
      operand2 = tens2 * 10 + ones2;
    } while (operand2 == 0 || (operand1 + operand2) >= 100);

    return MathProblem(
      id: id,
      type: ProblemType.addition,
      difficulty: DifficultyLevel.level1,
      operand1: operand1,
      operand2: operand2,
      correctAnswer: operand1 + operand2,
      displayText: _formatProblem(operand1, operand2, '+'),
    );
  }

  /// Level 2: 2-column addition (with carrying)
  MathProblem _generate2ColumnAdditionWithCarrying(String id) {
    int operand1, operand2;
    do {
      // Generate numbers that require carrying in ones place
      operand1 = _random.nextInt(90) + 10; // 10-99
      operand2 = _random.nextInt(90) + 10; // 10-99
    } while ((operand1 % 10) + (operand2 % 10) < 10 || // Must carry
        (operand1 + operand2) >= 100); // Stay 2-digit result

    return MathProblem(
      id: id,
      type: ProblemType.addition,
      difficulty: DifficultyLevel.level2,
      operand1: operand1,
      operand2: operand2,
      correctAnswer: operand1 + operand2,
      displayText: _formatProblem(operand1, operand2, '+'),
    );
  }

  /// Level 3: 2-column subtraction (no borrowing)
  MathProblem _generate2ColumnSubtractionNoBorrowing(String id) {
    int operand1, operand2;
    do {
      // Generate numbers where each digit of op1 >= corresponding digit of op2
      final tens1 = _random.nextInt(9) + 1; // 1-9
      final ones1 = _random.nextInt(10); // 0-9
      operand1 = tens1 * 10 + ones1;

      final tens2 = _random.nextInt(tens1 + 1); // <= tens1
      final ones2 = _random.nextInt(ones1 + 1); // <= ones1
      operand2 = tens2 * 10 + ones2;
    } while (operand2 == 0 || operand1 == operand2);

    return MathProblem(
      id: id,
      type: ProblemType.subtraction,
      difficulty: DifficultyLevel.level3,
      operand1: operand1,
      operand2: operand2,
      correctAnswer: operand1 - operand2,
      displayText: _formatProblem(operand1, operand2, '-'),
    );
  }

  /// Level 4: 2-column subtraction (with borrowing)
  MathProblem _generate2ColumnSubtractionWithBorrowing(String id) {
    int operand1, operand2;
    do {
      operand1 = _random.nextInt(90) + 10; // 10-99
      operand2 = _random.nextInt(operand1); // Less than operand1
    } while (operand2 < 10 || // Must be 2-digit
        (operand1 % 10) >= (operand2 % 10)); // Must require borrowing

    return MathProblem(
      id: id,
      type: ProblemType.subtraction,
      difficulty: DifficultyLevel.level4,
      operand1: operand1,
      operand2: operand2,
      correctAnswer: operand1 - operand2,
      displayText: _formatProblem(operand1, operand2, '-'),
    );
  }

  /// Level 5: 3-column addition (no carrying)
  MathProblem _generate3ColumnAdditionNoCarrying(String id) {
    int operand1, operand2;
    do {
      // Generate 3-digit numbers where sum of each column < 10
      final hundreds1 = _random.nextInt(5) + 1; // 1-5
      final tens1 = _random.nextInt(10);
      final ones1 = _random.nextInt(10);
      operand1 = hundreds1 * 100 + tens1 * 10 + ones1;

      final hundreds2 = _random.nextInt(10 - hundreds1);
      final tens2 = _random.nextInt(10 - tens1);
      final ones2 = _random.nextInt(10 - ones1);
      operand2 = hundreds2 * 100 + tens2 * 10 + ones2;
    } while (operand2 < 100 || (operand1 + operand2) >= 1000);

    return MathProblem(
      id: id,
      type: ProblemType.addition,
      difficulty: DifficultyLevel.level5,
      operand1: operand1,
      operand2: operand2,
      correctAnswer: operand1 + operand2,
      displayText: _formatProblem(operand1, operand2, '+'),
    );
  }

  /// Level 6: 3-column addition (with carrying)
  MathProblem _generate3ColumnAdditionWithCarrying(String id) {
    int operand1, operand2;
    do {
      operand1 = _random.nextInt(900) + 100; // 100-999
      operand2 = _random.nextInt(900) + 100; // 100-999
    } while ((operand1 % 10) + (operand2 % 10) < 10 || // Must carry somewhere
        (operand1 + operand2) >= 1000); // Stay 3-digit result

    return MathProblem(
      id: id,
      type: ProblemType.addition,
      difficulty: DifficultyLevel.level6,
      operand1: operand1,
      operand2: operand2,
      correctAnswer: operand1 + operand2,
      displayText: _formatProblem(operand1, operand2, '+'),
    );
  }

  /// Level 7: 3-column subtraction (no borrowing)
  MathProblem _generate3ColumnSubtractionNoBorrowing(String id) {
    int operand1, operand2;
    do {
      final hundreds1 = _random.nextInt(9) + 1; // 1-9
      final tens1 = _random.nextInt(10);
      final ones1 = _random.nextInt(10);
      operand1 = hundreds1 * 100 + tens1 * 10 + ones1;

      final hundreds2 = _random.nextInt(hundreds1 + 1);
      final tens2 = _random.nextInt(tens1 + 1);
      final ones2 = _random.nextInt(ones1 + 1);
      operand2 = hundreds2 * 100 + tens2 * 10 + ones2;
    } while (operand2 < 100 || operand1 == operand2);

    return MathProblem(
      id: id,
      type: ProblemType.subtraction,
      difficulty: DifficultyLevel.level7,
      operand1: operand1,
      operand2: operand2,
      correctAnswer: operand1 - operand2,
      displayText: _formatProblem(operand1, operand2, '-'),
    );
  }

  /// Level 8: 3-column subtraction (with borrowing)
  MathProblem _generate3ColumnSubtractionWithBorrowing(String id) {
    int operand1, operand2;
    do {
      operand1 = _random.nextInt(900) + 100; // 100-999
      operand2 = _random.nextInt(operand1 - 100) + 100; // 100 to (operand1-1)
    } while ((operand1 % 10) >= (operand2 % 10)); // Must require borrowing

    return MathProblem(
      id: id,
      type: ProblemType.subtraction,
      difficulty: DifficultyLevel.level8,
      operand1: operand1,
      operand2: operand2,
      correctAnswer: operand1 - operand2,
      displayText: _formatProblem(operand1, operand2, '-'),
    );
  }

  /// Format problem for display
  String _formatProblem(int operand1, int operand2, String operator) {
    return '$operand1 $operator $operand2 = ?';
  }
}
