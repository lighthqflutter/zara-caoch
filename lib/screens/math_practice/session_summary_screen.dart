import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/session.dart';

/// Screen showing session summary and results
class SessionSummaryScreen extends StatefulWidget {
  final List<ProblemAttempt> attempts;
  final String photoPath;

  const SessionSummaryScreen({
    super.key,
    required this.attempts,
    required this.photoPath,
  });

  @override
  State<SessionSummaryScreen> createState() => _SessionSummaryScreenState();
}

class _SessionSummaryScreenState extends State<SessionSummaryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isSaving = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _saveSession();
  }

  Future<void> _saveSession() async {
    // Simulate saving (actual implementation would use SessionService)
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isSaving = false;
      });
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double _calculateAccuracy() {
    if (widget.attempts.isEmpty) return 0.0;
    final correct = widget.attempts.where((a) => a.isCorrect).length;
    return (correct / widget.attempts.length) * 100;
  }

  String _getEncouragingMessage(double accuracy) {
    if (accuracy == 100) {
      return 'Perfect Score! You\'re amazing!';
    } else if (accuracy >= 80) {
      return 'Great Work! Keep it up!';
    } else if (accuracy >= 60) {
      return 'Good Effort! You\'re getting better!';
    } else {
      return 'Nice Try! Let\'s practice more!';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSaving) {
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
                'Saving your progress...',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      );
    }

    final accuracy = _calculateAccuracy();
    final correct = widget.attempts.where((a) => a.isCorrect).length;
    final total = widget.attempts.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Complete'),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
                      // Celebration icon
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getResultColor(accuracy).withValues(alpha: 0.2),
                          ),
                          child: Icon(
                            _getResultIcon(accuracy),
                            size: 64,
                            color: _getResultColor(accuracy),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Encouraging message
                      Text(
                        _getEncouragingMessage(accuracy),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Stats cards
                      _buildStatsCard(
                        'Problems Completed',
                        '$total',
                        Icons.calculate,
                        Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      _buildStatsCard(
                        'Correct Answers',
                        '$correct out of $total',
                        Icons.check_circle,
                        Colors.green,
                      ),
                      const SizedBox(height: 16),
                      _buildStatsCard(
                        'Accuracy',
                        '${accuracy.toStringAsFixed(0)}%',
                        Icons.trending_up,
                        _getResultColor(accuracy),
                      ),

                      // Problem breakdown
                      const SizedBox(height: 32),
                      _buildProblemBreakdown(),
                    ],
                  ),
                ),
              ),

              // Action buttons
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.go('/child-home');
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Start a new session
                        context.go('/child-home');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Practice More',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
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

  Widget _buildProblemBreakdown() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Problem Breakdown',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              widget.attempts.length,
              (index) => _buildProblemRow(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemRow(int index) {
    final attempt = widget.attempts[index];
    final problem = attempt.problem;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: attempt.isCorrect
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.orange.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              attempt.isCorrect ? Icons.check : Icons.close,
              color: attempt.isCorrect ? Colors.green : Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${problem.operand1} ${problem.type.symbol} ${problem.operand2} = ${attempt.userAnswer}',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
              ),
            ),
          ),
          if (!attempt.isCorrect)
            Text(
              '(${problem.correctAnswer})',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Color _getResultColor(double accuracy) {
    if (accuracy >= 80) return Colors.green;
    if (accuracy >= 60) return Colors.blue;
    return Colors.orange;
  }

  IconData _getResultIcon(double accuracy) {
    if (accuracy == 100) return Icons.star;
    if (accuracy >= 80) return Icons.emoji_events;
    if (accuracy >= 60) return Icons.thumb_up;
    return Icons.lightbulb;
  }
}
