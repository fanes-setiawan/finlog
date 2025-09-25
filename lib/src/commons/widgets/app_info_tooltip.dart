import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/commons/constants/styles/sizing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class AppInfoTooltip extends StatelessWidget {
  final String info;
  const AppInfoTooltip(this.info, {super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 10),
      richMessage: WidgetSpan(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 200.0, // Set maximum width for the tooltip message
          ),
          child: Text(
            info,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                ),
            softWrap: true, // Ensure text wraps within the maxWidth
            overflow: TextOverflow.clip, // Handle overflow
          ),
        ),
      ),
      child: Icon(
        LucideIcons.info,
        size: Sizing.icon,
        color: AppColors.subtitle,
      ),
    );
  }
}
