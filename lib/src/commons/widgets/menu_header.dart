import 'package:auto_route/auto_route.dart';
import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/commons/constants/styles/app_text.dart';
import 'package:finlog/src/commons/constants/styles/sizing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuHeader extends StatelessWidget {
  final Widget? action;
  final String title;
  const MenuHeader({
    super.key,
    required this.title,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.only(
        right: 42.r,
        top: 16.r,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                context.router.maybePop();
                
              },
              icon: Icon(
                LucideIcons.arrow_left,
                size: Sizing.icon,
              ),
            ),
            Text(title, style: AppText.d24Bold),
            // const Spacer(), 
            Container(
              height: 56.r,
              width: 320.r,
              child: action??SizedBox(width: 48.r)),
          ],
        ),
      ),
    );
  }
}
