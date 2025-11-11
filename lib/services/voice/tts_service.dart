import 'package:flutter_tts/flutter_tts.dart';

/// Singleton service for text-to-speech functionality
class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;
  TTSService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  bool _isSpeaking = false;
  bool _isEnabled = true;
  final List<String> _messageQueue = [];

  /// Initialize TTS engine with default settings
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Set language
      await _flutterTts.setLanguage("en-US");

      // Set speech rate (0.0 to 1.0, default 0.5)
      await _flutterTts.setSpeechRate(0.45); // Slightly slower for clarity

      // Set volume (0.0 to 1.0)
      await _flutterTts.setVolume(1.0);

      // Set pitch (0.5 to 2.0, default 1.0)
      await _flutterTts.setPitch(1.1); // Slightly higher for friendliness

      // iOS specific settings
      await _flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        ],
        IosTextToSpeechAudioMode.defaultMode,
      );

      // Set up completion handler
      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
        _processQueue();
      });

      // Set up error handler
      _flutterTts.setErrorHandler((message) {
        _isSpeaking = false;
        _processQueue();
      });

      _isInitialized = true;
    } catch (e) {
      // Fail silently - voice is optional
      _isInitialized = false;
    }
  }

  /// Speak the given text
  Future<void> speak(String text) async {
    if (!_isEnabled || text.isEmpty) return;

    if (!_isInitialized) {
      await initialize();
    }

    if (!_isInitialized) return; // Still failed, give up

    // Add to queue
    _messageQueue.add(text);

    // Process queue if not already speaking
    if (!_isSpeaking) {
      await _processQueue();
    }
  }

  /// Process the message queue
  Future<void> _processQueue() async {
    if (_messageQueue.isEmpty || !_isEnabled) {
      _isSpeaking = false;
      return;
    }

    _isSpeaking = true;
    final message = _messageQueue.removeAt(0);

    try {
      await _flutterTts.speak(message);
    } catch (e) {
      _isSpeaking = false;
      _processQueue(); // Try next message
    }
  }

  /// Stop current speech and clear queue
  Future<void> stop() async {
    _messageQueue.clear();
    _isSpeaking = false;
    if (_isInitialized) {
      await _flutterTts.stop();
    }
  }

  /// Pause current speech
  Future<void> pause() async {
    if (_isInitialized) {
      await _flutterTts.pause();
    }
  }

  /// Enable or disable TTS
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
    if (!enabled) {
      stop();
    }
  }

  /// Get enabled status
  bool get isEnabled => _isEnabled;

  /// Get speaking status
  bool get isSpeaking => _isSpeaking;

  /// Dispose resources
  Future<void> dispose() async {
    await stop();
  }
}

/// Extension for common voice messages
extension TTSMessages on TTSService {
  /// Welcome message for math practice
  Future<void> speakMathWelcome(int problemCount) async {
    await speak(
      "Hi Zara! Ready to practice? I have $problemCount problem${problemCount > 1 ? 's' : ''} for you today. "
      "Solve them in your notebook, then take a photo when you're done!",
    );
  }

  /// Camera instructions
  Future<void> speakCameraInstructions() async {
    await speak(
      "Perfect! Now take a clear photo of your work. "
      "Make sure the lighting is good and I can see all your answers!",
    );
  }

  /// OCR processing message
  Future<void> speakProcessing() async {
    await speak("Let me check your work... This will just take a moment!");
  }

  /// Feedback message (correct answer)
  Future<void> speakCorrectFeedback() async {
    final messages = [
      "Great work! That's correct! You're doing an amazing job!",
      "Excellent! You got it right! Keep up the great work!",
      "Perfect! Well done! You're a math star!",
      "Awesome! That's the right answer! You're doing fantastic!",
    ];
    final index = DateTime.now().millisecond % messages.length;
    await speak(messages[index]);
  }

  /// Feedback message (incorrect answer)
  Future<void> speakIncorrectFeedback(String feedbackMessage) async {
    await speak(feedbackMessage);
  }

  /// Summary message
  Future<void> speakSummary({
    required int correct,
    required int total,
    required double accuracy,
  }) async {
    String message;

    if (accuracy == 100) {
      message =
          "Wow! Perfect score! You got all $total problems correct! You're a math superstar!";
    } else if (accuracy >= 80) {
      message =
          "Great work! You got $correct out of $total correct! You're getting better and better!";
    } else if (accuracy >= 60) {
      message =
          "Good effort! You got $correct out of $total correct! Keep practicing and you'll get even better!";
    } else {
      message =
          "Nice try! You got $correct out of $total correct! Let's practice more together!";
    }

    await speak(message);
  }

  /// Encouragement when reviewing problem
  Future<void> speakReviewingProblem(int problemNumber, int total) async {
    await speak("Let's look at problem $problemNumber of $total.");
  }
}
