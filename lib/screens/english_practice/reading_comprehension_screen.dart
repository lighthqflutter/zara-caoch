import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/english_exercise.dart';
import '../../services/voice/tts_service.dart';

/// Screen for reading comprehension exercises
class ReadingComprehensionScreen extends StatefulWidget {
  final ReadingComprehensionExercise exercise;

  const ReadingComprehensionScreen({
    super.key,
    required this.exercise,
  });

  @override
  State<ReadingComprehensionScreen> createState() =>
      _ReadingComprehensionScreenState();
}

class _ReadingComprehensionScreenState
    extends State<ReadingComprehensionScreen> {
  final TTSService _tts = TTSService();
  int _currentQuestionIndex = 0;
  final List<int?> _userAnswers = [];
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    // Initialize user answers list
    _userAnswers.addAll(
      List.filled(widget.exercise.questions.length, null),
    );
    _speakWelcome();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _speakWelcome() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await _tts.speak(
      'Read the passage carefully, then answer the questions below!',
    );
  }

  void _selectAnswer(int answerIndex) {
    setState(() {
      _userAnswers[_currentQuestionIndex] = answerIndex;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.exercise.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _showResultsSummary();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _showResultsSummary() {
    setState(() {
      _showResults = true;
    });

    // Calculate score
    int correct = 0;
    for (int i = 0; i < widget.exercise.questions.length; i++) {
      if (_userAnswers[i] ==
          widget.exercise.questions[i].correctAnswerIndex) {
        correct++;
      }
    }

    final accuracy =
        (correct / widget.exercise.questions.length * 100).round();

    _tts.speak(
      'Great job! You got $correct out of ${widget.exercise.questions.length} questions correct!',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showResults) {
      return _buildResultsView();
    }

    final currentQuestion = widget.exercise.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Difficulty badge
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.exercise.difficulty.description,
                    style: TextStyle(
                      color: Colors.green.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Passage card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.book, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Reading Passage',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade900,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.exercise.passage,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: 1.6,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Question progress
              LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) /
                    widget.exercise.questions.length,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.green.shade600,
                ),
                minHeight: 8,
              ),
              const SizedBox(height: 16),

              Text(
                'Question ${_currentQuestionIndex + 1} of ${widget.exercise.questions.length}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Question
              Text(
                currentQuestion.question,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),

              // Answer options
              ...List.generate(
                currentQuestion.options.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildOptionButton(
                    index,
                    currentQuestion.options[index],
                    _userAnswers[_currentQuestionIndex] == index,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Navigation buttons
              Row(
                children: [
                  if (_currentQuestionIndex > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousQuestion,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: Colors.green.shade600,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Previous',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (_currentQuestionIndex > 0) const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _userAnswers[_currentQuestionIndex] != null
                          ? _nextQuestion
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentQuestionIndex ==
                                widget.exercise.questions.length - 1
                            ? 'Finish'
                            : 'Next Question',
                        style: const TextStyle(
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

  Widget _buildOptionButton(int index, String text, bool isSelected) {
    return InkWell(
      onTap: () => _selectAnswer(index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade100 : Colors.grey.shade50,
          border: Border.all(
            color: isSelected ? Colors.green.shade600 : Colors.grey.shade300,
            width: isSelected ? 3 : 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.green.shade600 : Colors.transparent,
                border: Border.all(
                  color:
                      isSelected ? Colors.green.shade600 : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsView() {
    int correct = 0;
    for (int i = 0; i < widget.exercise.questions.length; i++) {
      if (_userAnswers[i] ==
          widget.exercise.questions[i].correctAnswerIndex) {
        correct++;
      }
    }

    final accuracy =
        (correct / widget.exercise.questions.length * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Score card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        accuracy >= 80
                            ? Icons.celebration
                            : Icons.thumb_up,
                        size: 64,
                        color: accuracy >= 80
                            ? Colors.green
                            : Colors.orange,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '$accuracy%',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: accuracy >= 80
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You got $correct out of ${widget.exercise.questions.length} correct!',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),

              // Done button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => context.pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 18,
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
}
