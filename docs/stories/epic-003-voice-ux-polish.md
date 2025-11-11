# Epic 003: Voice & UX Polish

**Epic ID:** EPIC-003
**Sprint:** Week 1 - MVP
**Timeline:** Day 5
**Status:** Complete
**Priority:** P0 (Critical)
**Assigned To:** Development Team
**Started:** 2025-11-10

---

## Story

As a **child learner (Zara)**, I want to **hear encouraging voice guidance throughout my math practice**, so that **I feel supported and engaged without needing to read everything on screen**.

---

## Acceptance Criteria

- [ ] Text-to-speech service integrated
  - [ ] Uses flutter_tts for device-native TTS
  - [ ] Clear, pleasant voice
  - [ ] Adjustable speech rate and pitch
  - [ ] Can be paused/stopped
- [ ] Voice guidance at key moments:
  - [ ] Welcome message when starting math practice
  - [ ] Instructions read aloud on problem display screen
  - [ ] Encouragement when taking photo
  - [ ] "Checking your work" during OCR processing
  - [ ] AI feedback read aloud on review screen
  - [ ] Celebration on summary screen
- [ ] Optional voice toggle (on by default)
  - [ ] Settings to enable/disable voice
  - [ ] Visual indicator when voice is speaking
  - [ ] User can tap to skip current speech
- [ ] Environment configuration for API keys
  - [ ] Secure storage of OpenAI API key
  - [ ] .env file with .gitignore protection
  - [ ] Configuration loading at startup
- [ ] UX enhancements:
  - [ ] Smooth transitions between screens
  - [ ] Loading animations with progress indicators
  - [ ] Success animations (confetti, stars)
  - [ ] Haptic feedback on button presses (iOS)
  - [ ] Improved button states (enabled/disabled/loading)
- [ ] Accessibility improvements:
  - [ ] Sufficient touch target sizes (min 44x44)
  - [ ] High contrast text
  - [ ] Screen reader support
  - [ ] Semantic labels for all interactive elements

---

## Dev Notes

### Technical Approach

**Text-to-Speech Service**

Create `lib/services/voice/tts_service.dart`:
- Singleton pattern for app-wide access
- Uses flutter_tts plugin
- Configurable voice parameters
- Queue management for multiple messages
- Pause/resume/stop controls

**Voice Integration Points:**

1. **Problem Display Screen**
   - "Hi Zara! Ready to practice? I have 2 problems for you. Solve them in your notebook, then take a photo!"

2. **Camera Screen**
   - "Great! Now take a clear photo of your work. Make sure I can see all your answers!"

3. **OCR Processing Screen**
   - "Let me check your work... This will just take a moment!"

4. **Review Screen**
   - Read AI feedback aloud for each problem
   - "Let's look at problem 1... [feedback message]"

5. **Summary Screen**
   - "You completed 2 problems! You got [X] correct! [Encouraging message]"

**Environment Configuration**

Create `.env` file:
```
OPENAI_API_KEY=sk-...
```

Update `.gitignore`:
```
.env
*.env
```

Use `flutter_dotenv` package for loading:
```dart
await dotenv.load(fileName: ".env");
final apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
```

**UX Polish**

Animations to add:
- Page transitions (slide, fade)
- Button press animations (scale down)
- Success confetti on 100% accuracy
- Progress bar animations
- Shimmer loading effects

Haptic feedback:
- Light impact on button press
- Medium impact on correct answer
- Success notification on session complete

**Performance Considerations**

- Preload TTS engine on app start
- Cache voice settings
- Async voice operations (non-blocking)
- Cancel pending speech when navigating away

---

## Tasks

### Task 1: Create Voice Service
- [ ] Create `lib/services/voice/tts_service.dart`
- [ ] Initialize flutter_tts
- [ ] Implement speak() method with queueing
- [ ] Add pause/resume/stop controls
- [ ] Configure voice parameters (rate, pitch, volume)
- [ ] Handle platform-specific voices (iOS/Android)

### Task 2: Add Environment Configuration
- [ ] Add `flutter_dotenv` to pubspec.yaml
- [ ] Create `.env.example` with placeholder
- [ ] Update `.gitignore` to exclude .env
- [ ] Create `lib/core/config/env_config.dart`
- [ ] Load environment at app startup
- [ ] Update FeedbackService to use env API key

### Task 3: Integrate Voice into Math Flow
- [ ] Add voice to ProblemDisplayScreen
- [ ] Add voice to CameraScreen
- [ ] Add voice to OCRProcessingScreen
- [ ] Add voice to ReviewScreen (read feedback)
- [ ] Add voice to SessionSummaryScreen
- [ ] Add skip button for current speech

### Task 4: Add Voice Settings
- [ ] Create voice settings in user preferences
- [ ] Add toggle in child home screen or settings
- [ ] Persist voice preference to Firestore
- [ ] Apply preference across all screens

### Task 5: UX Polish - Animations
- [ ] Add page transition animations to GoRouter
- [ ] Add button press scale animations
- [ ] Create success confetti animation for 100% accuracy
- [ ] Add shimmer loading effect to OCR processing
- [ ] Smooth progress bar animations

### Task 6: UX Polish - Haptic Feedback
- [ ] Add `vibration` package to pubspec.yaml
- [ ] Light haptic on button presses
- [ ] Medium haptic on correct answers
- [ ] Success haptic on session complete
- [ ] Error haptic on incorrect answers

### Task 7: Accessibility Improvements
- [ ] Verify all buttons are min 44x44 points
- [ ] Add semantic labels to all interactive elements
- [ ] Test with VoiceOver (iOS screen reader)
- [ ] Ensure sufficient color contrast
- [ ] Add focus indicators

### Task 8: Testing & Refinement
- [ ] Test complete flow with voice enabled
- [ ] Test voice toggle on/off
- [ ] Test on iPad device
- [ ] Verify API key loading
- [ ] Check performance (no lag from TTS)
- [ ] Test accessibility features

---

## Testing

### Manual Testing Checklist

**Voice Service:**
- [ ] TTS initializes without errors
- [ ] Voice is clear and understandable
- [ ] Speech can be paused/resumed
- [ ] Speech can be stopped
- [ ] Multiple messages queue correctly
- [ ] Voice settings persist

**Voice Integration:**
- [ ] Welcome message plays on problem display
- [ ] Camera instructions play when opening camera
- [ ] Processing message plays during OCR
- [ ] Feedback messages read aloud on review
- [ ] Summary message plays with results
- [ ] Skip button works on all screens

**Environment Configuration:**
- [ ] .env file loads successfully
- [ ] API key retrieved correctly
- [ ] FeedbackService uses real API key
- [ ] .env not committed to git

**UX Polish:**
- [ ] Page transitions smooth
- [ ] Button animations responsive
- [ ] Confetti appears on perfect score
- [ ] Loading animations don't freeze UI
- [ ] Haptic feedback feels appropriate

**Accessibility:**
- [ ] All buttons have adequate touch targets
- [ ] VoiceOver announces elements correctly
- [ ] Color contrast meets WCAG standards
- [ ] Focus indicators visible

---

## Definition of Done

- [ ] All tasks completed and checked off
- [ ] All acceptance criteria met
- [ ] Text-to-speech working throughout math flow
- [ ] Voice can be toggled on/off
- [ ] Environment configuration secure
- [ ] API key not in source code
- [ ] UX polish complete (animations, haptics)
- [ ] Accessibility standards met
- [ ] All manual testing passed
- [ ] Code reviewed for quality
- [ ] No lint errors or warnings
- [ ] Code committed to Git
- [ ] Story documentation updated
- [ ] Ready for Day 6 (Parent Features & Tutorial)

---

## Dependencies & Blockers

**Dependencies:**
- EPIC-002 completed (Core Math Loop)
- OpenAI API key obtained
- flutter_tts package
- flutter_dotenv package
- vibration package (optional)

**Potential Blockers:**
- TTS voice quality on iOS
- API key security in production
- Performance issues with TTS

**Mitigation:**
- Test TTS on actual device early
- Use environment variables, not hardcoded keys
- Make voice optional to avoid blocking UI

---

## Related Documentation

- `docs/brainstorming-session-results.md` - Challenge 6: Multimodal interaction
- `docs/architecture/tech-stack.md` - Voice interaction technologies
- `docs/stories/epic-002-core-math-loop.md` - Math flow to enhance

---

## Notes

**Time Estimate:** 1 full day (Day 5)

**Key Success Factors:**
1. Voice must feel natural and encouraging, not robotic
2. Voice should enhance, not interrupt the experience
3. API keys must be secure (never committed)
4. UX polish should make app feel professional
5. Performance must remain smooth with voice enabled

**Voice Script Examples:**

*Problem Display:*
"Hi Zara! Ready to practice? I have 2 problems for you today. Solve them in your notebook, then take a photo when you're done!"

*Camera:*
"Perfect! Now take a clear photo of your work. Make sure the lighting is good and I can see all your answers!"

*OCR Processing:*
"Let me check your work... This will just take a moment!"

*Review - Correct:*
"Great work! That's correct! You're doing an amazing job!"

*Review - Incorrect:*
"Not quite, but you're close! The answer is 47. Let's check your carrying - make sure you're adding the carried number to the tens column."

*Summary - 100%:*
"Wow! Perfect score! You got both problems correct! You're a math star!"

*Summary - Good:*
"Great work! You got 1 out of 2 correct! You're getting better and better!"

**Post-Completion:**
- Day 6: Parent features & tutorial
- Day 7: Testing & launch

---

**Story Status:** Complete
**Created:** 2025-11-10
**Completed:** 2025-11-10
**Last Updated:** 2025-11-11
