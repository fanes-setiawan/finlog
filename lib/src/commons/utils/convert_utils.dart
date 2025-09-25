// converter
// - countryCodeToFlagEmoji
// - errorCodeToCamelCase
// - convertToCurrency
import 'package:easy_localization/easy_localization.dart';
import 'package:finlog/src/commons/extensions/app_string_extension.dart';
import 'package:finlog/src/features/app_config/app_config_cubit.dart';
import 'package:finlog/src/features/app_config/models/app_config.dart';
import 'package:finlog/src/injection/injection.dart';
import 'package:flutter/foundation.dart';

class ConverterUtils {
  // countryCodeToFlagEmoji
  static String countryCodeToFlagEmoji(String countryCode) {
    final codePoints = countryCode.toUpperCase().split('').map((e) => 127397 + e.codeUnitAt(0));

    return String.fromCharCodes(codePoints);
  }

  // errorCodeToCamelCase
  static String errorCodeToCamelCase(String errorCode) {
    List<String> words = errorCode.split('.');
    String camelCase = words.first;

    for (int i = 1; i < words.length; i++) {
      String word = words[i];
      camelCase += word[0].toUpperCase() + word.substring(1);
    }

    return camelCase;
  }

  // convertToNum
  static String convertToNum(
    String stringNumber, {
    bool forDisplay = true,
  }) {
    final configApp = getIt.get<AppConfigCubit>().latestConfig!;
    bool isId = configApp.locale.languageCode == 'id';
    final maxDigit = configApp.maxDigitQty;
    RegExp comaAtEnd = isId ? RegExp(r',\d{0,' '$maxDigit' '' r'}$') : RegExp(r'\.\d{0,' '$maxDigit' '' r'}$');
    if (forDisplay && !isId) {
      stringNumber = stringNumber.removeTrailingZerosAndCommas();
    }
    if (comaAtEnd.hasMatch(stringNumber) && !forDisplay) {
      List<String> numSplit = stringNumber.split(isId ? ',' : '.');
      int num = int.parse(numSplit[0].replaceAll(isId ? '.' : ',', ''));
      return '${numSplit[0].startsWith('-') ? '-' : ''}${_removeTrailingZerosAndCommas(_getPattern(configApp, maxDigit).format(num)).replaceAll('-', '')}${isId ? ',' : '.'}${numSplit[1]}';
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

      final numFormat = _getPattern(configApp, maxDigit);

      if (forDisplay) {
        return _removeTrailingZerosAndCommas(numFormat.format(number));
      }
      return number is double ? numFormat.format(number) : _removeTrailingZerosAndCommas(numFormat.format(number));
    } catch (e) {
      return stringNumber;
    }
  }

  static String removeZeroAfterComa(String v) {
    return _removeTrailingZerosAndCommas(v.replaceAll('.', ','));
  }
}

NumberFormat _getPattern(AppConfig configApp, int maxDigit) {
  String len = '0' * maxDigit;
  String pattern = '#,##0${len.isEmpty ? '' : '.$len'}';

  if (kIsWeb) {
    pattern = '#,##0';
  }

  return NumberFormat(pattern, configApp.locale.toString());
}

String _removeTrailingZerosAndCommas(String input) {
  final configApp = getIt.get<AppConfigCubit>().latestConfig!;
  bool isId = configApp.locale.languageCode == 'id';
  final result = input.replaceAllMapped(
      isId ? RegExp(r'(\d+,\d*[1-9]+)0+|(\d+),0+$') : RegExp(r'(\d+\.\d*[1-9])0+|(\d+)\.0+$'), (match) {
    return match.group(1) ?? match.group(2) ?? '';
  });

  return result;
}