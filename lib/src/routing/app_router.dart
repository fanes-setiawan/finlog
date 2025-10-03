import 'package:auto_route/auto_route.dart';
import 'package:finlog/src/features/card/screens/card_screen.dart';
import 'package:finlog/src/features/home/screens/home_screen.dart';
import 'package:finlog/src/features/navbar/navbar.dart';
import 'package:finlog/src/features/setting/screens/setting_screen.dart';
import 'package:finlog/src/features/splash/splash_screen.dart';
import 'package:finlog/src/features/statistic/screens/statistic_screen.dart';
import 'package:flutter/material.dart';
part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: SplashScreen.path,
          page: SplashRoute.page,
        ),
        AutoRoute(
          initial: true,
          page: NavBarRoute.page,
          children: [
            AutoRoute(page: HomeRoute.page, initial: true),
            AutoRoute(page: CardRoute.page),
            AutoRoute(page: StatisticRoute.page),
            AutoRoute(page: SettingRoute.page),
          ],
        ),
      ];
}

Widget _fadeScaleTransition(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: animation,
    child: ScaleTransition(
      scale: Tween<double>(begin: 0.98, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOut),
      ),
      child: child,
    ),
  );
}
