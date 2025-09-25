import 'package:dio/dio.dart';
import 'package:finlog/src/commons/utils/type_utils.dart';

List<T> parseListInsideData<T>({
  required Response<dynamic> response,
  required String listKey,
  required T Function(Map<String, dynamic>) fromJson,
}) {
  if (TypeUtils.isEmpty(response.data)) {
    return [];
  }

  final List<T> result = [];
  for (final json in response.data["data"][listKey]) {
    result.add(fromJson(json));
  }
  return result;
}
