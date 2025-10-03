import 'package:auto_route/auto_route.dart';
import 'package:finlog/src/commons/constants/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Center(
          child: Column(
        children: [
          const Text("Setting Page"),
          SwitchListTile(
              title: const Text("Dark Mode"),
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.setThemeMode(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
              })
        ],
      )),
    );
  }
}
