# Epic 004: Parent Features & Onboarding Tutorial

**Epic ID:** EPIC-004
**Sprint:** Week 1 - MVP
**Timeline:** Day 6
**Status:** In Progress
**Priority:** P0 (Critical)
**Assigned To:** Development Team
**Started:** 2025-11-10

---

## Story

As a **parent**, I want to **view my child's progress, upload school materials, and have a clear tutorial on first launch**, so that **I can support my child's learning and understand how to use the app effectively**.

---

## Acceptance Criteria

- [ ] Enhanced parent dashboard with real data
  - [ ] Display today's stats (problems completed, accuracy, time spent)
  - [ ] Show recent session history
  - [ ] Display current difficulty level
  - [ ] Show streak/consistency information
  - [ ] Loading states while fetching data
- [ ] School material upload feature
  - [ ] Photo capture of workbook pages
  - [ ] OCR text extraction from uploaded images
  - [ ] Problem pattern recognition for math
  - [ ] Store uploaded materials in Firebase Storage
  - [ ] Display upload history
- [ ] Onboarding tutorial (first-time experience)
  - [ ] Welcome screen introducing app purpose
  - [ ] Role explanation (child vs parent)
  - [ ] Child mode walkthrough (how to do math practice)
  - [ ] Parent mode walkthrough (dashboard, upload, settings)
  - [ ] Skip button on each step
  - [ ] "Show tutorial again" option in settings
  - [ ] Tutorial completed flag in Firestore
- [ ] Settings screen
  - [ ] Voice toggle (enable/disable TTS)
  - [ ] Session length preferences (weekday/weekend)
  - [ ] Tutorial reset button
  - [ ] Difficulty level override (manual adjustment)
  - [ ] About section (version, credits)
- [ ] Parent authentication improvements
  - [ ] Remember password (optional)
  - [ ] Change password feature
  - [ ] Password validation

---

## Dev Notes

### Technical Approach

**Enhanced Parent Dashboard**

Update `lib/screens/parent_dashboard/dashboard_screen.dart`:
- Make StatefulWidget to load async data
- Use SessionService to fetch today's stats
- Display real data instead of placeholders
- Add pull-to-refresh
- Show loading skeleton while fetching

**School Material Upload**

Create `lib/screens/parent_dashboard/upload_materials_screen.dart`:
- Camera integration to photograph workbook
- Firebase Storage upload
- OCR processing to extract text
- Pattern recognition for math problems
- Store metadata in Firestore collection `school_materials`

Schema:
```dart
school_materials/{materialId}
  userId: string
  uploadDate: timestamp
  imageUrl: string
  extractedText: string
  materialType: 'math' | 'reading' | 'other'
  problemsDetected: int
  status: 'processing' | 'completed' | 'failed'
```

**Onboarding Tutorial**

Create `lib/screens/onboarding/tutorial_screen.dart`:
- PageView with 5-7 tutorial steps
- Step indicators (dots)
- Skip button on each page
- "Get Started" on final page
- Store completion flag in Firestore

Tutorial Flow:
1. Welcome: "Hi! I'm Zara Coach, here to help Zara learn!"
2. Purpose: "I make learning fun with AI-powered math practice"
3. Child Mode: "Zara solves problems, takes photos, gets feedback"
4. Parent Mode: "Track progress, upload school materials"
5. Getting Started: "Let's begin! Choose your role to start"

**Settings Screen**

Create `lib/screens/settings/settings_screen.dart`:
- Voice toggle with persistence
- Session length sliders
- Tutorial reset button
- Difficulty level dropdown
- About section

**User Preferences Model**

Create `lib/models/user_preferences.dart`:
```dart
class UserPreferences {
  bool voiceEnabled;
  int weekdaySessionMinutes;
  int weekendSessionMinutes;
  bool tutorialCompleted;
  DifficultyLevel? manualDifficultyOverride;
}
```

Store in Firestore: `users/{userId}/preferences`

---

## Tasks

### Task 1: Enhance Parent Dashboard
- [ ] Update dashboard_screen.dart to StatefulWidget
- [ ] Integrate SessionService.getTodayStats()
- [ ] Display real session data
- [ ] Add recent session list
- [ ] Show current difficulty level
- [ ] Add loading states
- [ ] Implement pull-to-refresh

### Task 2: Create User Preferences Model
- [ ] Create `lib/models/user_preferences.dart`
- [ ] Add toJson/fromJson methods
- [ ] Create PreferencesService for CRUD operations
- [ ] Initialize default preferences on first launch

### Task 3: Implement School Material Upload
- [ ] Create upload_materials_screen.dart
- [ ] Camera integration for photo capture
- [ ] Firebase Storage upload service
- [ ] OCR processing for uploaded images
- [ ] Store material metadata in Firestore
- [ ] Display upload history
- [ ] Navigate to upload from dashboard

### Task 4: Create Onboarding Tutorial
- [ ] Create tutorial_screen.dart with PageView
- [ ] Design 5 tutorial pages with illustrations
- [ ] Add step indicators (dots)
- [ ] Implement skip functionality
- [ ] Store completion flag in Firestore
- [ ] Check tutorial status on app launch
- [ ] Show tutorial on first launch only

### Task 5: Create Settings Screen
- [ ] Create settings_screen.dart
- [ ] Voice toggle with real-time effect
- [ ] Session length preferences
- [ ] Tutorial reset button
- [ ] Manual difficulty level selector
- [ ] About section with version info
- [ ] Navigate to settings from dashboard

### Task 6: Improve Parent Authentication
- [ ] Add "Remember me" checkbox
- [ ] Store encrypted password in secure storage
- [ ] Add change password feature
- [ ] Password strength validation
- [ ] Update parent_login_screen.dart

### Task 7: Update Routes
- [ ] Add routes for upload, settings, tutorial
- [ ] Update parent dashboard navigation
- [ ] Add settings navigation from child home

### Task 8: Testing & Refinement
- [ ] Test parent dashboard data loading
- [ ] Test school material upload flow
- [ ] Test onboarding tutorial on fresh install
- [ ] Test settings persistence
- [ ] Verify authentication improvements
- [ ] Test navigation flows

---

## Testing

### Manual Testing Checklist

**Parent Dashboard:**
- [ ] Dashboard loads today's stats correctly
- [ ] Shows real session data
- [ ] Displays current difficulty level
- [ ] Shows recent session history
- [ ] Pull-to-refresh updates data
- [ ] Loading states appear appropriately

**School Material Upload:**
- [ ] Can capture photo of workbook
- [ ] Photo uploads to Firebase Storage
- [ ] OCR extracts text from image
- [ ] Material metadata saved to Firestore
- [ ] Upload history displays correctly
- [ ] Can view uploaded materials

**Onboarding Tutorial:**
- [ ] Tutorial appears on first launch
- [ ] Can navigate between pages
- [ ] Skip button works on all pages
- [ ] Completion flag saved correctly
- [ ] Tutorial doesn't show on second launch
- [ ] Can re-show tutorial from settings

**Settings:**
- [ ] Voice toggle affects TTS immediately
- [ ] Session length preferences save
- [ ] Tutorial reset works
- [ ] Difficulty override applies
- [ ] About section displays correctly

**Parent Authentication:**
- [ ] Remember me checkbox saves password
- [ ] Can change password
- [ ] Password validation works
- [ ] Remembered password auto-fills

---

## Definition of Done

- [ ] All tasks completed and checked off
- [ ] All acceptance criteria met
- [ ] Parent dashboard shows real data
- [ ] School material upload working
- [ ] Onboarding tutorial complete
- [ ] Settings screen functional
- [ ] All preferences persist correctly
- [ ] All manual testing passed
- [ ] Code reviewed for quality
- [ ] No lint errors or warnings
- [ ] Code committed to Git
- [ ] Story documentation updated
- [ ] Ready for Day 7 (Final Testing & Launch)

---

## Dependencies & Blockers

**Dependencies:**
- EPIC-003 completed (Voice & Environment Config)
- SessionService (from EPIC-002)
- OCRService (from EPIC-002)
- Firebase Storage configured

**Potential Blockers:**
- OCR accuracy on school materials may vary
- Secure storage for remembered passwords

**Mitigation:**
- Make password remember feature optional
- Provide clear upload tips for best OCR results

---

## Related Documentation

- `docs/brainstorming-session-results.md` - Parent features, tutorial requirements
- `docs/architecture/tech-stack.md` - Firebase services
- `docs/stories/epic-002-core-math-loop.md` - Session tracking
- `docs/stories/epic-003-voice-ux-polish.md` - Voice preferences

---

## Notes

**Time Estimate:** 1 full day (Day 6)

**Key Success Factors:**
1. Parent dashboard must show meaningful, real data
2. Tutorial must be clear and skippable
3. Settings must persist correctly
4. School upload must be easy and reliable
5. Authentication must be secure

**Parent Dashboard Content:**
- Today's progress card
- Recent sessions list (last 5)
- Current difficulty level
- Quick actions (upload, settings)

**Tutorial Script (Draft):**

*Page 1 - Welcome:*
"Welcome to Zara Coach! 👋 I'm here to help Zara learn math with AI-powered practice."

*Page 2 - How It Works:*
"Zara solves problems in her notebook, takes a photo, and gets instant feedback from me!"

*Page 3 - Child Mode:*
"In Child Mode, Zara practices math independently. I'll guide her every step of the way!"

*Page 4 - Parent Mode:*
"In Parent Mode, you can track progress, upload school materials, and adjust settings."

*Page 5 - Let's Begin:*
"Ready to start? Choose Child Mode to practice, or Parent Mode to set up!"

**Post-Completion:**
- Day 7: Final testing, bug fixes, deploy for Zara to use!

---

**Story Status:** In Progress
**Created:** 2025-11-10
**Last Updated:** 2025-11-10
