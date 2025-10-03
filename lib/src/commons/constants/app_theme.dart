import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF6200EE),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF6200EE),
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6200EE),
      brightness: Brightness.light,
      secondary: const Color(0xFF03DAC6),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFFBB86FC),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F),
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFBB86FC),
      brightness: Brightness.dark,
      secondary: const Color(0xFF03DAC6),
    ),
  );
}
