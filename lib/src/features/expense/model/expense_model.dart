import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 0)
class ExpenseModel extends HiveObject {
  @HiveField(0)
  String type;

  @HiveField(1)
  String note;

  @HiveField(2)
  double amount;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String method;

  ExpenseModel({
    this.type = '',
    this.note = '',
    this.amount = 0,
    DateTime? date,
    this.method = '',
  }) : date = date ?? DateTime.now();
}
