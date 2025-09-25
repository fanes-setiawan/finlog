import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/commons/constants/styles/sizing.dart';
import 'package:finlog/src/commons/widgets/spacing.dart';
import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final List<Widget> children;
  const SectionCard({
    super.key,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Spacing.bottom(Sizing.md),
      child: Card(
        color: AppColors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizing.borderRadiusMedium),
        ),
        child: Padding(
          padding: Spacing.all(Sizing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}
