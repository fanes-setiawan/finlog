import 'package:flutter/material.dart';

extension AppTextStyleExtension on TextStyle {
  TextStyle setColor(Color? color) => color != null ? copyWith(color: color) : this;

  TextStyle setFontWeight(FontWeight? fontWeight) => fontWeight != null ? copyWith(fontWeight: fontWeight) : this;

  TextStyle setSize(double? size) => size != null ? copyWith(fontSize: size) : this;

  TextStyle setLetterSpacing(double? spacing) => spacing != null ? copyWith(letterSpacing: spacing) : this;

  TextStyle setFontStyle(FontStyle? style) => style != null ? copyWith(fontStyle: style) : this;

  TextStyle setDecoration(TextDecoration? decoration) => decoration != null ? copyWith(decoration: decoration) : this;
}
