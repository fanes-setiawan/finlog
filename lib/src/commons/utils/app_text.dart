import 'package:flutter/material.dart';

class AppTextStyles {
  // Default font family
  static const String _fontFamily = 'Roboto';

  // Headline 1
  static TextStyle headline1({Color color = Colors.black}) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  // Headline 2
  static TextStyle headline2({Color color = Colors.black}) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  // Subtitle
  static TextStyle subtitle({Color color = Colors.black}) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  // Body text
  static TextStyle body({Color color = Colors.black}) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: color,
    );
  }

  // Caption / Small text
  static TextStyle caption({Color color = Colors.grey}) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  // Custom style example
  static TextStyle button({Color color = Colors.white}) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: color,
      letterSpacing: 1.2,
    );
  }
}
