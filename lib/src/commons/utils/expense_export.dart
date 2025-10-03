// import 'dart:io';
// import 'package:excel/excel.dart';
// import 'package:finlog/src/features/expense/model/expense_model.dart';
// import 'package:path_provider/path_provider.dart';

// class ExpenseExport {
//   static Future<String> exportToExcel(List<ExpenseModel> expenses) async {
//     final excel = Excel.createExcel();
//     final sheet = excel['Pengeluaran'];

//     // Header
//     sheet.appendRow(["Tipe", "Catatan", "Jumlah", "Tanggal", "Metode"]);

//     // Data
//     for (final exp in expenses) {
//       sheet.appendRow([
//         exp.type,
//         exp.note,
//         exp.amount,
//         "${exp.date.day}-${exp.date.month}-${exp.date.year} ${exp.date.hour}:${exp.date.minute}",
//         exp.method,
//       ]);
//     }

//     // Simpan file
//     final dir = await getApplicationDocumentsDirectory();
//     final path = "${dir.path}/pengeluaran.xlsx";
//     final fileBytes = excel.save();
//     File(path)
//       ..createSync(recursive: true)
//       ..writeAsBytesSync(fileBytes!);
//     return path;
//   }
// }
