import 'package:auto_route/auto_route.dart';
import 'package:finlog/src/commons/constants/app_assets.dart';
import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/commons/constants/styles/app_text.dart';
import 'package:finlog/src/commons/utils/app_icon.dart';
import 'package:finlog/src/routing/app_router.dart';
import 'package:flutter/material.dart';

import 'package:finlog/src/features/auth/cubit/auth_cubit.dart';
import 'package:finlog/src/features/core/logic/category_cubit.dart';
import 'package:finlog/src/features/core/logic/wallet_cubit.dart';
import 'package:finlog/src/features/transactions/logic/transaction_cubit.dart';
import 'package:finlog/src/injection/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class NavBarScreen extends StatelessWidget {
  const NavBarScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        String? userId;
        if (authState is AuthAuthenticated) {
          userId = authState.user.uid;
        }

        // We wrap everything in MultiBlocProvider.
        // If userId is null (not auth), we still provide Cubits but maybe they don't load data yet,
        // or we handle loading inside the builder if userId changes.
        // Ideally, we only reach NavBar if authenticated.

        return MultiBlocProvider(
          key: ValueKey(userId), // Force rebuild when user ID changes
          providers: [
            BlocProvider(
                create: (_) => getIt<WalletCubit>()..loadWallets(userId ?? '')),
            BlocProvider(
                create: (_) =>
                    getIt<TransactionCubit>()..loadTransactions(userId ?? '')),
            BlocProvider(
                create: (_) =>
                    getIt<CategoryCubit>()..loadCategories(userId ?? '')),
          ],
          child: AutoTabsScaffold(
            routes: const [
              HomeRoute(),
              TransactionHistoryRoute(),
              BudgetRoute(),
              WalletsRoute(),
              ProfileRoute(),
            ],
            bottomNavigationBuilder: (_, tabsRouter) {
              return BottomNavigationBar(
                backgroundColor: AppColors.neutral6,
                currentIndex: tabsRouter.activeIndex,
                onTap: tabsRouter.setActiveIndex,
                selectedItemColor: AppColors.neutral5,
                unselectedItemColor: AppColors.subtitle,
                selectedLabelStyle: AppText.title.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: AppText.bigTitle.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                    icon:
                        AppIcon(AppAssets.homeIcon, color: AppColors.neutral3),
                    activeIcon:
                        AppIcon(AppAssets.homeIcon, color: AppColors.neutral5),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.receipt_long_outlined,
                        color: AppColors.neutral3),
                    activeIcon:
                        Icon(Icons.receipt_long, color: AppColors.neutral5),
                    label: "Transactions",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.pie_chart_outline,
                        color: AppColors.neutral3),
                    activeIcon:
                        Icon(Icons.pie_chart, color: AppColors.neutral5),
                    label: "Budget",
                  ),
                  BottomNavigationBarItem(
                    icon:
                        AppIcon(AppAssets.cardIcon, color: AppColors.neutral3),
                    activeIcon:
                        AppIcon(AppAssets.cardIcon, color: AppColors.neutral5),
                    label: "Wallets",
                  ),
                  BottomNavigationBarItem(
                    icon: AppIcon(AppAssets.settingsIcon,
                        color: AppColors.neutral3),
                    activeIcon: AppIcon(AppAssets.settingsIcon,
                        color: AppColors.neutral5),
                    label: "Profile",
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
