import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // prevents instantiation

  // Brand Colors (from SureDone logo)
  static const Color primaryTeal = Color(0xFF2AC5B3);     // Light teal
  static const Color primaryCyan = Color(0xFF29A9E0);     // Cyan / Aqua
  static const Color primaryBlue = Color(0xFF1E3F8A);     // Deep Blue / Indigo

  // Gradient used in the logo
  static const LinearGradient brandGradient = LinearGradient(
    colors: [
      primaryTeal,
      primaryCyan,
      primaryBlue,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Light theme colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF5F7FA);
  static const Color lightText = Color(0xFF1A1A1A);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF0D0D0F);
  static const Color darkSurface = Color(0xFF1A1C20);
  static const Color darkText = Color(0xFFFFFFFF);

  // Supporting colors
  static const Color success = Color(0xFF3CC37B);
  static const Color warning = Color(0xFFF7C844);
  static const Color error = Color(0xFFE74C3C);

  // For service cards
  static const Color cardShadow = Colors.black12;
  static const Color cardBorder = Color(0xFFDDE3F0);
}
