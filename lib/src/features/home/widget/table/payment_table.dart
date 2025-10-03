import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/commons/constants/styles/sizing.dart';
import 'package:finlog/src/features/expense/cubit/expense_cubit.dart';
import 'package:finlog/src/features/expense/model/expense_model.dart';
import 'package:finlog/src/features/home/widget/form/add_expense_form.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'header_cell.dart';
import 'data_cell.dart';

class PaymentTable extends StatelessWidget {
  final List<ExpenseModel> data;
  const PaymentTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultColumnWidth: const FixedColumnWidth(150),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          /// HEADER
          TableRow(
            decoration: BoxDecoration(color: AppColors.subtitle),
            children: const [
              HeaderCell('Tanggal'),
              HeaderCell('Catatan'),
              HeaderCell('Jumlah'),
              HeaderCell('Metode Pembayaran'),
              HeaderCell('Aksi'),
            ],
          ),
          ...data.asMap().entries.map((entry) {
            final index = entry.key;
            final e = entry.value;
            {
              return TableRow(
                  decoration: BoxDecoration(
                    color: index.isEven
                        ? AppColors.primary2
                        : AppColors.primary3,
                  ),
                  children: [
                    DataCellWidget("${e.date}"),
                    DataCellWidget(e.note),
                    DataCellWidget("Rp ${e.amount}"),
                    PayStatusWidget(e.method),
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
                                builder: (_) => AddExpenseForm(expenseModel: e),
                              );
                            },
                            icon: const Icon(
                              Icons.open_in_new,
                              size: 18.0,
                              color: AppColors.primary1,
                            )),
                        Gap(Sizing.xs),
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
                    ),
                  ]);
            }
          })
        ],
      ),
    );
  }
}
