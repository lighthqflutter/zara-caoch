# Coding Standards - Zara Coach

**Project:** Zara Coach
**Language:** Dart 3.x / Flutter 3.x
**Purpose:** Maintain code quality, consistency, and maintainability

---

## General Principles

### SOLID Principles
- **S**ingle Responsibility: Each class/function has one clear purpose
- **O**pen/Closed: Open for extension, closed for modification
- **L**iskov Substitution: Subtypes must be substitutable for base types
- **I**nterface Segregation: Many specific interfaces > one general interface
- **D**ependency Inversion: Depend on abstractions, not concretions

### DRY (Don't Repeat Yourself)
- Extract repeated code into reusable functions/classes
- Use mixins for shared widget behavior
- Create constants for repeated values

### KISS (Keep It Simple, Stupid)
- Prefer simple solutions over clever ones
- Avoid premature optimization
- Write code that's easy to understand

---

## Dart Code Style

### Follow Official Dart Style Guide
- Use `dart format` for automatic formatting
- Enable `flutter_lints` in `analysis_options.yaml`
- Run `flutter analyze` before committing

### Naming Conventions

**Classes:** PascalCase
```dart
class MathProblemGenerator { }
class UserProfile { }
```

**Functions/Methods:** camelCase
```dart
void generateProblem() { }
Future<void> uploadPhoto() async { }
```

**Variables:** camelCase
```dart
int problemCount = 0;
String userName = 'Zara';
```

**Constants:** lowerCamelCase (Dart convention)
```dart
const int maxSessionLength = 40;
const String appName = 'Zara Coach';
```

**Private members:** Prefix with underscore
```dart
class MyClass {
  int _privateField;
  void _privateMethod() { }
}
```

**Files:** snake_case
```dart
// Good
math_problem_generator.dart
user_profile_service.dart

// Bad
MathProblemGenerator.dart
userProfileService.dart
```

---

## File Organization

### File Structure

**One class per file** (unless closely related small classes)

**File naming matches class name:**
```dart
// math_problem_generator.dart
class MathProblemGenerator { }
```

**Imports order:**
1. Dart core imports
2. Flutter imports
3. Third-party package imports
4. Local/project imports

```dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../models/problem.dart';
import '../services/api_service.dart';
```

**Use relative imports for local files:**
```dart
// Good
import '../models/problem.dart';

// Avoid
import 'package:zara_coach/models/problem.dart';
```

---

## Code Organization

### Project Structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── utils/
│   └── extensions/
├── models/
│   ├── problem.dart
│   ├── session.dart
│   └── user_profile.dart
├── services/
│   ├── api_service.dart
│   ├── firebase_service.dart
│   ├── problem_generator.dart
│   └── ocr_service.dart
├── providers/
│   ├── auth_provider.dart
│   ├── session_provider.dart
│   └── problem_provider.dart
├── screens/
│   ├── home/
│   ├── math_practice/
│   ├── parent_dashboard/
│   └── onboarding/
├── widgets/
│   ├── common/
│   ├── problem_display.dart
│   └── feedback_overlay.dart
└── routes/
    └── app_routes.dart
```

---

## Flutter Widget Best Practices

### StatelessWidget vs StatefulWidget

**Use StatelessWidget when:**
- No internal state changes
- Only rebuilds when parent rebuilds
- Presentational components

```dart
class ProblemDisplay extends StatelessWidget {
  final Problem problem;

  const ProblemDisplay({super.key, required this.problem});

  @override
  Widget build(BuildContext context) {
    return Text('${problem.question}');
  }
}
```

**Use StatefulWidget when:**
- Internal state changes
- Manages timers, controllers, animations

```dart
class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int _seconds = 0;

  @override
  Widget build(BuildContext context) {
    return Text('$_seconds seconds');
  }
}
```

### Widget Composition

**Break large widgets into smaller ones:**
```dart
// Bad - monolithic widget
class MathPracticeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 100+ lines of widget tree
        ],
      ),
    );
  }
}

// Good - composed widgets
class MathPracticeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ProblemHeader(),
          ProblemDisplay(),
          ActionButtons(),
        ],
      ),
    );
  }
}
```

### Use const constructors when possible
```dart
// Good - const constructor
const Text('Hello');
const SizedBox(height: 16);

// Avoid
Text('Hello');  // non-const when possible
```

---

## State Management (Provider)

### Provider Pattern

**Create providers for:**
- Authentication state
- User data
- Session management
- Problem generation

**Example:**
```dart
class SessionProvider extends ChangeNotifier {
  Session? _currentSession;

  Session? get currentSession => _currentSession;

  Future<void> startSession() async {
    _currentSession = Session(startTime: DateTime.now());
    notifyListeners();
  }

  Future<void> endSession() async {
    _currentSession = null;
    notifyListeners();
  }
}
```

**Usage in widgets:**
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);

    return Text('Session: ${sessionProvider.currentSession?.id}');
  }
}

// Or with Consumer
Consumer<SessionProvider>(
  builder: (context, sessionProvider, child) {
    return Text('Session: ${sessionProvider.currentSession?.id}');
  },
)
```

---

## Asynchronous Programming

### Use async/await

**Preferred:**
```dart
Future<void> loadData() async {
  try {
    final data = await apiService.fetchData();
    // process data
  } catch (e) {
    // handle error
  }
}
```

**Avoid .then() chains:**
```dart
// Avoid
apiService.fetchData().then((data) {
  // process
}).catchError((error) {
  // handle
});
```

### Handle errors properly

```dart
Future<Problem> generateProblem() async {
  try {
    final result = await _problemService.generate();
    return result;
  } on NetworkException catch (e) {
    log('Network error: $e');
    rethrow;
  } catch (e) {
    log('Unexpected error: $e');
    throw ProblemGenerationException('Failed to generate problem');
  }
}
```

### Use FutureBuilder for async UI

```dart
FutureBuilder<Problem>(
  future: problemService.generateProblem(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }

    if (snapshot.hasError) {
      return ErrorWidget(error: snapshot.error);
    }

    return ProblemDisplay(problem: snapshot.data!);
  },
)
```

---

## Error Handling

### Custom Exceptions

```dart
class ProblemGenerationException implements Exception {
  final String message;
  ProblemGenerationException(this.message);

  @override
  String toString() => 'ProblemGenerationException: $message';
}
```

### Try-Catch Blocks

```dart
Future<void> uploadPhoto(File photo) async {
  try {
    await storageService.upload(photo);
  } on StorageException catch (e) {
    log('Storage error: $e');
    // Show user-friendly message
    showErrorDialog('Failed to upload photo. Please try again.');
  } catch (e) {
    log('Unexpected error: $e');
    showErrorDialog('An unexpected error occurred.');
  }
}
```

### Logging

```dart
import 'dart:developer' as developer;

// Use developer.log for debugging
developer.log('Problem generated', name: 'ProblemGenerator');

// Use print for simple debugging (avoid in production)
if (kDebugMode) {
  print('Debug: $variable');
}
```

---

## Testing Standards

### Test File Naming

```
lib/services/problem_generator.dart
test/services/problem_generator_test.dart
```

### Test Structure

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:zara_coach/services/problem_generator.dart';

void main() {
  group('ProblemGenerator', () {
    late ProblemGenerator generator;

    setUp(() {
      generator = ProblemGenerator();
    });

    test('generates 2-column addition problem', () {
      final problem = generator.generate(
        type: ProblemType.addition,
        columns: 2,
      );

      expect(problem.type, ProblemType.addition);
      expect(problem.columns, 2);
      expect(problem.answer, isNotNull);
    });

    test('generates problem within difficulty level', () {
      final problem = generator.generate(difficulty: 1);

      expect(problem.difficulty, 1);
      expect(problem.hasCarrying, false);
    });
  });
}
```

### Widget Testing

```dart
testWidgets('displays problem correctly', (WidgetTester tester) async {
  final problem = Problem(question: '47 + 25', answer: 72);

  await tester.pumpWidget(
    MaterialApp(
      home: ProblemDisplay(problem: problem),
    ),
  );

  expect(find.text('47 + 25'), findsOneWidget);
});
```

### Test Coverage Target

- **Minimum:** 70% code coverage
- **Target:** 80%+ for critical paths (problem generation, OCR, feedback)
- Run: `flutter test --coverage`

---

## Documentation Standards

### Code Comments

**Use /// for public APIs:**
```dart
/// Generates a math problem based on difficulty level.
///
/// The [difficulty] parameter ranges from 1 (easiest) to 8 (hardest).
/// Returns a [Problem] instance with question and answer.
///
/// Throws [ProblemGenerationException] if generation fails.
Future<Problem> generateProblem({required int difficulty}) async {
  // implementation
}
```

**Use // for inline comments:**
```dart
// Calculate carry digit
final carry = sum ~/ 10;
```

**Avoid obvious comments:**
```dart
// Bad
int count = 0;  // initialize count to zero

// Good - no comment needed, code is clear
int problemCount = 0;
```

### TODOs

```dart
// TODO(username): Implement OCR fallback for poor handwriting
// FIXME(username): Handle edge case when photo is too dark
// HACK(username): Temporary workaround for Firebase timeout issue
```

---

## Performance Best Practices

### Avoid unnecessary rebuilds

```dart
// Use const constructors
const Text('Static text');

// Use keys for list items
ListView.builder(
  itemBuilder: (context, index) {
    return ListTile(
      key: ValueKey(items[index].id),
      title: Text(items[index].name),
    );
  },
)
```

### Optimize images

```dart
// Compress before upload
final compressedImage = await imageCompressor.compress(
  image,
  quality: 85,
  maxWidth: 1024,
);
```

### Use lazy loading

```dart
// Load data on demand
FutureBuilder(
  future: loadProblemsLazy(),
  builder: (context, snapshot) {
    // ...
  },
)
```

---

## Security Best Practices

### Never commit secrets

```dart
// Bad
const String apiKey = 'sk-abc123...';

// Good - use environment variables
final apiKey = const String.fromEnvironment('OPENAI_API_KEY');
```

### Validate user input

```dart
Future<void> submitAnswer(String answer) async {
  // Validate
  if (answer.isEmpty || answer.length > 100) {
    throw ValidationException('Invalid answer');
  }

  // Sanitize
  final sanitized = answer.trim();

  // Process
  await processAnswer(sanitized);
}
```

### Use Firebase Security Rules

```javascript
// Firestore rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
  }
}
```

---

## Git Commit Standards

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Build/tooling changes

**Examples:**
```
feat(math): add 3-column addition problem generator

Implements atomic skill breakdown for addition with carrying.
Supports difficulty levels 5-6.

Closes #12

---

fix(ocr): handle low-quality photos gracefully

Added fallback to typed input when OCR confidence < 80%.

---

docs(readme): update setup instructions

Added Firebase configuration steps.
```

---

## Code Review Checklist

Before submitting code for review:

- [ ] Code follows Dart style guide (`dart format` passes)
- [ ] No linter warnings (`flutter analyze` passes)
- [ ] Tests written and passing (`flutter test`)
- [ ] Documentation added for public APIs
- [ ] No secrets/API keys in code
- [ ] Error handling implemented
- [ ] Performance considered (no obvious bottlenecks)
- [ ] Works on target device (iPad)

---

**Document Status:** Initial Version
**Last Updated:** 2025-11-10
**Owner:** Development Team
