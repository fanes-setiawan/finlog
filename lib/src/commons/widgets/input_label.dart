import 'package:finlog/src/commons/constants/styles/app_color.dart';
import 'package:finlog/src/commons/constants/styles/sizing.dart';
import 'package:finlog/src/commons/widgets/app_text.dart';
import 'package:flutter/material.dart';

class InputLabel extends StatelessWidget {
  const InputLabel({
    super.key,
    required this.text,
    this.isRequired = false,
  });

  final String text;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: AppText.labelSmall.copyWith(
            color: AppColor.inactivePrimary,
          ),
        ),
        SizedBox(
          width: Sizing.xs,
        ),
        if (isRequired)
          Text(
            '*',
            style: AppText.labelSmall.copyWith(
              color: AppColor.suppCrimsonRed,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}
