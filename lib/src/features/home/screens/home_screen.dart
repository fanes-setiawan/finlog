import 'package:auto_route/auto_route.dart';
import 'package:finlog/src/commons/constants/styles/sizing.dart';
import 'package:finlog/src/commons/utils/fancy_fab.dart';
import 'package:finlog/src/commons/widgets/app_text.dart';
import 'package:finlog/src/features/expense/cubit/expense_cubit.dart';
import 'package:finlog/src/features/home/widget/credit_card_widget.dart';
import 'package:finlog/src/features/home/widget/form/add_expense_form.dart';
import 'package:finlog/src/features/home/widget/table/payment_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CreditCardWidget(
              cardNumber: "4562 1122 4595 7852",
              cardHolder: "AR Jonson",
              expiryDate: "24/2000",
              cvv: "6986",
            ),
            Gap(Sizing.sm),
            // Card(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            // Text("Finance Action",
            //     style: AppTextStyles.subtitle(color: AppColors.white)),
            // const SizedBox(height: 12.0),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     CircleButtonIcon(
            //         iconPath: AppAssets.ustdIcon,
            //         label: "Loan",
            //         onTap: () => debugPrint("Loan tapped")),
            //     CircleButtonIcon(
            //         iconPath: AppAssets.uploadIcon,
            //         label: "Topup",
            //         onTap: () => debugPrint("Topup tapped")),
            //     CircleButtonIcon(
            //         iconPath: AppAssets.downIcon,
            //         label: "Receive",
            //         onTap: () => debugPrint("Receive tapped")),
            // CircleButtonIcon(
            //     iconPath: AppAssets.upIcon,
            //     label: "Add",
            //     onTap: () => DialogUtils.bottomSheet(
            //           useCloseButton: false,
            //           dismissFirst: false,
            //           child: const AddExpenseForm(),
            //         )),
            //   ],
            // ),
            //   ],
            // ),
            // ),
            // ),

            Gap(Sizing.sm),
            const AppText("Data Pengeluaran").labelSmall.semiBold,
            Gap(Sizing.xs),
            BlocBuilder<ExpenseCubit, ExpenseState>(builder: (context, state) {
              if (state.status == ExpenseStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state.status == ExpenseStatus.failure) {
                return const Center(child: Text("Gagal memuat data"));
              }
              if (state.expenses.isEmpty) {
                return const Text('Balum ada data');
              }
              return PaymentTable(data: state.expenses);
            }),
          ],
        ),
      ),
      floatingActionButton: FancyFab(
        items: [
          FabItem(
            tooltip: 'Add',
            icon: Icons.add,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => const AddExpenseForm(),
              );
            },
          ),
        ],
      ),
    );
  }
}
