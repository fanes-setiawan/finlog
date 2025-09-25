import 'package:easy_localization/easy_localization.dart';
import 'package:finlog/src/commons/utils/type_utils.dart';
import 'package:finlog/src/features/app_config/app_config_cubit.dart';
import 'package:finlog/src/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

extension AppStringExtension on String {
  String toRequestDate() {
    if (length != 14) {
      return this; // Return original if format is invalid
    }
    try {
      String year = substring(0, 4);
      String month = substring(4, 6);
      String day = substring(6, 8);
      final formattedDate = DateTime(
        int.parse(year),
        int.parse(month),
        int.parse(day),
      );
      // Format to dd/mm/yyyy
      final DateFormat formatter = DateFormat('yyyyMMdd');
      return formatter.format(formattedDate);
    } catch (e) {
      return this; // Return original on error
    }
  }

  String toDisplayTime() {
    if (length != 4) {
      return this; // Return original if format is invalid
    }
    try {
      String hours = substring(0, 2); // Extract hours (e.g., "01")
      String minutes = substring(2, 4); // Extract minutes (e.g., "15")
      return '$hours:$minutes'; // Combine with colon
    } catch (e) {
      return this; // Return original on error
    }
  }

  String toDisplayDate2({String format = 'dd MMM yyyy HH:mm:ss'}) {
    if (length != 14) {
      debugPrint('🔥 app_string_extension:45');
      return this; // Return original if format is invalid
    }
    try {
      debugPrint('🔥 app_string_extension:49');
      // Parse the string to DateTime (YYYYMMDDHHMMSS)
      String year = substring(0, 4);
      String month = substring(4, 6);
      String day = substring(6, 8);
      String hour = substring(8, 10);
      String min = substring(10, 12);
      String sec = substring(12, 14);
      final formattedDate = DateTime(
        int.parse(year),
        int.parse(month),
        int.parse(day),
        int.parse(hour),
        int.parse(min),
        int.parse(sec),
      );

      final config = getIt.get<AppConfigCubit>().latestConfig!;

      final DateFormat formatter = DateFormat(
        format,
        "${config.locale.languageCode}_${config.locale.countryCode}",
      );
      return formatter.format(formattedDate);
    } catch (e) {
      debugPrint('🔥 app_string_extension:69 ~ $e');
      return this;
    }
  }

  String toDisplayDate({bool showDay = false}) {
    if (length != 8) {
      debugPrint('🔥 app_string_extension:45');
      return this; // Return original if format is invalid
    }
    try {
      debugPrint('🔥 app_string_extension:49');
      // Parse the string to DateTime (YYYYMMDDHHMMSS)
      String year = substring(0, 4);
      String month = substring(4, 6);
      String day = substring(6, 8);
      final formattedDate = DateTime(
        int.parse(year),
        int.parse(month),
        int.parse(day),
      );

      final config = getIt.get<AppConfigCubit>().latestConfig!;

      debugPrint('cek locale : ${config.locale.toString()}');

      // Format to dd/mm/yyyy
      final DateFormat formatter = DateFormat(
        '${showDay ? 'EEEE, ' : ''}dd/MM/yyyy', // 'EEEE, dd/MM/yyyy',
        "${config.locale.languageCode}_${config.locale.countryCode}",
      );
      return formatter.format(formattedDate);
    } catch (e) {
      debugPrint('🔥 app_string_extension:69 ~ $e');
      return this; // Return original on error
    }
  }

  DateTime toDate() {
    if (TypeUtils.isEmpty(this)) return DateTime.now();
    int year = int.parse(substring(0, 4));
    int month = int.parse(substring(4, 6));
    int day = int.parse(substring(6, 8));
    return DateTime(year, month, day);
  }

  DateTime toDateTime() {
    if (TypeUtils.isEmpty(this)) return DateTime.now();
    int year = int.parse(substring(0, 4));
    int month = int.parse(substring(4, 6));
    int day = int.parse(substring(6, 8));
    int hour = int.parse(substring(8, 10));
    int min = int.parse(substring(10, 12));
    int sec = int.parse(substring(12, 14));
    return DateTime(year, month, day, hour, min, sec);
  }

  String toNum({bool forDisplay = true}) {
    String stringNumber = this;
    final configApp = getIt.get<AppConfigCubit>();
    bool isId = configApp.latestConfig!.locale.languageCode == 'id';

    debugPrint(
        '🔥 app_string_extension:33 ~ ${configApp.latestConfig!.locale}');
    debugPrint(
        '🔥 app_string_extension:34 ~ ${configApp.latestConfig!.maxDigitQty}');

    // max digit decimal place
    final maxDigit = configApp.latestConfig!.maxDigitQty;
    RegExp comaAtEnd = isId
        ? RegExp(r',\d{0,' '$maxDigit' '' r'}$')
        : RegExp(r'\.\d{0,' '$maxDigit' '' r'}$');
    if (forDisplay && !isId) {
      stringNumber = stringNumber.removeTrailingZerosAndCommas();
    }
    if (comaAtEnd.hasMatch(stringNumber) && !forDisplay) {
      List<String> numSplit = stringNumber.split(isId ? ',' : '.');
      int num = int.parse(numSplit[0].replaceAll(isId ? '.' : ',', ''));
      return '${numSplit[0].startsWith('-') ? '-' : ''}${_getPattern(configApp.latestConfig!.locale, maxDigit).format(num).replaceAll('-', '').removeTrailingZerosAndCommas()}${isId ? ',' : '.'}${numSplit[1]}';
    }
    if (stringNumber.startsWith('-0') && !forDisplay) {
      return stringNumber;
    }
    try {
      dynamic number = 0;
      stringNumber = stringNumber.replaceAll(',', '.');
      if (stringNumber.contains('.')) {
        number = double.parse(stringNumber);
      } else {
        number = int.parse(stringNumber);
      }

      final numFormat = _getPattern(configApp.latestConfig!.locale, maxDigit);

      if (forDisplay) {
        return numFormat.format(number).removeTrailingZerosAndCommas();
      }
      return number is double
          ? numFormat.format(number)
          : numFormat.format(number).removeTrailingZerosAndCommas();
    } catch (e) {
      return stringNumber;
    }
  }

  String toCurrency({
    bool showSymbol = false,
    bool forDisplay = true,
  }) {
    String stringNumber = this;

    final configApp = getIt.get<AppConfigCubit>().latestConfig!;
    bool isId = configApp.locale.languageCode == 'id';
    final maxDigit = configApp.maxDigitCurr;
    RegExp comaAtEnd = isId
        ? RegExp(r',\d{0,' '$maxDigit' '' r'}$')
        : RegExp(r'\.\d{0,' '$maxDigit' '' r'}$');
    if (forDisplay && !isId) {
      stringNumber = stringNumber.removeTrailingZerosAndCommas();
    }
    if (comaAtEnd.hasMatch(stringNumber) && !forDisplay) {
      List<String> numSplit = stringNumber.split(isId ? ',' : '.');
      int num = int.parse(numSplit[0].replaceAll(isId ? '.' : ',', ''));
      return '${numSplit[0].startsWith('-') ? '-' : ''}${(_getPattern(configApp.locale, maxDigit).format(num)).removeTrailingZerosAndCommas().replaceAll('-', '')}${isId ? ',' : '.'}${numSplit[1]}';
    }

    if (stringNumber.startsWith('-0') && !forDisplay) {
      return stringNumber;
    }

    try {
      dynamic number = 0;
      stringNumber = isId
          ? stringNumber.replaceAll(',', '.')
          : stringNumber.replaceAll(',', '');
      if (stringNumber.contains('.')) {
        number = double.parse(stringNumber);
      } else {
        number = int.parse(stringNumber);
      }

      final currencyFormat = _getPattern(configApp.locale, maxDigit);

      if (forDisplay) {
        return '${showSymbol ? '${configApp.currLocale} ' : ''}${currencyFormat.format(number).removeTrailingZerosAndCommas()}';
      }

      // return '${showSymbol ? '${configApp.currLocale} ' : ''}${number is double ? currencyFormat.format(number) : _removeTrailingZerosAndCommas(currencyFormat.format(number))}';
      return '${showSymbol ? '${configApp.currLocale} ' : ''}${number is double ? currencyFormat.format(number) : (currencyFormat.format(number)).removeTrailingZerosAndCommas()}';
    } catch (e) {
      return stringNumber;
    }
  }

  String removeTrailingZerosAndCommas() {
    final configApp = getIt.get<AppConfigCubit>().latestConfig!;
    bool isId = configApp.locale.languageCode == 'id';

    return replaceAllMapped(
      isId
          ? RegExp(r'(\d+,\d*[1-9]+)0+|(\d+),0+$')
          : RegExp(r'(\d+\.\d*[1-9])0+|(\d+)\.0+$'),
      (match) {
        return match.group(1) ?? match.group(2) ?? '';
      },
    );
  }

  NumberFormat _getPattern(Locale locale, int maxDigit) {
    String len = '0' * maxDigit;
    String pattern = '#,##0${len.isEmpty ? '' : '.$len'}';

    // if (kIsWeb) {
    //   pattern = '#,##0';
    // }

    return NumberFormat(pattern, locale.toString());
  }
}
