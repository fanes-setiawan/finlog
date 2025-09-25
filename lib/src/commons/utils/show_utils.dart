import 'package:auto_route/auto_route.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:finlog/src/commons/constants/styles/app_color.dart';
import 'package:finlog/src/commons/constants/styles/app_space.dart';
import 'package:finlog/src/commons/constants/styles/app_text.dart';
import 'package:finlog/src/commons/extensions/translate_extension.dart';
import 'package:finlog/src/commons/widgets/primary_button.dart';
import 'package:finlog/src/commons/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// show utils:
/// - showSuccessDialog
/// - showLoadingDialog
/// - dismissLoadingDialog
/// - showErrorDialog
/// - showBottomSheet
/// - showConfirmationDialog
@Deprecated('use DialogUtils instead')
class ShowUtils {
  static void showCustomDialog({
    required BuildContext context,
    String? title,
    required Widget body,
    String? labelAccept,
    String? labelReject,
    String? desc,
    Widget? descWidget,
    dynamic Function()? btnOkOnPress,
    dynamic Function()? btnCancelOnPress,
    dynamic Function(DismissType)? onDissmissCallback,
    bool dismissOnBackKeyPress = true,
    bool hideButton = false,
  }) {
    AwesomeDialog(
      onDismissCallback: onDissmissCallback ??
          (type) {
            if (type == DismissType.androidBackButton) {
              if (btnCancelOnPress != null) {
                btnCancelOnPress.call();
                return;
              }
              Navigator.of(context).pop();
            }
          },
      autoDismiss: false,
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      title: title,
      dismissOnBackKeyPress: dismissOnBackKeyPress,
      body: body,
      headerAnimationLoop: false,
      dialogBorderRadius: BorderRadius.circular(AppSpace.x6),
      btnOk: hideButton
          ? null
          : PrimaryButton(
              label: labelAccept ?? "Ok",
              onPressed: btnOkOnPress,
            ),
      btnCancel: hideButton
          ? null
          : SecondaryButton(
              label: labelReject ?? 'cancel'.trLabel(),
              onPressed: btnCancelOnPress ??
                  () {
                    Navigator.of(context).pop();
                  },
            ),
    ).show();
  }

  static void showConfirmationDialog({
    required BuildContext context,
    required String title,
    bool hideButtonCancel = false,
    bool useHeadIcon = true,
    String? labelAccept,
    String? labelReject,
    String? desc,
    Widget? descWidget,
    dynamic Function()? btnOkOnPress,
    dynamic Function()? btnCancelOnPress,
    dynamic Function(DismissType)? onDissmissCallback,
    bool dismissOnBackKeyPress = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpace.x2,
            vertical: AppSpace.x4,
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.x4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                useHeadIcon
                    ? Column(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/alert-circle.svg',
                            width: 70,
                          ),
                          const SizedBox(
                            height: AppSpace.x2,
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppText.h18Bold.copyWith(color: AppColor.bgTertiary),
                ),
                const SizedBox(
                  height: AppSpace.x2,
                ),
                descWidget ??
                    Text(
                      desc!,
                      textAlign: TextAlign.center,
                      style: AppText.l16Regular.copyWith(
                        color: AppColor.bgTertiary.withAlpha(
                          190,
                        ),
                      ),
                    ),
                const SizedBox(
                  height: AppSpace.x4,
                ),
                Row(
                  children: [
                    !hideButtonCancel
                        ? Expanded(
                            child: SecondaryButton(
                              label: labelReject ?? "cancel".trLabel(),
                              onPressed: btnCancelOnPress ??
                                  () {
                                    // context.router.pop();
                                  },
                            ),
                          )
                        : const SizedBox.shrink(),
                    !hideButtonCancel
                        ? const SizedBox(
                            width: AppSpace.x2,
                          )
                        : const SizedBox.shrink(),
                    Expanded(
                      child: PrimaryButton(
                        label: labelAccept ?? "Ok",
                        onPressed: btnOkOnPress,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static void showBottomSheet({
    required BuildContext context,
    Widget? child,
    bool disablePadding = false,
    bool showKeyboard = false,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpace.x6),
      ),
      builder: (context) {
        return Padding(
          padding: disablePadding
              ? EdgeInsets.only(
                  bottom: showKeyboard
                      ? MediaQuery.of(context).viewInsets.bottom
                      : 0.0,
                )
              : EdgeInsets.only(
                  bottom: showKeyboard
                      ? MediaQuery.of(context).viewInsets.bottom
                      : AppSpace.x2,
                  left: AppSpace.x2,
                  right: AppSpace.x2,
                  top: AppSpace.x2,
                ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: AppSpace.x1, bottom: AppSpace.x4),
                  child: Container(
                    width: AppSpace.x5,
                    height: AppSpace.x1,
                    decoration: BoxDecoration(
                      color: AppColor.inactivePrimary,
                      borderRadius: BorderRadius.circular(AppSpace.x6),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: child ?? const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }

  static void showSuccessDialog({
    required BuildContext context,
    String title = '',
    String desc = '',
    dynamic Function()? btnOkOnPress,
    dynamic Function(DismissType)? onDissmissCallback,
    bool dismissOnBackKeyPress = true,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      title: title,
      desc: desc,
      onDismissCallback: onDissmissCallback,
      dismissOnBackKeyPress: dismissOnBackKeyPress,
      body: Column(
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
          title.isNotEmpty
              ? Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppText.h18Bold.copyWith(color: AppColor.bgTertiary),
                )
              : const SizedBox.shrink(),
          title.isNotEmpty
              ? const SizedBox(
                  height: AppSpace.x2,
                )
              : const SizedBox.shrink(),
          desc.isNotEmpty
              ? Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: AppText.l16Regular.copyWith(
                    color: AppColor.bgTertiary.withAlpha(
                      190,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          desc.isNotEmpty
              ? const SizedBox(
                  height: AppSpace.x2,
                )
              : const SizedBox.shrink(),
        ],
      ),
      headerAnimationLoop: false,
      dialogBorderRadius: BorderRadius.circular(AppSpace.x6),
      btnOk: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.x6 * 2),
        child: PrimaryButton(
          label: "Ok",
          onPressed: btnOkOnPress ??
              () {
                context.router.maybePop();
              },
        ),
      ),
      // btnOkOnPress: btnOkOnPress,
    ).show();
  }

  static void showLoadingDialog() {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
  }

  static void dismissLoadingDialog() {
    EasyLoading.dismiss();
  }

  static void showErrorDialog({
    required BuildContext context,
    String title = '',
    String desc = '',
    dynamic Function(DismissType)? onDissmissCallback,
    dynamic Function()? btnOkOnPress,
  }) {
    AwesomeDialog(
      onDismissCallback: onDissmissCallback ?? (type) {},
      autoDismiss: false,
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      title: title,
      desc: desc,
      body: Column(
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
          title.isNotEmpty
              ? Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppText.h18Bold.copyWith(color: AppColor.bgTertiary),
                )
              : const SizedBox.shrink(),
          title.isNotEmpty
              ? const SizedBox(
                  height: AppSpace.x2,
                )
              : const SizedBox.shrink(),
          desc.isNotEmpty
              ? Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: AppText.l16Regular.copyWith(
                    color: AppColor.bgTertiary.withAlpha(
                      190,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          desc.isNotEmpty
              ? const SizedBox(
                  height: AppSpace.x2,
                )
              : const SizedBox.shrink(),
        ],
      ),
      headerAnimationLoop: false,
      dialogBorderRadius: BorderRadius.circular(AppSpace.x6),
      btnOk: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.x6 * 2),
        child: PrimaryButton(
          label: "Ok",
          onPressed: btnOkOnPress ??
              () {
                debugPrint('🔥 show_utils:368');
                context.router.back();
              },
        ),
      ),
    ).show();
  }
}
