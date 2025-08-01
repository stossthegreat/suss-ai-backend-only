import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryPink = Color(0xFFEC4899);
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color primaryCyan = Color(0xFF06B6D4);
  static const Color primaryBlue = Color(0xFF3B82F6);

  // Background Colors
  static const Color backgroundBlack = Color(0xFF000000);
  static const Color backgroundGray900 = Color(0xFF111827);
  static const Color backgroundGray800 = Color(0xFF1F2937);
  static const Color backgroundGray700 = Color(0xFF374151);

  // Text Colors
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGray400 = Color(0xFF9CA3AF);
  static const Color textGray300 = Color(0xFFD1D5DB);
  static const Color textGray500 = Color(0xFF6B7280);

  // Status Colors
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningYellow = Color(0xFFF59E0B);
  static const Color warningOrange = Color(0xFFF97316);
  static const Color dangerRed = Color(0xFFEF4444);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPink, primaryPurple],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundBlack, backgroundGray900, backgroundBlack],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [
      Color(0x80374151), // gray-800/80
      Color(0x80111827), // gray-900/80
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pinkPurpleGradient = LinearGradient(
    colors: [
      Color(0x1AEC4899), // pink-500/10
      Color(0x1A8B5CF6), // purple-500/10
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient blueCyanGradient = LinearGradient(
    colors: [
      Color(0x1A3B82F6), // blue-500/10
      Color(0x1A06B6D4), // cyan-500/10
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Border Colors
  static Color borderGray600 = const Color(0xFF4B5563).withOpacity(0.3);
  static Color borderGray700 = const Color(0xFF374151).withOpacity(0.5);
  static Color borderPink = primaryPink.withOpacity(0.3);
  static Color borderPurple = primaryPurple.withOpacity(0.3);
  static Color borderBlue = primaryBlue.withOpacity(0.2);

  // Score Colors
  static Color getScoreColor(int score) {
    if (score >= 80) return dangerRed;
    if (score >= 60) return warningOrange;
    if (score >= 40) return warningYellow;
    return successGreen;
  }

  static String getScoreEmoji(int score) {
    if (score >= 90) return '🚨';
    if (score >= 80) return '🩸';
    if (score >= 60) return '🚩';
    if (score >= 40) return '⚠️';
    return '✅';
  }

  static String getScoreTier(int score) {
    if (score >= 90) return 'Run For Your Life Zone';
    if (score >= 80) return 'Emotional Vampire Zone';
    if (score >= 60) return 'Danger Zone';
    if (score >= 40) return 'Proceed With Caution';
    return 'Green Light';
  }
} 