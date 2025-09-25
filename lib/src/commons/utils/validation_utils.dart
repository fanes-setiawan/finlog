import 'package:finlog/src/commons/extensions/translate_extension.dart';
class ValidationUtils {
  // validateNotEmpty
  static String? validateNotEmpty(String? value) {
    if (value == null) {
      return 'mustFilled'.trLabel();
    } else if (value.isEmpty) {
      return 'mustFilled'.trLabel();
    }
    return null;
  }

  // validateEmail
  static String? validateEmail(String value) {
    final RegExp emailRegExp = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegExp.hasMatch(value)) {
      return 'emailNotValid'.trLabel();
    }
    return null;
  }

  // validatePhoneNumber
  static String? validatePhoneNumber(String value) {
    final RegExp phoneNumberRegExp = RegExp(
      r'^\+?[\d-]+(?:[\s-][\d-]+)*$',
    );

    if (!phoneNumberRegExp.hasMatch(value)) {
      return 'phoneNotValid'.trLabel();
    }
    return null;
  }

  // validatePasswordConfirmation
  static String? validatePasswordConfirmation(String password, String passwordConfirmation) {
    if (password != passwordConfirmation) {
      return 'passwordConfirmationMustSave'.trLabel();
    }
    return null;
  }
}
