import 'package:auto_route/auto_route.dart';
import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/features/auth/cubit/auth_cubit.dart';
import 'package:finlog/src/features/budget/logic/budget_cubit.dart';
import 'package:finlog/src/features/core/logic/category_cubit.dart';
import 'package:finlog/src/features/core/model/core_models.dart';
import 'package:finlog/src/features/home/logic/dashboard_statistics_helper.dart';
import 'package:finlog/src/features/transactions/logic/transaction_cubit.dart';
import 'package:finlog/src/features/transactions/widget/numeric_keyboard.dart';
import 'package:finlog/src/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

@RoutePage()
class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is AuthAuthenticated) {
          final userId = authState.user.uid;
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (_) => getIt<BudgetCubit>()
                    ..loadBudgets(userId, month: DateTime.now())),
              BlocProvider(
                  create: (_) =>
                      getIt<TransactionCubit>()..loadTransactions(userId)),
              BlocProvider(
                  create: (_) =>
                      getIt<CategoryCubit>()..loadCategories(userId)),
            ],
            child: const _BudgetView(),
          );
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class _BudgetView extends StatelessWidget {
  const _BudgetView();

  @override
  Widget build(BuildContext context) {
    final userId = context
        .select((AuthCubit c) => (c.state as AuthAuthenticated).user.uid);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text("Monthly Budget",
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<BudgetCubit, BudgetState>(
        builder: (context, budgetState) {
          return BlocBuilder<TransactionCubit, TransactionState>(
            builder: (context, transactionState) {
              return BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, categoryState) {
                  if (budgetState.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final budgets = budgetState.budgets;
                  // Calculate Usage Logic
                  final transactions = transactionState.maybeWhen(
                      success: (t) => t, orElse: () => <TransactionModel>[]);

                  final categories = categoryState.maybeWhen(
                      success: (c) => c, orElse: () => <CategoryModel>[]);

                  final currentMonth = DateTime.now();
                  final dashboardHelper =
                      DashboardStatisticsHelper(transactions);

                  // Total Budget
                  final totalLimit =
                      budgets.fold(0.0, (sum, b) => sum + b.limitAmount);
                  // Total Expense (Actual) for current month
                  final totalExpense =
                      dashboardHelper.getTotalExpense(month: currentMonth);

                  final remaining = totalLimit - totalExpense;
                  final percentage = totalLimit == 0
                      ? 0.0
                      : (totalExpense / totalLimit).clamp(0.0, 1.0);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Recap Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total Budget (Bulan Ini)",
                                  style: GoogleFonts.inter(
                                      color: Colors.white70, fontSize: 14)),
                              const Gap(8),
                              Text(
                                "Rp ${NumberFormat('#,###', 'id_ID').format(totalLimit)}",
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Gap(24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Terpakai",
                                          style: GoogleFonts.inter(
                                              color: Colors.white70,
                                              fontSize: 12)),
                                      Text(
                                          "Rp ${NumberFormat('#,###', 'id_ID').format(totalExpense)}",
                                          style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("Sisa",
                                          style: GoogleFonts.inter(
                                              color: Colors.white70,
                                              fontSize: 12)),
                                      Text(
                                          "Rp ${NumberFormat('#,###', 'id_ID').format(remaining)}",
                                          style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ],
                              ),
                              const Gap(16),
                              LinearPercentIndicator(
                                padding: EdgeInsets.zero,
                                lineHeight: 10,
                                percent: percentage,
                                backgroundColor: Colors.white30,
                                progressColor: percentage > 0.9
                                    ? AppColors.error
                                    : (percentage > 0.75
                                        ? Colors.orange
                                        : Colors.greenAccent),
                                barRadius: const Radius.circular(5),
                              ),
                            ],
                          ),
                        ),

                        const Gap(24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Budget per Kategori",
                                style: GoogleFonts.inter(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            TextButton(
                              onPressed: () => _showSetBudgetSheet(
                                  context, userId, categories),
                              child: const Text("Set Budget"),
                            )
                          ],
                        ),
                        const Gap(16),

                        if (budgets.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Icon(Icons.account_balance_wallet_outlined,
                                      size: 60, color: AppColors.grey300),
                                  const Gap(16),
                                  Text("Belum ada budget yang diset",
                                      style:
                                          TextStyle(color: AppColors.grey500)),
                                ],
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: budgets.length,
                            separatorBuilder: (_, __) => const Gap(16),
                            itemBuilder: (context, index) {
                              final budget = budgets[index];
                              final category = categories.firstWhere(
                                (c) => c.id == budget.categoryId,
                                orElse: () => CategoryModel(
                                    id: 'unknown',
                                    userId: userId,
                                    name: 'Unknown',
                                    iconCode: Icons.help.codePoint,
                                    colorValue: Colors.grey.value,
                                    type: 'expense'),
                              );

                              // Calculate usage for this specific category
                              final catExpense = transactions
                                  .where((t) =>
                                      t.categoryId == category.id &&
                                      t.type == 'expense' &&
                                      t.date != null &&
                                      t.date!.month == currentMonth.month &&
                                      t.date!.year == currentMonth.year)
                                  .fold(0.0, (sum, t) => sum + t.amount);

                              final catPercentage = budget.limitAmount == 0
                                  ? 0.0
                                  : (catExpense / budget.limitAmount)
                                      .clamp(0.0, 1.0);

                              return Dismissible(
                                key: Key(budget.id),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    color: AppColors.error,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
                                confirmDismiss: (direction) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Hapus Budget?"),
                                      content: const Text(
                                          "Apakah Anda yakin ingin menghapus budget ini?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text("Batal")),
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text("Hapus",
                                                style: TextStyle(
                                                    color: Colors.red))),
                                      ],
                                    ),
                                  );
                                },
                                onDismissed: (_) {
                                  context
                                      .read<BudgetCubit>()
                                      .deleteBudget(budget.id);
                                },
                                child: InkWell(
                                  onTap: () => _showSetBudgetSheet(
                                      context, userId, categories,
                                      budgetToEdit: budget),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border:
                                          Border.all(color: AppColors.grey100),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color:
                                                    Color(category.colorValue)
                                                        .withOpacity(0.1),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                  IconData(category.iconCode,
                                                      fontFamily:
                                                          'MaterialIcons'),
                                                  color: Color(
                                                      category.colorValue),
                                                  size: 20),
                                            ),
                                            const Gap(12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(category.name,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                    "${(catPercentage * 100).toStringAsFixed(0)}% used",
                                                    style: TextStyle(
                                                        color:
                                                            catPercentage > 0.9
                                                                ? Colors.red
                                                                : Colors.grey,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                    "Rp ${NumberFormat('#,###', 'id_ID').format(catExpense)}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    "/ ${NumberFormat('#,###', 'id_ID').format(budget.limitAmount)}",
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12)),
                                              ],
                                            )
                                          ],
                                        ),
                                        const Gap(12),
                                        LinearPercentIndicator(
                                          padding: EdgeInsets.zero,
                                          lineHeight: 6,
                                          percent: catPercentage,
                                          progressColor: catPercentage > 0.9
                                              ? AppColors.error
                                              : (catPercentage > 0.75
                                                  ? Colors.orange
                                                  : AppColors.primary),
                                          backgroundColor: AppColors.grey100,
                                          barRadius: const Radius.circular(3),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                        const Gap(80),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showSetBudgetSheet(
      BuildContext context, String userId, List<CategoryModel> categories,
      {BudgetModel? budgetToEdit}) async {
    final result = await showModalBottomSheet<BudgetModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SetBudgetSheet(
          userId: userId, categories: categories, budgetToEdit: budgetToEdit),
    );

    if (result != null && context.mounted) {
      context.read<BudgetCubit>().setBudget(result);
    }
  }
}

class _SetBudgetSheet extends StatefulWidget {
  final String userId;
  final List<CategoryModel> categories;
  final BudgetModel? budgetToEdit;
  const _SetBudgetSheet(
      {required this.userId, required this.categories, this.budgetToEdit});

  @override
  State<_SetBudgetSheet> createState() => _SetBudgetSheetState();
}

class _SetBudgetSheetState extends State<_SetBudgetSheet> {
  // Use a string to store raw amount for manual handling
  // Display formatted version in TextField
  String _rawAmount = "";
  final _amountController = TextEditingController();
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    if (widget.budgetToEdit != null) {
      _selectedCategoryId = widget.budgetToEdit!.categoryId;
      // Initialize raw amount properly (integer part only for simplicity in keyboard)
      _rawAmount = widget.budgetToEdit!.limitAmount.toInt().toString();
      _updateAmountController();
    }
  }

  void _updateAmountController() {
    if (_rawAmount.isEmpty) {
      _amountController.text = "";
      return;
    }
    final value = double.tryParse(_rawAmount) ?? 0;
    final formatter = NumberFormat("#,###", "id_ID");
    _amountController.text = formatter.format(value);
  }

  void _onKeyboardTap(String value) {
    setState(() {
      if (value == "0" && _rawAmount.isEmpty) return;
      if (value == "00" && _rawAmount.isEmpty) return;
      if (value == "000" && _rawAmount.isEmpty) return;

      // Handle comma for decimals (optional, current keyboard sends comma)
      // For now, let's strip non-digits or handle simple integer logic
      // If value is ",", we might ignore it if we only support integers for budget limit
      if (value == ",") return;

      _rawAmount += value;
      _updateAmountController();
    });
  }

  void _onBackspace() {
    setState(() {
      if (_rawAmount.isNotEmpty) {
        _rawAmount = _rawAmount.substring(0, _rawAmount.length - 1);
        _updateAmountController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final expenseCategories =
        widget.categories.where((c) => c.type == 'expense').toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75, // Taller for keyboard
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                      widget.budgetToEdit != null
                          ? "Edit Budget Limit"
                          : "Set Budget Limit",
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const Gap(20),
                  DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    hint: const Text("Select Category"),
                    items: expenseCategories
                        .map((c) =>
                            DropdownMenuItem(value: c.id, child: Text(c.name)))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _selectedCategoryId = val),
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const Gap(16),
                  TextFormField(
                    controller: _amountController,
                    readOnly: true, // Custom Keyboard handles input
                    showCursor: true,
                    // Prevent system keyboard
                    onTap: () {},
                    style: GoogleFonts.inter(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      prefixText: "Rp ",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _submit(context),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white),
                      child: const Text("Simpan"),
                    ),
                  ),
                  const Gap(16),
                ],
              ),
            ),
          ),
          // Custom Keyboard
          Container(
            color: AppColors.grey50,
            child: NumericKeyboard(
              onKeyboardTap: _onKeyboardTap,
              onBackspace: _onBackspace,
            ),
          ),
        ],
      ),
    );
  }

  void _submit(BuildContext context) {
    if (_selectedCategoryId == null || _rawAmount.isEmpty) return;

    final amount = double.tryParse(_rawAmount) ?? 0;

    // Safety check for ridiculous amounts or 0
    if (amount <= 0) return;

    final now = DateTime.now();
    final period = "${now.year}-${now.month.toString().padLeft(2, '0')}";

    // If editing, use existing ID, else generate new
    final id = widget.budgetToEdit?.id ?? const Uuid().v4();

    final budget = BudgetModel(
      id: id,
      userId: widget.userId,
      categoryId: _selectedCategoryId!,
      limitAmount: amount,
      period: period,
    );

    Navigator.pop(context, budget);
  }
}
