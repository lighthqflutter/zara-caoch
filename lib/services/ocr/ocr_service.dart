import 'package:google_ml_kit/google_ml_kit.dart';

/// Result of OCR processing
class OCRResult {
  final List<int> extractedAnswers;
  final double confidence;
  final String rawText;
  final bool isReliable;

  const OCRResult({
    required this.extractedAnswers,
    required this.confidence,
    required this.rawText,
    required this.isReliable,
  });
}

/// Service for extracting text and answers from photos using ML Kit
class OCRService {
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();

  /// Process photo and extract mathematical answers
  Future<OCRResult> processImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      // Extract raw text
      final String rawText = recognizedText.text;

      // Parse answers from text
      final answers = _extractAnswers(rawText, recognizedText);

      // Calculate confidence
      final confidence = _calculateConfidence(recognizedText, answers);

      // Determine if result is reliable (>= 70% confidence)
      final isReliable = confidence >= 0.7 && answers.isNotEmpty;

      return OCRResult(
        extractedAnswers: answers,
        confidence: confidence,
        rawText: rawText,
        isReliable: isReliable,
      );
    } catch (e) {
      return const OCRResult(
        extractedAnswers: [],
        confidence: 0.0,
        rawText: '',
        isReliable: false,
      );
    }
  }

  /// Extract numeric answers from recognized text
  List<int> _extractAnswers(String text, RecognizedText recognizedText) {
    final answers = <int>[];

    // Look for patterns like:
    // "= 45", "45", "answer: 45", etc.
    final RegExp numberPattern = RegExp(r'\b\d{1,4}\b');
    final matches = numberPattern.allMatches(text);

    // Filter and extract likely answers
    for (final match in matches) {
      final numStr = match.group(0);
      if (numStr != null) {
        try {
          final num = int.parse(numStr);
          // Basic validation: answers likely between 0-9999
          if (num >= 0 && num < 10000) {
            answers.add(num);
          }
        } catch (e) {
          // Skip invalid numbers
        }
      }
    }

    // If we found more than 2 answers, try to identify the most likely ones
    // by looking for answers after "=" signs or at the bottom of the page
    if (answers.length > 2) {
      return _filterMostLikelyAnswers(answers, recognizedText);
    }

    return answers.take(2).toList();
  }

  /// Filter to find the most likely answer values
  List<int> _filterMostLikelyAnswers(
    List<int> answers,
    RecognizedText recognizedText,
  ) {
    // Look for numbers that appear after "=" or on separate lines
    final likelyAnswers = <int>[];

    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        final lineText = line.text;
        if (lineText.contains('=') || lineText.contains('answer')) {
          // Extract number from this line
          final numberMatch = RegExp(r'\d{1,4}').firstMatch(lineText);
          if (numberMatch != null) {
            try {
              final num = int.parse(numberMatch.group(0)!);
              if (!likelyAnswers.contains(num)) {
                likelyAnswers.add(num);
              }
            } catch (e) {
              // Skip
            }
          }
        }
      }
    }

    // If we found answers with "=" context, use those
    if (likelyAnswers.isNotEmpty) {
      return likelyAnswers.take(2).toList();
    }

    // Otherwise, take the last 2 numbers (likely to be answers at bottom)
    return answers.length >= 2
        ? answers.sublist(answers.length - 2)
        : answers;
  }

  /// Calculate overall confidence score
  double _calculateConfidence(
    RecognizedText recognizedText,
    List<int> extractedAnswers,
  ) {
    if (recognizedText.blocks.isEmpty || extractedAnswers.isEmpty) {
      return 0.0;
    }

    // Factors that affect confidence:
    // 1. Number of blocks detected (more is better, indicates clear image)
    // 2. Number of answers extracted (should be 2)
    // 3. Text clarity (based on block count and line count)

    double confidence = 0.0;

    // Factor 1: Text detection quality
    final blockCount = recognizedText.blocks.length;
    if (blockCount >= 2) {
      confidence += 0.3;
    } else if (blockCount == 1) {
      confidence += 0.15;
    }

    // Factor 2: Answer extraction
    if (extractedAnswers.length == 2) {
      confidence += 0.5;
    } else if (extractedAnswers.length == 1) {
      confidence += 0.25;
    }

    // Factor 3: Text contains mathematical symbols
    final text = recognizedText.text.toLowerCase();
    if (text.contains('+') ||
        text.contains('-') ||
        text.contains('=') ||
        text.contains('answer')) {
      confidence += 0.2;
    }

    return confidence.clamp(0.0, 1.0);
  }

  /// Dispose resources
  void dispose() {
    _textRecognizer.close();
  }
}
