import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/commons/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuSectionItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? value;
  final Widget? widgetValue;
  final Widget? prefix;
  final bool boldTitle;
  const MenuSectionItem(
    this.title, {
    this.subtitle,
    super.key,
    this.value,
    this.widgetValue,
    this.prefix,
    this.boldTitle = false,
  });

  static List<int> flexs = [3, 7];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.r),
      child: Row(
        children: [
          Expanded(
            flex: flexs[0],
            child: Row(
              children: [
                if (prefix != null) prefix!,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppText.labelSmall.copyWith(
                        fontWeight: boldTitle ? FontWeight.bold : FontWeight.w400,
                      ),
                    ),
                    if (subtitle != null)
                      AppText(
                        subtitle!,
                      ).labelSmall.regular.color(AppColors.neutral3),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: flexs[1],
            child: Padding(
              padding: EdgeInsets.only(left: 32.r),
              child: widgetValue ?? Text(value ?? "", style: AppText.subtitleSmall),
            ),
          ),
        ],
      ),
    );
  }
}
