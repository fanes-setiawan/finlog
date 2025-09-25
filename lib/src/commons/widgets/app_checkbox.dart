import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/commons/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AppCheckBox extends StatefulWidget {
  final String? leftLabel;
  final String? rightLabel;
  final bool? initialValue;
  final void Function(bool value)? onChanged;

  const AppCheckBox({
    super.key,
    this.leftLabel,
    this.rightLabel,
    this.onChanged,
    this.initialValue,
  });

  @override
  State<AppCheckBox> createState() => _AppCheckBoxState();
}

class _AppCheckBoxState extends State<AppCheckBox> {
  late bool value = widget.initialValue ?? false;

  @override
  Widget build(BuildContext context) {
    final checkBox = Checkbox(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      activeColor: AppColors.primary1,
      value: value,
      onChanged: (value) {
        setState(() => this.value = value ?? false);
        widget.onChanged?.call(value ?? false);
      },
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.leftLabel != null) AppText(widget.leftLabel!).labelSmall,
        if (widget.leftLabel != null) Gap(4.r),
        checkBox,
        if (widget.rightLabel != null) Gap(4.r),
        if (widget.rightLabel != null) AppText(widget.rightLabel!).labelSmall,
      ],
    );
  }
}
