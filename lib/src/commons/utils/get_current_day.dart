import 'package:easy_localization/easy_localization.dart';
import 'package:finlog/src/features/app_config/app_config_cubit.dart';
import 'package:finlog/src/injection/injection.dart';

String getCurrentDay() {
  final config = getIt.get<AppConfigCubit>().latestConfig!;

  // Format to dd/mm/yyyy
  final DateFormat formatter = DateFormat(
    'EEEE',
    "${config.locale.languageCode}_${config.locale.countryCode}",
  );
  var now = DateTime.now();
  String formatted = formatter.format(now);
  return formatted;
}
