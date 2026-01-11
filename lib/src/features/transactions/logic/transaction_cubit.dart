import 'package:bloc/bloc.dart';
import 'package:finlog/src/features/core/model/core_models.dart';
import 'package:finlog/src/features/core/repository/firestore_repository.dart';
import 'package:finlog/src/features/core/services/notification_service.dart';
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
  final NotificationService _notificationService;

  TransactionCubit(this._repository, this._notificationService)
      : super(const TransactionState.initial());

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
      print("DEBUG: Adding transaction... Check Budget Triggering...");
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

      // 4. Check Budget Thresholds (Only for Expenses)
      if (transaction.type == 'expense') {
        _checkBudgetThresholds(transaction);
      }
    } catch (e) {
      emit(TransactionState.error(e.toString()));
    }
  }

  Future<void> _checkBudgetThresholds(TransactionModel transaction) async {
    try {
      if (transaction.date == null) return;

      final targetDate = transaction.date!;
      final period =
          "${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}";
      print(
          "DEBUG: Checking budgets for period $period, category: ${transaction.categoryId}");

      // Get Budget for this category
      final budgets = await _repository.getCollection<BudgetModel>(
        collectionPath: 'budgets',
        fromJson: (data, id) => BudgetModel.fromJson(data).copyWith(id: id),
        queryBuilder: (query) => query
            .where('userId', isEqualTo: transaction.userId)
            .where('categoryId', isEqualTo: transaction.categoryId)
            .where('period', isEqualTo: period),
      );

      print("DEBUG: Found ${budgets.length} budgets.");

      if (budgets.isNotEmpty) {
        final budget = budgets.first;
        if (budget.limitAmount <= 0) {
          print("DEBUG: Budget limit <= 0. Skipping.");
          return;
        }

        final startOfMonth = DateTime(targetDate.year, targetDate.month, 1);
        final endOfMonth =
            DateTime(targetDate.year, targetDate.month + 1, 0, 23, 59, 59);

        final transactions = await _repository.getCollection<TransactionModel>(
          collectionPath: 'transactions',
          fromJson: (data, id) =>
              TransactionModel.fromJson(data).copyWith(id: id),
          queryBuilder: (query) => query
              .where('userId', isEqualTo: transaction.userId)
              .where('categoryId', isEqualTo: transaction.categoryId)
              .where('type', isEqualTo: 'expense')
              .where('date', isGreaterThanOrEqualTo: startOfMonth)
              .where('date', isLessThanOrEqualTo: endOfMonth),
        );

        final isCurrentIncluded =
            transactions.any((t) => t.id == transaction.id);
        double totalExpense =
            transactions.fold(0.0, (sum, t) => sum + t.amount);

        if (!isCurrentIncluded) {
          print(
              "DEBUG: Current transaction not in query results yet. Adding manually: ${transaction.amount}");
          totalExpense += transaction.amount;
        }

        final percentage = totalExpense / budget.limitAmount;

        // Fetch Category Name for Notification
        final category = await _repository.getDocument<CategoryModel>(
          collectionPath: 'categories',
          docId: transaction.categoryId,
          fromJson: (data, id) => CategoryModel.fromJson(data).copyWith(id: id),
        );
        final categoryName = category?.name ?? 'Kategori';

        print(
            "DEBUG: Budget Check -> Budget: ${budget.limitAmount}, Total Expense: $totalExpense, Percentage: $percentage");

        if (percentage >= 1.0) {
          print("DEBUG: Triggering 100% Alert");
          await _notificationService.showNotification(
              id: budget.hashCode,
              title: 'Over Budget: $categoryName 🚨',
              body:
                  'Pengeluaran $categoryName sudah mencapai ${(percentage * 100).toStringAsFixed(0)}% dari budget (Rp ${budget.limitAmount})!');
        } else if (percentage >= 0.9) {
          print("DEBUG: Triggering 90% Alert");
          await _notificationService.showNotification(
              id: budget.hashCode,
              title: 'Warning Budget: $categoryName ⚠️',
              body:
                  'Pengeluaran $categoryName sudah mencapai ${(percentage * 100).toStringAsFixed(0)}% dari budget.');
        } else {
          print("DEBUG: No alert triggered (Percentage < 0.9)");
        }
      } else {
        print("DEBUG: No budget found for category.");
      }
    } catch (e) {
      // Silent error for budget check, don't block transaction flow
      print("Budget Check Error (See logs): $e");
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
      final newWallet = await _repository.getDocument<WalletModel>(
        collectionPath: 'wallets',
        docId: newTx.walletId,
        fromJson: (data, id) => WalletModel.fromJson(data).copyWith(id: id),
      );

      if (newWallet != null) {
        double newBalance = newWallet.balance;

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

      // 4. Check Budget (If expense)
      if (newTx.type == 'expense') {
        _checkBudgetThresholds(newTx);
      }
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
