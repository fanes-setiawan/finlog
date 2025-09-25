// ignore_for_file: deprecated_member_use_from_same_package

import 'package:auto_route/auto_route.dart';
import 'package:finlog/src/commons/constants/app_assets.dart';
import 'package:finlog/src/commons/constants/styles/app_color.dart';
import 'package:finlog/src/commons/utils/app_icon.dart';
import 'package:finlog/src/commons/utils/app_text.dart';
import 'package:finlog/src/commons/utils/rotation_utils.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  static const path = '/splash';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const RotatingWidget(
              repeat: true,
              child: AppIcon(
                AppAssets.logo,
                size: 124,
              ),
            ),
            Text(
              "Fin Log",
              style: AppTextStyles.headline1(color: AppColor.blue500),
            ),
          ],
        ),
      ),
    );
  }
}
