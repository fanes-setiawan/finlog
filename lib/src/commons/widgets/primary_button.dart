import 'package:finlog/src/commons/constants/styles/app_color.dart';
import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/commons/constants/styles/app_space.dart';
import 'package:finlog/src/commons/constants/styles/sizing.dart';
import 'package:finlog/src/commons/widgets/app_text.dart';
import 'package:finlog/src/commons/widgets/loading.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.onPressed,
    required this.label,
    this.width,
    this.backgroundColor = AppColor.activePrimary,
    this.foregroundColor = AppColor.bgPrimary,
    this.rounded = false,
    this.loading = false,
    this.isContain = false,
    this.posLeft,
    this.borderColor = AppColor.activePrimary,
    this.borderSize = 1.5,
  });

  final Widget? posLeft;
  final Color backgroundColor;
  final Color foregroundColor;
  final double? width;
  final String label;
  final bool loading;
  final bool rounded;
  final bool isContain;
  final void Function()? onPressed;
  final Color borderColor;
  final double borderSize;

  factory PrimaryButton.outlined({
    required VoidCallback? onPressed,
    required String label,
    double? width,
    Color backgroundColor = Colors.white,
    Color foregroundColor = AppColors.primary1,
    bool rounded = false,
    bool loading = false,
    bool isContain = false,
    Widget? posLeft,
    Color borderColor = AppColors.primary1,
    double borderSize = 1.5,
  }) =>
      PrimaryButton(
        onPressed: onPressed,
        posLeft: posLeft,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        borderColor: borderColor,
        width: width,
        label: label,
        rounded: rounded,
        loading: loading,
      );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? () {} : onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: loading ? AppColor.blue200 : backgroundColor,
        side: BorderSide(
          width: borderSize,
          color: onPressed == null
              ? AppColor.surface200
              : loading
                  ? AppColor.blue200
                  : borderColor,
        ),
        shape: rounded
            ? const StadiumBorder()
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizing.borderRadiusMedium),
              ),
        minimumSize: const Size(0, 48),
        elevation: 0,
      ),
      child: SizedBox(
        width: isContain ? null : width,
        child: loading
            ? Loading(
                color: foregroundColor,
              )
            : posLeft != null
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      posLeft!,
                      const SizedBox(
                        width: AppSpace.x2,
                      ),
                      AppText(
                        label,
                      ).labelSmall.bold,
                    ],
                  )
                : AppText(
                    label,
                    textAlign: TextAlign.center,
                  ).labelSmall.bold,
      ),
    );
  }
}
