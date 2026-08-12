import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../core/services/logger/logger_service.dart';
import '../core/services/storage/storage_service.dart';
import 'di/injection.dart';
import 'providers/app_providers.dart';

Future<void> bootstrap(Future<Widget> Function() builder) async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      await dotenv.load(
        fileName: const String.fromEnvironment(
          'ENV',
          defaultValue: 'env/.env.dev',
        ),
      );
      await initDependencies();
      final initialTheme = await sl<StorageService>().getThemeMode();
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
