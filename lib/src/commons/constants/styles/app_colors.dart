import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand Colors (Deep Violet/Blue)
  static const primary = Color(0xFF6C63FF); // Modern Violet
  static const primaryDark = Color(0xFF4B45B2);
  static const primaryLight = Color(0xFFE5E4FF);

  // Secondary/Accent Colors (Teal/Orange)
  static const secondary = Color(0xFF00BFA6); // Teal
  static const secondaryDark = Color(0xFF008C7A);
  static const secondaryLight = Color(0xFFE0F7F2);

  static const accentOrange = Color(0xFFFF9F1C);

  // Neutral Colors
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const transparent = Colors.transparent;

  static const grey50 = Color(0xFFF9FAFB);
  static const grey100 = Color(0xFFF3F4F6);
  static const grey200 = Color(0xFFE5E7EB);
  static const grey300 = Color(0xFFD1D5DB);
  static const grey400 = Color(0xFF9CA3AF);
  static const grey500 = Color(0xFF6B7280);
  static const grey600 = Color(0xFF4B5563);
  static const grey700 = Color(0xFF374151);
  static const grey800 = Color(0xFF1F2937);
  static const grey900 = Color(0xFF111827);

  // Legacy Aliases
  static const neutral1 = grey50;
  static const neutral2 = grey100;
  static const neutral3 = grey300;
  static const neutral4 = grey400;
  static const neutral5 = grey500;
  static const neutral6 = grey600;
  static const subtitle = grey500;
  static const primary1 = primary;
  static const primary2 = primaryDark;
  static const primary3 = primary;
  static const primary4 = primaryLight;

  // Semantic Colors
  static const success = Color(0xFF10B981); // Emerald Green
  static const error = Color(0xFFEF4444); // Red
  static const warning = Color(0xFFF59E0B); // Amber
  static const info = Color(0xFF3B82F6); // Blue

  // Backgrounds
  static const backgroundLight = Color(0xFFF8F9FE);
  static const backgroundDark = Color(0xFF121212);

  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF1E1E1E);

  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF4B45B2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
