import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:toastification/toastification.dart';

import '../core/states/theme/theme_cubit.dart';
import '../core/wrappers/connectivity/presentation/pages/connectivity_page.dart';
import '../core/wrappers/security/presentation/pages/security_page.dart';
import 'config/app_config.dart';
import 'routes/app_router.dart';
import 'themes/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: false,
      splitScreenMode: false,
      child: ToastificationWrapper(
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp.router(
              // showPerformanceOverlay: true,
              locale: const Locale('en', 'US'),
              supportedLocales: const [Locale('id', 'ID'), Locale('en', 'US')],
              // localizationsDelegates: const [
              //   GlobalMaterialLocalizations.delegate,
              //   GlobalWidgetsLocalizations.delegate,
              //   GlobalCupertinoLocalizations.delegate,
              // ],
              title: AppConfig.appName,
              debugShowCheckedModeBanner: AppConfig.enableLog,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: state.themeMode,
              routerConfig: appRouter,
              builder: (context, child) {
                return ConnectivityPage(
                  child: SecurityPage(child: child ?? const SizedBox.shrink()),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
