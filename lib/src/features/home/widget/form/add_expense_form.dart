import 'package:finlog/src/commons/widgets/secondary_button.dart';
import 'package:finlog/src/features/expense/cubit/expense_cubit.dart';
import 'package:finlog/src/features/expense/model/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddExpenseForm extends StatefulWidget {
  final ExpenseModel? expenseModel;
  const AddExpenseForm({super.key, this.expenseModel});

  @override
  State<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  DateTime? _selectedDateTime;
  String? _selectedMethod;
  String? _selectedType;

  List<String> _expenseTypes = [
    "Makan",
    "Transport",
    "Listrik",
    "Paket Data",
    "Sedekah",
  ];

  bool isValidation() {
    if (_amountController.text.isNotEmpty &&
        _noteController.text.isNotEmpty &&
        _selectedDateTime != null &&
        _selectedMethod!.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool hasChanges() {
    if (widget.expenseModel == null) return true;

    return _amountController.text != widget.expenseModel!.amount.toString() ||
        _noteController.text != widget.expenseModel!.note ||
        _selectedDateTime != widget.expenseModel!.date ||
        _selectedMethod != widget.expenseModel!.method ||
        _selectedType != widget.expenseModel!.type;
  }

  @override
  void initState() {
    super.initState();
    if (widget.expenseModel != null) {
      _amountController.text = widget.expenseModel!.amount.toString();
      _noteController.text = widget.expenseModel!.note;
      _selectedDateTime = widget.expenseModel!.date;
      _selectedMethod = widget.expenseModel!.method;
      _selectedType = widget.expenseModel!.type;

      if (!_expenseTypes.contains(widget.expenseModel!.type)) {
        _expenseTypes.add(widget.expenseModel!.type);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Center(
            child: Text(
              (widget.expenseModel != null)
                  ? "Edit Data"
                  : "Tambah Pengeluaran",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 20),

          /// TIPE PENGELUARAN
          const Text(
            "Tipe Pengeluaran*",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var type in _expenseTypes)
                ChoiceChip(
                  label: Text(type),
                  selected: _selectedType == type,
                  onSelected: (selected) {
                    setState(() => _selectedType = type);
                  },
                ),

              /// Tambah kategori baru
              ActionChip(
                label: const Text("+ Tambah"),
                onPressed: () async {
                  final newType = await _showAddTypeDialog(context);
                  if (newType != null && newType.isNotEmpty) {
                    setState(() {
                      _expenseTypes.add(newType);
                      _selectedType = newType;
                    });
                  }
                },
              )
            ],
          ),
          const SizedBox(height: 16),

          /// DATE & TIME
          const Text(
            "Waktu*",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );

              if (date != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() {
                    _selectedDateTime = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    );
                  });
                }
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: "Tanggal & Waktu",
                border: OutlineInputBorder(),
              ),
              child: Text(
                _selectedDateTime == null
                    ? "Pilih tanggal & waktu"
                    : "${_selectedDateTime!.day}-${_selectedDateTime!.month}-${_selectedDateTime!.year} "
                        "${_selectedDateTime!.hour.toString().padLeft(2, '0')}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}",
              ),
            ),
          ),
          const SizedBox(height: 12),

          const Text(
            "Jumlah*",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: "Jumlah Uang",
              prefixText: "Rp ",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          /// CATATAN
          const Text(
            "Catatan(optional)",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: "Catatan",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          /// METODE PEMBAYARAN
          const Text(
            "Metode Pembayaran",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedMethod = "Cash"),
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _selectedMethod == "Cash"
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Cash",
                      style: TextStyle(
                        color: _selectedMethod == "Cash"
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedMethod = "Transfer"),
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _selectedMethod == "Transfer"
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Transfer",
                      style: TextStyle(
                        color: _selectedMethod == "Transfer"
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (hasChanges())
            SecondaryButton(
              onPressed: () {
                if (isValidation()) {
                  final expense = ExpenseModel(
                    type: _selectedType ?? "Lainnya",
                    note: _noteController.text,
                    amount: double.tryParse(_amountController.text) ?? 0,
                    date: _selectedDateTime ?? DateTime.now(),
                    method: _selectedMethod ?? "Cash",
                  );
                  context.read<ExpenseCubit>().addExpense(expense);
                  Navigator.pop(context);
                }
              },
              label: widget.expenseModel != null ? "Simpan" : 'Tambah',
            ),
        ],
      ),
    );
  }

  Future<String?> _showAddTypeDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Tambah Tipe Pengeluaran"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Masukkan nama kategori"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text("Tambah"),
          ),
        ],
      ),
    );
  }
}
