import 'dart:math';
import '../../models/english_exercise.dart';

/// Service for generating English language exercises
class EnglishExerciseGenerator {
  final Random _random = Random();

  /// Generate reading comprehension exercises
  List<ReadingComprehensionExercise> generateReadingExercises({
    required EnglishDifficultyLevel difficulty,
    required int count,
  }) {
    final exercises = <ReadingComprehensionExercise>[];

    for (int i = 0; i < count; i++) {
      exercises.add(_generateReadingExercise(difficulty, i));
    }

    return exercises;
  }

  /// Generate vocabulary exercises
  List<VocabularyExercise> generateVocabularyExercises({
    required EnglishDifficultyLevel difficulty,
    required int count,
  }) {
    final exercises = <VocabularyExercise>[];

    for (int i = 0; i < count; i++) {
      exercises.add(_generateVocabularyExercise(difficulty, i));
    }

    return exercises;
  }

  ReadingComprehensionExercise _generateReadingExercise(
    EnglishDifficultyLevel difficulty,
    int index,
  ) {
    final passages = _getPassagesForLevel(difficulty);
    final passageData = passages[_random.nextInt(passages.length)];

    return ReadingComprehensionExercise(
      id: 'reading_${DateTime.now().millisecondsSinceEpoch}_$index',
      title: passageData['title'] as String,
      passage: passageData['passage'] as String,
      questions: (passageData['questions'] as List)
          .map((q) => ComprehensionQuestion(
                question: q['question'] as String,
                options: List<String>.from(q['options'] as List),
                correctAnswerIndex: q['correct'] as int,
                explanation: q['explanation'] as String?,
              ))
          .toList(),
      difficulty: difficulty,
    );
  }

  VocabularyExercise _generateVocabularyExercise(
    EnglishDifficultyLevel difficulty,
    int index,
  ) {
    final words = _getWordsForLevel(difficulty);
    final wordData = words[_random.nextInt(words.length)];

    return VocabularyExercise(
      id: 'vocab_${DateTime.now().millisecondsSinceEpoch}_$index',
      word: wordData['word'] as String,
      definition: wordData['definition'] as String,
      exampleSentences:
          List<String>.from(wordData['examples'] as List),
      questionType: VocabularyQuestionType.definition,
      options: List<String>.from(wordData['options'] as List),
      correctAnswerIndex: wordData['correct'] as int,
      difficulty: difficulty,
    );
  }

  List<Map<String, dynamic>> _getPassagesForLevel(
      EnglishDifficultyLevel difficulty) {
    switch (difficulty) {
      case EnglishDifficultyLevel.level1:
        return _primaryLevel1Passages;
      case EnglishDifficultyLevel.level2:
        return _primaryLevel2Passages;
      case EnglishDifficultyLevel.level3:
        return _secondaryPassages;
    }
  }

  List<Map<String, dynamic>> _getWordsForLevel(
      EnglishDifficultyLevel difficulty) {
    switch (difficulty) {
      case EnglishDifficultyLevel.level1:
        return _primaryLevel1Words;
      case EnglishDifficultyLevel.level2:
        return _primaryLevel2Words;
      case EnglishDifficultyLevel.level3:
        return _secondaryWords;
    }
  }

  // Sample passages for Primary 4-5
  static final List<Map<String, dynamic>> _primaryLevel1Passages = [
    {
      'title': 'A Day at the Beach',
      'passage':
          'Last weekend, my family went to the beach. The sun was shining brightly, and the water was crystal clear. My sister and I built a huge sandcastle with towers and a moat. We decorated it with shells we found along the shore. Later, we went swimming in the cool ocean. The waves were gentle, and we had so much fun jumping over them. Before we left, we watched the beautiful sunset paint the sky orange and pink.',
      'questions': [
        {
          'question': 'When did the family go to the beach?',
          'options': [
            'Yesterday',
            'Last weekend',
            'Last month',
            'This morning'
          ],
          'correct': 1,
          'explanation':
              'The passage states "Last weekend, my family went to the beach."'
        },
        {
          'question': 'What did the children build?',
          'options': [
            'A boat',
            'A sandcastle',
            'A bridge',
            'A house'
          ],
          'correct': 1,
          'explanation':
              'The passage mentions they built "a huge sandcastle with towers and a moat."'
        },
        {
          'question': 'How were the waves described?',
          'options': [
            'Rough and dangerous',
            'Gentle',
            'Very high',
            'Non-existent'
          ],
          'correct': 1,
          'explanation': 'The text says "The waves were gentle."'
        },
      ],
    },
    {
      'title': 'The Lost Puppy',
      'passage':
          'One rainy afternoon, Emma heard a soft whimpering sound from her backyard. She looked out the window and saw a small, wet puppy hiding under a bush. The puppy looked scared and hungry. Emma quickly grabbed a towel and some food. She gently approached the puppy, speaking in a calm voice. After a few minutes, the puppy came out and ate the food gratefully. Emma and her parents decided to take care of the puppy until they could find its owner.',
      'questions': [
        {
          'question': 'Where did Emma find the puppy?',
          'options': [
            'In the front yard',
            'Under a bush in the backyard',
            'On the street',
            'At the park'
          ],
          'correct': 1,
          'explanation':
              'The passage states she "saw a small, wet puppy hiding under a bush" in her backyard.'
        },
        {
          'question': 'How did the puppy look when Emma found it?',
          'options': [
            'Happy and playful',
            'Scared and hungry',
            'Sleeping peacefully',
            'Running around'
          ],
          'correct': 1,
          'explanation': 'The text says "The puppy looked scared and hungry."'
        },
      ],
    },
  ];

  // Sample passages for Primary 6
  static final List<Map<String, dynamic>> _primaryLevel2Passages = [
    {
      'title': 'The Science Fair Project',
      'passage':
          'Maya had been working on her science fair project for three weeks. She chose to study how different types of music affect plant growth. She planted six identical seedlings and played different genres of music to three of them while keeping three in silence as a control group. Every day, she measured their height and recorded the data carefully in her notebook. After two weeks, she noticed that the plants exposed to classical music grew taller than both the plants with rock music and those in silence. Maya was excited to present her findings at the science fair next week.',
      'questions': [
        {
          'question': 'What was Maya studying in her project?',
          'options': [
            'How water affects plants',
            'How music affects plant growth',
            'Different types of plants',
            'How sunlight affects plants'
          ],
          'correct': 1,
          'explanation':
              'The passage clearly states she studied "how different types of music affect plant growth."'
        },
        {
          'question': 'Which plants grew the tallest?',
          'options': [
            'Plants with rock music',
            'Plants in silence',
            'Plants with classical music',
            'All grew the same'
          ],
          'correct': 2,
          'explanation':
              'The text mentions "the plants exposed to classical music grew taller."'
        },
      ],
    },
  ];

  // Sample passages for Secondary
  static final List<Map<String, dynamic>> _secondaryPassages = [
    {
      'title': 'The Future of Renewable Energy',
      'passage':
          'As global concerns about climate change intensify, the shift toward renewable energy sources has become increasingly crucial. Solar and wind power, once considered alternative options, are now mainstream solutions adopted by countries worldwide. Recent technological advances have significantly reduced the cost of solar panels, making them accessible to more households and businesses. Wind turbines have also become more efficient, capable of generating power even in low-wind conditions. However, challenges remain, particularly in energy storage and grid infrastructure. Scientists are working on innovative battery technologies to store excess energy produced during peak generation times for use when production is low.',
      'questions': [
        {
          'question':
              'According to the passage, what has made solar panels more accessible?',
          'options': [
            'Government subsidies',
            'Technological advances reducing costs',
            'Increased demand',
            'Better weather conditions'
          ],
          'correct': 1,
          'explanation':
              'The passage states "technological advances have significantly reduced the cost of solar panels, making them accessible."'
        },
        {
          'question': 'What is one remaining challenge mentioned?',
          'options': [
            'High costs',
            'Lack of wind',
            'Energy storage',
            'Public opposition'
          ],
          'correct': 2,
          'explanation':
              'The text mentions "challenges remain, particularly in energy storage and grid infrastructure."'
        },
      ],
    },
  ];

  // Vocabulary words for Primary 4-5
  static final List<Map<String, dynamic>> _primaryLevel1Words = [
    {
      'word': 'grateful',
      'definition': 'Feeling or showing thanks; appreciative',
      'examples': [
        'I am grateful for my parents\' support.',
        'She felt grateful when her friend helped her.',
      ],
      'options': [
        'Feeling or showing thanks',
        'Feeling angry',
        'Feeling tired',
        'Feeling confused'
      ],
      'correct': 0,
    },
    {
      'word': 'enormous',
      'definition': 'Very large in size or amount',
      'examples': [
        'The elephant was enormous!',
        'She had an enormous pile of homework.',
      ],
      'options': [
        'Very small',
        'Very large',
        'Very colorful',
        'Very quiet'
      ],
      'correct': 1,
    },
    {
      'word': 'curious',
      'definition': 'Eager to know or learn something',
      'examples': [
        'The curious cat explored every corner.',
        'He was curious about how things work.',
      ],
      'options': [
        'Feeling sleepy',
        'Eager to learn',
        'Feeling scared',
        'Feeling bored'
      ],
      'correct': 1,
    },
  ];

  // Vocabulary words for Primary 6
  static final List<Map<String, dynamic>> _primaryLevel2Words = [
    {
      'word': 'persevere',
      'definition': 'To continue trying despite difficulties',
      'examples': [
        'She persevered through the challenging math problem.',
        'Athletes must persevere during tough training.',
      ],
      'options': [
        'To give up quickly',
        'To continue despite difficulties',
        'To complain loudly',
        'To celebrate success'
      ],
      'correct': 1,
    },
    {
      'word': 'meticulous',
      'definition': 'Showing great attention to detail; very careful',
      'examples': [
        'He was meticulous in his science experiments.',
        'The artist was meticulous about every brushstroke.',
      ],
      'options': [
        'Very careless',
        'Very quick',
        'Very careful and detailed',
        'Very lazy'
      ],
      'correct': 2,
    },
  ];

  // Vocabulary words for Secondary
  static final List<Map<String, dynamic>> _secondaryWords = [
    {
      'word': 'eloquent',
      'definition': 'Fluent and persuasive in speaking or writing',
      'examples': [
        'The speaker gave an eloquent speech.',
        'Her eloquent writing moved many readers.',
      ],
      'options': [
        'Difficult to understand',
        'Fluent and persuasive',
        'Boring and dull',
        'Angry and loud'
      ],
      'correct': 1,
    },
    {
      'word': 'innovative',
      'definition': 'Featuring new methods; creative and original',
      'examples': [
        'The company developed innovative solutions.',
        'Her innovative approach solved the problem.',
      ],
      'options': [
        'Traditional and old',
        'Creative and original',
        'Expensive and luxurious',
        'Simple and basic'
      ],
      'correct': 1,
    },
  ];
}
