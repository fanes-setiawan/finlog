import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DottedVerticalDivider extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final double dotSpacing;

  const DottedVerticalDivider({
    Key? key,
    this.height = 20.0,
    this.width = 1.0,
    this.color = Colors.grey,
    this.dotSpacing = 5.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: CustomPaint(
        size: Size(width, height),
        painter: DottedLinePainter(
          color: color,
          dotSpacing: dotSpacing,
        ),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;
  final double dotSpacing;

  DottedLinePainter({
    required this.color,
    required this.dotSpacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = size.width
      ..style = PaintingStyle.stroke;

    double startY = 0;
    while (startY < size.height) {
      // Perbaikan: ganti 'y' dengan 'startY'
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dotSpacing),
        paint,
      );
      startY += dotSpacing * 2; // Jarak antar segmen putus-putus
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
