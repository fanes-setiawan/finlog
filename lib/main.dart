import 'package:finlog/firebase_options.dart';
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:finlog/src/commons/constants/app_theme.dart';
import 'package:finlog/src/commons/clients/local/local_client.dart';
import 'package:finlog/src/injection/injection.dart';
import 'package:finlog/src/features/expense/cubit/expense_cubit.dart';
import 'package:finlog/src/features/expense/model/expense_model.dart';
import 'package:finlog/src/features/expense/repository/expense_repository.dart';
import 'package:finlog/src/features/auth/repository/auth_repository.dart';
import 'package:finlog/src/features/auth/cubit/auth_cubit.dart';
import 'package:finlog/src/features/core/repository/firestore_repository.dart';
import 'package:finlog/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'src/commons/constants/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await Hive.openBox(LocalClient.boxName); // Open box for LocalClient
  Hive.registerAdapter(ExpenseModelAdapter());
  final expenseBox = await Hive.openBox<ExpenseModel>('expenses');

  await configureDependencies(); // Now injection is safe
  await initializeDateFormatting('id_ID', null);

  final expenseRepository = ExpenseRepository(expenseBox);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (_) => AuthRepository()),
          RepositoryProvider(
              create: (context) =>
                  expenseRepository), // passing existing one as repository
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => AuthCubit(
                      context.read<AuthRepository>(),
                      getIt<FirestoreRepository>(), // Fix injection
                    )..checkAuthStatus()),
            BlocProvider(
                create: (_) => ExpenseCubit(expenseRepository)
                  ..loadExpenses()), // Note: ExpenseCubit uses expenseRepository from main, can also use context.read if we passed it
          ],
          child: const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final _appRouter = AppRouter();

    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp.router(
          title: 'FinLog',
          debugShowCheckedModeBanner: false,
          routerConfig: _appRouter.config(),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          builder: FlutterSmartDialog.init(),
        ),
      );
    });
  }
}
