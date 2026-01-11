import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:finlog/src/features/auth/screens/login_screen.dart';
import 'package:finlog/src/features/auth/screens/register_screen.dart';
import 'package:finlog/src/features/wallet/screens/wallets_screen.dart';
import 'package:finlog/src/features/home/screens/home_screen.dart';
import 'package:finlog/src/features/navbar/navbar.dart';
import 'package:finlog/src/features/profile/screens/profile_screen.dart';
import 'package:finlog/src/features/splash/splash_screen.dart';
import 'package:finlog/src/features/statistic/screens/statistic_screen.dart';
import 'package:finlog/src/features/transactions/screens/add_transaction_screen.dart';
import 'package:finlog/src/features/transactions/screens/transaction_history_screen.dart';
import 'package:finlog/src/features/budget/screens/budget_screen.dart';
import 'package:finlog/src/features/core/model/core_models.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
            path: SplashScreen.path, page: SplashRoute.page, initial: true),
        AutoRoute(path: LoginScreen.path, page: LoginRoute.page),
        AutoRoute(path: RegisterScreen.path, page: RegisterRoute.page),
        AutoRoute(page: AddTransactionRoute.page),
        AutoRoute(
          page: NavBarRoute.page,
          children: [
            AutoRoute(page: HomeRoute.page, initial: true),
            AutoRoute(page: TransactionHistoryRoute.page),
            AutoRoute(page: BudgetRoute.page),
            AutoRoute(page: WalletsRoute.page),
            AutoRoute(page: ProfileRoute.page),
          ],
        ),
      ];
}
