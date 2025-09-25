import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/commons/constants/styles/sizing.dart';
import 'package:finlog/src/commons/widgets/app_text.dart';
import 'package:finlog/src/commons/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SideBarHeader extends StatelessWidget {
  final IconData? icon;
  final String title;
  const SideBarHeader({
    super.key,
    this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Spacing.all(Sizing.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              padding: Spacing.all(Sizing.md),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizing.borderRadius),
                color: AppColors.primary1,
              ),
              child: Icon(
                icon!,
                size: Sizing.icon * 1.2,
                color: AppColors.white,
              ),
            ),
            Gap(Sizing.md),
          ],
          AppText(title).labelSmall.bold.color(AppColors.primary3),
        ],
      ),
    );
  }
}
