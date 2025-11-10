import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/problem.dart';
import '../../services/ocr/ocr_service.dart';

/// Screen for processing OCR and deciding next step
class OCRProcessingScreen extends StatefulWidget {
  final List<MathProblem> problems;
  final String photoPath;

  const OCRProcessingScreen({
    super.key,
    required this.problems,
    required this.photoPath,
  });

  @override
  State<OCRProcessingScreen> createState() => _OCRProcessingScreenState();
}

class _OCRProcessingScreenState extends State<OCRProcessingScreen> {
  final OCRService _ocrService = OCRService();
  String _statusMessage = 'Reading your work...';

  @override
  void initState() {
    super.initState();
    _processImage();
  }

  Future<void> _processImage() async {
    setState(() {
      _statusMessage = 'Analyzing your handwriting...';
    });

    await Future.delayed(const Duration(seconds: 1)); // Small delay for UX

    final result = await _ocrService.processImage(widget.photoPath);

    if (!mounted) return;

    if (result.isReliable) {
      // OCR succeeded - go to review screen with extracted answers
      setState(() {
        _statusMessage = 'Great! I can read your work!';
      });

      await Future.delayed(const Duration(milliseconds: 800));

      if (mounted) {
        context.go(
          '/math-practice/review',
          extra: {
            'problems': widget.problems,
            'answers': result.extractedAnswers,
            'photoPath': widget.photoPath,
          },
        );
      }
    } else {
      // OCR failed - go to typed input screen
      setState(() {
        _statusMessage = 'Having trouble reading. Let\'s type the answers!';
      });

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        context.go(
          '/math-practice/typed-input',
          extra: {
            'problems': widget.problems,
            'photoPath': widget.photoPath,
          },
        );
      }
    }
  }

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Loading animation
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // Status message
                Text(
                  _statusMessage,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Sub message
                Text(
                  'This will only take a moment...',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
