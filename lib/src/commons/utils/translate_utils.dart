import 'package:easy_localization/easy_localization.dart';

@Deprecated("use trLabel() insteat")
class Tr {
  static String label(String? label, {String? def, List<String>? args}) {
    return _handleTrans('label', label, def: def, args: args);
  }

  static String error(String? label, {String? def, List<String>? args}) {
    return _handleTrans('error', label, def: def, args: args);
  }

  static String _handleTrans(String key, String? label, {String? def, List<String>? args}) {
    label = label ?? '';
    def = def ?? '';
    args = args ?? [''];

    if (label.isNotEmpty) {
      String res = '$key.$label'.tr(args: args);
      if (res.startsWith('$key.')) {
        return def.isEmpty ? label : def;
      }
      return res;
    }
    return def;
  }
}
