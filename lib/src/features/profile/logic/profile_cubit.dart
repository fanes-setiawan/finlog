import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finlog/src/features/core/logic/data_seeder.dart';
import 'package:finlog/src/features/core/model/core_models.dart';
import 'package:finlog/src/features/core/repository/firestore_repository.dart';
import 'package:injectable/injectable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileSuccess extends ProfileState {
  final String message;
  const ProfileSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
  @override
  List<Object?> get props => [message];
}

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final FirestoreRepository _repository;

  ProfileCubit(this._repository) : super(const ProfileInitial());

  Future<void> resetData(String userId) async {
    try {
      emit(const ProfileLoading());

      // 1. Delete Transactions
      final transactions = await _repository.getCollection<TransactionModel>(
        collectionPath: 'transactions',
        fromJson: (data, id) => TransactionModel.fromJson(data),
        queryBuilder: (q) => q.where('userId', isEqualTo: userId),
      );
      for (var item in transactions) {
        await _repository.delete(
            collectionPath: 'transactions', docId: item.id);
      }

      // 2. Delete Wallets
      final wallets = await _repository.getCollection<WalletModel>(
        collectionPath: 'wallets',
        fromJson: (data, id) => WalletModel.fromJson(data),
        queryBuilder: (q) => q.where('userId', isEqualTo: userId),
      );
      for (var item in wallets) {
        await _repository.delete(collectionPath: 'wallets', docId: item.id);
      }

      // 3. Delete Categories
      final categories = await _repository.getCollection<CategoryModel>(
        collectionPath: 'categories',
        fromJson: (data, id) => CategoryModel.fromJson(data),
        queryBuilder: (q) => q.where('userId', isEqualTo: userId),
      );
      for (var item in categories) {
        await _repository.delete(collectionPath: 'categories', docId: item.id);
      }

      // 4. Delete Budgets
      final budgets = await _repository.getCollection<BudgetModel>(
        collectionPath: 'budgets',
        fromJson: (data, id) => BudgetModel.fromJson(data),
        queryBuilder: (q) => q.where('userId', isEqualTo: userId),
      );
      for (var item in budgets) {
        await _repository.delete(collectionPath: 'budgets', docId: item.id);
      }

      // 5. Re-seed Data (Optional, but user asked for reset start over)
      // We can let the auto-seeder do it on next load, or do it here.
      // Doing it here provides immediate feedback.
      await DataSeeder.defaultWallets(userId).forEachAsync((wallet) async {
        await _repository.set(
          collectionPath: 'wallets',
          id: wallet.id,
          item: wallet,
          toJson: (w) => w.toJson(),
        );
      });

      await DataSeeder.defaultCategories(userId).forEachAsync((category) async {
        await _repository.set(
          collectionPath: 'categories',
          id: category.id,
          item: category,
          toJson: (c) => c.toJson(),
        );
      });

      emit(const ProfileSuccess("Data berhasil direset!"));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}

extension IterableExtension<T> on Iterable<T> {
  Future<void> forEachAsync(Future<void> Function(T element) action) async {
    for (final element in this) {
      await action(element);
    }
  }
}
