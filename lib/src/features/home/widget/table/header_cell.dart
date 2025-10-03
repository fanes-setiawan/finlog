import 'package:finlog/src/commons/widgets/app_text.dart';
import 'package:flutter/material.dart';

class HeaderCell extends StatelessWidget {
  final String text;
  const HeaderCell(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: AppText(text).bold,
    );
  }
}
