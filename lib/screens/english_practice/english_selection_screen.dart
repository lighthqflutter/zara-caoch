import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/english_exercise.dart';
import '../../services/english/english_exercise_generator.dart';
import '../../services/voice/tts_service.dart';

/// Screen for selecting English practice type
class EnglishSelectionScreen extends StatefulWidget {
  const EnglishSelectionScreen({super.key});

  @override
  State<EnglishSelectionScreen> createState() => _EnglishSelectionScreenState();
}

class _EnglishSelectionScreenState extends State<EnglishSelectionScreen> {
  final TTSService _tts = TTSService();
  final EnglishExerciseGenerator _generator = EnglishExerciseGenerator();

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
      "Great! Let's practice English. Choose what you'd like to work on!",
    );
  }

  void _startReadingPractice() {
    final exercises = _generator.generateReadingExercises(
      difficulty: EnglishDifficultyLevel.level1,
      count: 1,
    );

    context.push(
      '/english-practice/reading',
      extra: exercises.first,
    );
  }

  void _startVocabularyPractice() {
    final exercises = _generator.generateVocabularyExercises(
      difficulty: EnglishDifficultyLevel.level1,
      count: 3,
    );

    context.push(
      '/english-practice/vocabulary',
      extra: exercises,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('English Practice'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Choose Your Activity',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 48),

              // Reading Comprehension card
              _ActivityCard(
                icon: Icons.book,
                title: 'Reading Comprehension',
                subtitle: 'Read passages and answer questions',
                color: Colors.green,
                onTap: _startReadingPractice,
              ),
              const SizedBox(height: 20),

              // Vocabulary card
              _ActivityCard(
                icon: Icons.text_fields,
                title: 'Vocabulary Builder',
                subtitle: 'Learn new words and their meanings',
                color: Colors.purple,
                onTap: _startVocabularyPractice,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final MaterialColor color;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.3),
                color.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.shade600,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color.shade900,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: color.shade700,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color.shade700,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
