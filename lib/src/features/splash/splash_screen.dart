// ignore_for_file: deprecated_member_use_from_same_package

import 'package:auto_route/auto_route.dart';
import 'package:finlog/src/commons/constants/app_assets.dart';
import 'package:finlog/src/commons/constants/styles/app_color.dart';
import 'package:finlog/src/commons/utils/app_icon.dart';
import 'package:finlog/src/commons/utils/app_text.dart';
import 'package:finlog/src/commons/utils/rotation_utils.dart';
import 'package:finlog/src/routing/app_router.dart';
import 'package:finlog/src/features/auth/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  static const path = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check current state after frame builds to ensure navigation context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkState(context.read<AuthCubit>().state);
    });
  }

  void _checkState(AuthState state) {
    if (state is AuthAuthenticated) {
      context.router.replace(const NavBarRoute());
    } else if (state is AuthUnauthenticated) {
      context.router.replace(const LoginRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        _checkState(state);
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const RotatingWidget(
                repeat: true,
                child: AppIcon(
                  AppAssets.logo,
                  size: 124,
                ),
              ),
              Text(
                "Fin Log",
                style: AppTextStyles.headline1(color: AppColor.blue500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
