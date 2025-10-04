import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/commons/widgets/app_text.dart';
import 'package:flutter/material.dart';

class DataCellWidget extends StatelessWidget {
  final String text;
  const DataCellWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 14, color: AppColors.neutral1),
      ),
    );
  }
}

class PayStatusWidget extends StatelessWidget {
  final String text;
  const PayStatusWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    bool isCash = text.toUpperCase() == "CASH";
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
            shape: BoxShape.rectangle,
            color: isCash ? AppColors.primary3 : AppColors.primary2),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: AppText(
              text.toUpperCase(),
              style:
                  const TextStyle(fontSize: 14, color: AppColors.neutral1).bold,
            ),
          ),
        ),
      ),
    );
  }
}
