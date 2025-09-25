import 'package:auto_route/auto_route.dart';
import 'package:finlog/src/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
part 'app_router.gr.dart'; 

@AutoRouterConfig()
class AppRouter extends RootStackRouter  {
  @override
  List<AutoRoute> get routes => [
      AutoRoute(
          initial: true,
          path: SplashScreen.path,
          page: SplashRoute.page,
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
