import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/problem.dart';
import '../../models/session.dart';

/// AI-generated feedback for a problem attempt
class AIFeedback {
  final String message;
  final String? errorType;
  final String? specificGuidance;

  const AIFeedback({
    required this.message,
    this.errorType,
    this.specificGuidance,
  });
}

/// Service for generating encouraging AI feedback using OpenAI
class FeedbackService {
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';
  final String _apiKey;

  FeedbackService({required String apiKey}) : _apiKey = apiKey;

  /// Generate feedback for a problem attempt
  Future<AIFeedback> generateFeedback({
    required MathProblem problem,
    required int userAnswer,
    required bool isCorrect,
  }) async {
    if (isCorrect) {
      return _generatePositiveFeedback(problem);
    } else {
      return _generateCorrectiveFeedback(problem, userAnswer);
    }
  }

  /// Generate positive feedback for correct answers
  AIFeedback _generatePositiveFeedback(MathProblem problem) {
    final messages = [
      'Great work! That\'s correct! 🎉',
      'Excellent! You got it right! ⭐',
      'Perfect! Well done! 👏',
      'Awesome job! Keep it up! 🌟',
      'That\'s right! You\'re doing great! ✨',
      'Fantastic! You solved it! 🎯',
    ];

    return AIFeedback(
      message: messages[DateTime.now().millisecond % messages.length],
    );
  }

  /// Generate corrective feedback using AI
  Future<AIFeedback> _generateCorrectiveFeedback(
    MathProblem problem,
    int userAnswer,
  ) async {
    try {
      final prompt = _buildFeedbackPrompt(problem, userAnswer);
      final response = await _callOpenAI(prompt);

      // Parse response to extract feedback and error type
      return _parseFeedbackResponse(response, problem, userAnswer);
    } catch (e) {
      // Fallback to simple feedback if API fails
      return _generateFallbackFeedback(problem, userAnswer);
    }
  }

  /// Build prompt for OpenAI
  String _buildFeedbackPrompt(MathProblem problem, int userAnswer) {
    return '''
You are a patient, encouraging math tutor for a 10-year-old with ADHD.
The child solved this problem:

Problem: ${problem.operand1} ${problem.type.symbol} ${problem.operand2}
Correct Answer: ${problem.correctAnswer}
Child's Answer: $userAnswer

Provide:
1. A brief, encouraging message (1-2 sentences)
2. Identify the likely error type (carrying, borrowing, alignment, or basic arithmetic)
3. Specific guidance on what to check (1 sentence)

Keep the tone positive and patient. Never say "wrong" or "incorrect". Instead say "not quite" or "let's try again".
Use simple, clear language appropriate for a 10-year-old.

Format your response as JSON:
{
  "message": "encouraging message here",
  "errorType": "carrying/borrowing/alignment/basicArithmetic",
  "guidance": "specific guidance here"
}
''';
  }

  /// Call OpenAI API
  Future<String> _callOpenAI(String prompt) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4',
        'messages': [
          {
            'role': 'system',
            'content':
                'You are a patient, encouraging math tutor for children with ADHD. Always respond in JSON format.'
          },
          {'role': 'user', 'content': prompt}
        ],
        'temperature': 0.7,
        'max_tokens': 200,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] as String;
    } else {
      throw Exception('OpenAI API failed: ${response.statusCode}');
    }
  }

  /// Parse AI response
  AIFeedback _parseFeedbackResponse(
    String response,
    MathProblem problem,
    int userAnswer,
  ) {
    try {
      // Extract JSON from response (might be wrapped in markdown)
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(response);
      if (jsonMatch != null) {
        final jsonStr = jsonMatch.group(0)!;
        final data = jsonDecode(jsonStr);

        return AIFeedback(
          message: data['message'] as String,
          errorType: data['errorType'] as String?,
          specificGuidance: data['guidance'] as String?,
        );
      }
    } catch (e) {
      // Fallback if parsing fails
    }

    return _generateFallbackFeedback(problem, userAnswer);
  }

  /// Generate fallback feedback when AI is unavailable
  AIFeedback _generateFallbackFeedback(
    MathProblem problem,
    int userAnswer,
  ) {
    final difference = (problem.correctAnswer - userAnswer).abs();
    String errorType = 'basicArithmetic';
    String guidance = 'Try solving it again step by step.';

    // Detect likely error type based on difference
    if (problem.type == ProblemType.addition) {
      if (difference == 10 || difference == 100) {
        errorType = 'carrying';
        guidance = 'Check if you need to carry a number to the next column.';
      }
    } else if (problem.type == ProblemType.subtraction) {
      if (difference == 10 || difference == 100) {
        errorType = 'borrowing';
        guidance = 'Check if you need to borrow from the next column.';
      }
    }

    return AIFeedback(
      message:
          'Not quite, but you\'re close! The answer is ${problem.correctAnswer}. Let\'s figure out what happened.',
      errorType: errorType,
      specificGuidance: guidance,
    );
  }

  /// Generate batch feedback for multiple problems
  Future<List<AIFeedback>> generateBatchFeedback({
    required List<ProblemAttempt> attempts,
  }) async {
    final feedbacks = <AIFeedback>[];

    for (final attempt in attempts) {
      if (attempt.userAnswer != null) {
        final feedback = await generateFeedback(
          problem: attempt.problem,
          userAnswer: attempt.userAnswer!,
          isCorrect: attempt.isCorrect,
        );
        feedbacks.add(feedback);
      }
    }

    return feedbacks;
  }
}
