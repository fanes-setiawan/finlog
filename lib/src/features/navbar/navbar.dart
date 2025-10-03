import 'package:auto_route/auto_route.dart';
import 'package:finlog/src/commons/constants/app_assets.dart';
import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/commons/constants/styles/app_text.dart';
import 'package:finlog/src/commons/utils/app_icon.dart';
import 'package:finlog/src/routing/app_router.dart';
import 'package:flutter/material.dart';

@RoutePage()
class NavBarScreen extends StatelessWidget {
  const NavBarScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        HomeRoute(),
        CardRoute(),
        StatisticRoute(),
        SettingRoute(),
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
              icon: AppIcon(AppAssets.homeIcon,color:AppColors.neutral3), 
              activeIcon: AppIcon(AppAssets.homeIcon,color: AppColors.neutral5), 
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: AppIcon(AppAssets.cardIcon, color: AppColors.neutral3),
              activeIcon:AppIcon(AppAssets.cardIcon, color: AppColors.neutral5),
              label: "Card",
            ),
            BottomNavigationBarItem(
              icon:AppIcon(AppAssets.statisticsIcon, color: AppColors.neutral3),
              activeIcon:AppIcon(AppAssets.statisticsIcon, color: AppColors.neutral5),
              label: "Statistic",
            ),
            BottomNavigationBarItem(
              icon: AppIcon(AppAssets.settingsIcon, color: AppColors.neutral3),
              activeIcon:AppIcon(AppAssets.settingsIcon, color: AppColors.neutral5),
              label: "Setting",
            ),
          ],
        );
      },
    );
  }
}
