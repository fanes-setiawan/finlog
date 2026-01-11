import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TopCategoriesList extends StatelessWidget {
  final List<MapEntry<String, double>> topCategories; // CategoryId -> Amount
  final Map<String, String> categoryNames; // CategoryId -> Name
  final Map<String, int> categoryColors; // CategoryId -> ColorValue
  final double totalExpense;

  const TopCategoriesList({
    super.key,
    required this.topCategories,
    required this.categoryNames,
    required this.categoryColors,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Top Expenses",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.grey800,
          ),
        ),
        const SizedBox(height: 16),
        if (topCategories.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Text("No expenses yet",
                    style: TextStyle(color: AppColors.grey500))),
          )
        else
          ...topCategories.map((entry) {
            final categoryId = entry.key;
            final amount = entry.value;
            final name = categoryNames[categoryId] ?? 'Unknown';
            final colorValue = categoryColors[categoryId] ?? 0xFF9E9E9E;
            final percentage = totalExpense > 0 ? (amount / totalExpense) : 0.0;

            final currencyFormatter = NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp ',
              decimalDigits: 0,
            );

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(colorValue).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        name[0].toUpperCase(),
                        style: GoogleFonts.inter(
                          color: Color(colorValue),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              name,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                color: AppColors.grey800,
                              ),
                            ),
                            Text(
                              currencyFormatter.format(amount),
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percentage,
                            backgroundColor: AppColors.grey100,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(colorValue)),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }
}
