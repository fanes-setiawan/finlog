import 'package:bloc/bloc.dart';
import 'package:finlog/src/features/core/logic/data_seeder.dart';
import 'package:finlog/src/features/core/model/core_models.dart';
import 'package:finlog/src/features/core/repository/firestore_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'category_cubit.freezed.dart';

@freezed
class CategoryState with _$CategoryState {
  const factory CategoryState.initial() = _Initial;
  const factory CategoryState.loading() = _Loading;
  const factory CategoryState.success(List<CategoryModel> categories) =
      _Success;
  const factory CategoryState.error(String message) = _Error;
}

@injectable
class CategoryCubit extends Cubit<CategoryState> {
  final FirestoreRepository _repository;

  CategoryCubit(this._repository) : super(const CategoryState.initial());

  Future<void> loadCategories(String userId) async {
    try {
      emit(const CategoryState.loading());
      _repository
          .streamCollection<CategoryModel>(
        collectionPath: 'categories',
        fromJson: (data, id) => CategoryModel.fromJson(data).copyWith(id: id),
        queryBuilder: (query) => query.where('userId', isEqualTo: userId),
      )
          .listen((categories) {
        if (categories.isEmpty) {
          seedCategories(userId);
        } else {
          emit(CategoryState.success(categories));
        }
      }, onError: (e) {
        emit(CategoryState.error(e.toString()));
      });
    } catch (e) {
      emit(CategoryState.error(e.toString()));
    }
  }

  Future<void> addCategory(CategoryModel category) async {
    try {
      await _repository.add<CategoryModel>(
        collectionPath: 'categories',
        item: category,
        toJson: (model) => model.toJson(),
      );
    } catch (e) {
      emit(CategoryState.error(e.toString()));
    }
  }

  Future<void> seedCategories(String userId) async {
    try {
      final categories = DataSeeder.defaultCategories(userId);
      for (var cat in categories) {
        await _repository.set(
          collectionPath: 'categories',
          id: cat.id,
          item: cat,
          toJson: (c) => c.toJson(),
        );
      }
    } catch (e) {
      emit(CategoryState.error(e.toString()));
    }
  }
}
