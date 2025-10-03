import 'package:finlog/src/features/expense/model/expense_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../repository/expense_repository.dart';

part 'expense_state.dart';
class ExpenseCubit extends Cubit<ExpenseState> {
  final ExpenseRepository repository;

  ExpenseCubit(this.repository) : super(const ExpenseState());

  Future<void> loadExpenses() async {
    emit(state.copyWith(status: ExpenseStatus.loading));
    final data = await repository.getAllExpenses();
    emit(state.copyWith(status: ExpenseStatus.success, expenses: data));
  }

  Future<void> addExpense(ExpenseModel expense) async {
    await repository.addExpense(expense);
    await loadExpenses();
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    await repository.updateExpense(expense);
    await loadExpenses();
  }

  Future<void> deleteExpense(ExpenseModel expense) async {
    await repository.deleteExpense(expense);
    await loadExpenses();
  }

  Future<void> clearAll() async {
    await repository.clearAll();
    await loadExpenses();
  }
}
