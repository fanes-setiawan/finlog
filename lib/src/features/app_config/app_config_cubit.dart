import 'package:easy_localization/easy_localization.dart';
import 'package:finlog/src/commons/clients/local/local_keys.dart';
import 'package:finlog/src/commons/constants/app_localization.dart';
import 'package:finlog/src/commons/constants/app_result.dart';
import 'package:finlog/src/commons/extensions/cubit_extension.dart';
import 'package:finlog/src/commons/utils/dialog_utils.dart';
import 'package:finlog/src/commons/utils/get_local_data.dart';
import 'package:finlog/src/commons/utils/set_local_data.dart';
import 'package:finlog/src/features/app_config/models/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

@singleton
class AppConfigCubit extends Cubit<AppResult> {
  AppConfigCubit() : super(AppResult.initial()) {
    latestConfig = AppConfig();
    getVersion();
  }

  AppConfig? latestConfig;

  @override
  void emit(AppResult state) {
    if (state.isSuccess) {
      latestConfig = state.data!;
    }

    super.emit(state);
  }

  String get langKey => LocalKeys.lang;
  String get currLocaleKey => LocalKeys.currLocale;

  void refresh() {
    if (state.isSuccess) {
      emit(state.copyWith(data: latestConfig));
    } else {
      emit(state.newInstance);
    }
  }

  Future<void> getVersion() async {
    await process(
      () async {
        bool isDev = true;
        try {
          isDev = FlavorConfig.instance.name != 'prod';
        } catch (_) {}
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String version = packageInfo.version;
        String buildNumber = packageInfo.buildNumber;
        latestConfig = latestConfig!
            .copyWith(version: '$version+$buildNumber${isDev ? ' (dev)' : ''}');
        refresh();
      },
      emitLoading: false,
      emitSuccess: true,
    );
  }

  Future<void> setLocale(Locale locale) async {
    await process(
      () async {
        await setLocalData(langKey, locale.languageCode);

        latestConfig = latestConfig!.copyWith(locale: locale);
        refresh();
      },
      emitLoading: false,
      emitSuccess: true,
    );
  }

  Future<void> getDefaultLang(BuildContext context) async {
    DialogUtils.loading();
    final lang = getLocalData(langKey);
    final locale =
        lang == 'id' ? AppLocalization.localeId : AppLocalization.localeEn;

    if (!context.mounted) {
      await setLocale(locale);
      DialogUtils.dismiss();
      return;
    }
    context.setLocale(locale).then((_) async {
      await setLocale(locale);
      DialogUtils.dismiss();
    });
  }

  Future<T?> getSuccessOrNull<T>(Future<T?> Function() future) async {
    try {
      return await future();
    } catch (_) {
      return null;
    }
  }
}
