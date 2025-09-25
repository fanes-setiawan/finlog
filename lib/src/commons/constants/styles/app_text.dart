// ignore_for_file: provide_deprecation_message

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

@deprecated
extension AppTextStyleExtension on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w500);
  TextStyle get regular => copyWith(fontWeight: FontWeight.normal);

  TextStyle size(double size) => copyWith(fontSize: size.sp);
  TextStyle setColor(Color? color) => color != null ? copyWith(color: color) : this;
}

@Deprecated("use KbText instead")
class AppText {
  AppText._();

  static TextStyle get bigTitle => TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle get bigSubtitle => TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600);
  static TextStyle get bigDescription => TextStyle(fontSize: 18.sp, fontWeight: FontWeight.normal);

  static TextStyle get title => TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle get subtitle => TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600);
  static TextStyle get description => TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal);

  static TextStyle get smallTitle => TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle get smallSubtitle => TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600);
  static TextStyle get smallDescription => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal);

  //
  // deprecated
  //

  @deprecated
  static double get headingHeight => 24.sp;

  @deprecated
  static double get paragraphHeight => 20.sp;

  @deprecated
  static double get labelHeight => 16.sp;

  @deprecated
  static TextStyle get d28Bold => TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, height: 44.r / 28.r);

  @deprecated
  static TextStyle get d24Bold => TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, height: 36.r / 24.r);

  @deprecated
  static TextStyle get d21Bold => TextStyle(fontSize: 21.sp, fontWeight: FontWeight.bold, height: 28.r / 21.r);

  @deprecated
  static TextStyle hxRegular(double size) =>
      TextStyle(fontSize: size, fontWeight: FontWeight.normal, height: headingHeight / size);

  @deprecated
  static TextStyle hxBold(double size) =>
      TextStyle(fontSize: size, fontWeight: FontWeight.bold, height: headingHeight / size);

  @deprecated
  static TextStyle get h18Bold => TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold);

  @deprecated
  static TextStyle get h16Bold => TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold);

  @deprecated
  static TextStyle get h14Bold => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold);

  @deprecated
  static TextStyle get h18SemiBold => TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500);

  @deprecated
  static TextStyle get h16SemiBold => TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500);

  @deprecated
  static TextStyle get h14SemiBold => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500);

  @deprecated
  static TextStyle pxRegular(double size) => TextStyle(fontSize: size, fontWeight: FontWeight.normal);

  @deprecated
  static TextStyle get p16Regular => TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal);

  @deprecated
  static TextStyle get p14Regular => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal);

  @deprecated
  static TextStyle get p16SemiBold => TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500);

  @deprecated
  static TextStyle get p14SemiBold => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500);

  @deprecated
  static TextStyle pxBold(double size) => TextStyle(fontSize: size, fontWeight: FontWeight.bold);

  @deprecated
  static TextStyle lxBold(double size) => TextStyle(fontSize: size, fontWeight: FontWeight.bold);

  @deprecated
  static TextStyle get l18Bold => TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold);

  @deprecated
  static TextStyle get l16Bold => TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold);

  @deprecated
  static TextStyle get l14Bold => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold);

  @deprecated
  static TextStyle get l12Bold => TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold);

  @deprecated
  static TextStyle lxSemiBold(double size) => TextStyle(fontSize: size, fontWeight: FontWeight.w500);

  @deprecated
  static TextStyle get l18SemiBold => TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500);

  @deprecated
  static TextStyle get l16SemiBold => TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500);

  @deprecated
  static TextStyle get l14SemiBold => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500);

  @deprecated
  static TextStyle get l12SemiBold => TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500);

  @deprecated
  static TextStyle lxRegular(double size) => TextStyle(fontSize: size, fontWeight: FontWeight.normal);

  @deprecated
  static TextStyle get l18Regular => TextStyle(fontSize: 18.sp, fontWeight: FontWeight.normal);

  @deprecated
  static TextStyle get l16Regular => TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal);

  @deprecated
  static TextStyle get l14Regular => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal);

  @deprecated
  static TextStyle get l12Regular => TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal);
}
