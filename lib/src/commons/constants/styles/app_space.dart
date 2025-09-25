/// Space type:
/// - x1
/// - x2
/// - x3
/// - x4
/// - x5
/// - x6
@Deprecated("Use Spacing widget & Sizing instead")
class AppSpace {
  static const double base = 4;

  static const double x1 = 1 * base;
  static const double x2 = 2 * base;
  static const double x3 = 3 * base;
  static const double x4 = 4 * base;
  static const double x5 = 5 * base;
  static const double x6 = 6 * base;
  static double x(double multiplier) => multiplier * base;
}
