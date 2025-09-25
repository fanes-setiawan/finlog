import 'package:finlog/src/commons/constants/styles/app_color.dart';
import 'package:flutter/material.dart';

class ContentLoadingWidget extends StatelessWidget {
  const ContentLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColor.activePrimary,
      ),
    );
  }
}
