import 'package:auto_route/auto_route.dart';
import 'package:finlog/src/features/transactions/logic/transaction_cubit.dart';
import 'package:finlog/src/features/core/model/core_models.dart';
import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:finlog/src/features/home/widget/transaction_list_item.dart';

import 'package:finlog/src/features/auth/cubit/auth_cubit.dart';
import 'package:finlog/src/routing/app_router.dart';

@RoutePage()
class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is AuthAuthenticated) {
          final userId = authState.user.uid;
          return BlocProvider(
            create: (_) => getIt<TransactionCubit>()..loadTransactions(userId),
            child: Scaffold(
              backgroundColor: AppColors.backgroundLight,
              appBar: AppBar(
                title: Text("Transactions",
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                elevation: 0,
              ),
              body: _TransactionHistoryView(userId: userId),
            ),
          );
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class _TransactionHistoryView extends StatelessWidget {
  final String userId;
  const _TransactionHistoryView({required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => const Center(child: CircularProgressIndicator()),
          success: (transactions) {
            if (transactions.isEmpty) {
              return Center(
                child: Text("No transactions found",
                    style: GoogleFonts.inter(color: AppColors.grey500)),
              );
            }

            // Group by Date
            final grouped = groupBy(transactions, (TransactionModel t) {
              if (t.date == null) return DateTime.now();
              return DateTime(t.date!.year, t.date!.month, t.date!.day);
            });

            final sortedKeys = grouped.keys.toList()
              ..sort((a, b) => b.compareTo(a));

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: sortedKeys.length,
              itemBuilder: (context, index) {
                final date = sortedKeys[index];
                final dayTransactions = grouped[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        DateFormat('EEEE, d MMM yyyy').format(date),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    ...dayTransactions.map((tx) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Dismissible(
                            key: Key(tx.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Hapus Transaksi?"),
                                    content: const Text(
                                        "Transaksi yang dihapus tidak dapat dikembalikan."),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text("Batal")),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text("Hapus",
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            onDismissed: (_) {
                              context
                                  .read<TransactionCubit>()
                                  .deleteTransaction(tx.id);
                            },
                            child: TransactionListItem(
                              transaction: tx,
                              onTap: () {
                                context.pushRoute(AddTransactionRoute(
                                    userId: userId, transactionToEdit: tx));
                              },
                            ),
                          ),
                        )),
                    const SizedBox(height: 8),
                  ],
                );
              },
            );
          },
          error: (msg) => Center(child: Text("Error: $msg")),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}
