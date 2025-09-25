import 'package:finlog/src/commons/constants/styles/app_color.dart';
import 'package:finlog/src/commons/constants/styles/app_text.dart';
import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  final void Function()? onPressed;
  final String label;
  const AppTextButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: AppText.l16Bold.copyWith(
          color: AppColor.activePrimary,
        ),
      ),
    );
  }
}
