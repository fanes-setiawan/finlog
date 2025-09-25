import 'package:flutter/material.dart';

/// Utility class for consistent spacing.
/// All values are fixed (non-responsive).
class Spacing {
  Spacing._();

  /// EdgeInsets.zero
  static EdgeInsets zero = EdgeInsets.zero;

  /// Creates EdgeInsets.only with individual sides
  static EdgeInsets only({
    double top = 0,
    double right = 0,
    double bottom = 0,
    double left = 0,
  }) {
    return EdgeInsets.only(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
    );
  }

  /// Creates EdgeInsets fromLTRB
  static EdgeInsets fromLTRB(double left, double top, double right, double bottom) {
    return Spacing.only(
      bottom: bottom,
      top: top,
      right: right,
      left: left,
    );
  }

  /// EdgeInsets with same value on all sides
  static EdgeInsets all(double spacing) => EdgeInsets.all(spacing);

  /// EdgeInsets with left only
  static EdgeInsets left(double spacing) => EdgeInsets.only(left: spacing);

  /// EdgeInsets excluding left
  static EdgeInsets nLeft(double spacing) => EdgeInsets.only(
        top: spacing,
        bottom: spacing,
        right: spacing,
      );

  /// EdgeInsets with top only
  static EdgeInsets top(double spacing) => EdgeInsets.only(top: spacing);

  /// EdgeInsets excluding top
  static EdgeInsets nTop(double spacing) => EdgeInsets.only(
        left: spacing,
        bottom: spacing,
        right: spacing,
      );

  /// EdgeInsets with right only
  static EdgeInsets right(double spacing) => EdgeInsets.only(right: spacing);

  /// EdgeInsets excluding right
  static EdgeInsets nRight(double spacing) => EdgeInsets.only(
        top: spacing,
        bottom: spacing,
        left: spacing,
      );

  /// EdgeInsets with bottom only
  static EdgeInsets bottom(double spacing) => EdgeInsets.only(bottom: spacing);

  /// EdgeInsets excluding bottom
  static EdgeInsets nBottom(double spacing) => EdgeInsets.only(
        top: spacing,
        left: spacing,
        right: spacing,
      );

  /// Horizontal only (left and right)
  static EdgeInsets horizontal(double spacing) => EdgeInsets.symmetric(horizontal: spacing);

  /// Alias for [horizontal]
  static EdgeInsets x(double spacing) => horizontal(spacing);

  /// Vertical only (top and bottom)
  static EdgeInsets vertical(double spacing) => EdgeInsets.symmetric(vertical: spacing);

  /// Alias for [vertical]
  static EdgeInsets y(double spacing) => vertical(spacing);

  /// EdgeInsets with custom x and y spacing
  static EdgeInsets xy(double xSpacing, double ySpacing) => EdgeInsets.only(
        left: xSpacing,
        right: xSpacing,
        top: ySpacing,
        bottom: ySpacing,
      );

  /// Symmetric spacing with vertical and horizontal values
  static EdgeInsets symmetric({
    double vertical = 0,
    double horizontal = 0,
  }) =>
      EdgeInsets.symmetric(
        vertical: vertical,
        horizontal: horizontal,
      );

  /// SizedBox with fixed height
  static SizedBox height(double height) => SizedBox(height: height);

  /// SizedBox with fixed width
  static SizedBox width(double width) => SizedBox(width: width);

  /// Empty SizedBox (width: 0, height: 0)
  static Widget empty() => const SizedBox(width: 0, height: 0);

  /// Get full screen width
  static double fullWidth(BuildContext context) => MediaQuery.of(context).size.width;

  /// Get top safe area padding
  static double safeAreaTop(BuildContext context) => MediaQuery.of(context).padding.top;
}
