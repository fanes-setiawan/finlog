import 'package:finlog/src/features/core/model/core_models.dart';

class DashboardStatisticsHelper {
  final List<TransactionModel> transactions;

  DashboardStatisticsHelper(this.transactions);

  // --- Basic Totals ---

  double get totalBalance {
    // This might be better fetched from WalletCubit, but calculated here for consistency if needed
    // However, usually balance is a property of wallets.
    // If we want "Cash Flow" balance (Income - Expense), we can do:
    return getTotalIncome() - getTotalExpense();
  }

  double getTotalIncome({DateTime? month}) {
    return _sumAmount(transactions, 'income', month: month);
  }

  double getTotalExpense({DateTime? month}) {
    return _sumAmount(transactions, 'expense', month: month);
  }

  double _sumAmount(List<TransactionModel> txs, String type,
      {DateTime? month}) {
    var filtered = txs.where((t) => t.type == type);

    if (month != null) {
      filtered = filtered.where((t) =>
          t.date != null &&
          t.date!.year == month.year &&
          t.date!.month == month.month);
    }

    return filtered.fold(0.0, (sum, t) => sum + t.amount);
  }

  // --- Comparisons ---

  // Returns percentage increase/decrease from previous month
  double getIncomePercentageChange() {
    final now = DateTime.now();
    final currentMonthIncome = getTotalIncome(month: now);
    final prevMonth = DateTime(now.year, now.month - 1);
    final prevMonthIncome = getTotalIncome(month: prevMonth);

    if (prevMonthIncome == 0) return currentMonthIncome > 0 ? 100.0 : 0.0;
    return ((currentMonthIncome - prevMonthIncome) / prevMonthIncome) * 100;
  }

  double getExpensePercentageChange() {
    final now = DateTime.now();
    final currentMonthExpense = getTotalExpense(month: now);
    final prevMonth = DateTime(now.year, now.month - 1);
    final prevMonthExpense = getTotalExpense(month: prevMonth);

    if (prevMonthExpense == 0) return currentMonthExpense > 0 ? 100.0 : 0.0;
    return ((currentMonthExpense - prevMonthExpense) / prevMonthExpense) * 100;
  }

  // --- Charts Data ---

  // Group by day for the current month (for Line/Bar chart)
  Map<int, double> getDailyExpense(DateTime month) {
    final Map<int, double> dailyMap = {};
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    for (int i = 1; i <= daysInMonth; i++) {
      dailyMap[i] = 0.0;
    }

    for (var t in transactions) {
      if (t.type == 'expense' &&
          t.date != null &&
          t.date!.year == month.year &&
          t.date!.month == month.month) {
        dailyMap[t.date!.day] = (dailyMap[t.date!.day] ?? 0) + t.amount;
      }
    }
    return dailyMap;
  }

  // --- Category Breakdown ---

  // Returns top N categories by expense amount
  List<MapEntry<String, double>> getTopExpenseCategories(int topN) {
    final Map<String, double> categoryMap = {};

    for (var t in transactions) {
      if (t.type == 'expense') {
        categoryMap[t.categoryId] = (categoryMap[t.categoryId] ?? 0) + t.amount;
      }
    }

    final sortedEntries = categoryMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // Descending

    return sortedEntries.take(topN).toList();
  }
}
