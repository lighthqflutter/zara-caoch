import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/problem.dart';
import '../../services/ai/feedback_service.dart';
import '../../services/voice/tts_service.dart';

/// Screen for reviewing drawings and providing feedback
class DrawingReviewScreen extends StatefulWidget {
  final List<MathProblem> problems;
  final List<Uint8List> drawings;

  const DrawingReviewScreen({
    super.key,
    required this.problems,
    required this.drawings,
  });

  @override
  State<DrawingReviewScreen> createState() => _DrawingReviewScreenState();
}

class _DrawingReviewScreenState extends State<DrawingReviewScreen> {
  final FeedbackService _feedbackService = FeedbackService();
  final TTSService _tts = TTSService();
  final Map<int, int?> _answers = {};
  bool _isLoading = false;
  String? _feedback;

  @override
  void initState() {
    super.initState();
    _speakInstructions();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _speakInstructions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await _tts.speak(
      "Great job! Now, let's enter your final answers for each problem. "
      "Look at your work and type in the answer you got!"
    );
  }

  Future<void> _submitForReview() async {
    // Check if all answers are provided
    final allAnswered = widget.problems.every((p) {
      final index = widget.problems.indexOf(p);
      return _answers[index] != null;
    });

    if (!allAnswered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter answers for all problems'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Generate feedback for each problem
      final feedbackList = <String>[];
      int correctCount = 0;

      for (int i = 0; i < widget.problems.length; i++) {
        final problem = widget.problems[i];
        final userAnswer = _answers[i] ?? 0;
        final isCorrect = userAnswer == problem.correctAnswer;

        if (isCorrect) correctCount++;

        final aiFeedback = await _feedbackService.generateFeedback(
          problem: problem,
          userAnswer: userAnswer,
          isCorrect: isCorrect,
        );

        feedbackList.add(
          'Problem ${i + 1}: ${aiFeedback.message}'
        );
      }

      // Combine all feedback
      final combinedFeedback = 'You got $correctCount out of ${widget.problems.length} correct!\n\n' +
          feedbackList.join('\n\n');

      setState(() {
        _feedback = combinedFeedback;
        _isLoading = false;
      });

      // Speak the feedback
      await _tts.speak(combinedFeedback);
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting feedback: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _goToSummary() {
    // Create problem attempts from answers
    final attempts = widget.problems.asMap().entries.map((entry) {
      final index = entry.key;
      final problem = entry.value;
      final userAnswer = _answers[index] ?? 0;

      return ProblemAttempt(
        problem: problem,
        userAnswer: userAnswer,
        isCorrect: userAnswer == problem.correctAnswer,
        timeSpent: const Duration(minutes: 1), // Placeholder
      );
    }).toList();

    context.go(
      '/math-practice/summary',
      extra: {
        'attempts': attempts,
        'photoPath': '', // No photo for drawings
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
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Reviewing your work...',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      );
    }

    if (_feedback != null) {
      return _buildFeedbackScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Your Answers'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Look at your work and enter your final answer for each problem',
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: widget.problems.length,
                itemBuilder: (context, index) {
                  final problem = widget.problems[index];
                  final drawing = index < widget.drawings.length
                      ? widget.drawings[index]
                      : null;

                  return _buildProblemCard(index, problem, drawing);
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _submitForReview,
                  icon: const Icon(Icons.check_circle),
                  label: const Text(
                    'Get Feedback',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemCard(int index, MathProblem problem, Uint8List? drawing) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Problem number
            Text(
              'Problem ${index + 1}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 12),

            // Problem equation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${problem.operand1} ${problem.type.symbol} ${problem.operand2} = ',
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: '?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _answers[index] = int.tryParse(value);
                      });
                    },
                  ),
                ),
              ],
            ),

            if (drawing != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Your work:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    drawing,
                    fit: BoxFit.contain,
                    height: 200,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Great Work!'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Icon(
                        Icons.star,
                        size: 80,
                        color: Colors.amber.shade600,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Feedback',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Text(
                          _feedback!,
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _goToSummary,
                  icon: const Icon(Icons.check_circle),
                  label: const Text(
                    'View Summary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
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
