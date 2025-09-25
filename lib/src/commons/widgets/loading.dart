// ignore_for_file: depend_on_referenced_packages

import 'package:finlog/src/commons/constants/styles/app_color.dart';
import 'package:finlog/src/commons/constants/styles/app_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpace.x2),
      child: SpinKitFadingCircle(
        size: 32,
        color: color ?? AppColor.activePrimary,
      ),
    );
  }
}
