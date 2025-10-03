import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcon extends StatelessWidget {
  final String path;
  final double? size;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;

  const AppIcon(
    this.path, {
    super.key,
    this.size,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
  });

  bool get isSvg => path.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    if (isSvg) {
      return SvgPicture.asset(
        path,
        width: size ?? width,
        height: size ?? height,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
        fit: fit,
      );
    } else {
      return Image.asset(
        path,
        width: size ?? width,
        height: size ?? height,
        color: color,
        fit: fit,
      );
    }
  }
}
