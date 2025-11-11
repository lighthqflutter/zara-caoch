import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_preferences.dart';

/// Service for managing user preferences
class PreferencesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  PreferencesService({required this.userId});

  /// Get user preferences
  Future<UserPreferences> getPreferences() async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('preferences')
          .doc('settings')
          .get();

      if (doc.exists) {
        return UserPreferences.fromJson(doc.data()!);
      } else {
        // Return defaults and create document
        final defaults = UserPreferences.defaults();
        await savePreferences(defaults);
        return defaults;
      }
    } catch (e) {
      return UserPreferences.defaults();
    }
  }

  /// Save user preferences
  Future<void> savePreferences(UserPreferences preferences) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('preferences')
        .doc('settings')
        .set(preferences.toJson());
  }

  /// Update specific preference
  Future<void> updatePreference(String key, dynamic value) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('preferences')
        .doc('settings')
        .update({key: value});
  }

  /// Toggle voice enabled
  Future<void> toggleVoice(bool enabled) async {
    await updatePreference('voiceEnabled', enabled);
  }

  /// Update session lengths
  Future<void> updateSessionLengths({
    int? weekday,
    int? weekend,
  }) async {
    final updates = <String, dynamic>{};
    if (weekday != null) {
      updates['weekdaySessionMinutes'] = weekday;
    }
    if (weekend != null) {
      updates['weekendSessionMinutes'] = weekend;
    }

    if (updates.isNotEmpty) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('preferences')
          .doc('settings')
          .update(updates);
    }
  }

  /// Mark tutorial as completed
  Future<void> completeTutorial() async {
    await updatePreference('tutorialCompleted', true);
  }

  /// Reset tutorial (allow re-showing)
  Future<void> resetTutorial() async {
    await updatePreference('tutorialCompleted', false);
  }

  /// Check if tutorial completed
  Future<bool> isTutorialCompleted() async {
    final prefs = await getPreferences();
    return prefs.tutorialCompleted;
  }

  /// Stream preferences changes
  Stream<UserPreferences> watchPreferences() {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('preferences')
        .doc('settings')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return UserPreferences.fromJson(snapshot.data()!);
      }
      return UserPreferences.defaults();
    });
  }
}
