import 'package:finlog/src/commons/constants/styles/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MenuSectionTitle extends StatelessWidget {
  final String title;
  const MenuSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppText.title,
        ),
        Gap(8.r),
        const Divider(),
        Gap(16.r),
      ],
    );
  }
}
