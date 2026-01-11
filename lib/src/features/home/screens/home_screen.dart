import 'package:auto_route/auto_route.dart';
import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/features/auth/cubit/auth_cubit.dart';
import 'package:finlog/src/features/core/logic/category_cubit.dart';
import 'package:finlog/src/features/core/logic/wallet_cubit.dart';
import 'package:finlog/src/features/home/logic/dashboard_statistics_helper.dart';
import 'package:finlog/src/features/home/widget/budget_progress_bar.dart';
import 'package:finlog/src/features/home/widget/daily_reminders_widget.dart';
import 'package:finlog/src/features/home/widget/financial_chart_widget.dart';
import 'package:finlog/src/features/home/widget/monthly_summary_card.dart';
import 'package:finlog/src/features/home/widget/top_categories_list.dart';
import 'package:finlog/src/features/home/widget/transaction_list_item.dart';
import 'package:finlog/src/features/home/widget/wallet_overview_list.dart';
import 'package:finlog/src/features/transactions/logic/transaction_cubit.dart';
import 'package:finlog/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // AuthCubit state is already handled in NavBarScreen which wraps this
    final userId = context.select((AuthCubit cubit) {
      final state = cubit.state;
      return (state is AuthAuthenticated) ? state.user.uid : null;
    });

    if (userId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return DashboardView(userId: userId);
  }
}

class DashboardView extends StatelessWidget {
  final String userId;
  const DashboardView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, transactionState) {
          return BlocBuilder<WalletCubit, WalletState>(
              builder: (context, walletState) {
            return BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, categoryState) {
              // Check if all data is loaded (or at least try to render)
              // Ideally handle loading states more gracefully, but for now:

              // Helper Logic
              final transactions = transactionState.maybeWhen(
                success: (txs) => txs,
                error: (msg) {
                  // Display error if present (for debugging)
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Tx Error: $msg")));
                  });
                  return [];
                },
                orElse: () => [],
              );

              final wallets = walletState.maybeWhen(
                success: (w) => w,
                error: (msg) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Wallet Error: $msg")));
                  });
                  return [];
                },
                orElse: () => [],
              );

              // Get Category Map
              final categories = categoryState.maybeWhen(
                success: (cats) => cats,
                orElse: () => [],
              );
              final categoryNameMap = <String, String>{
                for (var c in categories) c.id: c.name
              };
              final categoryColorMap = <String, int>{
                for (var c in categories) c.id: c.colorValue
              };

              // Statistics
              // Note: We need standard List<TransactionModel>, ensure Helper supports it
              // Assuming 'transactions' is List<TransactionModel>
              final stats = DashboardStatisticsHelper(
                  List.from(transactions)); // Safely cast if needed

              final currentMonth = DateTime.now();
              final totalIncome = stats.getTotalIncome(month: currentMonth);
              final totalExpense = stats.getTotalExpense(month: currentMonth);
              final incomeChange = stats.getIncomePercentageChange();
              final expenseChange = stats.getExpensePercentageChange();

              final totalBalance =
                  wallets.fold(0.0, (sum, w) => sum + w.balance);

              final dailyExpenses = stats.getDailyExpense(currentMonth);
              final topCategories = stats.getTopExpenseCategories(5);

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<WalletCubit>().loadWallets(userId);
                  context.read<TransactionCubit>().loadTransactions(userId);
                  context.read<CategoryCubit>().loadCategories(userId);
                },
                child: CustomScrollView(
                  slivers: [
                    // AppBar Area
                    SliverAppBar(
                      backgroundColor: AppColors.backgroundLight,
                      floating: true,
                      title: Text("Dashboard",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none_rounded,
                              color: Colors.black),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Monthly Summary
                            MonthlySummaryCard(
                              totalBalance: totalBalance,
                              income: totalIncome,
                              expense: totalExpense,
                              incomeChange: incomeChange,
                              expenseChange: expenseChange,
                            ).animate().fadeIn().slideY(begin: 0.1),

                            const Gap(24),

                            // 2. Daily Reminders
                            const DailyRemindersWidget()
                                .animate()
                                .fadeIn(delay: 200.ms),

                            const Gap(24),

                            // 3. Wallets Overview
                            if (wallets.isNotEmpty)
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("My Wallets",
                                          style: GoogleFonts.inter(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      TextButton(
                                        onPressed: () {
                                          // Navigate to Wallets Tab (Index 3)
                                          final tabsRouter =
                                              AutoTabsRouter.of(context);
                                          tabsRouter.setActiveIndex(3);
                                        },
                                        child: const Text("See All"),
                                      ),
                                    ],
                                  ),
                                  WalletOverviewList(
                                          wallets: List.from(wallets))
                                      .animate()
                                      .fadeIn(delay: 300.ms),
                                ],
                              ),

                            const Gap(24),

                            // 4. Financial Charts
                            FinancialChartWidget(
                                    dailyData: dailyExpenses, isExpense: true)
                                .animate()
                                .fadeIn(delay: 400.ms),

                            const Gap(24),

                            // 5. Budget Progress (Mock)
                            BudgetProgressBar(
                              label: "Monthly Budget Plan",
                              limitAmount: 5000000, // Example limit
                              usedAmount: totalExpense,
                            ).animate().fadeIn(delay: 500.ms),

                            const Gap(24),

                            // 6. Top Categories
                            TopCategoriesList(
                              topCategories: topCategories,
                              categoryNames: categoryNameMap,
                              categoryColors: categoryColorMap,
                              totalExpense: totalExpense,
                            ).animate().fadeIn(delay: 600.ms),

                            const Gap(24),

                            // 7. Recent Transactions (Short list)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Recent Transactions",
                                    style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                TextButton(
                                  onPressed: () {
                                    context.pushRoute(
                                        const TransactionHistoryRoute());
                                  },
                                  child: const Text("See All"),
                                ),
                              ],
                            ),
                            const Gap(16),
                            if (transactions.isEmpty)
                              const Center(child: Text("No transactions yet"))
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: transactions.take(5).length,
                                separatorBuilder: (_, __) => const Gap(12),
                                itemBuilder: (context, index) {
                                  return TransactionListItem(
                                    transaction: transactions[index],
                                    onTap: () {
                                      context.pushRoute(AddTransactionRoute(
                                          userId: userId,
                                          transactionToEdit:
                                              transactions[index]));
                                    },
                                  );
                                },
                              ),

                            const Gap(80), // Bottom padding
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushRoute(AddTransactionRoute(userId: userId));
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
