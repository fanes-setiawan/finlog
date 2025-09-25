import 'package:finlog/src/commons/constants/styles/app_color.dart';
import 'package:finlog/src/commons/constants/styles/app_space.dart';
import 'package:finlog/src/commons/constants/styles/app_text.dart';
import 'package:finlog/src/commons/extensions/translate_extension.dart';
import 'package:finlog/src/commons/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class ContentErrorWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final void Function()? onRefresh;

  const ContentErrorWidget({
    super.key,
    this.title,
    this.description,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/x-circle.svg',
              colorFilter: const ColorFilter.mode(
                AppColor.errorPrimary,
                BlendMode.srcIn,
              ),
              width: 70,
            ),
            const SizedBox(
              height: AppSpace.x2,
            ),
            Text(
              title ?? "somethingWentWrong".trError(),
              textAlign: TextAlign.center,
              style: AppText.h18Bold.copyWith(color: AppColor.bgTertiary),
            ),
            const SizedBox(
              height: AppSpace.x2,
            ),
            Text(
              description ?? "",
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
    );
  }
}
