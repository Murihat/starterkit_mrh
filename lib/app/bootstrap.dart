import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../core/services/local_notification/local_notification_service.dart';
import '../core/services/logger/logger_service.dart';
import '../core/services/storage/storage_service.dart';
import 'di/injection.dart';
import 'providers/app_providers.dart';

Future<void> bootstrap(Future<Widget> Function() builder) async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      // 1. Tangkap error di level framework & engine
      FlutterError.onError = (details) {
        try {
          sl<LoggerService>().e(
            'FLUTTER_ERROR',
            details.exceptionAsString(),
            details.exception,
            details.stack,
          );
        } catch (_) {
          FlutterError.presentError(details);
        }
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        try {
          sl<LoggerService>().e(
            'PLATFORM_ERROR',
            error.toString(),
            error,
            stack,
          );
        } catch (_) {
          debugPrint('PLATFORM_ERROR: $error\n$stack');
        }
        return true;
      };

      await Future.wait([
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
        dotenv.load(
          fileName: const String.fromEnvironment(
            'ENV',
            defaultValue: 'env/.env.dev',
          ),
        ),
      ]);
      await initDependencies();
      final results = await Future.wait([
        sl<StorageService>().getThemeMode(),
        sl<LocalNotificationService>().init(),
      ]);
      final initialTheme = results[0] as ThemeMode;

      return runApp(
        MultiBlocProvider(
          providers: AppProviders.providers(initialTheme: initialTheme),
          child: await builder(),
        ),
      );
    },
    (error, stack) {
      try {
        sl<LoggerService>().e('BOOTSTRAP_ZONE', error.toString(), error, stack);
      } catch (_) {
        debugPrint('BOOTSTRAP - ZONE_ERROR: $error\n$stack');
      }
    },
  );
}
