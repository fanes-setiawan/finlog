import 'package:finlog/src/commons/constants/styles/app_color.dart';
import 'package:finlog/src/commons/constants/styles/app_space.dart';
import 'package:finlog/src/commons/constants/styles/app_text.dart';
import 'package:finlog/src/commons/extensions/translate_extension.dart';
import 'package:flutter/material.dart';

class CheckboxInputNegative extends StatelessWidget {
  const CheckboxInputNegative({super.key, required this.value, this.onTap});

  final bool value;
  final Function(bool)? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call(!value);
      },
      child: Row(
        children: [
          value
              ? const Icon(
                  Icons.check_box,
                  color: AppColor.bgTertiary,
                  size: 18,
                )
              : const Icon(
                  Icons.crop_square_outlined,
                  color: AppColor.bgTertiary,
                  size: 18,
                ),
          const SizedBox(
            width: AppSpace.x2,
          ),
          Text(
            'inputAsNegative'.trLabel(),
            style: AppText.l12Regular,
          ),
        ],
      ),
    );
  }
}
