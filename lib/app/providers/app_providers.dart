import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/connectivity/connectivity_service.dart';
import '../../core/services/local_notification/local_notification_service.dart';
import '../../core/services/logger/logger_service.dart';
import '../../core/services/safe_device/safe_device_service.dart';
import '../../core/services/storage/storage_service.dart';
import '../../core/states/connectivity/connectivity_bloc.dart';
import '../../core/states/local_notification/local_notification_cubit.dart';
import '../../core/states/security/security_cubit.dart';
import '../../core/states/theme/theme_cubit.dart';
import '../../features/main_navigation/presentation/cubit/main_navigation_cubit.dart';
import '../di/injection.dart';

class AppProviders {
  AppProviders._();

  static List<BlocProvider> providers({required ThemeMode initialTheme}) => [
    BlocProvider<ConnectivityBloc>(
      create: (_) => ConnectivityBloc(
        service: sl<ConnectivityService>(),
        logger: sl<LoggerService>(),
      )..add(ConnectivityStarted()),
    ),
    BlocProvider<SecurityCubit>(
      create: (_) => SecurityCubit(service: sl<SafeDeviceService>())..check(),
    ),
    BlocProvider<ThemeCubit>(
      create: (_) =>
          ThemeCubit(storage: sl<StorageService>(), initialTheme: initialTheme),
    ),

    BlocProvider<LocalNotificationCubit>(
      create: (_) =>
          LocalNotificationCubit(service: sl<LocalNotificationService>()),
    ),
    BlocProvider<MainNavigationCubit>(create: (_) => sl<MainNavigationCubit>()),
  ];
}
