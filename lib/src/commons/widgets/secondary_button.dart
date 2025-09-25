import 'package:finlog/src/commons/constants/styles/app_color.dart';
import 'package:finlog/src/commons/constants/styles/app_space.dart';
import 'package:finlog/src/commons/constants/styles/app_text.dart';
import 'package:finlog/src/commons/widgets/loading.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.onPressed,
    this.label,
    this.width = double.infinity,
    this.borderColor = AppColor.activePrimary,
    this.foregroundColor = AppColor.activePrimary,
    this.labelWidget,
    this.rounded = true,
    this.borderSize = 1.5,
    this.isContain = false,
    this.loading = false,
  });

  final Color borderColor;
  final Color foregroundColor;
  final Widget? labelWidget;
  final double width;
  final String? label;
  final bool loading;
  final bool rounded;
  final double borderSize;
  final void Function()? onPressed;
  final bool isContain;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor,
        side: BorderSide(width: borderSize, color: borderColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            rounded ? AppSpace.x6 : AppSpace.x2,
          ),
        ),
        minimumSize: const Size(0, 48),
        elevation: 0,
      ),
      child: SizedBox(
        width: isContain ? null : width,
        child: loading
            ? const Loading()
            : labelWidget ??
                Text(
                  label ?? '',
                  style: AppText.l16Bold,
                  textAlign: TextAlign.center,
                ),
      ),
    );
  }
}
