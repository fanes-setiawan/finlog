import 'package:finlog/src/commons/utils/app_date_utils.dart';
import 'package:finlog/src/features/home/widget/form/add_expense_form.dart';
import 'package:finlog/src/features/home/widget/table/data_cell.dart';
import 'package:finlog/src/features/home/widget/table/header_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/features/expense/cubit/expense_cubit.dart';

class HomeViewAllTable extends StatefulWidget {
  static const path = '/homeTableAll';
  const HomeViewAllTable({super.key});

  @override
  State<HomeViewAllTable> createState() => _HomeViewAllTableState();
}

class _HomeViewAllTableState extends State<HomeViewAllTable> {
  @override
  void initState() {
    super.initState();
    // Kunci ke mode horizontal
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Kembalikan ke mode vertikal normal
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<ExpenseCubit>().state.expenses;
    final sortedData = List.of(data)..sort((b, a) => a.date.compareTo(b.date));

    // Batasi maksimal 5 data

    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Data Pengeluaran'),
        backgroundColor: AppColors.primary1,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: sortedData.isEmpty
          ? const Center(
              child: Text(
                "Belum ada data pengeluaran",
                style: TextStyle(fontSize: 16),
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(
                  border: TableBorder.all(color: AppColors.primary2),
                  defaultColumnWidth: const FixedColumnWidth(150),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {
                    0: FixedColumnWidth(50),
                    1: FixedColumnWidth(200),
                    2: FixedColumnWidth(250),
                    3: FixedColumnWidth(130),
                    4: FixedColumnWidth(120),
                    5: FixedColumnWidth(100),
                  },
                  children: [
                    // HEADER
                    TableRow(
                      decoration: BoxDecoration(color: AppColors.subtitle),
                      children: const [
                        HeaderCell('No'),
                        HeaderCell('Tanggal'),
                        HeaderCell('Catatan'),
                        HeaderCell('Jumlah'),
                        HeaderCell('Metode Pembayaran'),
                        HeaderCell('Aksi'),
                      ],
                    ),
                    // ISI
                    ...sortedData.asMap().entries.map((entry) {
                      final index = entry.key;
                      final e = entry.value;

                      return TableRow(
                        decoration: BoxDecoration(
                          color: index.isEven
                              ? AppColors.primary4
                              : AppColors.white,
                        ),
                        children: [
                          DataCellWidget("${index + 1}"),
                          DataCellWidget(e.date.toFullDateTime()),
                          DataCellWidget(e.note),
                          DataCellWidget("Rp ${e.amount}"),
                          DataCellWidget(e.method),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    useSafeArea: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16)),
                                    ),
                                    builder: (_) =>
                                        AddExpenseForm(expenseModel: e),
                                  );
                                },
                                icon: const Icon(
                                  Icons.open_in_new,
                                  size: 18.0,
                                  color: AppColors.primary1,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  context.read<ExpenseCubit>().deleteExpense(e);
                                },
                                icon: const Icon(
                                  Icons.delete_rounded,
                                  size: 24.0,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
    );
  }
}
