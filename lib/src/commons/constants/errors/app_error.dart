import 'package:dio/dio.dart';
import 'package:finlog/src/commons/extensions/translate_extension.dart';
import 'package:finlog/src/commons/utils/type_utils.dart';
import 'package:flutter/material.dart';

class AppError {
  final String message;
  final List<dynamic> args;

  AppError(String message, {this.args = const []})
      : message = args is List<Map>
            ? message.replaceAll('.', ' ').toCamelize().trError()
            : message.replaceAll('.', ' ').toCamelize().trError(
                  args: _toStrings(args),
                  def: message.replaceAll('.', ' ').toCamelize(),
                );

  static List<String> _toStrings(List<dynamic> list) {
    debugPrint('🔥 app_error:19');
    return list
        .map(
          (e) => (e.toString().contains("/") || e.toString().contains(" "))
              ? e.toString()
              : e.toString().replaceAll('.', ' ').toCamelize().trError(),
        )
        .toList();
  }

  factory AppError.fromException(Object exception) {
    try {
      if (exception is DioException) {
        if ([
          DioExceptionType.sendTimeout,
          DioExceptionType.receiveTimeout,
          DioExceptionType.connectionTimeout
        ].contains(
          exception.type,
        )) {
          return AppError("connectionTimeout");
        } else if (exception.response?.statusCode == 405) {
          return AppError("methodNotAllowed", args: [
            "${exception.requestOptions.method} ${exception.requestOptions.path}",
          ]);
        } else if (exception.type == DioExceptionType.connectionError) {
          return AppError("failedToFetchApi");
        } else if (exception.response?.data["errorCode"] != null) {
          return AppError(
            exception.response?.data["errorCode"],
            args: exception.response?.data["errorArgs"] ?? [],
          );
        }
      }

      throw exception;
    } catch (e) {
      debugPrint('🔥 app_error:28 ~ kenapa masuk sini ${e.toString()}');
      // Handle generic errors by using a predefined key instead of raw exception string
      return AppError("unexpectedError", args: [e.toString()]);
    }
  }
}
