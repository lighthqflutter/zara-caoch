import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/problem.dart';
import '../../models/session.dart';

/// Service for managing learning sessions
class SessionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  SessionService({required this.userId});

  /// Create a new session
  Future<LearningSession> createSession({
    required DifficultyLevel difficultyLevel,
  }) async {
    final session = LearningSession(
      id: _firestore.collection('sessions').doc().id,
      startTime: DateTime.now(),
      difficultyLevel: difficultyLevel,
      attempts: [],
    );

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('sessions')
        .doc(session.id)
        .set(session.toJson());

    return session;
  }

  /// Add a problem attempt to the session
  Future<void> addAttempt({
    required String sessionId,
    required ProblemAttempt attempt,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('sessions')
        .doc(sessionId)
        .update({
      'attempts': FieldValue.arrayUnion([attempt.toJson()]),
    });
  }

  /// Complete a session
  Future<void> completeSession({
    required String sessionId,
    required List<ProblemAttempt> attempts,
  }) async {
    final accuracy = _calculateAccuracy(attempts);

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('sessions')
        .doc(sessionId)
        .update({
      'endTime': Timestamp.now(),
      'attempts': attempts.map((a) => a.toJson()).toList(),
      'accuracy': accuracy,
    });

    // Update user's difficulty level based on performance
    await _updateDifficultyLevel(accuracy);
  }

  /// Calculate accuracy percentage
  double _calculateAccuracy(List<ProblemAttempt> attempts) {
    if (attempts.isEmpty) return 0.0;
    final correct = attempts.where((a) => a.isCorrect).length;
    return (correct / attempts.length) * 100;
  }

  /// Update difficulty level based on recent performance
  Future<void> _updateDifficultyLevel(double currentAccuracy) async {
    // Get last 3 sessions
    final recentSessions = await _firestore
        .collection('users')
        .doc(userId)
        .collection('sessions')
        .orderBy('startTime', descending: true)
        .limit(3)
        .get();

    if (recentSessions.docs.length < 2) {
      // Not enough data yet
      return;
    }

    final accuracies = recentSessions.docs
        .map((doc) => doc.data()['accuracy'] as double?)
        .where((acc) => acc != null)
        .cast<double>()
        .toList();

    // Get current difficulty
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final currentLevel = userDoc.data()?['currentDifficultyLevel'] as int? ?? 1;

    int newLevel = currentLevel;

    // Check if should increase difficulty (90%+ for last 3 sessions)
    if (accuracies.length >= 3 &&
        accuracies.every((acc) => acc >= 90.0) &&
        currentLevel < 8) {
      newLevel = currentLevel + 1;
    }
    // Check if should decrease difficulty (<60% for last 2 sessions)
    else if (accuracies.length >= 2 &&
        accuracies.take(2).every((acc) => acc < 60.0) &&
        currentLevel > 1) {
      newLevel = currentLevel - 1;
    }

    // Update if changed
    if (newLevel != currentLevel) {
      await _firestore.collection('users').doc(userId).update({
        'currentDifficultyLevel': newLevel,
      });
    }
  }

  /// Get current difficulty level
  Future<DifficultyLevel> getCurrentDifficultyLevel() async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        // Initialize user document with default level
        await _firestore.collection('users').doc(userId).set({
          'currentDifficultyLevel': 1,
          'problemsPerSession': 2,
          'createdAt': Timestamp.now(),
        });
        return DifficultyLevel.level1;
      }

      final level = userDoc.data()?['currentDifficultyLevel'] as int? ?? 1;
      return DifficultyLevel.fromLevel(level);
    } catch (e) {
      return DifficultyLevel.level1; // Default
    }
  }

  /// Get session history
  Future<List<LearningSession>> getSessionHistory({int limit = 10}) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('sessions')
        .orderBy('startTime', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => LearningSession.fromJson(doc.data()))
        .toList();
  }

  /// Get today's stats
  Future<Map<String, dynamic>> getTodayStats() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('sessions')
        .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart))
        .get();

    final sessions = snapshot.docs
        .map((doc) => LearningSession.fromJson(doc.data()))
        .toList();

    int totalProblems = 0;
    int correctProblems = 0;
    int totalMinutes = 0;

    for (final session in sessions) {
      totalProblems += session.attempts.length;
      correctProblems +=
          session.attempts.where((a) => a.isCorrect).length;

      if (session.endTime != null) {
        totalMinutes +=
            session.endTime!.difference(session.startTime).inMinutes;
      }
    }

    final accuracy = totalProblems > 0
        ? (correctProblems / totalProblems * 100).round()
        : 0;

    return {
      'problemsCompleted': totalProblems,
      'accuracy': accuracy,
      'timeSpent': totalMinutes,
      'sessionsCompleted': sessions.where((s) => s.endTime != null).length,
    };
  }

  /// Get session by ID
  Future<LearningSession?> getSession(String sessionId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('sessions')
        .doc(sessionId)
        .get();

    if (doc.exists) {
      return LearningSession.fromJson(doc.data()!);
    }
    return null;
  }
}
