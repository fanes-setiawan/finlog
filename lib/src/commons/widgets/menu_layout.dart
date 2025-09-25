import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/commons/constants/styles/sizing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MenuLayout extends StatelessWidget {
  final Widget header;
  final Widget body;
  const MenuLayout({
    super.key,
    required this.header,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral5,
      body: Column(
        children: [
          header,
          Gap(Sizing.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.r),
              child: Padding(
                padding: EdgeInsets.only(right: 16.r),
                child: body,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
