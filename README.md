# Zara Coach

Adaptive AI coaching app for 10-year-old with ADHD to develop skills through multimodal interaction.

## Project Overview

Zara Coach is a Flutter-based mobile application designed to help children with ADHD improve their learning through:
- **Math Practice** with photo-based problem solving
- **Vocabulary Building** with spaced repetition
- **Reading Comprehension** with multimodal support
- **Adaptive Learning** that adjusts to individual needs

## Tech Stack

- **Frontend:** Flutter 3.x / Dart 3.x
- **Backend:** Firebase (Auth, Firestore, Storage)
- **AI:** OpenAI GPT-4 for feedback generation
- **OCR:** Google ML Kit / Cloud Vision
- **Voice:** flutter_tts, speech_to_text

## Prerequisites

- Flutter SDK 3.x or higher
- Dart SDK 3.x or higher
- Xcode (for iOS development)
- CocoaPods
- Firebase CLI
- Firebase account with project "zara-coach"

## Setup Instructions

### 1. Install Flutter

```bash
# Verify Flutter installation
flutter --version

# Should show Flutter 3.x
```

### 2. Clone Repository

```bash
git clone <repository-url>
cd zara_coach
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Firebase Setup

Firebase is already configured for this project. The configuration files are:
- `lib/firebase_options.dart` - Generated configuration
- `ios/Runner/GoogleService-Info.plist` - iOS Firebase config

If you need to reconfigure:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure --project=zara-coach
```

### 5. Run the App

```bash
# For iOS (simulator or device)
flutter run

# For specific device
flutter devices  # List available devices
flutter run -d <device-id>
```

## Project Structure

```
lib/
├── core/          # Core utilities, constants, extensions
├── models/        # Data models
├── services/      # Business logic services
├── providers/     # State management (Provider)
├── screens/       # Full-screen pages
├── widgets/       # Reusable widgets
├── routes/        # Navigation configuration
└── theme/         # App theme and styles
```

See `docs/architecture/source-tree.md` for detailed structure.

## Development

### Code Standards

Follow the coding standards defined in `docs/architecture/coding-standards.md`:

- Use `dart format` for formatting
- Run `flutter analyze` before committing
- Write tests for new features
- Follow naming conventions (camelCase, PascalCase, etc.)

### Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/services/problem_generator_test.dart
```

### Build

```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release
```

## Features

### Week 1 MVP
- [x] Math practice with 2-3 column addition/subtraction
- [x] Photo upload for problem solving
- [x] OCR with typed fallback
- [x] AI feedback generation
- [x] Role-based access (child/parent modes)
- [x] Session management (40 min weekday, 2 hr weekend)
- [x] Parent dashboard
- [x] School material upload

### Planned Features
- [ ] Vocabulary practice (Week 2)
- [ ] Reading comprehension (Week 3)
- [ ] Concept learning (Week 4)
- [ ] Gamification (streaks, badges)
- [ ] Advanced analytics

## Architecture

See `docs/architecture/` for detailed documentation:
- `tech-stack.md` - Technology choices and rationale
- `coding-standards.md` - Code quality standards
- `source-tree.md` - Project organization

## Contributing

1. Create a branch for your feature
2. Follow coding standards
3. Write tests
4. Run `flutter analyze` and `flutter test`
5. Submit pull request

## License

Private project - All rights reserved

## Support

For questions or issues, contact the development team.

---

**Project Status:** Week 1 MVP Development
**Last Updated:** 2025-11-10
