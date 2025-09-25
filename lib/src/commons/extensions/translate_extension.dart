import 'package:easy_localization/easy_localization.dart';

extension TranslateExtension on String {
  String trLabel({String? def, List<String>? args}) => _handleTrans("label", def: def, args: args);
  String trError({String? def, List<String>? args}) => _handleTrans("error", def: def, args: args);
  String _handleTrans(String key, {String? def, List<String>? args}) {
    def = def ?? '';
    args = args ?? [''];

    if (isNotEmpty) {
      String res = '$key.$this'.tr(args: args);
      if (res.startsWith('$key.')) {
        return def.isEmpty ? this : def;
      }
      return res;
    }
    return def;
  }
}
