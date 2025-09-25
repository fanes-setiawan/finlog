import 'package:finlog/src/commons/constants/errors/app_error.dart';

enum ResultStatus { initial, success, error, loading }

class AppResult<T> {
  final T? data;
  final ResultStatus status;
  final AppError? error;

  AppResult({this.data, this.error, required this.status});

  factory AppResult.initial() {
    return AppResult(status: ResultStatus.initial);
  }

  factory AppResult.loading() {
    return AppResult(status: ResultStatus.loading);
  }
  factory AppResult.error(AppError error) {
    return AppResult(status: ResultStatus.error, error: error);
  }

  factory AppResult.success(T data) {
    return AppResult(status: ResultStatus.success, data: data);
  }

  bool get isInitial => status == ResultStatus.initial;
  bool get isLoading => status == ResultStatus.loading;
  bool get isError => status == ResultStatus.error;
  bool get isSuccess => status == ResultStatus.success;

  AppResult get newInstance => AppResult(status: status, data: data, error: error);

  AppResult copyWith({ResultStatus? status, T? data, AppError? error}) {
    return AppResult(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}
