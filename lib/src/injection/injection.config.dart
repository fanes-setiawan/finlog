// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:finlog/src/commons/clients/local/local_client.dart' as _i750;
import 'package:finlog/src/features/app_config/app_config_cubit.dart' as _i36;
import 'package:finlog/src/features/core/logic/category_cubit.dart' as _i211;
import 'package:finlog/src/features/core/logic/wallet_cubit.dart' as _i875;
import 'package:finlog/src/features/core/repository/firestore_repository.dart'
    as _i398;
import 'package:finlog/src/features/core/services/notification_service.dart'
    as _iNotif;
import 'package:finlog/src/features/transactions/logic/transaction_cubit.dart'
    as _i790;
import 'package:finlog/src/features/auth/cubit/auth_cubit.dart' as _i791;
import 'package:finlog/src/features/auth/repository/auth_repository.dart'
    as _i800;
import 'package:finlog/src/features/profile/logic/profile_cubit.dart'
    as _iProfile;
import 'package:finlog/src/features/budget/logic/budget_cubit.dart' as _iBudget;
import 'package:finlog/src/injection/register_module.dart' as _i584;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.singleton<_i750.LocalClient>(() => _i750.LocalClient());
    gh.singleton<_i36.AppConfigCubit>(() => _i36.AppConfigCubit());
    gh.singleton<_iNotif.NotificationService>(
        () => _iNotif.NotificationService());
    gh.lazySingleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.auth);
    gh.lazySingleton<_i398.FirestoreRepository>(
        () => _i398.FirestoreRepository(gh<_i974.FirebaseFirestore>()));
    gh.factory<_i791.AuthCubit>(() => _i791.AuthCubit(
          gh<_i800.AuthRepository>(),
          gh<_i398.FirestoreRepository>(),
        ));
    gh.factory<_i211.CategoryCubit>(
        () => _i211.CategoryCubit(gh<_i398.FirestoreRepository>()));
    gh.factory<_i875.WalletCubit>(
        () => _i875.WalletCubit(gh<_i398.FirestoreRepository>()));
    gh.factory<_i790.TransactionCubit>(() => _i790.TransactionCubit(
          gh<_i398.FirestoreRepository>(),
          gh<_iNotif.NotificationService>(),
        ));
    gh.factory<_iProfile.ProfileCubit>(
        () => _iProfile.ProfileCubit(gh<_i398.FirestoreRepository>()));
    gh.factory<_iBudget.BudgetCubit>(
        () => _iBudget.BudgetCubit(gh<_i398.FirestoreRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i584.RegisterModule {}
