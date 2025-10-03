part of 'expense_cubit.dart';

enum ExpenseStatus { initial, loading, success, failure }

class ExpenseState extends Equatable {
  final ExpenseStatus status;
  final List<ExpenseModel> expenses;

  const ExpenseState({
    this.status = ExpenseStatus.initial,
    this.expenses = const [],
  });


  ExpenseState copyWith({
    ExpenseStatus? status,
    List<ExpenseModel>? expenses,
  }) {
    return ExpenseState(
      status: status ?? this.status,
      expenses: expenses ?? this.expenses,
    );
  }

  @override
  List<Object?> get props => [status, expenses];
}
