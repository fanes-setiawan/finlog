import 'package:bloc/bloc.dart';
import 'package:finlog/src/features/core/model/core_models.dart';
import 'package:finlog/src/features/core/repository/firestore_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class BudgetState {
  final bool isLoading;
  final List<BudgetModel> budgets;
  final String? errorMessage;

  const BudgetState({
    this.isLoading = false,
    this.budgets = const [],
    this.errorMessage,
  });

  factory BudgetState.initial() => const BudgetState();
  factory BudgetState.loading() => const BudgetState(isLoading: true);
  factory BudgetState.success(List<BudgetModel> budgets) =>
      BudgetState(budgets: budgets);
  factory BudgetState.error(String message) =>
      BudgetState(errorMessage: message);
}

@injectable
class BudgetCubit extends Cubit<BudgetState> {
  final FirestoreRepository _repository;

  BudgetCubit(this._repository) : super(BudgetState.initial());

  Future<void> loadBudgets(String userId, {DateTime? month}) async {
    try {
      emit(BudgetState.loading());

      final targetMonth = month ?? DateTime.now();
      final period =
          "${targetMonth.year}-${targetMonth.month.toString().padLeft(2, '0')}";

      _repository
          .streamCollection<BudgetModel>(
        collectionPath: 'budgets',
        fromJson: (data, id) => BudgetModel.fromJson(data).copyWith(id: id),
        queryBuilder: (query) => query
            .where('userId', isEqualTo: userId)
            .where('period', isEqualTo: period),
      )
          .listen((budgets) {
        emit(BudgetState.success(budgets));
      }, onError: (e) {
        emit(BudgetState.error(e.toString()));
      });
    } catch (e) {
      emit(BudgetState.error(e.toString()));
    }
  }

  Future<void> setBudget(BudgetModel budget) async {
    try {
      // Check if budget for this category and period already exists
      // getCollection returns List<BudgetModel>
      final existingBudgets = await _repository.getCollection<BudgetModel>(
        collectionPath: 'budgets',
        fromJson: (data, id) => BudgetModel.fromJson(data).copyWith(id: id),
        queryBuilder: (query) => query
            .where('userId', isEqualTo: budget.userId)
            .where('categoryId', isEqualTo: budget.categoryId)
            .where('period', isEqualTo: budget.period),
      );

      if (existingBudgets.isNotEmpty) {
        // Update existing
        final docId = existingBudgets.first.id;
        await _repository.update(
          collectionPath: 'budgets',
          docId: docId,
          data: {'limitAmount': budget.limitAmount},
        );
      } else {
        // Add new
        await _repository.add(
          collectionPath: 'budgets',
          item: budget,
          toJson: (model) => model.toJson(),
        );
      }
    } catch (e) {
      emit(BudgetState.error(e.toString()));
    }
  }

  Future<void> deleteBudget(String id) async {
    try {
      await _repository.delete(collectionPath: 'budgets', docId: id);
    } catch (e) {
      emit(BudgetState.error(e.toString()));
    }
  }
}
