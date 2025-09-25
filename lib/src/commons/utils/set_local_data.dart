import 'package:finlog/src/commons/clients/local/local_client.dart';
import 'package:finlog/src/injection/injection.dart';

Future<void> setLocalData(String key, dynamic value) {
  return getIt.get<LocalClient>().set(key, value);
}
