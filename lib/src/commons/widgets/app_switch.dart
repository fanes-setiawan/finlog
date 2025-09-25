import 'package:finlog/src/commons/constants/styles/sizing.dart';
import 'package:finlog/src/commons/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AppSwitch extends StatefulWidget {
  final String? label;
  final String? activeLabel;
  final String? inactiveLabel;
  final bool initialValue;
  final Future<bool> Function(bool value)? onSwitch;
  const AppSwitch({
    super.key,
    this.label,
    this.activeLabel,
    this.inactiveLabel,
    this.onSwitch,
    this.initialValue = false,
  });

  @override
  State<AppSwitch> createState() => _AppSwitchState();
}

class _AppSwitchState extends State<AppSwitch> {
  late bool isActive = widget.initialValue;
  bool isConnecting = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Switch(
          value: isActive,
          onChanged: (value) async {
            if (isConnecting) return;

            isConnecting = true;
            // DialogUtils.loading();

            final result = await widget.onSwitch?.call(value);
            setState(() => isActive = result ?? value);

            // DialogUtils.dismiss();
            isConnecting = false;
          },
        ),
        if (widget.label != null ||
            widget.activeLabel != null ||
            widget.inactiveLabel != null) ...[
          Gap(Sizing.sm),
          AppText(isActive
                  ? widget.activeLabel ?? widget.label!
                  : widget.inactiveLabel ?? widget.label!)
              .labelSmall,
        ],
      ],
    );
  }
}
