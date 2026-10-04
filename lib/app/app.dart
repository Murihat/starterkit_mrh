import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

import '../core/states/locale/locale_cubit.dart';
import '../core/states/theme/theme_cubit.dart';
import '../core/wrappers/connectivity/presentation/pages/connectivity_page.dart';
import '../core/wrappers/security/presentation/pages/security_page.dart';
import 'config/app_config.dart';
import 'l10n/app_localizations.dart';
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
          builder: (context, themeState) {
            return BlocBuilder<LocaleCubit, LocaleState>(
              builder: (context, localeState) {
                return MaterialApp.router(
                  // showPerformanceOverlay: true,
                  locale: localeState.locale,
                  supportedLocales: const [
                    Locale('id', 'ID'),
                    Locale('en', 'US'),
                  ],
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  title: AppConfig.appName,
                  debugShowCheckedModeBanner: AppConfig.enableLog,
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  themeMode: themeState.themeMode,
                  routerConfig: appRouter,
                  builder: (context, child) {
                    return ConnectivityPage(
                      child: SecurityPage(
                        child: child ?? const SizedBox.shrink(),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
