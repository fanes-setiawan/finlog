import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/commons/constants/styles/sizing.dart';
import 'package:finlog/src/commons/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SideBarContainer extends StatelessWidget {
  final Widget? child;
  final bool useContentPadding;
  const SideBarContainer({
    super.key,
    this.child,
    this.useContentPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh,
      width: 0.2.sw,
      padding: useContentPadding ? Spacing.vertical(Sizing.md) : null,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 0,
            blurRadius: 8.r,
            offset: Offset(0, 2.r),
          ),
        ],
      ),
      child: child,
    );
  }
}
