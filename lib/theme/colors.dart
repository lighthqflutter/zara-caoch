import 'package:flutter/material.dart';

/// Application color palette
/// Colors chosen to be child-friendly but not overwhelming (ADHD considerations)
class AppColors {
  // Primary colors - calm, friendly tones
  static const Color primary = Color(0xFF4A90E2); // Soft blue
  static const Color primaryLight = Color(0xFF7BB3F0);
  static const Color primaryDark = Color(0xFF2E5C8A);

  // Secondary colors
  static const Color secondary = Color(0xFF50C878); // Soft green
  static const Color secondaryLight = Color(0xFF7ED89B);
  static const Color secondaryDark = Color(0xFF3A9B5C);

  // Accent colors
  static const Color accent = Color(0xFFFFA726); // Warm orange
  static const Color accentLight = Color(0xFFFFB84D);
  static const Color accentDark = Color(0xFFE68900);

  // Feedback colors
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color error = Color(0xFFEF5350); // Red
  static const Color warning = Color(0xFFFFA726); // Orange
  static const Color info = Color(0xFF42A5F5); // Blue

  // Neutral colors
  static const Color background = Color(0xFFF5F7FA); // Very light gray-blue
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF2C3E50); // Dark gray-blue
  static const Color textSecondary = Color(0xFF7F8C8D); // Medium gray
  static const Color textDisabled = Color(0xFFBDC3C7); // Light gray

  // Special colors
  static const Color childModeAccent = Color(0xFF9B59B6); // Purple for child mode
  static const Color parentModeAccent = Color(0xFF34495E); // Dark blue-gray for parent mode
}
