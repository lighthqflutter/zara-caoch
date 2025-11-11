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
                      Icons.info_outline,
                      color: Colors.blue.shade700,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Solve these problems in your notebook, then take a photo!',
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

              // Ready button
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to camera screen
                    context.push(
                      '/math-practice/camera',
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
                      const Icon(Icons.camera_alt, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'Ready to Take Photo',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
              child: Column(
                children: [
                  // First operand
                  Text(
                    problem.operand1.toString().padLeft(
                          problem.difficulty.isThreeColumn ? 3 : 2,
                          ' ',
                        ),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Operator and second operand
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        problem.type.symbol,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        problem.operand2.toString().padLeft(
                              problem.difficulty.isThreeColumn ? 3 : 2,
                              ' ',
                            ),
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Line
                  Container(
                    width: 200,
                    height: 3,
                    color: Colors.black87,
                  ),
                  const SizedBox(height: 16),

                  // Answer placeholder
                  Text(
                    '?',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
