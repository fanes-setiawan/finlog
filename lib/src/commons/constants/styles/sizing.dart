import 'package:flutter_screenutil/flutter_screenutil.dart';

class Sizing {
  Sizing._();
  static double get _multiplier => 2.0;

  static double get xs => 4.r * _multiplier;
  static double get sm => 8.r * _multiplier;
  static double get md => 16.r * _multiplier;
  static double get lg => 24.r * _multiplier;
  static double get xl => 32.r * _multiplier;

  static double get pagePadding => 32.r;
  static double get icon => 32.r;
  static double get logo => 72.r;

  static double get borderRadiusLarge => 32.r;
  static double get borderRadius => 16.r;
  static double get borderRadiusMedium => 24.r;
  static double get borderRadiusSmall => 8.r;
}
