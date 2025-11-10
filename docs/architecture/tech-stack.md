# Tech Stack - Zara Coach

**Project:** Zara Coach - Adaptive AI coaching app for 10-year-old with ADHD
**Platform:** iOS/iPad (Flutter cross-platform)
**Target:** Week 1 MVP, scalable to Primary 5 → University

---

## Core Technologies

### Frontend - Mobile App

**Framework:** Flutter 3.x
- **Language:** Dart 3.x
- **Target Platform:** iOS/iPad (with potential Android expansion)
- **UI Toolkit:** Material Design 3 / Cupertino widgets
- **State Management:** Provider (or Riverpod for scalability)
- **Routing:** GoRouter or Navigator 2.0

**Rationale:**
- Cross-platform with native performance
- Hot reload for rapid development (critical for 1-week MVP)
- Rich widget ecosystem
- Excellent camera/photo integration
- Strong Firebase integration

---

### Backend & Database

**Backend as a Service:** Firebase
- **Authentication:** Firebase Auth (parent password login)
- **Database:** Cloud Firestore (NoSQL, real-time sync)
- **Storage:** Cloud Storage (photo uploads)
- **Functions:** Cloud Functions (serverless processing) - optional for Week 1
- **Hosting:** Firebase Hosting (if web dashboard needed)

**Rationale:**
- Free tier sufficient for MVP (1-2 users)
- Real-time sync between parent/child views
- Automatic scaling for future market launch
- Minimal backend code required
- Built-in security rules

**Cost Estimate:**
- Firebase: Free tier (suitable for development and initial user)
- Scales affordably as users grow

---

### AI & Machine Learning

**Primary AI:** OpenAI API
- **Model:** GPT-4 or GPT-3.5-turbo
- **Usage:**
  - Feedback generation for math problems
  - Encouraging prompts and conversational guidance
  - Content generation (similar problems from school materials)
- **Cost:** ~$5-10/month for 1 active user (pay-as-you-go)

**OCR (Optical Character Recognition):**
- **Option 1 (Preferred):** Google Cloud Vision API
  - Free tier: 1,000 requests/month
  - High accuracy for handwriting recognition
  - Works well with child handwriting
- **Option 2 (Backup):** Tesseract OCR
  - Open-source, free
  - Lower accuracy, may need training data
  - Fallback if Cloud Vision costs become issue

**Rationale:**
- OpenAI provides natural, encouraging feedback tone
- Cloud Vision proven for handwriting OCR
- Both APIs have generous free tiers for MVP

---

### Voice Interaction

**Text-to-Speech (TTS):**
- **Package:** flutter_tts
- **Engine:** Device-native TTS (iOS Speech Synthesis)
- **Cost:** Free (uses device capabilities)

**Speech-to-Text (STT):**
- **Package:** speech_to_text
- **Engine:** Device-native STT (iOS Speech Recognition)
- **Cost:** Free (uses device capabilities)

**Rationale:**
- No API costs
- Works offline
- Natural voice quality on iOS devices
- Supports Nigerian English accent

---

## Development Tools

### IDE & Environment

**Recommended IDE:** Visual Studio Code or Android Studio
- Flutter SDK 3.x
- Dart SDK 3.x
- Flutter plugins
- Firebase CLI

**Version Control:** Git
- Repository hosting: GitHub/GitLab (user's choice)

---

### Testing

**Unit Testing:**
- `flutter_test` (built-in)
- `mockito` for mocking dependencies

**Widget Testing:**
- `flutter_test` widget tests
- Golden file testing for UI consistency

**Integration Testing:**
- `integration_test` package
- Firebase Test Lab (for device testing)

**Linting & Formatting:**
- `flutter_lints` (recommended lints)
- `dart format` (code formatting)

---

## Key Flutter Packages

### MVP Week 1 Dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  provider: ^6.1.0  # or riverpod

  # Firebase
  firebase_core: ^2.24.0
  firebase_auth: ^4.15.0
  cloud_firestore: ^4.13.0
  firebase_storage: ^11.5.0

  # Camera & Photo
  camera: ^0.10.5
  image_picker: ^1.0.5

  # Voice
  flutter_tts: ^3.8.0
  speech_to_text: ^6.5.0

  # OCR
  google_ml_kit: ^0.16.0  # includes Vision API

  # HTTP & API calls
  http: ^1.1.0
  dio: ^5.4.0  # alternative, more features

  # UI & UX
  go_router: ^12.1.0  # routing

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  mockito: ^5.4.4
  integration_test:
    sdk: flutter
```

---

## Data Structure (Firestore Schema)

### Collections:

**users/{userId}**
```json
{
  "profile": {
    "name": "Zara",
    "grade": "Primary 5",
    "role": "child",
    "country": "Nigeria",
    "interests": ["tech", "travel", "history"]
  },
  "settings": {
    "sessionLength": {
      "weekday": 40,
      "weekend": 120
    },
    "currentLevel": 2,
    "difficultyProgression": [...]
  }
}
```

**sessions/{sessionId}**
```json
{
  "userId": "userId",
  "date": "2025-11-10T16:30:00Z",
  "duration": 15,
  "problemsAttempted": 4,
  "problemsCorrect": 3,
  "accuracy": 0.75,
  "type": "math"
}
```

**problems/{problemId}**
```json
{
  "userId": "userId",
  "sessionId": "sessionId",
  "type": "2-column-addition",
  "difficulty": 2,
  "problem": "47 + 25",
  "correctAnswer": 72,
  "userAnswer": 72,
  "correct": true,
  "attempts": 1,
  "timestamp": "2025-11-10T16:32:00Z",
  "photoUrl": "gs://bucket/path/photo.jpg"
}
```

**photos/{photoId}**
```json
{
  "userId": "userId",
  "problemIds": ["problemId1", "problemId2"],
  "storageUrl": "gs://bucket/path/photo.jpg",
  "ocrSuccess": true,
  "ocrText": "47 + 25 = 72\n63 - 28 = 35",
  "timestamp": "2025-11-10T16:32:00Z"
}
```

---

## Security Considerations

### Firebase Security Rules:

**Firestore:**
- Users can only read/write their own data
- Parent mode has elevated permissions (read child's data)
- Cloud Functions enforce business logic server-side

**Storage:**
- Users can only upload to their own directory
- File size limits enforced (max 10MB per photo)
- Image type validation

**Authentication:**
- Parent login: Email/password
- Child mode: No authentication (local device trust)
- Role-based access control in app logic

---

## Deployment & Hosting

### Week 1 MVP:
- **Target:** Single iPad (development device)
- **Distribution:** Direct install via Xcode/Flutter

### Post-MVP:
- **Beta Testing:** TestFlight (iOS)
- **Production:** App Store (iOS) - long-term goal

---

## Development Environment Setup

### Prerequisites:
1. Install Flutter SDK 3.x
2. Install Xcode (for iOS development)
3. Install Firebase CLI: `npm install -g firebase-tools`
4. Configure Firebase project
5. Set up OpenAI API key (environment variable)
6. Set up Google Cloud Vision API key (environment variable)

### Environment Variables:
```
OPENAI_API_KEY=sk-...
GOOGLE_CLOUD_VISION_API_KEY=...
FIREBASE_PROJECT_ID=zara-coach
```

---

## Performance Targets

### Week 1 MVP Targets:
- **App startup:** < 3 seconds
- **Photo upload + OCR:** < 5 seconds
- **AI feedback generation:** < 3 seconds
- **Session load time:** < 2 seconds

### Optimization Strategies:
- Image compression before upload
- Caching for frequently accessed data
- Lazy loading for problem lists
- Background processing for non-critical tasks

---

## Scalability Considerations

### Current (Week 1 MVP):
- 1 user
- ~10-20 problems/day
- ~5-10 photos/day
- Minimal API costs

### Future (Market Launch):
- 1,000+ users
- Firebase scaling (automatic)
- Firestore: Efficient queries, pagination
- Storage: CDN distribution
- OpenAI: Batch processing, caching common responses
- Monitoring: Firebase Performance Monitoring

---

## Alternative Technologies Considered

**State Management Alternatives:**
- Bloc: More complex, overkill for MVP
- GetX: Simpler but less community support
- **Decision:** Provider (or Riverpod) - balance of simplicity and power

**Backend Alternatives:**
- Supabase: Similar to Firebase, open-source
- AWS Amplify: More complex setup
- **Decision:** Firebase - fastest to MVP, free tier, proven

**AI Alternatives:**
- Claude API (Anthropic): Excellent but newer ecosystem
- Local AI models: No internet dependency but limited capability
- **Decision:** OpenAI - proven, affordable, excellent feedback quality

---

## Tech Stack Summary

| **Layer** | **Technology** | **Rationale** |
|-----------|----------------|---------------|
| Mobile App | Flutter + Dart | Cross-platform, fast development |
| Backend | Firebase (BaaS) | Free tier, scalable, minimal code |
| Database | Cloud Firestore | Real-time, NoSQL, easy sync |
| Storage | Cloud Storage | Photo uploads, scalable |
| AI | OpenAI GPT-4 | Natural feedback, affordable |
| OCR | Google Cloud Vision | High accuracy, free tier |
| Voice | flutter_tts, speech_to_text | Free, device-native |
| State Mgmt | Provider | Simple, sufficient for MVP |
| Routing | GoRouter | Type-safe, declarative |

---

**Document Status:** Initial Version
**Last Updated:** 2025-11-10
**Owner:** Development Team
