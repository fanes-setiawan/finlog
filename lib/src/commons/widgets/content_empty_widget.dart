import 'package:finlog/src/commons/constants/styles/app_color.dart';
import 'package:finlog/src/commons/constants/styles/app_space.dart';
import 'package:finlog/src/commons/constants/styles/app_text.dart';
import 'package:finlog/src/commons/extensions/translate_extension.dart';
import 'package:finlog/src/commons/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ContentEmptyWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final void Function()? onRefresh;

  const ContentEmptyWidget({
    super.key,
    this.title,
    this.description,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        if (onRefresh != null) {
          await Future.delayed(const Duration(seconds: 1)); // Simulate refresh
          onRefresh!();
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: onRefresh, // Tap-to-refresh
            child: Center(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Empty state icon
                    Icon(
                      Icons.inbox,
                      size: 64.sp, // Responsive size
                      color: Colors.grey[400],
                    ),
                    Text(
                      title ?? "noData".trLabel(),
                      textAlign: TextAlign.center,
                      style: AppText.h18Bold.copyWith(color: AppColor.bgTertiary),
                    ),
                    const SizedBox(
                      height: AppSpace.x2,
                    ),
                    Text(
                      description ?? "noDataDesc".trLabel(),
                      textAlign: TextAlign.center,
                      style: AppText.l16Regular.copyWith(
                        color: AppColor.bgTertiary.withAlpha(
                          190,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppSpace.x2,
                    ),
                    Gap(16.r),
                    PrimaryButton(
                      label: "retry".trLabel(),
                      width: 200.r,
                      onPressed: () {
                        onRefresh?.call();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
