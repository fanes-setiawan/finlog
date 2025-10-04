import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/commons/utils/app_date_utils.dart';
import 'package:finlog/src/features/expense/cubit/expense_cubit.dart';
import 'package:finlog/src/features/expense/model/expense_model.dart';
import 'package:finlog/src/features/home/widget/form/add_expense_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'header_cell.dart';
import 'data_cell.dart';

class PaymentTable extends StatelessWidget {
  final List<ExpenseModel> data;
  const PaymentTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final sortedData = List.of(data);
    sortedData.sort((b, a) => a.date.compareTo(b.date));
    final displayData = List<ExpenseModel?>.from(sortedData.take(5));
    while (displayData.length < 5) {
      displayData.add(null);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(color: AppColors.primary2),
        defaultColumnWidth: const FixedColumnWidth(150),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const {
          0: FixedColumnWidth(50),
          1: FixedColumnWidth(100),
          2: FixedColumnWidth(100),
          3: FixedColumnWidth(100),
          4: FixedColumnWidth(100),
          5: FixedColumnWidth(100),
        },
        children: [
          /// HEADER
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
          ...displayData.asMap().entries.map((entry) {
            final index = entry.key;
            final e = entry.value;

            return TableRow(
              decoration: BoxDecoration(
                color: index.isEven ? AppColors.primary4 : AppColors.white,
              ),
              children: [
                DataCellWidget("${index + 1}"),
                DataCellWidget(e?.date != null
                    ? "${e!.date.toFullDateTime()}"
                    : "..."),
                DataCellWidget(e?.note ?? "..."),
                DataCellWidget(e?.amount != null ? "Rp ${e!.amount}" : "..."),
                PayStatusWidget(e?.method ?? '...'),
                e != null
                    ? Row(
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
                                builder: (_) => AddExpenseForm(expenseModel: e),
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
                    : const SizedBox.shrink(),
              ],
            );
          })
        ],
      ),
    );
  }
}
