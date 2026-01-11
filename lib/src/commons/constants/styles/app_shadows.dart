import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static BoxShadow defaultShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.05),
    blurRadius: 12,
    spreadRadius: 0,
    offset: const Offset(0, 4),
  );
}
