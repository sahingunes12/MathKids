import 'package:flutter/material.dart';

abstract class DashboardTheme {
  // ### Colors
  // --- Core Palette
  static const Color primary = Color(0xFF6EC6FF);
  static const Color primaryLight = Color(0xFF82D3FF);
  static const Color primaryDark = Color(0xFF165C96);
  static const Color surface = Color(0xFFF3F8FF);
  static const Color surfaceGradientStart = Color(0xFFF3F8FF);
  static const Color surfaceGradientEnd = Color(0xFFE8F3FF);
  static const Color cardBg = Colors.white;
  static const Color cardBorder = Color(0xFFE0E8F3);
  static const Color textPrimary = Color(0xFF264C66);
  static const Color textSecondary = Color(0xFF7593B0);
  static const Color textOnPrimary = Colors.white;

  // --- Accent Palette
  static const Color accentShop = Color(0xFFFFA726);
  static const Color accentStats = Color(0xFF5C6BC0);
  static const Color accentTimeAttack = Color(0xFFEF5350);
  static const Color accentMistakes = Color(0xFF8D6E63);
  static const Color chipLevel = Color(0xFF42A5F5);
  static const Color chipStreak = Color(0xFFFF7043);

  // ### Dimensions
  // --- Radii
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;

  // ### Shadows
  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: primaryDark.withAlpha(25),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> buttonShadow(Color color) => [
        BoxShadow(
          color: color.withAlpha(50),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];
}
