import 'package:finlog/src/commons/constants/errors/app_error.dart';
import 'package:finlog/src/commons/extensions/translate_extension.dart';
import 'package:flutter/material.dart';

class NewPageErrorIndicator extends StatelessWidget {
  final AppError error;
  final void Function()? refresh;
  const NewPageErrorIndicator({
    super.key,
    this.refresh,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        refresh?.call();
      },
      child: Text(
        error.message.trLabel(),
      ),
    );
  }
}
