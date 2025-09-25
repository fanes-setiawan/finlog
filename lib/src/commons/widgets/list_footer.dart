import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ListFooter extends StatelessWidget {
  final bool handleKeyboard;
  const ListFooter({super.key, this.handleKeyboard = false});

  @override
  Widget build(BuildContext context) {
    return Gap(handleKeyboard ? 360.r : 64.r);
  }
}
