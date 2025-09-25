// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:finlog/src/commons/constants/app_result.dart';
import 'package:finlog/src/commons/constants/errors/app_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension CubitExtension on Cubit {
  Future<void> process<T>(
    Future<T> Function() callback, {
    bool emitLoading = true,
    bool emitSuccess = true,
    bool emitError = true,
  }) async {
    try {
      if (emitLoading) {
        emit(AppResult.loading());
      }
      final data = await callback();
      if (emitSuccess) {
        emit(AppResult.success(data));
      }
    } catch (e) {
      debugPrint('🔥 cubit_extension:23 ~ error: $e');
      if (emitError) {
        emit(AppResult.error(AppError.fromException(e)));
      }
    }
  }

  refresh() {
    emit(state.newInstance);
  }

  setState(AppResult state) {
    emit(state);
  }
}
