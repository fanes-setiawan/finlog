import "package:easy_localization/easy_localization.dart";
import "package:finlog/src/commons/extensions/translate_extension.dart";
import "package:finlog/src/commons/utils/type_utils.dart";
import "package:finlog/src/features/app_config/app_config_cubit.dart";
import "package:finlog/src/injection/injection.dart";

/// utils:
/// - getCurrentEpoch
class AppDateUtils {
  AppDateUtils._();

  // getCurrentEpoch
  static int getCurrentEpoch() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static String timeSince(dynamic dateFrom) {
    dateFrom = _handleInput(dateFrom);
    if (TypeUtils.isEmpty(dateFrom)) return '';

    Duration difference = DateTime.now().difference(dateFrom);
    int seconds = difference.inSeconds;

    double interval = seconds / 31536000;

    if (interval > 1) {
      return '${interval.floor()} ${'yearsAgo'.trLabel()}';
    }
    interval = seconds / 2592000;
    if (interval > 1) {
      return '${interval.floor()} ${'monthsAgo'.trLabel()}';
    }
    interval = seconds / 86400;
    if (interval > 1) {
      return '${interval.floor()} ${'daysAgo'.trLabel()}';
    }
    interval = seconds / 3600;
    if (interval > 1) {
      return '${interval.floor()} ${'hoursAgo'.trLabel()}';
    }
    interval = seconds / 60;
    if (interval > 1) {
      return '${interval.floor()} ${'minutesAgo'.trLabel()}';
    }
    return '${seconds < 0 ? 0 : seconds} ${'secondsAgo'.trLabel()}';
  }

  static DateTime strToYm(String date) {
    if (TypeUtils.isEmpty(date)) return DateTime.now();
    int year = int.parse(date.substring(0, 4));
    int month = int.parse(date.substring(4, 6));
    return DateTime(year, month);
  }

  static DateTime strToDate(String date) {
    if (TypeUtils.isEmpty(date)) return DateTime.now();
    int year = int.parse(date.substring(0, 4));
    int month = int.parse(date.substring(4, 6));
    int day = int.parse(date.substring(6, 8));
    return DateTime(year, month, day);
  }

  static DateTime strToDateTime(String date) {
    if (TypeUtils.isEmpty(date)) return DateTime.now();
    int year = int.parse(date.substring(0, 4));
    int month = int.parse(date.substring(4, 6));
    int day = int.parse(date.substring(6, 8));
    int hour = int.parse(date.substring(8, 10));
    int min = int.parse(date.substring(10, 12));
    int sec = int.parse(date.substring(12, 14));
    return DateTime(year, month, day, hour, min, sec);
  }

  static String displayDate({dynamic date, String format = 'DD-MMM-YYYY HH:mm:ss'}) {
    if (TypeUtils.isEmpty(date)) return '';
    DateTime currDate = _handleInput(date);
    return DateFormat(format, getIt.get<AppConfigCubit>().state.data!.locale.languageCode).format(currDate);
  }

  static DateTime _handleInput(dynamic input) {
    input = input ?? DateTime.now();
    if (input is! DateTime && input is! String) {
      return input;
    }

    if (input is String && input.length == 8) {
      input = strToDate(input);
    }

    if (input is String && input.length == 14) {
      input = strToDateTime(input);
    }

    return input;
  }
}

extension ExtDateFormat on DateTime {
  String toDateString({String? tmp}) {
    return DateFormat(tmp ?? "dd MMMM yyyy", getIt.get<AppConfigCubit>().state.data!.locale.languageCode).format(this);
  }

  String toDDMMYYYY({String? tmp}) {
    return DateFormat(tmp ?? "dd MM yyyy", getIt.get<AppConfigCubit>().state.data!.locale.languageCode).format(this);
  }

  String toDateReq() {
    return DateFormat("yyyyMMdd", "id").format(this);
  }

  String toDateTimeReq() {
    return DateFormat("yyyyMMddHHmmss", "id").format(this);
  }

  String toYearMonth() {
    return DateFormat("yyyyMM", "id").format(this);
  }
}
