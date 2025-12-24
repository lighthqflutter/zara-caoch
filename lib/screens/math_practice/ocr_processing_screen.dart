import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/problem.dart';
import '../../services/ocr/ocr_service.dart';
import '../../services/voice/tts_service.dart';

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
  final TTSService _tts = TTSService();
  String _statusMessage = 'Reading your work...';

  @override
  void initState() {
    super.initState();
    _speakProcessing();
    _processImage();
  }

  Future<void> _speakProcessing() async {
    await _tts.speakProcessing();
  }

  @override
  void dispose() {
    _tts.stop();
    _ocrService.dispose();
    super.dispose();
  }

  Future<void> _processImage() async {
    setState(() {
      _statusMessage = 'Analyzing your handwriting...';
    });

    await Future.delayed(const Duration(seconds: 1)); // Small delay for UX

    final result = await _ocrService.processImage(widget.photoPath);

    if (!mounted) return;

    if (result.isReliable || result.extractedAnswers.isNotEmpty) {
      // OCR got some results - let user review them
      setState(() {
        _statusMessage = 'Done! Please check if I read your answers correctly.';
      });

      await Future.delayed(const Duration(milliseconds: 800));

      if (mounted) {
        context.go(
          '/math-practice/ocr-review',
          extra: {
            'problems': widget.problems,
            'ocrResult': result,
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
