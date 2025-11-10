import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/problem.dart';
import '../../models/session.dart';
import '../../services/ai/feedback_service.dart';

/// Screen showing AI feedback on problem attempts
class ReviewScreen extends StatefulWidget {
  final List<MathProblem> problems;
  final List<int> answers;
  final String photoPath;

  const ReviewScreen({
    super.key,
    required this.problems,
    required this.answers,
    required this.photoPath,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late List<ProblemAttempt> _attempts;
  late List<AIFeedback> _feedbacks;
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _generateFeedback();
  }

  Future<void> _generateFeedback() async {
    // Create attempts
    _attempts = List.generate(
      widget.problems.length,
      (index) {
        final problem = widget.problems[index];
        final userAnswer = index < widget.answers.length ? widget.answers[index] : 0;
        final isCorrect = userAnswer == problem.correctAnswer;

        return ProblemAttempt(
          problem: problem,
          userAnswer: userAnswer,
          isCorrect: isCorrect,
          photoUrl: widget.photoPath,
          attemptTime: DateTime.now(),
        );
      },
    );

    // Generate AI feedback (need API key from environment)
    // For now, use fallback feedback
    final feedbackService = FeedbackService(apiKey: ''); // TODO: Add API key

    _feedbacks = [];
    for (final attempt in _attempts) {
      final feedback = await feedbackService.generateFeedback(
        problem: attempt.problem,
        userAnswer: attempt.userAnswer ?? 0,
        isCorrect: attempt.isCorrect,
      );
      _feedbacks.add(feedback);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _nextProblem() {
    if (_currentIndex < _attempts.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // All problems reviewed - go to summary
      _goToSummary();
    }
  }

  void _goToSummary() {
    context.go(
      '/math-practice/summary',
      extra: {
        'attempts': _attempts,
        'photoPath': widget.photoPath,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Checking your work...',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      );
    }

    final attempt = _attempts[_currentIndex];
    final feedback = _feedbacks[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Problem ${_currentIndex + 1} of ${_attempts.length}'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: (_currentIndex + 1) / _attempts.length,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
                minHeight: 8,
              ),
              const SizedBox(height: 32),

              // Result card
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Problem display
                      _buildProblemCard(attempt),
                      const SizedBox(height: 24),

                      // Feedback card
                      _buildFeedbackCard(attempt, feedback),

                      // Photo (if available)
                      if (widget.photoPath.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _buildPhotoCard(),
                      ],
                    ],
                  ),
                ),
              ),

              // Next button
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _nextProblem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _currentIndex < _attempts.length - 1
                        ? 'Next Problem'
                        : 'See Summary',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProblemCard(ProblemAttempt attempt) {
    final problem = attempt.problem;
    final isCorrect = attempt.isCorrect;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCorrect ? Colors.green : Colors.orange,
            width: 3,
          ),
        ),
        child: Column(
          children: [
            // Result icon
            Icon(
              isCorrect ? Icons.check_circle : Icons.info_outline,
              size: 64,
              color: isCorrect ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 16),

            // Problem
            Text(
              '${problem.operand1} ${problem.type.symbol} ${problem.operand2}',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Your answer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your answer: ',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${attempt.userAnswer}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isCorrect ? Colors.green : Colors.orange,
                      ),
                ),
              ],
            ),

            // Correct answer (if wrong)
            if (!isCorrect) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Correct answer: ',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${problem.correctAnswer}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackCard(ProblemAttempt attempt, AIFeedback feedback) {
    return Card(
      elevation: 3,
      color: attempt.isCorrect ? Colors.green.shade50 : Colors.orange.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Feedback message
            Text(
              feedback.message,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: attempt.isCorrect
                        ? Colors.green.shade900
                        : Colors.orange.shade900,
                  ),
              textAlign: TextAlign.center,
            ),

            // Specific guidance (if available)
            if (feedback.specificGuidance != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Colors.orange.shade700,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feedback.specificGuidance!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Work',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(widget.photoPath),
                fit: BoxFit.contain,
                height: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
