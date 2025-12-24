import 'package:go_router/go_router.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/role_selection/role_selection_screen.dart';
import '../screens/home/child_home_screen.dart';
import '../screens/parent_dashboard/parent_login_screen.dart';
import '../screens/parent_dashboard/dashboard_screen.dart';
import '../screens/math_practice/problem_display_screen.dart';
import '../screens/math_practice/camera_screen.dart';
import '../screens/math_practice/ocr_processing_screen.dart';
import '../screens/math_practice/typed_input_screen.dart';
import '../screens/math_practice/ocr_review_screen.dart';
import '../screens/math_practice/review_screen.dart';
import '../screens/math_practice/session_summary_screen.dart';
import '../services/ocr/ocr_service.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/onboarding/tutorial_screen.dart';
import '../screens/english_practice/english_selection_screen.dart';
import '../screens/english_practice/reading_comprehension_screen.dart';
import '../screens/english_practice/vocabulary_practice_screen.dart';
import '../models/problem.dart';
import '../models/session.dart';
import '../models/english_exercise.dart';

/// Application router configuration using GoRouter
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/child-home',
        builder: (context, state) => const ChildHomeScreen(),
      ),
      GoRoute(
        path: '/parent-login',
        builder: (context, state) => const ParentLoginScreen(),
      ),
      GoRoute(
        path: '/parent-dashboard',
        builder: (context, state) => const ParentDashboardScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/tutorial',
        builder: (context, state) => const TutorialScreen(),
      ),
      // Math practice flow
      GoRoute(
        path: '/math-practice/problems',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ProblemDisplayScreen(
            difficultyLevel: extra['difficultyLevel'] as DifficultyLevel,
            problemCount: extra['problemCount'] as int? ?? 2,
          );
        },
      ),
      GoRoute(
        path: '/math-practice/camera',
        builder: (context, state) {
          final problems = state.extra as List<MathProblem>;
          return CameraScreen(problems: problems);
        },
      ),
      GoRoute(
        path: '/math-practice/ocr-processing',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return OCRProcessingScreen(
            problems: extra['problems'] as List<MathProblem>,
            photoPath: extra['photoPath'] as String,
          );
        },
      ),
      GoRoute(
        path: '/math-practice/typed-input',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return TypedInputScreen(
            problems: extra['problems'] as List<MathProblem>,
            photoPath: extra['photoPath'] as String,
          );
        },
      ),
      GoRoute(
        path: '/math-practice/ocr-review',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return OCRReviewScreen(
            problems: extra['problems'] as List<MathProblem>,
            ocrResult: extra['ocrResult'] as OCRResult,
            photoPath: extra['photoPath'] as String,
          );
        },
      ),
      GoRoute(
        path: '/math-practice/review',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ReviewScreen(
            problems: extra['problems'] as List<MathProblem>,
            answers: extra['answers'] as List<int>,
            photoPath: extra['photoPath'] as String,
          );
        },
      ),
      GoRoute(
        path: '/math-practice/summary',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return SessionSummaryScreen(
            attempts: extra['attempts'] as List<ProblemAttempt>,
            photoPath: extra['photoPath'] as String,
          );
        },
      ),
      // English practice flow
      GoRoute(
        path: '/english-practice',
        builder: (context, state) => const EnglishSelectionScreen(),
      ),
      GoRoute(
        path: '/english-practice/reading',
        builder: (context, state) {
          final exercise = state.extra as ReadingComprehensionExercise;
          return ReadingComprehensionScreen(exercise: exercise);
        },
      ),
      GoRoute(
        path: '/english-practice/vocabulary',
        builder: (context, state) {
          final exercises = state.extra as List<VocabularyExercise>;
          return VocabularyPracticeScreen(exercises: exercises);
        },
      ),
    ],
  );
}
