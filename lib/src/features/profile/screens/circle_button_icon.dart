import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/commons/utils/app_icon.dart';
import 'package:flutter/material.dart';

class CircleButtonIcon extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const CircleButtonIcon({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1F1F2E),
            ),
            child: AppIcon(
              iconPath,
              size: 28,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.neutral4,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
