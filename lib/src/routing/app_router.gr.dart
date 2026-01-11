// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AddTransactionScreen]
class AddTransactionRoute extends PageRouteInfo<AddTransactionRouteArgs> {
  AddTransactionRoute({
    Key? key,
    required String userId,
    TransactionModel? transactionToEdit,
    List<PageRouteInfo>? children,
  }) : super(
          AddTransactionRoute.name,
          args: AddTransactionRouteArgs(
              key: key, userId: userId, transactionToEdit: transactionToEdit),
          initialChildren: children,
        );

  static const String name = 'AddTransactionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddTransactionRouteArgs>();
      return AddTransactionScreen(
          key: args.key,
          userId: args.userId,
          transactionToEdit: args.transactionToEdit);
    },
  );
}

class AddTransactionRouteArgs {
  const AddTransactionRouteArgs(
      {this.key, required this.userId, this.transactionToEdit});

  final Key? key;

  final String userId;

  final TransactionModel? transactionToEdit;

  @override
  String toString() {
    return 'AddTransactionRouteArgs{key: $key, userId: $userId, transactionToEdit: $transactionToEdit}';
  }
}

/// generated route for
/// [BudgetScreen]
class BudgetRoute extends PageRouteInfo<void> {
  const BudgetRoute({List<PageRouteInfo>? children})
      : super(BudgetRoute.name, initialChildren: children);

  static const String name = 'BudgetRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BudgetScreen();
    },
  );
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginScreen();
    },
  );
}

/// generated route for
/// [NavBarScreen]
class NavBarRoute extends PageRouteInfo<void> {
  const NavBarRoute({List<PageRouteInfo>? children})
      : super(NavBarRoute.name, initialChildren: children);

  static const String name = 'NavBarRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NavBarScreen();
    },
  );
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileScreen();
    },
  );
}

/// generated route for
/// [RegisterScreen]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterScreen();
    },
  );
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashScreen();
    },
  );
}

/// generated route for
/// [StatisticScreen]
class StatisticRoute extends PageRouteInfo<void> {
  const StatisticRoute({List<PageRouteInfo>? children})
      : super(StatisticRoute.name, initialChildren: children);

  static const String name = 'StatisticRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const StatisticScreen();
    },
  );
}

/// generated route for
/// [TransactionHistoryScreen]
class TransactionHistoryRoute extends PageRouteInfo<void> {
  const TransactionHistoryRoute({List<PageRouteInfo>? children})
      : super(TransactionHistoryRoute.name, initialChildren: children);

  static const String name = 'TransactionHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TransactionHistoryScreen();
    },
  );
}

/// generated route for
/// [WalletsScreen]
class WalletsRoute extends PageRouteInfo<void> {
  const WalletsRoute({List<PageRouteInfo>? children})
      : super(WalletsRoute.name, initialChildren: children);

  static const String name = 'WalletsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WalletsScreen();
    },
  );
}
