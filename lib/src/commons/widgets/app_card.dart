import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppCard extends StatelessWidget {
  final void Function()? onTap;
  final Widget child;
  final double padding;
  const AppCard({
    super.key,
    this.onTap,
    this.padding = 8,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Padding(
          padding: EdgeInsets.all(padding.r),
          child: child,
        ),
      ),
    );
  }
}
