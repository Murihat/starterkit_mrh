import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../features/login/presentation/pages/login_page.dart';
import '../../features/main_navigation/presentation/pages/main_navigation_page.dart';
import '../../features/maintenance/presentation/pages/maintenance_page.dart';
import '../../features/signup/presentation/pages/signup_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouteName {
  static const splash = "splash";
  static const login = 'login';
  static const signup = 'signup';
  static const maintenance = 'maintenance';

  static const home = 'home';
  static const account = 'account';
}

final GoRouter appRouter = GoRouter(
  observers: [],
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      name: AppRouteName.splash,
      path: '/',
      builder: (_, __) => const SplashPage(),
    ),
    GoRoute(
      name: AppRouteName.maintenance,
      path: '/${AppRouteName.maintenance}',
      builder: (_, __) => const MaintenancePage(),
    ),
    GoRoute(
      name: AppRouteName.login,
      path: '/${AppRouteName.login}',
      builder: (_, __) => const LoginPage(),
      routes: [
        GoRoute(
          name: AppRouteName.signup,
          path: '/${AppRouteName.signup}',
          builder: (_, __) => const SignupPage(),
        ),
      ],
    ),
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (_, __, child) => MainNavigationPage(child: child),
      routes: [
        GoRoute(
          name: AppRouteName.home,
          path: '/${AppRouteName.home}',
          builder: (_, __) => const Scaffold(body: Center(child: Text('Home'))),
        ),
        GoRoute(
          name: AppRouteName.account,
          path: '/${AppRouteName.account}',
          builder: (_, __) =>
              const Scaffold(body: Center(child: Text('Account'))),
        ),
        // ...HomeRoutes.routes,
        // ...BrandRoutes.routes,
        // ...WaitingListRoutes.routes,
        // ...OrderRoutes.routes,
        // ...RewardRoutes.routes,
      ],
    ),
  ],
);
