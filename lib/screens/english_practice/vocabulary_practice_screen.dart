import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/english_exercise.dart';
import '../../services/voice/tts_service.dart';

/// Screen for vocabulary practice
class VocabularyPracticeScreen extends StatefulWidget {
  final List<VocabularyExercise> exercises;

  const VocabularyPracticeScreen({
    super.key,
    required this.exercises,
  });

  @override
  State<VocabularyPracticeScreen> createState() =>
      _VocabularyPracticeScreenState();
}

class _VocabularyPracticeScreenState extends State<VocabularyPracticeScreen> {
  final TTSService _tts = TTSService();
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _showFeedback = false;
  int _correctCount = 0;

  @override
  void initState() {
    super.initState();
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
      "Let's practice some vocabulary! Read each word and choose the correct definition.",
    );
  }

  VocabularyExercise get _currentExercise => widget.exercises[_currentIndex];

  void _selectAnswer(int index) {
    if (_showFeedback) return;

    setState(() {
      _selectedAnswer = index;
    });
  }

  void _checkAnswer() {
    if (_selectedAnswer == null) return;

    final isCorrect = _selectedAnswer == _currentExercise.correctAnswerIndex;

    setState(() {
      _showFeedback = true;
      if (isCorrect) {
        _correctCount++;
      }
    });

    if (isCorrect) {
      _tts.speak("Excellent! That's correct!");
    } else {
      _tts.speak("Not quite. The correct answer is ${_currentExercise.options[_currentExercise.correctAnswerIndex]}.");
    }
  }

  void _nextWord() {
    if (_currentIndex < widget.exercises.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _showFeedback = false;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    final accuracy = (_correctCount / widget.exercises.length * 100).round();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Great Job!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              accuracy >= 80 ? Icons.celebration : Icons.thumb_up,
              size: 64,
              color: accuracy >= 80 ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              '$accuracy%',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: accuracy >= 80 ? Colors.green : Colors.orange,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'You got $_correctCount out of ${widget.exercises.length} correct!',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );

    _tts.speak(
      'You got $_correctCount out of ${widget.exercises.length} correct! ${accuracy >= 80 ? "Excellent work!" : "Keep practicing!"}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary Practice'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress
              LinearProgressIndicator(
                value: (_currentIndex + 1) / widget.exercises.length,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.purple.shade600,
                ),
                minHeight: 8,
              ),
              const SizedBox(height: 16),

              Text(
                'Word ${_currentIndex + 1} of ${widget.exercises.length}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Word card
              Card(
                elevation: 4,
                color: Colors.purple.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        _currentExercise.word,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade900,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Choose the correct definition:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.purple.shade700,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Options
              Expanded(
                child: ListView.builder(
                  itemCount: _currentExercise.options.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedAnswer == index;
                    final isCorrect =
                        index == _currentExercise.correctAnswerIndex;
                    final showCorrect = _showFeedback && isCorrect;
                    final showWrong = _showFeedback && isSelected && !isCorrect;

                    Color? borderColor;
                    Color? backgroundColor;

                    if (showCorrect) {
                      borderColor = Colors.green;
                      backgroundColor = Colors.green.shade50;
                    } else if (showWrong) {
                      borderColor = Colors.red;
                      backgroundColor = Colors.red.shade50;
                    } else if (isSelected) {
                      borderColor = Colors.purple.shade600;
                      backgroundColor = Colors.purple.shade50;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => _selectAnswer(index),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: backgroundColor ?? Colors.grey.shade50,
                            border: Border.all(
                              color: borderColor ?? Colors.grey.shade300,
                              width: isSelected || showCorrect || showWrong ? 3 : 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              if (showCorrect)
                                const Icon(Icons.check_circle, color: Colors.green, size: 24)
                              else if (showWrong)
                                const Icon(Icons.cancel, color: Colors.red, size: 24)
                              else
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? Colors.purple.shade600
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.purple.shade600
                                          : Colors.grey.shade400,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      String.fromCharCode(65 + index),
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey.shade700,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  _currentExercise.options[index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontWeight: isSelected || showCorrect
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Example sentences (after feedback)
              if (_showFeedback) ...[
                const SizedBox(height: 16),
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: Colors.blue.shade700),
                            const SizedBox(width: 8),
                            Text(
                              'Example:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _currentExercise.exampleSentences.first,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // Action button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _showFeedback
                      ? _nextWord
                      : (_selectedAnswer != null ? _checkAnswer : null),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _showFeedback
                        ? (_currentIndex == widget.exercises.length - 1
                            ? 'Finish'
                            : 'Next Word')
                        : 'Check Answer',
                    style: const TextStyle(
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
