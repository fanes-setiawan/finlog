// ignore_for_file: depend_on_referenced_packages

// import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:finlog/src/commons/constants/errors/app_error.dart';
import 'package:finlog/src/commons/constants/styles/app_color.dart';
import 'package:finlog/src/commons/constants/styles/app_space.dart';
import 'package:finlog/src/commons/constants/styles/app_text.dart';
import 'package:finlog/src/commons/extensions/translate_extension.dart';
import 'package:finlog/src/commons/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class DialogUtils {
  DialogUtils._();

  static Future<dynamic> bottomSheet({
    required Widget child,
    bool dismissFirst = true,
    bool useCloseButton = true,
    double? height,
    double? width,
    EdgeInsetsGeometry? padding,
  }) async {
    if (dismissFirst) {
      SmartDialog.dismiss();
    }

    return SmartDialog.show(
      alignment: Alignment.bottomCenter,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (context) {
        return Container(
          width: width ?? 1.sw,
          height: height ?? 0.5.sh,
          padding: padding ?? EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              if (useCloseButton)
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => SmartDialog.dismiss(),
                    icon: const Icon(Icons.close, color: Colors.black54),
                  ),
                ),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }

  static void toastSuccess(String message, {bool dismissFirst = true}) {
    if (dismissFirst) {
      SmartDialog.dismiss();
    }
    SmartDialog.showToast(
      message,
      displayTime: const Duration(seconds: 3),
      maskColor: Colors.green,
    );
  }

  static void toastError(String message, {bool dismissFirst = true}) {
    if (dismissFirst) {
      SmartDialog.dismiss();
    }
    SmartDialog.showToast(
      message,
      displayTime: const Duration(seconds: 3),
      maskColor: Colors.red,
    );
  }

  static Widget titleText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppText.h18Bold.copyWith(color: AppColor.bgTertiary),
    );
  }

  static Widget descText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppText.l16Regular.copyWith(
        color: AppColor.bgTertiary.withAlpha(
          190,
        ),
      ),
    );
  }

  static Future<String?> remark(
      {String? title, String? description, String? okLabel}) async {
    String? remark;
    await SmartDialog.show(
      builder: (_) {
        return _Container(
          child: _Remark(
            title: title,
            description: description,
            okLabel: okLabel,
            onSubmit: (value) {
              remark = value;
            },
          ),
        );
      },
    );

    return remark;
  }

  static Future<dynamic> error({
    String? title,
    AppError? error,
    String? okLabel,
    void Function()? ok,
    Widget? customButton,
    bool dismissFirst = true,
  }) async {
    if (dismissFirst) {
      SmartDialog.dismiss();
    } else {
      debugPrint('🔥 dialog_utils:68 ~ old dialog not dismiss');
    }

    String message = error?.message ?? "";

    final List<Map<String, dynamic>> errorList = [];

    if (error != null) {
      if (error.message == "unknownError") {
        message = "failedToFetchApi".trError();
      }

      if (error.args.isNotEmpty) {
        final firstArg = error.args[0];
        if (firstArg is List && firstArg.isNotEmpty && firstArg[0] is Map) {
          errorList.addAll(firstArg.whereType<Map<String, dynamic>>().toList());
        } else if (firstArg is Map) {
          errorList.add(firstArg as Map<String, dynamic>);
        } else {
          errorList
              .addAll(error.args.whereType<Map<String, dynamic>>().toList());
        }
      }

      // log(errorList.toString());
      if (errorList.isNotEmpty) {
        debugPrint('🔥 dialog_utils:48 ~ errorList: $errorList');
      }

      if (error.message.contains('validitySchemaExpired')) {
        // showSubscriptionModalWidget
        // return;
      }
    }

    return SmartDialog.show(
      alignment: Alignment.center,
      builder: (_) => _Container(
        child: _ErrMessage(
          title: title ?? "somethingWentWrong".trError(),
          desc: message.trLabel(),
          okLabel: okLabel,
          ok: ok,
          customButton: customButton,
        ),
      ),
    );
  }

  static Future<dynamic> success({
    String? title,
    String? desc,
    String? okLabel,
    void Function()? ok,
    bool dismissFirst = true,
  }) async {
    if (dismissFirst) {
      SmartDialog.dismiss();
    }

    return SmartDialog.show(
      onDismiss: ok,
      alignment: Alignment.center,
      builder: (_) => _Container(
        child: _SuccessMessage(
          title: title ?? "",
          desc: desc ?? "",
          okLabel: okLabel,
          ok: ok,
        ),
      ),
    );
  }

  static Future<dynamic> custom({
    @Deprecated("use child instead") Widget? title,
    @Deprecated("use child instead") Widget? body,
    @Deprecated("use child instead") Widget? footer,
    @Deprecated("use child is auto expanded") bool isBodyExpanded = false,
    Widget? child,
    void Function()? onCancel,
    bool dismissFirst = true,
  }) async {
    if (dismissFirst) {
      SmartDialog.dismiss();
    }

    return SmartDialog.show(
      alignment: Alignment.center,
      builder: (context) => _Container(
        onClose: onCancel,
        child: SizedBox(
          width: 0.6.sw,
          child: child ??
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (title != null) title,
                  if (body != null && !isBodyExpanded) body,
                  if (body != null && isBodyExpanded) Expanded(child: body),
                  if (footer != null) footer,
                ],
              ),
        ),
      ),
    );
  }

  // static Future<dynamic> pickDate({
  //   required DateTime initialDate,
  //   required DateTime maxDate,
  //   required DateTime minDate,
  //   void Function(DateTime selected)? onSelected,
  // }) async {
  //   SmartDialog.show(
  //     alignment: Alignment.center,
  //     builder: (context) => _Container(
  //       child: SizedBox(
  //         width: 0.6.sw,
  //         child: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               DatePicker(
  //                 initialDate: initialDate,
  //                 selectedDate: initialDate,
  //                 maxDate: maxDate,
  //                 minDate: minDate,
  //                 onDateSelected: (selected) {
  //                   SmartDialog.dismiss();
  //                   onSelected?.call(selected);
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // static Future<dynamic> pickDateRange({
  //   required DateTime maxDate,
  //   required DateTime minDate,
  //   DateTime? initialDate,
  //   DateTimeRange? selectedRange,
  //   void Function(DateTimeRange range)? onSelected,
  // }) async {
  //   SmartDialog.show(
  //     alignment: Alignment.center,
  //     builder: (context) => _Container(
  //       child: SizedBox(
  //         width: 0.6.sw,
  //         child: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               RangeDatePicker(
  //                 maxDate: maxDate,
  //                 minDate: minDate,
  //                 initialDate: initialDate,
  //                 selectedRange: selectedRange,
  //                 onRangeSelected: (range) {
  //                   SmartDialog.dismiss();
  //                   onSelected?.call(range);
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  static void loading() {
    debugPrint('🔥 dialog_utils:58 ~ loading');
    SmartDialog.dismiss();

    SmartDialog.showLoading();
  }

  static void dismiss({String? jenisNilai}) {
    debugPrint('🔥 dialog_utils:62 ~ dismiss');
    SmartDialog.dismiss();
  }
}

class _Container extends StatelessWidget {
  final Widget child;
  final void Function()? onClose;
  const _Container({
    required this.child,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      width: 0.8.sw,
      height: 0.7.sh,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.bgTertiary.withValues(alpha: 0.15),
            spreadRadius: 1,
            blurRadius: 0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: onClose ?? () => SmartDialog.dismiss(),
                icon: const Icon(Icons.close, color: Colors.black54, size: 30),
                style: const ButtonStyle(),
              ),
            ],
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

class _Remark extends StatefulWidget {
  final String? title;
  final String? description;
  final void Function(String remark) onSubmit;
  final String? okLabel;
  const _Remark({
    required this.onSubmit,
    this.title,
    this.description,
    this.okLabel,
  });

  @override
  State<_Remark> createState() => _RemarkState();
}

class _RemarkState extends State<_Remark> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 0.6.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: AppSpace.x2,
            ),
            if (widget.title != null) ...[
              Text(
                widget.title!,
                textAlign: TextAlign.center,
                style: AppText.h18Bold.copyWith(color: AppColor.bgTertiary),
              ),
              const SizedBox(
                height: AppSpace.x2,
              ),
            ],
            if (widget.description != null) ...[
              Text(
                widget.description!,
                textAlign: TextAlign.center,
                style: AppText.l16Regular.copyWith(
                  color: AppColor.bgTertiary.withAlpha(
                    190,
                  ),
                ),
              ),
              const SizedBox(
                height: AppSpace.x2,
              ),
            ],
            Gap(16.r),
            // InputField(
            //   textController: controller,
            //   textInputAction: TextInputAction.done,
            //   multiLine: true,
            //   autoFocus: true,
            //   onFieldSubmitted: (_) => submit(),
            // ),
            Gap(36.r),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.x6 * 2),
              child: PrimaryButton(
                width: 1.sw,
                label: widget.okLabel ?? "Ok",
                onPressed: submit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submit() {
    SmartDialog.dismiss();
    widget.onSubmit(controller.text);
  }
}

class _SuccessMessage extends StatelessWidget {
  final String title;
  final String desc;
  final String? okLabel;
  final void Function()? ok;
  const _SuccessMessage({
    this.title = "",
    this.desc = "",
    this.okLabel,
    this.ok,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 0.6.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/check-circle.svg',
              width: 70,
            ),
            const SizedBox(
              height: AppSpace.x2,
            ),
            if (title.isNotEmpty) ...[
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppText.h18Bold.copyWith(color: AppColor.bgTertiary),
              ),
              const SizedBox(
                height: AppSpace.x2,
              ),
            ],
            if (desc.isNotEmpty) ...[
              Text(
                desc,
                textAlign: TextAlign.center,
                style: AppText.l16Regular.copyWith(
                  color: AppColor.bgTertiary.withAlpha(
                    190,
                  ),
                ),
              ),
              const SizedBox(
                height: AppSpace.x2,
              ),
            ],
            Gap(36.r),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.x6 * 2),
              child: PrimaryButton(
                width: 1.sw,
                label: okLabel ?? "Ok",
                onPressed: () {
                  SmartDialog.dismiss();
                  ok?.call();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrMessage extends StatelessWidget {
  final String title;
  final String desc;
  final String? okLabel;
  final void Function()? ok;
  final Widget? customButton;

  const _ErrMessage({
    this.title = "",
    this.desc = "",
    this.customButton,
    this.okLabel,
    this.ok,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 0.6.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/x-circle.svg',
              colorFilter: const ColorFilter.mode(
                AppColor.errorPrimary,
                BlendMode.srcIn,
              ),
              width: 70,
            ),
            const SizedBox(
              height: AppSpace.x2,
            ),
            if (title.isNotEmpty) ...[
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppText.h18Bold.copyWith(color: AppColor.bgTertiary),
              ),
              const SizedBox(
                height: AppSpace.x2,
              ),
            ],
            if (desc.isNotEmpty) ...[
              Text(
                desc,
                textAlign: TextAlign.center,
                style: AppText.l16Regular.copyWith(
                  color: AppColor.bgTertiary.withAlpha(
                    190,
                  ),
                ),
              ),
              const SizedBox(
                height: AppSpace.x2,
              ),
            ],
            Gap(36.r),
            customButton ??
                PrimaryButton(
                  width: 1.sw,
                  label: okLabel ?? "gotIt".trLabel(),
                  onPressed: () {
                    SmartDialog.dismiss();
                    ok?.call();
                  },
                ),
          ],
        ),
      ),
    );
  }
}

// class _ErrMessageFullPage extends StatelessWidget {
//   const _ErrMessageFullPage({required this.appError, required this.errorList, this.customButton});

//   final AppError appError;
//   final List<Map<String, dynamic>> errorList;
//   final Widget? customButton;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(
//             height: AppSpace.x4,
//           ),
//           const IconButton(
//             onPressed: SmartDialog.dismiss,
//             icon: Icon(Icons.close),
//           ),
//           Center(
//             child: Container(
//               decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(100)), boxShadow: [
//                 BoxShadow(
//                   color: AppColor.bgTertiary.withOpacity(0.15),
//                   spreadRadius: 1,
//                   blurRadius: 0,
//                   offset: const Offset(0, 0),
//                 ),
//               ]),
//               child: Image.asset(
//                 'assets/images/unable_to_process.webp',
//                 fit: BoxFit.cover,
//                 width: 200,
//                 height: 150,
//               ),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: AppSpace.x4, vertical: AppSpace.x4),
//             margin: const EdgeInsets.only(
//               top: AppSpace.x2,
//             ),
//             width: double.infinity,
//             child: Text(
//               'somethingWentWrong'.trLabel(),
//               maxLines: 4,
//               overflow: TextOverflow.ellipsis,
//               style: AppText.l16Bold.copyWith(color: AppColor.bgTertiary),
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(width: 2.0, color: Colors.grey.shade400),
//               ),
//             ),
//             padding: const EdgeInsets.only(left: AppSpace.x4, right: AppSpace.x4, bottom: AppSpace.x4),
//             width: double.infinity,
//             child: Text(
//               appError.message,
//               maxLines: 4,
//               overflow: TextOverflow.ellipsis,
//               style: AppText.l12Regular.copyWith(color: AppColor.bgTertiary),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: appError.args.length,
//               itemBuilder: (context, index) {
//                 final data = errorList[index];
//                 List<String> keyList = data.keys.toList();
//                 return Container(
//                   decoration: BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
//                     ),
//                   ),
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: AppSpace.x6,
//                       vertical: AppSpace.base,
//                     ),
//                     title: Text(
//                       '${keyList[0].trLabel()} : ${data[keyList[0]]}',
//                       style: AppText.l14SemiBold.copyWith(color: AppColor.bgTertiary),
//                     ),
//                     subtitle: keyList.length > 1
//                         ? Text(
//                             '${keyList[1].trLabel()} : ${data[keyList[1]] is Map<String, dynamic> ? AppError(data[keyList[1]]["errorCode"], args: data[keyList[1]]["errorArgs"] ?? []).message : data[keyList[1]]}',
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: AppText.l12Regular,
//                           )
//                         : null,
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(
//           horizontal: AppSpace.x6,
//           vertical: AppSpace.x4,
//         ),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 5,
//               offset: Offset(0, -2),
//             )
//           ],
//         ),
//         child: customButton ??
//             Row(
//               children: [
//                 Expanded(
//                   child: SecondaryButton(
//                     onPressed: SmartDialog.dismiss,
//                     label: 'learnMore'.trLabel(),
//                     rounded: false,
//                   ),
//                 ),
//                 const SizedBox(width: AppSpace.x4),
//                 Expanded(
//                   child: PrimaryButton(
//                     label: 'notifyMe'.trLabel(),
//                     onPressed: SmartDialog.dismiss,
//                     rounded: false,
//                   ),
//                 ),
//               ],
//             ),
//       ),
//     );
//   }
// }
