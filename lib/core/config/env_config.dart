import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration service for managing API keys and sensitive data
class EnvConfig {
  static bool _isInitialized = false;

  /// Initialize environment variables from .env file
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await dotenv.load(fileName: ".env");
      _isInitialized = true;
    } catch (e) {
      // .env file not found or error loading
      // This is okay for development - services will use fallback behavior
      _isInitialized = false;
    }
  }

  /// Get OpenAI API key
  static String get openAiApiKey {
    return dotenv.env['OPENAI_API_KEY'] ?? '';
  }

  /// Check if environment is properly configured
  static bool get isConfigured {
    return _isInitialized && openAiApiKey.isNotEmpty;
  }

  /// Get all available config keys (for debugging, never log values!)
  static List<String> get availableKeys {
    return dotenv.env.keys.toList();
  }
}
