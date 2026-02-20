import 'package:flutter/material.dart';

/// Dashboard-specific theme: modern, clean look (Figma-style).
/// Distinct from the rest of the app for a fresh dashboard feel.
class DashboardTheme {
  DashboardTheme._();

  // Background
  static const Color surface = Color(0xFFF8FAFC);
  static const Color surfaceGradientStart = Color(0xFFF1F5F9);
  static const Color surfaceGradientEnd = Color(0xFFE2E8F0);

  // Cards & surfaces
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE2E8F0);

  // Brand / primary
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Accents for actions
  static const Color accentShop = Color(0xFFF43F5E);
  static const Color accentStats = Color(0xFF0EA5E9);
  static const Color accentTimeAttack = Color(0xFFF59E0B);
  static const Color accentMistakes = Color(0xFFEF4444);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Chips / badges
  static const Color chipLevel = Color(0xFF6366F1);
  static const Color chipStreak = Color(0xFFF97316);

  // Radii
  static const double radiusSm = 12.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 24.0;
  static const double radiusXl = 28.0;

  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF0F172A).withOpacity(0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
  static List<BoxShadow> buttonShadow(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.35),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
}
