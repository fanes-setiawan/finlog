import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const AppText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
  });

  static const double _multiplier = 2.2;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
    );
  }

  AppText _copyWith({
    FontWeight? fontWeight,
    Color? color,
    double? fontSize,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    TextAlign? textAlign,
  }) {
    final newStyle = (style ?? const TextStyle()).copyWith(
      fontWeight: fontWeight,
      color: color,
      fontSize: fontSize != null ? (fontSize * _multiplier).sp : null,
      decoration: decoration,
      fontStyle: fontStyle,
    );
    return AppText(
      text,
      style: newStyle,
      textAlign: textAlign ?? this.textAlign,
    );
  }

  // Static method for backward compatibility
  static TextStyle copyWith({
    FontWeight? fontWeight,
    Color? color,
    double? fontSize,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontWeight: fontWeight,
      color: color,
      fontSize: fontSize != null ? (fontSize * _multiplier).sp : null,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }

  // Static methods that return TextStyle
  static TextStyle get title =>
      TextStyle(fontSize: (18 * _multiplier).sp, fontWeight: FontWeight.w600);
  static TextStyle get titleLarge =>
      TextStyle(fontSize: (22 * _multiplier).sp, fontWeight: FontWeight.w700);
  static TextStyle get titleMedium =>
      TextStyle(fontSize: (18 * _multiplier).sp, fontWeight: FontWeight.w600);
  static TextStyle get titleSmall =>
      TextStyle(fontSize: (16 * _multiplier).sp, fontWeight: FontWeight.w500);

  static TextStyle get subtitle => TextStyle(
      fontSize: (14 * _multiplier).sp,
      fontWeight: FontWeight.w400,
      color: Colors.grey[700]);
  static TextStyle get subtitleLarge => TextStyle(
      fontSize: (16 * _multiplier).sp,
      fontWeight: FontWeight.w500,
      color: Colors.grey[800]);
  static TextStyle get subtitleMedium => TextStyle(
      fontSize: (14 * _multiplier).sp,
      fontWeight: FontWeight.w400,
      color: Colors.grey[700]);
  static TextStyle get subtitleSmall => TextStyle(
      fontSize: (12 * _multiplier).sp,
      fontWeight: FontWeight.w400,
      color: Colors.grey[600]);

  static TextStyle get body =>
      TextStyle(fontSize: (14 * _multiplier).sp, fontWeight: FontWeight.w400);
  static TextStyle get bodyLarge =>
      TextStyle(fontSize: (16 * _multiplier).sp, fontWeight: FontWeight.w400);
  static TextStyle get bodyMedium =>
      TextStyle(fontSize: (14 * _multiplier).sp, fontWeight: FontWeight.w400);
  static TextStyle get bodySmall =>
      TextStyle(fontSize: (12 * _multiplier).sp, fontWeight: FontWeight.w400);

  static TextStyle get label =>
      TextStyle(fontSize: (12 * _multiplier).sp, fontWeight: FontWeight.w500);
  static TextStyle get labelLarge =>
      TextStyle(fontSize: (14 * _multiplier).sp, fontWeight: FontWeight.w600);
  static TextStyle get labelMedium =>
      TextStyle(fontSize: (12 * _multiplier).sp, fontWeight: FontWeight.w500);
  static TextStyle get labelSmall =>
      TextStyle(fontSize: (10 * _multiplier).sp, fontWeight: FontWeight.w400);

  static TextStyle get button =>
      TextStyle(fontSize: (14 * _multiplier).sp, fontWeight: FontWeight.w600);
  static TextStyle get buttonLarge =>
      TextStyle(fontSize: (16 * _multiplier).sp, fontWeight: FontWeight.w700);
  static TextStyle get buttonMedium =>
      TextStyle(fontSize: (14 * _multiplier).sp, fontWeight: FontWeight.w600);
  static TextStyle get buttonSmall =>
      TextStyle(fontSize: (12 * _multiplier).sp, fontWeight: FontWeight.w500);
}

// Extension for TextStyle
extension TextStyleExtension on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
  TextStyle get overline => copyWith(decoration: TextDecoration.overline);
  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);

  TextStyle color(Color? color) => copyWith(color: color);
  TextStyle size(double? size) => copyWith(fontSize: size);
}

// Extension for backward compatibility
extension AppTextExtension on AppText {
  AppText get bold => _copyWith(fontWeight: FontWeight.bold);
  AppText get semiBold => _copyWith(fontWeight: FontWeight.w600);
  AppText get medium => _copyWith(fontWeight: FontWeight.w500);
  AppText get regular => _copyWith(fontWeight: FontWeight.w400);
  AppText get italic => _copyWith(fontStyle: FontStyle.italic);
  AppText get underline => _copyWith(decoration: TextDecoration.underline);
  AppText align(TextAlign textAlign) => _copyWith(textAlign: textAlign);
  AppText color(Color? color) => _copyWith(color: color);
  AppText size(double? size) => _copyWith(fontSize: size);

  // Helper method to apply static styles
  AppText _applyStyle(TextStyle staticStyle) {
    return AppText(
      text,
      style: staticStyle,
      textAlign: textAlign,
    );
  }

  // Title styles - reuse static styles
  AppText get title => _applyStyle(AppText.title);
  AppText get titleLarge => _applyStyle(AppText.titleLarge);
  AppText get titleMedium => _applyStyle(AppText.titleMedium);
  AppText get titleSmall => _applyStyle(AppText.titleSmall);

  // Subtitle styles - reuse static styles
  AppText get subtitle => _applyStyle(AppText.subtitle);
  AppText get subtitleLarge => _applyStyle(AppText.subtitleLarge);
  AppText get subtitleMedium => _applyStyle(AppText.subtitleMedium);
  AppText get subtitleSmall => _applyStyle(AppText.subtitleSmall);

  // Body styles - reuse static styles
  AppText get body => _applyStyle(AppText.body);
  AppText get bodyLarge => _applyStyle(AppText.bodyLarge);
  AppText get bodyMedium => _applyStyle(AppText.bodyMedium);
  AppText get bodySmall => _applyStyle(AppText.bodySmall);

  // Label styles - reuse static styles
  AppText get label => _applyStyle(AppText.label);
  AppText get labelLarge => _applyStyle(AppText.labelLarge);
  AppText get labelMedium => _applyStyle(AppText.labelMedium);
  AppText get labelSmall => _applyStyle(AppText.labelSmall);

  // Button styles - reuse static styles
  AppText get button => _applyStyle(AppText.button);
  AppText get buttonLarge => _applyStyle(AppText.buttonLarge);
  AppText get buttonMedium => _applyStyle(AppText.buttonMedium);
  AppText get buttonSmall => _applyStyle(AppText.buttonSmall);
}
