import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BudgetProgressBar extends StatelessWidget {
  final double usedAmount;
  final double limitAmount;
  final String label;

  const BudgetProgressBar({
    super.key,
    required this.usedAmount,
    required this.limitAmount,
    this.label = "Monthly Budget",
  });

  @override
  Widget build(BuildContext context) {
    // Avoid division by zero
    final percentage =
        limitAmount > 0 ? (usedAmount / limitAmount).clamp(0.0, 1.0) : 0.0;
    final isOverBudget = usedAmount > limitAmount;

    // Color logic: Green (<50%), Yellow (50-80%), Red (>80%)
    Color progressColor = AppColors.success;
    if (percentage > 0.8 || isOverBudget) {
      progressColor = AppColors.error;
    } else if (percentage > 0.5) {
      progressColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey800,
                ),
              ),
              Text(
                "${(percentage * 100).toStringAsFixed(0)}%",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: progressColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: AppColors.grey100,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isOverBudget
                ? "You exceeded your budget!"
                : "You have spent ${(percentage * 100).toStringAsFixed(0)}% of your budget.",
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }
}
