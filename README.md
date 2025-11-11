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

### 5. Environment Configuration

Create a `.env` file in the project root with your API keys:

```bash
# Copy the example file
cp .env.example .env

# Edit .env and add your OpenAI API key
OPENAI_API_KEY=your_actual_api_key_here
```

**Important:** Never commit the `.env` file to version control. It's already in `.gitignore`.

### 6. Run the App

```bash
# For iOS (simulator or device)
flutter run

# For specific device
flutter devices  # List available devices
flutter run -d <device-id>
```

### 7. Default Credentials

**Parent Mode Password:** `parent123`

Change this in `lib/providers/auth_provider.dart` for production use.

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

### ✅ Week 1 MVP (Complete)

**Math Practice Flow:**
- 8 progressive difficulty levels (2-3 column addition/subtraction)
- Photo capture of handwritten work (exam-format practice)
- OCR text recognition with typed fallback
- AI-powered encouraging feedback (OpenAI GPT-4)
- Problem generation with atomic skill progression
- Session tracking and adaptive difficulty adjustment

**Voice Interaction:**
- Text-to-speech guidance throughout
- Encouraging, child-friendly voice messages
- Context-aware instructions
- Optional voice toggle in settings

**Parent Features:**
- Real-time progress dashboard
- Today's stats (problems, accuracy, time, sessions)
- Current difficulty level display
- Settings for voice, session length, difficulty
- Pull-to-refresh data updates

**User Experience:**
- Role-based access (Child Mode / Parent Mode)
- First-time onboarding tutorial (5 pages)
- Session length management (40 min weekday, 2 hr weekend)
- ADHD-friendly UI (calm colors, clear fonts, animations)
- Smooth navigation with GoRouter

**Data & Security:**
- Firebase Authentication (parent password protection)
- Cloud Firestore (session history, preferences)
- Firebase Storage (photo uploads)
- Secure API key management (.env configuration)

### 📋 Planned Features (Post-MVP)
- [ ] School material upload with OCR extraction
- [ ] Vocabulary practice (2 words/week with repetition)
- [ ] Reading comprehension (10 question formats)
- [ ] Concept learning (chunk-based teaching)
- [ ] Gamification (streaks, badges, rewards)
- [ ] Spaced repetition system
- [ ] Advanced error pattern recognition
- [ ] Predictive analytics

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

## Known Limitations

- **iOS Only:** Currently optimized for iPad, iOS platform only
- **Single User:** Uses hardcoded "demo_user" ID (multi-user support planned)
- **Hardcoded Password:** Parent password is "parent123" in code
- **OCR Accuracy:** Depends on handwriting clarity and lighting
- **Internet Required:** Needs connectivity for AI feedback (fallback available)
- **API Keys:** Requires OpenAI API key for best feedback experience
- **Limited Problem Types:** Addition/subtraction only (MVP scope)

## Troubleshooting

### App won't build
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Firebase connection issues
- Verify `GoogleService-Info.plist` is in `ios/Runner/`
- Check Firebase project name matches "zara-coach"
- Ensure Firebase services are enabled (Auth, Firestore, Storage)

### OCR not working
- Ensure photo is clear with good lighting
- Try typed fallback option
- Check Google ML Kit is properly installed

### Voice not playing
- Check device volume
- Verify TTS is enabled in settings
- Test on physical device (simulator TTS can be inconsistent)

### .env file not loading
- Ensure `.env` file is in project root
- Verify `OPENAI_API_KEY` is set
- Rebuild app after changing `.env`

## Support

For questions or issues, contact the development team or open an issue on GitHub.

---

## Week 1 MVP Summary

**Days 1-2:** Project Setup & Foundation
- Flutter project initialization
- Firebase backend configuration
- Basic app architecture (routing, theme, structure)
- Role-based navigation (child/parent modes)

**Days 3-4:** Core Math Loop
- Problem generator (8 difficulty levels)
- Camera integration & photo capture
- OCR service with typed fallback
- AI feedback service (OpenAI)
- Session tracking & adaptive difficulty
- Complete math practice flow (6 screens)

**Day 5:** Voice & UX Polish
- Text-to-speech service
- Voice guidance throughout app
- Environment configuration (.env)
- Secure API key management

**Day 6:** Parent Features & Tutorial
- Enhanced parent dashboard with real data
- User preferences system
- Comprehensive settings screen
- Onboarding tutorial (5 pages)
- Tutorial routing logic

**Day 7:** Final Testing & Launch
- Comprehensive testing
- Bug fixes
- Documentation completion
- README with setup guide
- Ready for Zara to use!

---

**Project Status:** ✅ Week 1 MVP Complete - Ready for Use
**Last Updated:** 2025-11-10
**Version:** 1.0.0 (MVP)
