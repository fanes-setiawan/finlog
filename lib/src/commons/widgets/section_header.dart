import 'package:finlog/src/commons/constants/styles/app_text.dart';
import 'package:finlog/src/commons/widgets/app_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SectionHeader extends StatelessWidget {
  final String label;
  const SectionHeader(
    this.label, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.h18Bold),
        const AppDivider(),
        Gap(16.r),
      ],
    );
  }
}
