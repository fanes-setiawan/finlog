import 'package:bloc/bloc.dart';
import 'package:finlog/src/features/core/logic/data_seeder.dart';
import 'package:finlog/src/features/core/model/core_models.dart';
import 'package:finlog/src/features/core/repository/firestore_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'wallet_cubit.freezed.dart';

@freezed
class WalletState with _$WalletState {
  const factory WalletState.initial() = _Initial;
  const factory WalletState.loading() = _Loading;
  const factory WalletState.success(List<WalletModel> wallets) = _Success;
  const factory WalletState.error(String message) = _Error;
}

@injectable
class WalletCubit extends Cubit<WalletState> {
  final FirestoreRepository _repository;

  WalletCubit(this._repository) : super(const WalletState.initial());

  Future<void> loadWallets(String userId) async {
    try {
      emit(const WalletState.loading());
      _repository
          .streamCollection<WalletModel>(
        collectionPath: 'wallets',
        fromJson: (data, id) =>
            WalletModel.fromJson(data).copyWith(id: id), // Correct usage
        queryBuilder: (query) => query.where('userId', isEqualTo: userId),
      )
          .listen((wallets) {
        if (wallets.isEmpty) {
          // Auto-seed if empty
          seedWallets(userId);
        } else {
          emit(WalletState.success(wallets));
        }
      }, onError: (e) {
        emit(WalletState.error(e.toString()));
      });
    } catch (e) {
      emit(WalletState.error(e.toString()));
    }
  }

  Future<void> addWallet(WalletModel wallet) async {
    try {
      await _repository.add<WalletModel>(
        collectionPath: 'wallets',
        item: wallet,
        toJson: (model) => model.toJson(),
      );
    } catch (e) {
      emit(WalletState.error(e.toString()));
    }
  }

  Future<void> seedWallets(String userId) async {
    try {
      final wallets = DataSeeder.defaultWallets(userId);
      for (var wallet in wallets) {
        await _repository.set(
          collectionPath: 'wallets',
          id: wallet.id,
          item: wallet,
          toJson: (w) => w.toJson(),
        );
      }
    } catch (e) {
      emit(WalletState.error(e.toString()));
    }
  }
}
