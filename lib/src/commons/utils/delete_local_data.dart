import 'package:finlog/src/commons/clients/local/local_client.dart';
import 'package:finlog/src/injection/injection.dart';

dynamic deleteLocalData(String key) {
  return getIt.get<LocalClient>().delete(key);
}
