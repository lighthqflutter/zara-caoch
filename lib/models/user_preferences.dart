import 'problem.dart';

/// User preferences and settings
class UserPreferences {
  final bool voiceEnabled;
  final int weekdaySessionMinutes;
  final int weekendSessionMinutes;
  final bool tutorialCompleted;
  final DifficultyLevel? manualDifficultyOverride;
  final int problemsPerSession;

  const UserPreferences({
    this.voiceEnabled = true,
    this.weekdaySessionMinutes = 40,
    this.weekendSessionMinutes = 120,
    this.tutorialCompleted = false,
    this.manualDifficultyOverride,
    this.problemsPerSession = 2,
  });

  Map<String, dynamic> toJson() {
    return {
      'voiceEnabled': voiceEnabled,
      'weekdaySessionMinutes': weekdaySessionMinutes,
      'weekendSessionMinutes': weekendSessionMinutes,
      'tutorialCompleted': tutorialCompleted,
      'manualDifficultyOverride': manualDifficultyOverride?.level,
      'problemsPerSession': problemsPerSession,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      voiceEnabled: json['voiceEnabled'] as bool? ?? true,
      weekdaySessionMinutes: json['weekdaySessionMinutes'] as int? ?? 40,
      weekendSessionMinutes: json['weekendSessionMinutes'] as int? ?? 120,
      tutorialCompleted: json['tutorialCompleted'] as bool? ?? false,
      manualDifficultyOverride: json['manualDifficultyOverride'] != null
          ? DifficultyLevel.fromLevel(json['manualDifficultyOverride'] as int)
          : null,
      problemsPerSession: json['problemsPerSession'] as int? ?? 2,
    );
  }

  /// Create a copy with updated fields
  UserPreferences copyWith({
    bool? voiceEnabled,
    int? weekdaySessionMinutes,
    int? weekendSessionMinutes,
    bool? tutorialCompleted,
    DifficultyLevel? manualDifficultyOverride,
    int? problemsPerSession,
    bool clearDifficultyOverride = false,
  }) {
    return UserPreferences(
      voiceEnabled: voiceEnabled ?? this.voiceEnabled,
      weekdaySessionMinutes:
          weekdaySessionMinutes ?? this.weekdaySessionMinutes,
      weekendSessionMinutes:
          weekendSessionMinutes ?? this.weekendSessionMinutes,
      tutorialCompleted: tutorialCompleted ?? this.tutorialCompleted,
      manualDifficultyOverride: clearDifficultyOverride
          ? null
          : (manualDifficultyOverride ?? this.manualDifficultyOverride),
      problemsPerSession: problemsPerSession ?? this.problemsPerSession,
    );
  }

  /// Get default preferences
  factory UserPreferences.defaults() {
    return const UserPreferences();
  }
}
