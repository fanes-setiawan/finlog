import 'package:auto_route/auto_route.dart';
import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/features/core/logic/category_cubit.dart';
import 'package:finlog/src/features/core/logic/wallet_cubit.dart';
import 'package:finlog/src/features/core/model/core_models.dart';
import 'package:finlog/src/features/transactions/logic/transaction_cubit.dart';
import 'package:finlog/src/injection/injection.dart';
import 'package:finlog/src/features/transactions/widget/numeric_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:uuid/uuid.dart';

// ... (existing imports)

@RoutePage()
class AddTransactionScreen extends StatelessWidget {
  final String userId;
  final TransactionModel? transactionToEdit;

  const AddTransactionScreen(
      {super.key, required this.userId, this.transactionToEdit});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<TransactionCubit>()),
        BlocProvider(
            create: (_) => getIt<CategoryCubit>()..loadCategories(userId)),
        BlocProvider(create: (_) => getIt<WalletCubit>()..loadWallets(userId)),
      ],
      child: _AddTransactionView(
          userId: userId, transactionToEdit: transactionToEdit),
    );
  }
}

class _AddTransactionView extends StatefulWidget {
  final String userId;
  final TransactionModel? transactionToEdit;

  const _AddTransactionView({required this.userId, this.transactionToEdit});

  @override
  State<_AddTransactionView> createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<_AddTransactionView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _selectedCategoryId;
  String? _selectedWalletId;
  String? _selectedRecurring;

  final List<String> _recurringOptions = [
    'Tidak Berulang',
    'Harian',
    'Mingguan',
    'Bulanan',
    'Tahunan'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    if (widget.transactionToEdit != null) {
      final tx = widget.transactionToEdit!;
      _selectedDate = tx.date ?? DateTime.now();
      _selectedCategoryId = tx.categoryId;
      _selectedWalletId = tx.walletId;
      _selectedRecurring = tx.recurring;
      _noteController.text = tx.note ?? '';
      _tagsController.text = tx.tags?.join(', ') ?? '';

      // Set Amount
      // Format as string
      final formatter = NumberFormat('#,###', 'id_ID');
      String formatted = formatter.format(tx.amount.toInt());
      // Handle decimals if any
      if (tx.amount % 1 != 0) {
        formatted = tx.amount.toString().replaceAll('.', ',');
      }
      _amountController.text = formatted;

      // Set Tab
      if (tx.type == 'income') {
        _tabController.animateTo(1);
      } else {
        _tabController.animateTo(0);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _showKeyboard() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => NumericKeyboard(
        onKeyboardTap: _onKeyTap,
        onBackspace: _onBackspace,
      ),
    );
  }

  void _onKeyTap(String value) {
    String currentText = _amountController.text.replaceAll('Rp ', '');

    // Prevent multiple commas
    if (value == ',' && currentText.contains(',')) return;

    // If starting with comma, prepend 0
    if (currentText.isEmpty && value == ',') {
      currentText = '0';
    } else if (currentText == '0' && value != ',') {
      // Replace initial 0 if typing number
      currentText = '';
    }

    String newText = currentText + value;
    _formatAndSetAmount(newText);
  }

  void _onBackspace() {
    String currentText = _amountController.text.replaceAll('Rp ', '');
    if (currentText.isNotEmpty) {
      String newText = currentText.substring(0, currentText.length - 1);
      _formatAndSetAmount(newText);
    }
  }

  void _formatAndSetAmount(String rawText) {
    if (rawText.isEmpty) {
      _amountController.text = '';
      return;
    }

    // Split integer and decimal parts
    List<String> parts = rawText.split(',');
    String integerPart = parts[0].replaceAll('.', '');
    String decimalPart = parts.length > 1 ? parts[1] : '';

    // Format integer part
    String formattedInteger = '';
    if (integerPart.isNotEmpty) {
      try {
        final number = int.parse(integerPart);
        final formatter = NumberFormat('#,###', 'id_ID');
        formattedInteger = formatter.format(number);
      } catch (e) {
        formattedInteger = integerPart;
      }
    } else {
      if (parts.length > 1) formattedInteger = '0'; // Case: ,50 -> 0,50
    }

    String result = formattedInteger;
    if (parts.length > 1 || rawText.endsWith(',')) {
      result += ',$decimalPart';
    }

    _amountController.text = result;
    // Keep cursor at end is handled by readOnly textfield naturally or we might need selection update if editable
  }

  // Updated submit to parse properly
  void _submit() {
    if (_amountController.text.isEmpty ||
        _selectedCategoryId == null ||
        _selectedWalletId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    // Parse: Remove Rp, remove dots (thousands), replace comma with dot (decimal)
    final cleanString = _amountController.text
        .replaceAll('Rp ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');

    final double amount = double.tryParse(cleanString) ?? 0;

    final type = _tabController.index == 0 ? 'expense' : 'income';

    final isEditing = widget.transactionToEdit != null;
    final transactionId =
        isEditing ? widget.transactionToEdit!.id : const Uuid().v4();
    final createdAt =
        isEditing ? widget.transactionToEdit!.createdAt : DateTime.now();

    final transaction = TransactionModel(
      id: transactionId,
      userId: widget.userId,
      amount: amount,
      type: type,
      categoryId: _selectedCategoryId!,
      walletId: _selectedWalletId!,
      note: _noteController.text,
      date: _selectedDate,
      createdAt: createdAt,
      recurring: _selectedRecurring,
      tags: _tagsController.text.isNotEmpty
          ? _tagsController.text
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList()
          : null,
    );

    if (isEditing) {
      context
          .read<TransactionCubit>()
          .updateTransaction(widget.transactionToEdit!, transaction);
    } else {
      context.read<TransactionCubit>().addTransaction(transaction);
    }

    AutoRouter.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transactionToEdit != null;
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(isEditing ? "Edit Transaction" : "Add Transaction",
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey500,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: "Expense"),
            Tab(text: "Income"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Input
            Text("Nominal Uang",
                style: GoogleFonts.inter(color: AppColors.grey500)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey300),
              ),
              child: TextFormField(
                controller: _amountController,
                readOnly: true,
                showCursor: true,
                onTap: _showKeyboard,
                style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary),
                decoration: const InputDecoration(
                  prefixText: "Rp ",
                  border: InputBorder.none,
                  hintText: "0",
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Wallet Selection
            Text("Dompet / Wallet",
                style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            BlocBuilder<WalletCubit, WalletState>(
              builder: (context, state) {
                return state.maybeWhen(
                  success: (wallets) {
                    return DropdownButtonFormField<String>(
                      value: _selectedWalletId,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      hint: const Text("Pilih Dompet"),
                      items: wallets
                          .map((w) => DropdownMenuItem(
                                value: w.id,
                                child: Text(w.name),
                              ))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedWalletId = val),
                    );
                  },
                  orElse: () => const LinearProgressIndicator(),
                );
              },
            ),

            const SizedBox(height: 20),

            // Category Selection
            Text("Kategori",
                style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, state) {
                return state.maybeWhen(
                  success: (categories) {
                    final isExpense = _tabController.index == 0;
                    final filtered = categories
                        .where(
                            (c) => c.type == (isExpense ? 'expense' : 'income'))
                        .toList();

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: filtered.length + 1, // +1 for Add
                      itemBuilder: (context, index) {
                        if (index == filtered.length) {
                          return GestureDetector(
                            onTap: () async {
                              final newCategoryName = await showDialog<String>(
                                context: context,
                                builder: (context) {
                                  final controller = TextEditingController();
                                  return AlertDialog(
                                    title: const Text("Tambah Kategori Baru"),
                                    content: TextField(
                                      controller: controller,
                                      decoration: const InputDecoration(
                                          hintText: "Nama Kategori"),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Batal")),
                                      ElevatedButton(
                                          onPressed: () => Navigator.pop(
                                              context, controller.text),
                                          child: const Text("Tambah")),
                                    ],
                                  );
                                },
                              );

                              if (newCategoryName != null &&
                                  newCategoryName.isNotEmpty) {
                                final newCategory = CategoryModel(
                                  id: const Uuid().v4(),
                                  userId: widget.userId,
                                  name: newCategoryName,
                                  iconCode:
                                      Icons.category.codePoint, // Default icon
                                  colorValue:
                                      Colors.blue.value, // Default color
                                  type: _tabController.index == 0
                                      ? 'expense'
                                      : 'income',
                                  isCustom: true,
                                );
                                context
                                    .read<CategoryCubit>()
                                    .addCategory(newCategory);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.grey100,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.grey300,
                                    style: BorderStyle.solid),
                              ),
                              child: const Icon(Icons.add,
                                  color: AppColors.grey600),
                            ),
                          );
                        }
                        final cat = filtered[index];
                        final isSelected = cat.id == _selectedCategoryId;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedCategoryId = cat.id),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withOpacity(0.1)
                                  : AppColors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.grey200,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                    IconData(cat.iconCode,
                                        fontFamily: 'MaterialIcons'),
                                    size: 24,
                                    color: Color(cat.colorValue)),
                                const SizedBox(height: 4),
                                Text(
                                  cat.name,
                                  style: TextStyle(
                                      fontSize: 10, color: AppColors.grey800),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                );
              },
            ),

            const SizedBox(height: 20),

            // Date Picker
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (date != null) setState(() => _selectedDate = date);
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: "Tanggal",
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('dd MMM yyyy', 'id_ID')
                        .format(_selectedDate)),
                    const Icon(Icons.calendar_today, size: 20),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Note
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: "Catatan (Opsional)",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 20),

            const SizedBox(height: 20),

            // Recurring
            DropdownButtonFormField<String>(
              value: _selectedRecurring,
              decoration: const InputDecoration(
                labelText: "Berulang (Opsional)",
                border: OutlineInputBorder(),
              ),
              items: _recurringOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedRecurring = newValue;
                });
              },
            ),

            const SizedBox(height: 20),

            // Tags
            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: "Tags (pisahkan dengan koma)",
                hintText: "Contoh: liburan, kerja",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                    widget.transactionToEdit != null
                        ? "Simpan Perubahan"
                        : "Simpan Transaksi",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
