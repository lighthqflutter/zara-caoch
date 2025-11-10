# Source Tree - Zara Coach

**Project:** Zara Coach
**Structure:** Flutter project with Firebase backend
**Organization:** Feature-based with shared core utilities

---

## Root Directory Structure

```
zara_coach/
├── .bmad-core/              # BMAD methodology configuration
├── .claude/                 # Claude Code configuration
├── docs/                    # Project documentation
│   ├── architecture/        # Architecture documentation
│   ├── brainstorming-session-results.md
│   ├── prd/                 # Product requirements (sharded)
│   ├── stories/             # Development stories
│   └── qa/                  # QA reports
├── lib/                     # Flutter application source
├── test/                    # Test files
├── android/                 # Android platform code
├── ios/                     # iOS platform code
├── web/                     # Web platform code (if needed)
├── assets/                  # Static assets (images, fonts)
├── pubspec.yaml             # Dart dependencies
├── README.md                # Project overview
└── .gitignore               # Git ignore rules
```

---

## lib/ Directory Structure (Detailed)

```
lib/
├── main.dart                          # App entry point
├── app.dart                           # Root app widget with providers
│
├── core/                              # Core utilities, constants, extensions
│   ├── constants/
│   │   ├── app_constants.dart         # App-wide constants
│   │   ├── difficulty_levels.dart     # Math difficulty definitions
│   │   ├── routes.dart                # Route name constants
│   │   └── strings.dart               # UI strings (localization ready)
│   ├── utils/
│   │   ├── logger.dart                # Logging utility
│   │   ├── validators.dart            # Input validation helpers
│   │   ├── formatters.dart            # Data formatting helpers
│   │   └── date_helpers.dart          # Date/time utilities
│   ├── extensions/
│   │   ├── string_extensions.dart     # String helper methods
│   │   ├── datetime_extensions.dart   # DateTime helper methods
│   │   └── context_extensions.dart    # BuildContext extensions
│   └── config/
│       ├── env_config.dart            # Environment configuration
│       └── firebase_options.dart      # Firebase generated config
│
├── models/                            # Data models
│   ├── problem.dart                   # Math problem model
│   ├── session.dart                   # Learning session model
│   ├── user_profile.dart              # User profile model
│   ├── photo_submission.dart          # Photo upload model
│   ├── feedback.dart                  # AI feedback model
│   ├── progress.dart                  # Progress tracking model
│   └── enums/
│       ├── problem_type.dart          # Problem type enum
│       ├── difficulty_level.dart      # Difficulty enum
│       └── user_role.dart             # Role enum (child/parent)
│
├── services/                          # Business logic services
│   ├── firebase/
│   │   ├── auth_service.dart          # Firebase authentication
│   │   ├── firestore_service.dart     # Firestore CRUD operations
│   │   └── storage_service.dart       # Cloud Storage operations
│   ├── ai/
│   │   ├── openai_service.dart        # OpenAI API integration
│   │   └── feedback_generator.dart    # AI feedback generation logic
│   ├── ocr/
│   │   ├── ocr_service.dart           # OCR interface
│   │   ├── cloud_vision_ocr.dart      # Google Cloud Vision impl
│   │   └── tesseract_ocr.dart         # Tesseract fallback impl
│   ├── voice/
│   │   ├── tts_service.dart           # Text-to-speech service
│   │   └── stt_service.dart           # Speech-to-text service
│   ├── problem/
│   │   ├── problem_generator.dart     # Problem generation logic
│   │   ├── problem_validator.dart     # Answer validation
│   │   └── difficulty_manager.dart    # Difficulty progression logic
│   ├── session/
│   │   ├── session_manager.dart       # Session lifecycle management
│   │   └── timer_service.dart         # Session timer logic
│   └── analytics/
│       ├── progress_tracker.dart      # Track user progress
│       └── performance_analyzer.dart  # Analyze performance patterns
│
├── providers/                         # State management (Provider)
│   ├── auth_provider.dart             # Authentication state
│   ├── user_provider.dart             # User profile state
│   ├── session_provider.dart          # Current session state
│   ├── problem_provider.dart          # Current problem(s) state
│   ├── photo_provider.dart            # Photo upload state
│   ├── settings_provider.dart         # App settings state
│   └── navigation_provider.dart       # Navigation state (if needed)
│
├── screens/                           # Full-screen pages
│   ├── splash/
│   │   └── splash_screen.dart         # Splash/loading screen
│   ├── role_selection/
│   │   └── role_selection_screen.dart # Child/Parent mode selection
│   ├── onboarding/
│   │   ├── onboarding_screen.dart     # Tutorial flow
│   │   └── widgets/
│   │       ├── onboarding_step.dart   # Individual tutorial step
│   │       └── step_indicator.dart    # Progress indicator
│   ├── auth/
│   │   ├── login_screen.dart          # Parent login
│   │   └── widgets/
│   │       └── login_form.dart        # Login form widget
│   ├── home/
│   │   ├── child_home_screen.dart     # Child home (activity list)
│   │   └── widgets/
│   │       ├── activity_card.dart     # Activity selection card
│   │       └── streak_display.dart    # Streak counter widget
│   ├── math_practice/
│   │   ├── math_practice_screen.dart  # Main math practice screen
│   │   └── widgets/
│   │       ├── problem_display.dart   # Display problem
│   │       ├── photo_capture.dart     # Camera interface
│   │       ├── answer_input.dart      # Typed fallback input
│   │       ├── feedback_overlay.dart  # AI feedback display
│   │       └── session_timer.dart     # Timer widget
│   ├── parent_dashboard/
│   │   ├── dashboard_screen.dart      # Parent dashboard home
│   │   ├── progress_screen.dart       # Detailed progress view
│   │   ├── settings_screen.dart       # App settings
│   │   ├── upload_screen.dart         # School material upload
│   │   └── widgets/
│   │       ├── stat_card.dart         # Statistic display card
│   │       ├── progress_chart.dart    # Visual progress chart
│   │       └── upload_button.dart     # Upload action button
│   └── session_summary/
│       └── session_summary_screen.dart # End-of-session summary
│
├── widgets/                           # Reusable widgets (cross-feature)
│   ├── common/
│   │   ├── app_button.dart            # Custom button widget
│   │   ├── app_text_field.dart        # Custom text field
│   │   ├── loading_indicator.dart     # Loading spinner
│   │   ├── error_widget.dart          # Error display
│   │   ├── empty_state.dart           # Empty state display
│   │   └── dialog/
│   │       ├── confirmation_dialog.dart
│   │       └── error_dialog.dart
│   ├── layouts/
│   │   ├── screen_layout.dart         # Common screen structure
│   │   └── responsive_padding.dart    # Responsive padding helper
│   └── animations/
│       ├── fade_in.dart               # Fade in animation
│       └── confetti.dart              # Success confetti (future)
│
├── routes/
│   ├── app_router.dart                # GoRouter configuration
│   └── route_guards.dart              # Route protection logic
│
└── theme/
    ├── app_theme.dart                 # Material theme configuration
    ├── colors.dart                    # Color palette
    ├── text_styles.dart               # Text styles
    └── dimensions.dart                # Spacing, sizing constants
```

---

## test/ Directory Structure

```
test/
├── unit/                              # Unit tests
│   ├── services/
│   │   ├── problem_generator_test.dart
│   │   ├── difficulty_manager_test.dart
│   │   └── ocr_service_test.dart
│   ├── models/
│   │   ├── problem_test.dart
│   │   └── session_test.dart
│   └── utils/
│       └── validators_test.dart
│
├── widget/                            # Widget tests
│   ├── screens/
│   │   ├── math_practice_screen_test.dart
│   │   └── dashboard_screen_test.dart
│   └── widgets/
│       ├── problem_display_test.dart
│       └── activity_card_test.dart
│
├── integration/                       # Integration tests
│   ├── math_practice_flow_test.dart
│   └── parent_dashboard_flow_test.dart
│
└── mocks/                             # Mock objects
    ├── mock_firebase_service.dart
    ├── mock_openai_service.dart
    └── mock_ocr_service.dart
```

---

## assets/ Directory Structure

```
assets/
├── images/
│   ├── logo/
│   │   ├── app_icon.png
│   │   └── splash_logo.png
│   ├── illustrations/
│   │   ├── onboarding_1.png
│   │   ├── onboarding_2.png
│   │   └── empty_state.png
│   └── icons/
│       └── (custom icons if needed)
│
├── fonts/
│   └── (custom fonts if needed)
│
└── animations/
    └── (Lottie animations if needed)
```

---

## Configuration Files

### pubspec.yaml
```yaml
name: zara_coach
description: Adaptive AI coaching app for learning
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  # Flutter
  flutter:
    sdk: flutter

  # State Management
  provider: ^6.1.0

  # Firebase
  firebase_core: ^2.24.0
  firebase_auth: ^4.15.0
  cloud_firestore: ^4.13.0
  firebase_storage: ^11.5.0

  # Camera & Photo
  camera: ^0.10.5
  image_picker: ^1.0.5
  image: ^4.1.0  # Image processing

  # Voice
  flutter_tts: ^3.8.0
  speech_to_text: ^6.5.0

  # OCR
  google_ml_kit: ^0.16.0

  # HTTP & API
  http: ^1.1.0

  # Routing
  go_router: ^12.1.0

  # Utilities
  intl: ^0.18.0  # Date formatting
  path_provider: ^2.1.0  # File paths

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  mockito: ^5.4.4
  build_runner: ^2.4.0  # For code generation

flutter:
  uses-material-design: true

  assets:
    - assets/images/
    - assets/images/logo/
    - assets/images/illustrations/

  # fonts:
  #   - family: CustomFont
  #     fonts:
  #       - asset: assets/fonts/CustomFont-Regular.ttf
```

### analysis_options.yaml
```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - avoid_print
    - always_declare_return_types
    - require_trailing_commas
    - sort_constructors_first

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  errors:
    invalid_annotation_target: ignore
```

### .gitignore
```
# Flutter
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
build/
flutter_*.png

# iOS
ios/Flutter/.last_build_id
ios/Flutter/flutter_export_environment.sh
ios/Pods/
ios/.symlinks/
ios/Runner/GoogleService-Info.plist

# Android
android/.gradle/
android/captures/
android/local.properties
android/app/google-services.json

# Environment files
.env
.env.local
**/*firebase_options.dart

# IDE
.idea/
.vscode/
*.iml
*.ipr
*.iws

# Misc
.DS_Store
*.log
```

---

## Key File Descriptions

### Entry Points

**main.dart**
- App initialization
- Firebase initialization
- Provider setup
- Run app

**app.dart**
- Root MaterialApp widget
- Theme configuration
- Router configuration
- Provider wrappers

### Core Services

**problem_generator.dart**
- Generates math problems based on difficulty level
- Supports 8 difficulty levels (2-col to 3-col, +/-)
- Ensures problems match school format

**ocr_service.dart**
- Interface for OCR implementations
- Primary: Google Cloud Vision
- Fallback: Tesseract
- Returns confidence score + extracted text

**openai_service.dart**
- OpenAI API integration
- Generates encouraging feedback
- Creates similar problems from school materials

**session_manager.dart**
- Manages session lifecycle
- Tracks start/end times
- Enforces time limits (40 min weekday, 2 hr weekend)
- Saves session data to Firestore

**difficulty_manager.dart**
- Tracks accuracy per difficulty level
- Implements adaptive algorithm (70-85% target)
- Adjusts difficulty based on performance

### Providers

**session_provider.dart**
- Current session state
- Problem list
- Timer state
- Session progress

**problem_provider.dart**
- Current problem(s) being worked on
- Answer submission state
- Feedback state

**auth_provider.dart**
- Authentication state
- User role (child/parent)
- Login/logout logic

### Screens

**child_home_screen.dart**
- Activity list (Math Practice, etc.)
- Streak display
- Session start button

**math_practice_screen.dart**
- Problem display
- Photo capture button
- Answer input (typed fallback)
- Feedback overlay
- Session timer

**dashboard_screen.dart**
- Parent dashboard
- Progress statistics
- Recent activity
- School material upload

---

## Import Path Standards

### Use relative imports within lib/

```dart
// From lib/screens/math_practice/math_practice_screen.dart

// Good - relative
import '../../models/problem.dart';
import '../../services/problem/problem_generator.dart';
import '../../widgets/common/app_button.dart';

// Avoid - package
import 'package:zara_coach/models/problem.dart';
```

### Package imports for external dependencies

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
```

---

## Barrel Exports (Optional for MVP)

For cleaner imports, can create barrel files:

**lib/models/models.dart**
```dart
export 'problem.dart';
export 'session.dart';
export 'user_profile.dart';
// ... etc
```

**Usage:**
```dart
import '../models/models.dart';
// Now have access to Problem, Session, UserProfile
```

---

## File Naming Conventions

- **Screens:** `{feature}_screen.dart` (e.g., `math_practice_screen.dart`)
- **Widgets:** `{name}_widget.dart` or just `{name}.dart` (e.g., `problem_display.dart`)
- **Services:** `{name}_service.dart` (e.g., `ocr_service.dart`)
- **Providers:** `{name}_provider.dart` (e.g., `session_provider.dart`)
- **Models:** `{name}.dart` (e.g., `problem.dart`)
- **Tests:** `{name}_test.dart` (e.g., `problem_test.dart`)

---

## Growth Strategy

### As Features Are Added:

**Week 2 - Vocabulary:**
```
lib/services/vocabulary/
  ├── vocabulary_service.dart
  ├── word_bank.dart
  └── spaced_repetition.dart

lib/screens/vocabulary/
  ├── vocabulary_practice_screen.dart
  └── widgets/
      ├── word_card.dart
      └── definition_input.dart
```

**Week 3 - Reading Comprehension:**
```
lib/services/reading/
  ├── passage_service.dart
  ├── question_generator.dart
  └── comprehension_validator.dart

lib/screens/reading/
  ├── reading_practice_screen.dart
  └── widgets/
      ├── passage_display.dart
      └── question_widget.dart
```

**Week 4 - Concepts:**
```
lib/services/concepts/
  ├── concept_service.dart
  └── chunk_manager.dart

lib/screens/concepts/
  ├── concept_learning_screen.dart
  └── widgets/
      └── concept_chunk.dart
```

---

## Documentation Location

**Architecture:** `docs/architecture/`
**Stories:** `docs/stories/`
**PRD:** `docs/prd/`
**QA:** `docs/qa/`
**Brainstorming:** `docs/brainstorming-session-results.md`

---

**Document Status:** Initial Version
**Last Updated:** 2025-11-10
**Owner:** Development Team
