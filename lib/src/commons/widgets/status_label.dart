import 'package:finlog/src/commons/constants/flags.dart';
import 'package:finlog/src/commons/constants/styles/app_text.dart';
import 'package:flutter/material.dart';

class StatusLabel extends StatelessWidget {
  final Flags status;

  const StatusLabel({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = status == Flags.yes ? Colors.green : Colors.red;
    final String displayText = status == Flags.yes ? 'Aktif' : 'Non Aktif';

    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.2),
          ),
          child: Text(
            displayText,
            style: AppText.l16Bold.copyWith(
              color: backgroundColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
