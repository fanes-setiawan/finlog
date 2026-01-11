import 'package:bloc/bloc.dart';
import 'package:finlog/src/features/core/model/core_models.dart';
import 'package:finlog/src/features/core/repository/firestore_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'transaction_cubit.freezed.dart';

@freezed
class TransactionState with _$TransactionState {
  const factory TransactionState.initial() = _Initial;
  const factory TransactionState.loading() = _Loading;
  const factory TransactionState.success(List<TransactionModel> transactions) =
      _Success;
  const factory TransactionState.error(String message) = _Error;
}

@injectable
class TransactionCubit extends Cubit<TransactionState> {
  final FirestoreRepository _repository;

  TransactionCubit(this._repository) : super(const TransactionState.initial());

  Future<void> loadTransactions(String userId, {DateTime? month}) async {
    try {
      emit(const TransactionState.loading());

      // We are using client-side filtering for month for simplicity with the stream helper
      _repository
          .streamCollection<TransactionModel>(
        collectionPath: 'transactions',
        fromJson: (data, id) =>
            TransactionModel.fromJson(data).copyWith(id: id),
        queryBuilder: (query) => query
            .where('userId', isEqualTo: userId)
            .orderBy('date', descending: true),
      )
          .listen((transactions) {
        var filtered = transactions;
        if (month != null) {
          filtered = transactions
              .where((t) =>
                  t.date != null &&
                  t.date!.year == month.year &&
                  t.date!.month == month.month)
              .toList();
        }
        emit(TransactionState.success(filtered));
      }, onError: (e) {
        emit(TransactionState.error(e.toString()));
      });
    } catch (e) {
      emit(TransactionState.error(e.toString()));
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      // 1. Add Transaction
      await _repository.add<TransactionModel>(
        collectionPath: 'transactions',
        item: transaction,
        toJson: (model) => model.toJson(),
      );

      // 2. Fetch Wallet
      final wallet = await _repository.getDocument<WalletModel>(
        collectionPath: 'wallets',
        docId: transaction.walletId,
        fromJson: (data, id) => WalletModel.fromJson(data).copyWith(id: id),
      );

      // 3. Update Balance
      if (wallet != null) {
        double newBalance = wallet.balance;
        if (transaction.type == 'income') {
          newBalance += transaction.amount;
        } else {
          newBalance -= transaction.amount;
        }

        await _repository.update(
          collectionPath: 'wallets',
          docId: wallet.id,
          data: {'balance': newBalance},
        );
      }
    } catch (e) {
      emit(TransactionState.error(e.toString()));
    }
  }

  Future<void> updateTransaction(
      TransactionModel oldTx, TransactionModel newTx) async {
    try {
      // 1. Revert Old Transaction Effect
      final oldWallet = await _repository.getDocument<WalletModel>(
        collectionPath: 'wallets',
        docId: oldTx.walletId,
        fromJson: (data, id) => WalletModel.fromJson(data).copyWith(id: id),
      );

      if (oldWallet != null) {
        double revertedBalance = oldWallet.balance;
        if (oldTx.type == 'income') {
          revertedBalance -= oldTx.amount;
        } else {
          revertedBalance += oldTx.amount;
        }

        await _repository.update(
          collectionPath: 'wallets',
          docId: oldWallet.id,
          data: {'balance': revertedBalance},
        );
      }

      // 2. Apply New Transaction Effect
      // Fetch fresh wallet data (in case it's the same wallet, we need the reverted balance if updated,
      // but simpler to fetch again or just calculate carefully.
      // Safest is to fetch the target wallet for newTx separately.)

      final newWallet = await _repository.getDocument<WalletModel>(
        collectionPath: 'wallets',
        docId: newTx.walletId,
        fromJson: (data, id) => WalletModel.fromJson(data).copyWith(id: id),
      );

      if (newWallet != null) {
        double newBalance = newWallet.balance;

        // If same wallet, we must use the already reverted state?
        // Actually, if oldWallet.id == newWallet.id, the Firestore update above might happen 'before' this read
        // if we await properly. Firestore creates consistency.
        // HOWEVER, to be safe and avoid race conditions or reading stale data if the previous update hasn't propagated
        // to the read stream/cache instantly, we should chain logic carefully.
        // But given basic await implementation:
        // The revertedBalance update is awaited. So the next getDocument SHOULD see it.

        if (newTx.type == 'income') {
          newBalance += newTx.amount;
        } else {
          newBalance -= newTx.amount;
        }

        await _repository.update(
          collectionPath: 'wallets',
          docId: newWallet.id,
          data: {'balance': newBalance},
        );
      }

      // 3. Update Transaction Document
      await _repository.update(
        collectionPath: 'transactions',
        docId: newTx.id,
        data: newTx.toJson(),
      );
    } catch (e) {
      emit(TransactionState.error(e.toString()));
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      // 1. Fetch Transaction to be deleted
      final transaction = await _repository.getDocument<TransactionModel>(
        collectionPath: 'transactions',
        docId: id,
        fromJson: (data, id) =>
            TransactionModel.fromJson(data).copyWith(id: id),
      );

      if (transaction != null) {
        // 2. Fetch Wallet
        final wallet = await _repository.getDocument<WalletModel>(
          collectionPath: 'wallets',
          docId: transaction.walletId,
          fromJson: (data, id) => WalletModel.fromJson(data).copyWith(id: id),
        );

        // 3. Revert Balance
        if (wallet != null) {
          double newBalance = wallet.balance;
          // Revert logic is opposite of add
          if (transaction.type == 'income') {
            newBalance -= transaction.amount;
          } else {
            newBalance += transaction.amount;
          }

          await _repository.update(
            collectionPath: 'wallets',
            docId: wallet.id,
            data: {'balance': newBalance},
          );
        }
      }

      // 4. Delete Transaction
      await _repository.delete(collectionPath: 'transactions', docId: id);
    } catch (e) {
      emit(TransactionState.error(e.toString()));
    }
  }
}
