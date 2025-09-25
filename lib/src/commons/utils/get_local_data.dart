
import 'package:finlog/src/commons/clients/local/local_client.dart';
import 'package:finlog/src/injection/injection.dart';

dynamic getLocalData(String key, {dynamic defaultValue}) {
  return getIt.get<LocalClient>().get(key, defaultValue: defaultValue);
}
