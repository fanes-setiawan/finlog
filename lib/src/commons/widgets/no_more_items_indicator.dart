import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/commons/extensions/translate_extension.dart';
import 'package:finlog/src/commons/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoMoreItemsIndicator extends StatelessWidget {
  final String? message;
  const NoMoreItemsIndicator({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Center(
        child: Text(
          message ?? "noMoreData".trLabel(),
          textAlign: TextAlign.center,
          style: AppText.labelSmall.copyWith(color: AppColors.subtitle),
        ),
      ),
    );
  }
}
