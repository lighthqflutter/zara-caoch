# Epic 002: Core Math Loop - Problem Generation, Photo Review & AI Feedback

**Epic ID:** EPIC-002
**Sprint:** Week 1 - MVP
**Timeline:** Day 3-4
**Status:** In Progress
**Priority:** P0 (Critical)
**Assigned To:** Development Team
**Started:** 2025-11-10

---

## Story

As a **child learner (Zara)**, I want to **solve math problems in my notebook, photograph them, and get AI feedback**, so that **I can practice math the way exams work (paper-based) and get immediate, encouraging feedback on my work**.

---

## Acceptance Criteria

- [ ] Problem generation service creates math problems at 8 difficulty levels:
  - [ ] Level 1: 2-column addition (no carrying)
  - [ ] Level 2: 2-column addition (with carrying)
  - [ ] Level 3: 2-column subtraction (no borrowing)
  - [ ] Level 4: 2-column subtraction (with borrowing)
  - [ ] Level 5: 3-column addition (no carrying)
  - [ ] Level 6: 3-column addition (with carrying)
  - [ ] Level 7: 3-column subtraction (no borrowing)
  - [ ] Level 8: 3-column subtraction (with borrowing)
- [ ] Child sees 2 problems displayed per session (starting point)
- [ ] Camera integration works on iPad
  - [ ] Can capture clear photo of notebook page
  - [ ] Photo uploads to Firebase Storage
  - [ ] Loading state shows during upload/processing
- [ ] OCR service attempts handwriting recognition
  - [ ] Uses Google ML Kit for on-device OCR
  - [ ] Extracts numbers and operators from photo
  - [ ] Target 70%+ recognition accuracy on clear handwriting
- [ ] Typed fallback when OCR fails
  - [ ] AI detects low-confidence OCR results
  - [ ] Prompts child to type answers
  - [ ] Validates typed answers
- [ ] AI feedback service provides encouraging responses
  - [ ] Correct answer: Celebratory feedback ("Great work! That's correct!")
  - [ ] Incorrect answer: Specific, encouraging guidance ("Not quite. Let's look at the ones column...")
  - [ ] Identifies which step failed (alignment, carrying, basic arithmetic)
  - [ ] Tone is patient, never judgmental
- [ ] Session tracking stores results
  - [ ] Saves problem, answer, correctness to Firestore
  - [ ] Calculates session accuracy
  - [ ] Updates difficulty level based on performance
- [ ] Complete flow works end-to-end:
  - [ ] Child opens app → sees 2 problems
  - [ ] Solves in notebook
  - [ ] Takes photo
  - [ ] Gets feedback within 10 seconds
  - [ ] Sees session summary
  - [ ] Difficulty adjusts for next session

---

## Dev Notes

### Technical Approach

**Problem Generation Service**

Create `lib/services/problem/problem_generator.dart`:
- Generate problems based on difficulty level
- Ensure variety (different numbers each session)
- Store correct answers for validation
- Format problems clearly for display

**Problem Types:**
```dart
enum ProblemType { addition, subtraction }
enum DifficultyLevel {
  level1, // 2-col addition, no carry
  level2, // 2-col addition, with carry
  level3, // 2-col subtraction, no borrow
  level4, // 2-col subtraction, with borrow
  level5, // 3-col addition, no carry
  level6, // 3-col addition, with carry
  level7, // 3-col subtraction, no borrow
  level8, // 3-col subtraction, with borrow
}
```

**Camera Integration**

Use packages:
- `camera` - camera access
- `image_picker` - photo selection
- `image` - image processing

Create `lib/screens/math_practice/camera_screen.dart`:
- Camera preview
- Capture button
- Retake option
- Confirm & submit

**OCR Service**

Create `lib/services/ocr/ocr_service.dart`:
- Use Google ML Kit for on-device text recognition
- Extract text from photo
- Parse numbers and operators
- Calculate confidence score
- Fallback to typed input if confidence < 70%

**AI Feedback Service**

Create `lib/services/ai/feedback_service.dart`:
- Integrate OpenAI API (GPT-4)
- Generate encouraging, specific feedback
- Identify error types (carrying, alignment, arithmetic)
- Maintain encouraging tone
- Include emoji for engagement

**Session Service**

Create `lib/services/session/session_service.dart`:
- Track session start/end
- Store problems and answers
- Calculate accuracy
- Determine next difficulty level
- Save to Firestore

**Math Practice Flow Screens**

Create screens:
- `lib/screens/math_practice/problem_display_screen.dart` - Show 2 problems
- `lib/screens/math_practice/camera_screen.dart` - Photo capture
- `lib/screens/math_practice/review_screen.dart` - AI feedback
- `lib/screens/math_practice/session_summary_screen.dart` - Results

**Firestore Schema**

```
users/{userId}/
  settings/
    currentDifficultyLevel: int
    problemsPerSession: int (default: 2)

  sessions/{sessionId}/
    startTime: timestamp
    endTime: timestamp
    difficultyLevel: int
    accuracy: float
    problems: [
      {
        problem: string
        correctAnswer: int
        userAnswer: int
        isCorrect: bool
        photoUrl: string (optional)
        errorType: string (optional)
      }
    ]
```

**Adaptive Logic (Basic)**

Rule-based for MVP:
```dart
// After session completes
if (last3SessionsAccuracy >= 90) {
  difficultyLevel++;
} else if (last2SessionsAccuracy < 60) {
  difficultyLevel--;
}
```

---

## Tasks

### Task 1: Create Problem Generation Service
- [ ] Create `lib/services/problem/problem_generator.dart`
- [ ] Implement all 8 difficulty levels
- [ ] Generate random numbers within constraints
- [ ] Store correct answers
- [ ] Write unit tests for problem generation

### Task 2: Build Problem Display Screen
- [ ] Create `lib/screens/math_practice/problem_display_screen.dart`
- [ ] Display 2 problems clearly
- [ ] Large, readable font (per ADHD considerations)
- [ ] "Ready to Solve?" button to proceed
- [ ] Instructions: "Solve these in your notebook, then take a photo"

### Task 3: Implement Camera Capture
- [ ] Create `lib/screens/math_practice/camera_screen.dart`
- [ ] Integrate camera package
- [ ] Camera preview UI
- [ ] Capture button
- [ ] Review captured photo
- [ ] Retake option
- [ ] Confirm & submit to upload

### Task 4: Implement OCR Service
- [ ] Create `lib/services/ocr/ocr_service.dart`
- [ ] Integrate Google ML Kit text recognition
- [ ] Extract text from photo
- [ ] Parse numbers and answers
- [ ] Calculate confidence score
- [ ] Return structured results

### Task 5: Implement Typed Fallback
- [ ] Create `lib/screens/math_practice/typed_input_screen.dart`
- [ ] Trigger when OCR confidence < 70%
- [ ] Show message: "I'm having trouble reading. Can you type the answers?"
- [ ] Input fields for each problem
- [ ] Number keyboard
- [ ] Submit button

### Task 6: Implement AI Feedback Service
- [ ] Create `lib/services/ai/feedback_service.dart`
- [ ] Set up OpenAI API integration
- [ ] Store API key securely (environment variable)
- [ ] Generate feedback prompt:
  - Problem details
  - Correct answer
  - User's answer
  - Request: encouraging feedback with specific guidance
- [ ] Parse API response
- [ ] Handle errors gracefully

### Task 7: Build Review Screen
- [ ] Create `lib/screens/math_practice/review_screen.dart`
- [ ] Show each problem with:
  - ✅ or ❌ indicator
  - Correct answer if wrong
  - AI feedback message
  - Annotated photo (if available)
- [ ] "Next" button to continue
- [ ] Voice option: AI reads feedback aloud

### Task 8: Build Session Summary Screen
- [ ] Create `lib/screens/math_practice/session_summary_screen.dart`
- [ ] Show session results:
  - Problems completed
  - Accuracy percentage
  - Encouraging message based on performance
  - "Try Again" or "Continue" button
- [ ] Celebration animation if 100% correct

### Task 9: Implement Session Service
- [ ] Create `lib/services/session/session_service.dart`
- [ ] Track session state (problems, answers, timing)
- [ ] Save to Firestore
- [ ] Calculate accuracy
- [ ] Update difficulty level
- [ ] Retrieve session history

### Task 10: Implement Basic Adaptive Logic
- [ ] Create `lib/services/problem/adaptive_service.dart`
- [ ] Track last 3 session accuracies
- [ ] Implement difficulty adjustment rules:
  - 90%+ for 3 sessions → increase
  - <60% for 2 sessions → decrease
- [ ] Update user's difficulty level in Firestore

### Task 11: Update Child Home Screen
- [ ] Connect "Math Practice" button to problem display screen
- [ ] Update subtitle with current difficulty level
- [ ] Show number of problems ready

### Task 12: Integration Testing
- [ ] Test complete flow: problem → solve → photo → feedback
- [ ] Test typed fallback flow
- [ ] Test difficulty adjustment
- [ ] Test with various handwriting samples
- [ ] Verify Firebase data storage
- [ ] Check error handling (no internet, API failures)

---

## Testing

### Manual Testing Checklist

**Problem Generation:**
- [ ] Level 1 generates 2-column addition without carrying
- [ ] Level 2 generates 2-column addition with carrying
- [ ] Level 3 generates 2-column subtraction without borrowing
- [ ] Level 4 generates 2-column subtraction with borrowing
- [ ] Level 5 generates 3-column addition without carrying
- [ ] Level 6 generates 3-column addition with carrying
- [ ] Level 7 generates 3-column subtraction without borrowing
- [ ] Level 8 generates 3-column subtraction with borrowing
- [ ] Problems are different each session
- [ ] Correct answers are calculated properly

**Camera & Photo:**
- [ ] Camera opens successfully on iPad
- [ ] Can capture photo of notebook
- [ ] Photo is clear and readable
- [ ] Retake works correctly
- [ ] Photo uploads to Firebase Storage
- [ ] Loading indicator shows during upload

**OCR:**
- [ ] OCR extracts text from clear handwriting
- [ ] Confidence score calculated correctly
- [ ] Triggers typed fallback when confidence < 70%
- [ ] Handles photos with poor lighting
- [ ] Handles angled/rotated photos

**Typed Fallback:**
- [ ] Input screen appears when OCR fails
- [ ] Number keyboard shows
- [ ] Can enter answers for both problems
- [ ] Submit validates answers correctly

**AI Feedback:**
- [ ] Correct answer gets celebratory feedback
- [ ] Incorrect answer gets specific guidance
- [ ] Feedback is encouraging, not judgmental
- [ ] Identifies error type (carrying, alignment, arithmetic)
- [ ] Feedback appears within 10 seconds

**Session Tracking:**
- [ ] Session data saves to Firestore
- [ ] Accuracy calculates correctly
- [ ] Session history retrievable
- [ ] Difficulty level updates appropriately

**Adaptive Logic:**
- [ ] Difficulty increases after 3 high-accuracy sessions (90%+)
- [ ] Difficulty decreases after 2 low-accuracy sessions (<60%)
- [ ] Difficulty stays same in "Goldilocks Zone" (70-85%)

**End-to-End Flow:**
- [ ] Complete flow from start to finish works smoothly
- [ ] No crashes or errors
- [ ] Performance is acceptable (<10 sec for feedback)
- [ ] UI is child-friendly and clear

---

## Definition of Done

- [ ] All tasks completed and checked off
- [ ] All acceptance criteria met
- [ ] All manual testing passed
- [ ] Code reviewed for quality and standards
- [ ] No lint errors or warnings
- [ ] Firebase integration working
- [ ] OpenAI API integration working
- [ ] OCR accuracy >= 70% on clear handwriting
- [ ] Typed fallback works 100% of the time
- [ ] Session data persists correctly
- [ ] Difficulty adapts as expected
- [ ] Complete flow tested on iPad device
- [ ] Code committed to Git with clear commit messages
- [ ] Story documentation updated
- [ ] Ready for Day 5 (Voice & UX Polish)

---

## Dependencies & Blockers

**Dependencies:**
- EPIC-001 completed (app foundation, Firebase, routing)
- OpenAI API key (obtain from openai.com)
- Google Cloud project for ML Kit (if not using on-device)

**Potential Blockers:**
- OCR accuracy may require fine-tuning
- OpenAI API rate limits or costs
- Camera permissions on iPad
- Network connectivity for API calls

**Mitigation:**
- Test OCR with various handwriting samples early
- Monitor OpenAI API usage and costs
- Implement robust error handling for network issues
- Provide clear typed fallback when OCR struggles

---

## Related Documentation

- `docs/brainstorming-session-results.md` - Challenge 3: Math comprehension, Challenge 6: Multimodal interaction
- `docs/architecture/tech-stack.md` - Technology choices
- `docs/architecture/source-tree.md` - File structure
- `docs/stories/epic-001-mvp-setup.md` - Foundation work

---

## Notes

**Time Estimate:** 2 full days (Day 3-4)

**Key Success Factors:**
1. OCR must work reliably or typed fallback must be seamless
2. AI feedback tone is critical - encouraging, specific, patient
3. Complete flow must feel smooth and quick (<10 sec feedback)
4. Session tracking must be accurate for adaptive logic to work
5. Start with Level 1 (simplest) to build confidence

**API Keys Needed:**
- OpenAI API key for GPT-4 feedback generation
- Firebase project already configured in EPIC-001

**Testing Priority:**
- Test with actual handwritten samples from a 10-year-old
- Verify OCR works with various lighting conditions
- Ensure typed fallback is intuitive and quick

**Post-Completion:**
- Day 5: Voice & UX polish
- Day 6: Parent features & tutorial
- Day 7: Testing & launch

---

**Story Status:** In Progress
**Created:** 2025-11-10
**Last Updated:** 2025-11-10
