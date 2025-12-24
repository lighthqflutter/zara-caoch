import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../models/problem.dart';
import '../../services/ocr/ocr_service.dart';
import '../../services/voice/tts_service.dart';

/// Screen for reviewing and correcting OCR results before grading
class OCRReviewScreen extends StatefulWidget {
  final List<MathProblem> problems;
  final OCRResult ocrResult;
  final String photoPath;

  const OCRReviewScreen({
    super.key,
    required this.problems,
    required this.ocrResult,
    required this.photoPath,
  });

  @override
  State<OCRReviewScreen> createState() => _OCRReviewScreenState();
}

class _OCRReviewScreenState extends State<OCRReviewScreen> {
  final TTSService _tts = TTSService();
  late List<TextEditingController> _controllers;
  late List<int?> _answers;

  @override
  void initState() {
    super.initState();

    // Initialize answers from OCR or empty
    _answers = List.generate(
      widget.problems.length,
      (index) => index < widget.ocrResult.extractedAnswers.length
          ? widget.ocrResult.extractedAnswers[index]
          : null,
    );

    // Create text controllers with OCR values
    _controllers = List.generate(
      widget.problems.length,
      (index) => TextEditingController(
        text: _answers[index]?.toString() ?? '',
      ),
    );

    _speakInstructions();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _tts.stop();
    super.dispose();
  }

  Future<void> _speakInstructions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await _tts.speak(
      "I've read your answers from the photo. Please check if they're correct. You can edit any that don't look right!",
    );
  }

  void _submitAnswers() {
    // Update answers from text fields
    for (int i = 0; i < _controllers.length; i++) {
      final text = _controllers[i].text.trim();
      if (text.isNotEmpty) {
        _answers[i] = int.tryParse(text);
      } else {
        _answers[i] = null;
      }
    }

    // Check if all answers are provided
    final allAnswered = _answers.every((answer) => answer != null);

    if (!allAnswered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all answers'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Navigate to review screen with corrected answers
    context.go(
      '/math-practice/review',
      extra: {
        'problems': widget.problems,
        'answers': _answers.map((a) => a!).toList(),
        'photoPath': widget.photoPath,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Your Answers'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Instructions card
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Review Your Answers',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade900,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'I tried to read your handwriting. Please check if the answers below are correct and fix any mistakes!',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.blue.shade800,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // OCR Confidence indicator
              if (widget.ocrResult.confidence > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.ocrResult.confidence >= 0.8
                            ? Icons.check_circle
                            : Icons.warning_amber,
                        color: widget.ocrResult.confidence >= 0.8
                            ? Colors.green
                            : Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Reading confidence: ${(widget.ocrResult.confidence * 100).toInt()}%',
                        style: TextStyle(
                          color: widget.ocrResult.confidence >= 0.8
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

              // Problem list with editable answers
              Expanded(
                child: ListView.builder(
                  itemCount: widget.problems.length,
                  itemBuilder: (context, index) {
                    final problem = widget.problems[index];
                    return _buildProblemCard(index, problem);
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitAnswers,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Submit Answers',
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

  Widget _buildProblemCard(int index, MathProblem problem) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Problem number
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
                'Problem ${index + 1}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Problem display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${problem.operand1} ${problem.type.symbol} ${problem.operand2} =',
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                // Editable answer field
                SizedBox(
                  width: 120,
                  child: TextField(
                    controller: _controllers[index],
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: '?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 3,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Helper text
            if (_answers[index] != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'I read: ${_answers[index]}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
