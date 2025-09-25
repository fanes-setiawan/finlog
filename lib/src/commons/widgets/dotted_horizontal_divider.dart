import 'package:flutter/material.dart';

class DottedHorizontalDivider extends StatelessWidget {
  final double height;
  final double dashWidth;
  final double dashSpace;
  final Color color;
  final double thickness;

  const DottedHorizontalDivider({
    super.key,
    this.height = 1.0,
    this.dashWidth = 5.0,
    this.dashSpace = 5.0,
    this.color = Colors.grey,
    this.thickness = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedLinePainter(
        dashWidth: dashWidth,
        dashSpace: dashSpace,
        color: color,
        thickness: thickness,
      ),
      child: SizedBox(
        height: height,
        width: double.infinity,
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final double dashWidth;
  final double dashSpace;
  final Color color;
  final double thickness;

  DottedLinePainter({
    required this.dashWidth,
    required this.dashSpace,
    required this.color,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
