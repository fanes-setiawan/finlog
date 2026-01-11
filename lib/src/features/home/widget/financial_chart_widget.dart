import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FinancialChartWidget extends StatelessWidget {
  final Map<int, double> dailyData; // Day -> Amount
  final bool isExpense; // To decide color

  const FinancialChartWidget({
    super.key,
    required this.dailyData,
    this.isExpense = true,
  });

  @override
  Widget build(BuildContext context) {
    // Sort keys just in case
    final sortedKeys = dailyData.keys.toList()..sort();

    // Prepare spots
    List<FlSpot> spots = [];
    if (sortedKeys.isNotEmpty) {
      spots = sortedKeys.map((day) {
        return FlSpot(day.toDouble(), dailyData[day]!);
      }).toList();
    } else {
      // Empty placeholder
      spots = [const FlSpot(0, 0), const FlSpot(30, 0)];
    }

    // Determine Max Y for scaling (add some buffer)
    double maxY = 0;
    if (dailyData.isNotEmpty) {
      maxY = dailyData.values.reduce((a, b) => a > b ? a : b);
    }
    maxY = maxY == 0 ? 100 : maxY * 1.2;

    final color = isExpense ? AppColors.error : AppColors.success;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${isExpense ? 'Expense' : 'Income'} Trend",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.grey800,
            ),
          ),
          const SizedBox(height: 24),
          AspectRatio(
            aspectRatio: 1.70,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 5, // Show every 5th day
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            value.toInt().toString(),
                            style: GoogleFonts.inter(
                                fontSize: 10, color: AppColors.grey500),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 1,
                maxX: 31,
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
