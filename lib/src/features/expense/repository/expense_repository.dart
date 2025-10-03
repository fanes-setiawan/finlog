import 'package:hive/hive.dart';
import '../model/expense_model.dart';

class ExpenseRepository {
  final Box<ExpenseModel> box;

  ExpenseRepository(this.box);

  Future<List<ExpenseModel>> getAllExpenses() async {
    return box.values.toList();
  }

  Future<void> addExpense(ExpenseModel expense) async {
    await box.add(expense);
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    // langsung pakai key, tidak pakai index
    await box.put(expense.key, expense);
  }

  Future<void> deleteExpense(ExpenseModel expense) async {
    await expense.delete();
  }

  Future<void> clearAll() async {
    await box.clear();
  }
}
