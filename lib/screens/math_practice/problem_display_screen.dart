import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/problem.dart';
import '../../services/problem/problem_generator.dart';
import '../../services/voice/tts_service.dart';

/// Screen displaying math problems for the child to solve
class ProblemDisplayScreen extends StatefulWidget {
  final DifficultyLevel difficultyLevel;
  final int problemCount;

  const ProblemDisplayScreen({
    super.key,
    required this.difficultyLevel,
    this.problemCount = 2,
  });

  @override
  State<ProblemDisplayScreen> createState() => _ProblemDisplayScreenState();
}

class _ProblemDisplayScreenState extends State<ProblemDisplayScreen> {
  late List<MathProblem> _problems;
  final ProblemGenerator _generator = ProblemGenerator();
  final TTSService _tts = TTSService();

  @override
  void initState() {
    super.initState();
    _generateProblems();
    _speakWelcome();
  }

  void _generateProblems() {
    _problems = _generator.generateProblems(
      difficulty: widget.difficultyLevel,
      count: widget.problemCount,
    );
  }

  Future<void> _speakWelcome() async {
    // Small delay for screen to settle
    await Future.delayed(const Duration(milliseconds: 500));
    await _tts.speakMathWelcome(widget.problemCount);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Practice'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Difficulty badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.difficultyLevel.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 32),

              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.shade200,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.touch_app,
                      color: Colors.blue.shade700,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tap "Draw Solution" to solve each problem with your finger!',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Problems
              Expanded(
                child: ListView.builder(
                  itemCount: _problems.length,
                  itemBuilder: (context, index) {
                    final problem = _problems[index];
                    return _ProblemCard(
                      problemNumber: index + 1,
                      problem: problem,
                    );
                  },
                ),
              ),

              // Action buttons
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to drawing canvas screen
                    context.go(
                      '/math-practice/drawing-canvas',
                      extra: _problems,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.draw, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'Draw Solutions',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate to camera screen (alternative method)
                    context.push(
                      '/math-practice/camera',
                      extra: _problems,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.camera_alt, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Or Take Photo',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProblemCard extends StatelessWidget {
  final int problemNumber;
  final MathProblem problem;

  const _ProblemCard({
    required this.problemNumber,
    required this.problem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Problem number badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Problem $problemNumber',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 24),

            // Problem display (vertical format for solving)
            Center(
              child: _VerticalMathProblem(problem: problem),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget to display a vertical math problem with proper column alignment
class _VerticalMathProblem extends StatelessWidget {
  final MathProblem problem;

  const _VerticalMathProblem({required this.problem});

  @override
  Widget build(BuildContext context) {
    final isThreeColumn = problem.difficulty.isThreeColumn;
    final digitWidth = isThreeColumn ? 3 : 2;

    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // First operand (right-aligned)
          _buildNumberRow(
            problem.operand1.toString(),
            digitWidth,
            showOperator: false,
          ),
          const SizedBox(height: 8),

          // Operator and second operand (right-aligned)
          _buildNumberRow(
            problem.operand2.toString(),
            digitWidth,
            showOperator: true,
            operator: problem.type.symbol,
          ),
          const SizedBox(height: 8),

          // Line
          Container(
            height: 3,
            color: Colors.black87,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
          const SizedBox(height: 16),

          // Answer placeholder
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              '?',
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberRow(
    String number,
    int digitWidth, {
    bool showOperator = false,
    String operator = '',
  }) {
    // Pad number to proper width
    final paddedNumber = number.padLeft(digitWidth, ' ');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Operator space (fixed width)
        SizedBox(
          width: 60,
          child: showOperator
              ? Text(
                  operator,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        // Number (monospace, each digit properly spaced)
        ...paddedNumber.split('').map(
              (char) => SizedBox(
                width: 44, // Fixed width per digit for perfect alignment
                child: Text(
                  char,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
