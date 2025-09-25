// ignore_for_file: prefer_interpolation_to_compose_strings
import 'package:finlog/src/commons/extensions/app_string_extension.dart';
import 'package:finlog/src/commons/extensions/translate_extension.dart';
import 'package:finlog/src/commons/utils/type_utils.dart';
import 'package:finlog/src/features/app_config/app_config_cubit.dart';
import 'package:finlog/src/injection/injection.dart';
import 'package:flutter/services.dart';

/// - InputFormatterDouble
class FormatterUtils {
  FormatterUtils._();

  static TextInputFormatter inputFormatterDouble(String text) {
    return DoubleInputFormatter();
  }

  static TextInputFormatter currencyTextInputFormatter() {
    return CurrencyTextInputFormatter();
  }

  static TextInputFormatter qtyTextInputFormatter() {
    return QtyTextInputFormatter();
  }

  static TextInputFormatter upperCaseInput() {
    return UpperCaseTextFormatter();
  }

  static TextInputFormatter onlyNumber() {
    return OnlyNumberFormatter();
  }

  static String? valCurrencyTextInputFormatter(String? v,
      {greatherZero = false,
      greatherOrEqualZero = false,
      required = false,
      double? greatherOrEqualCustom,
      double? greatherCustom}) {
    final configApp = getIt.get<AppConfigCubit>();

    double val = 0;
    if (v == '') {
      v = '0';
    }

    if (configApp.latestConfig!.locale.languageCode == 'id') {
      val = double.parse((v ?? '0').replaceAll('.', '').replaceAll(',', '.'));
      if (v == '-' || RegExp(r',\s*$').hasMatch(v!) || (v.startsWith('-0') && v.length <= 3)) {
        return 'invalidInputValue'.trLabel();
      }
    } else {
      val = double.parse((v ?? '0').replaceAll(',', ''));
      if (v == '-' || RegExp(r'\.\s*$').hasMatch(v!) || (v.startsWith('-0') && v.length <= 3)) {
        return 'invalidInputValue'.trLabel();
      }
    }

    if (greatherCustom != null && val <= greatherCustom) {
      return 'Field ${'mustMoreThan'.trLabel(
        args: [greatherCustom.toString().toCurrency(forDisplay: true)],
      )}';
    }

    if (greatherOrEqualCustom != null && val < greatherOrEqualCustom) {
      return 'Field ${'mustGreaterThanOrEqual'.trLabel(
        args: [greatherOrEqualCustom.toString().toCurrency(forDisplay: true)],
      )}';
    }

    if (greatherZero && val <= 0) {
      return 'Field ${'mustMoreThanZero'.trLabel()}';
    }

    if (greatherOrEqualZero && val < 0) {
      return 'Field ${'mustGreaterThanOrEqualZero'.trLabel()}';
    }

    if (required && (v.isEmpty || v == '0')) {
      return 'Field ${'cannotEmptyOrZero'.trLabel()}';
    }

    return null;
  }

  static String? valQtyTextInputFormatter(String? v,
      {bool greatherZero = false,
      bool greatherOrEqualZero = false,
      bool required = false,
      double? greatherOrEqualCustom,
      double? greatherCustom,
      double? lessThanCustom,
      double? lessThanOrEqualCustom}) {
    final configApp = getIt.get<AppConfigCubit>();

    double val = 0;
    if (v == '') {
      v = '0';
    }

    if (configApp.latestConfig!.locale.languageCode == 'id') {
      val = double.parse((v ?? '0').replaceAll('.', '').replaceAll(',', '.'));
      if (v == '-' || RegExp(r',\s*$').hasMatch(v!) || (v.startsWith('-0') && v.length <= 3)) {
        return 'invalidInputValue'.trLabel();
      }
    } else {
      val = double.parse((v ?? '0').replaceAll(',', ''));
      if (v == '-' || RegExp(r'\.\s*$').hasMatch(v!) || (v.startsWith('-0') && v.length <= 3)) {
        return 'invalidInputValue'.trLabel();
      }
    }

    if (greatherCustom != null && val <= greatherCustom) {
      return 'Field ${'mustMoreThan'.trLabel(
        args: [greatherCustom.toString().toNum(forDisplay: true)],
      )}';
    }

    if (greatherOrEqualCustom != null && val < greatherOrEqualCustom) {
      return 'Field ${'mustGreaterThanOrEqual'.trLabel(
        args: [greatherOrEqualCustom.toString().toNum(forDisplay: true)],
      )}';
    }

    if (lessThanCustom != null && val >= lessThanCustom) {
      return 'Field ${'mustLessThan'.trLabel(
        args: [lessThanCustom.toString().toNum(forDisplay: true)],
      )}';
    }

    if (lessThanOrEqualCustom != null && val > lessThanOrEqualCustom) {
      return 'Field ${'mustLessThanOrEqual'.trLabel(args: [
            lessThanOrEqualCustom.toString().toNum(forDisplay: true),
          ])}';
    }

    if (greatherZero && val <= 0) {
      return 'Field ${'mustMoreThanZero'.trLabel()}';
    }

    if (greatherOrEqualZero && val < 0) {
      return 'Field ${'mustGreaterThanOrEqualZero'.trLabel()}';
    }

    if (required && (v.isEmpty || v == '0')) {
      return 'Field ${'cannotEmptyOrZero'.trLabel()}';
    }

    return null;
  }
}

class OnlyNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final valid = RegExp(r'[0-9]').hasMatch(newValue.text);

    if (valid || newValue.text.isEmpty) {
      if (newValue.text.startsWith('0') && newValue.text.length > 1) {
        final input = newValue.text.replaceAll(RegExp(r'^0+'), '');
        return newValue.copyWith(
            selection: TextSelection.collapsed(offset: input.length, affinity: TextAffinity.downstream), text: input);
      }
      return newValue;
    }

    return oldValue;
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class DoubleInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final validDouble = RegExp(r'^\d*\.?\d{0,2}$').hasMatch(newValue.text);

    // If it's a valid double or an empty string, allow the input.
    if (validDouble || newValue.text.isEmpty) {
      return newValue;
    }

    // Otherwise, return the oldValue to reject the invalid input.
    return oldValue;
  }
}

class CurrencyTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.trim().isEmpty) {
      return newValue.copyWith(
        text: '0',
        selection: const TextSelection.collapsed(offset: 1, affinity: TextAffinity.downstream),
      );
    }

    final configApp = getIt.get<AppConfigCubit>();
    final maxDigit = configApp.latestConfig!.maxDigitCurr;
    bool isId = configApp.latestConfig!.locale.languageCode == 'id';

    // Validasi input pattern yang lebih sederhana
    final validInputPattern = isId ? r'^[0-9\-,\.]*$' : r'^[0-9\-\.,]*$';
    if (!RegExp(validInputPattern).hasMatch(newValue.text)) {
      return oldValue;
    }

    String input = newValue.text;

    // Handle decimal separator conversion
    if (newValue.text.isNotEmpty && newValue.text.substring(newValue.text.length - 1) == (isId ? '.' : ',')) {
      input = newValue.text.substring(0, newValue.text.length - 1) + (isId ? ',' : '.');
    }

    // Handle leading zeros
    if (input.startsWith('0') && input.length > 1 && !input.contains(isId ? ',' : '.')) {
      // Remove leading zeros for whole numbers
      input = input.replaceFirst(RegExp(r'^0+'), '');
      if (input.isEmpty) input = '0';

      return newValue.copyWith(
          selection: TextSelection.collapsed(offset: input.length, affinity: TextAffinity.downstream), text: input);
    }

    // Handle negative sign only
    if (input == '-') {
      return newValue.copyWith(text: '-');
    }

    // Handle empty input
    if (input.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Format number with thousand separators
    String formattedInput = _formatCurrency(input, isId, maxDigit);

    // Validate the formatted input
    if (_isValidCurrencyInput(formattedInput, isId, maxDigit)) {
      return newValue.copyWith(
          selection: TextSelection.collapsed(offset: formattedInput.length, affinity: TextAffinity.downstream),
          text: formattedInput);
    } else {
      return oldValue;
    }
  }

  String _formatCurrency(String input, bool isId, int maxDigit) {
    if (input.isEmpty || input == '-') return input;

    bool isNegative = input.startsWith('-');
    if (isNegative) {
      input = input.substring(1);
    }

    String wholePart = '';
    String decimalPart = '';

    // Split whole and decimal parts
    if (isId) {
      List<String> parts = input.split(',');
      wholePart = parts[0];
      if (parts.length > 1) {
        decimalPart = parts[1];
        // Limit decimal places
        if (maxDigit > 0 && decimalPart.length > maxDigit) {
          decimalPart = decimalPart.substring(0, maxDigit);
        }
      }
    } else {
      List<String> parts = input.split('.');
      wholePart = parts[0];
      if (parts.length > 1) {
        decimalPart = parts[1];
        // Limit decimal places
        if (maxDigit > 0 && decimalPart.length > maxDigit) {
          decimalPart = decimalPart.substring(0, maxDigit);
        }
      }
    }

    // Remove existing thousand separators from whole part
    if (isId) {
      wholePart = wholePart.replaceAll('.', '');
    } else {
      wholePart = wholePart.replaceAll(',', '');
    }

    // Add thousand separators
    String formattedWhole = _addThousandSeparators(wholePart, isId);

    // Combine whole and decimal parts
    String result = formattedWhole;
    if (decimalPart.isNotEmpty) {
      result += isId ? ',$decimalPart' : '.$decimalPart';
    } else if (input.endsWith(isId ? ',' : '.')) {
      result += isId ? ',' : '.';
    }

    return isNegative ? '-$result' : result;
  }

  String _addThousandSeparators(String number, bool isId) {
    if (number.length <= 3) return number;

    String separator = isId ? '.' : ',';
    String result = '';
    int count = 0;

    for (int i = number.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        result = separator + result;
      }
      result = number[i] + result;
      count++;
    }

    return result;
  }

  bool _isValidCurrencyInput(String input, bool isId, int maxDigit) {
    if (input.isEmpty || input == '-') return true;

    // Basic validation
    if (input == '.' || input == ',' || input == '-.' || input == '-,') return false;

    // Check for valid number format
    try {
      String testValue = input;

      // Remove thousand separators and convert decimal separator
      if (isId) {
        testValue = testValue.replaceAll('.', '').replaceAll(',', '.');
      } else {
        testValue = testValue.replaceAll(',', '');
      }

      // Try to parse as double
      double.parse(testValue);

      // Check decimal places
      if (maxDigit > 0) {
        String decimalSeparator = isId ? ',' : '.';
        if (input.contains(decimalSeparator)) {
          String decimalPart = input.split(decimalSeparator).last;
          if (decimalPart.length > maxDigit) return false;
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}

class QtyTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    RegExp regExp = RegExp('.*');
    final configApp = getIt.get<AppConfigCubit>();
    final maxDigit = configApp.latestConfig!.maxDigitQty;
    bool isId = configApp.latestConfig!.locale.languageCode == 'id';
    if (newValue.text.isNotEmpty && newValue.text.substring(newValue.text.length - 1) == (isId ? '.' : ',')) {
      newValue = TextEditingValue(
        text: newValue.text.substring(0, newValue.text.length - 1) + (isId ? ',' : '.'),
        selection: TextSelection.collapsed(offset: newValue.text.length),
      );
    }
    String input = newValue.text;

    if (isId) {
      if (maxDigit > 0) {
        regExp = RegExp(
          r'^\$?\-?([1-9]\d{0,2}(\.\d{1,3})*(\,\d{0,'
          '$maxDigit'
          ''
          r'}})?|[1-9]\d{0,}(\,\d{0,'
          '$maxDigit'
          ''
          r'}})?|0(\.\d{1,3})?|0(\,\d{0,'
          '$maxDigit'
          ''
          r'}})?|(\,\d{1,'
          '$maxDigit'
          ''
          r'}}))$'
          r'|^\-?\$?([1-9]\d{0,2}(\.\d{1,3})*(\,\d{0,'
          '$maxDigit'
          ''
          r'}})?|[1-9]\d{0,}(\,\d{0,'
          '$maxDigit'
          ''
          r'}})?|0(\.\d{1,3})?|0(\,\d{0,'
          '$maxDigit'
          ''
          r'}})?|(\,\d{1,'
          '$maxDigit'
          ''
          r'}}))$'
          r'|^\(\$?([1-9]\d{0,2}(\.\d{1,3})*(\,\d{0,'
          '$maxDigit'
          ''
          r'}})?|[1-9]\d{0,}(\,\d{0,'
          '$maxDigit'
          ''
          r'}})?|0(\.\d{1,3})?|0(\,\d{0,'
          '$maxDigit'
          ''
          r'}})?|(\,\d{1,'
          '$maxDigit'
          ''
          r'}}))\)$',
        );
      } else {
        regExp = RegExp(r'^(\$?-?(\d{1,3}(,\d{3})*|\d+)(\.0)?)$');
      }

      RegExp dotAtEnd = RegExp(r'\.$');
      RegExp comaAtEnd = RegExp(r',\d{0,' '$maxDigit' '' r'}$');

      if (comaAtEnd.hasMatch(newValue.text) &&
          TypeUtils.countCharacter(newValue.text, ',') == 1 &&
          !newValue.text.contains('-,') &&
          maxDigit > 0) {
        return newValue.text.startsWith(',')
            ? newValue.copyWith(
                selection: TextSelection.collapsed(offset: newValue.text.length + 1, affinity: TextAffinity.downstream),
                text: '0${newValue.text}')
            : newValue;
      }

      input = dotAtEnd.hasMatch(newValue.text) ? newValue.text.replaceAll('.', ',') : newValue.text.replaceAll('.', '');
      input = input.replaceAll(RegExp(r',+$'), ',');
    } else {
      if (maxDigit > 0) {
        regExp = RegExp(
          r'^(\$?\-?([1-9]\d{0,2}(\,\d{1,3})*(\.\d{0,'
          '$maxDigit'
          ''
          r'})?|[1-9]\d{0,}(\.\d{0,'
          '$maxDigit'
          ''
          r'}})?|0(\,\d{1,3})?|0(\.\d{0,'
          '$maxDigit'
          ''
          r'}})?|(\.\d{1,'
          '$maxDigit'
          ''
          r'}}))'
          r'|^\-\$?([1-9]\d{0,2}(\,\d{1,3})*(\.\d{0,'
          '$maxDigit'
          ''
          r'}})?|[1-9]\d{0,}(\.\d{0,'
          '$maxDigit'
          ''
          r'}})?|0(\,\d{1,3})?|0(\.\d{0,'
          '$maxDigit'
          ''
          r'}})?|(\.\d{1,'
          '$maxDigit'
          ''
          r'}}))'
          r'|^\(\$?([1-9]\d{0,2}(\,\d{1,3})*(\.\d{0,'
          '$maxDigit'
          ''
          r'}})?|[1-9]\d{0,}(\.\d{0,'
          '$maxDigit'
          ''
          r'}})?|0(\,\d{1,3})?|0(\.\d{0,'
          '$maxDigit'
          ''
          r'}})?|(\.\d{1,'
          '$maxDigit'
          ''
          r'}}))\))$',
        );
      } else {
        regExp = RegExp(r'^(\$?-?(\d{1,3}(\.\d{3})*|\d+)(,0)?)$');
      }

      RegExp comaAtEnd = RegExp(r'\,$');
      RegExp dotAtEnd = RegExp(r'\.\d{0,' '$maxDigit' '' r'}$');

      if (dotAtEnd.hasMatch(newValue.text) &&
          TypeUtils.countCharacter(newValue.text, '.') == 1 &&
          !newValue.text.contains('-.') &&
          maxDigit > 0) {
        return newValue.text.startsWith('.')
            ? newValue.copyWith(
                selection: TextSelection.collapsed(offset: newValue.text.length + 1, affinity: TextAffinity.downstream),
                text: '0${newValue.text}')
            : newValue;
      }

      input =
          comaAtEnd.hasMatch(newValue.text) ? newValue.text.replaceAll(',', '.') : newValue.text.replaceAll(',', '');
      input = input.replaceAll(RegExp(r'\.+$'), '.');
    }

    if (input.startsWith('0') && input.length > 1) {
      String newInput = input.substring(1, input.length > maxDigit ? maxDigit + 2 : input.length);
      if (isId) {
        newInput = newInput.replaceAll(RegExp(r',+$'), '');
        if (newInput.startsWith(',')) {
          newInput = newInput.padLeft(newInput.length + 1, '0');
        }
      } else {
        newInput = newInput.replaceAll(RegExp(r'\.+$'), '');
        if (newInput.startsWith('.')) {
          newInput = newInput.padLeft(newInput.length + 1, '0');
        }
      }
      return newValue.copyWith(
          selection: TextSelection.collapsed(offset: newInput.length, affinity: TextAffinity.downstream),
          text: newInput);
    }

    if (input == '-') {
      return newValue.copyWith(text: '-');
    }
    if (input.isEmpty) {
      return newValue.copyWith(text: '');
    }

    if (regExp.hasMatch(input)) {
      if (RegExp(r'-\b0([0-9]|[1-9][0-9])\b').hasMatch(input)) {
        input = input.replaceAll('-0', '-');
      }
      return newValue.copyWith(text: input);
    } else {
      return oldValue;
    }
  }
}
