import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/network/api_client.dart';
import '../../core/services/connectivity/connectivity_service.dart';
import '../../core/services/device/device_service.dart';
import '../../core/services/local_notification/local_notification_service.dart';
import '../../core/services/logger/logger_service.dart';
import '../../core/services/safe_device/safe_device_service.dart';
import '../../core/services/storage/storage_service.dart';
import '../../core/states/connectivity/connectivity_bloc.dart';
import '../../core/states/local_notification/local_notification_cubit.dart';
import '../../core/states/security/security_cubit.dart';
import '../../core/states/theme/theme_cubit.dart';
import '../../features/main_navigation/presentation/cubit/main_navigation_cubit.dart';
import '../observer/app_observer.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ========================================
  // Services
  // ========================================
  sl.registerLazySingleton<StorageService>(() => StorageService());
  sl.registerLazySingleton<LoggerService>(() => LoggerService());
  sl.registerLazySingleton<AppObserver>(
    () => AppObserver(logger: sl<LoggerService>()),
  );
  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  sl.registerLazySingleton<SafeDeviceService>(() => SafeDeviceService());
  sl.registerLazySingleton<DeviceService>(
    () => DeviceService(storage: sl<StorageService>()),
  );
  sl.registerLazySingleton<LocalNotificationService>(
    () => LocalNotificationService(apiClient: sl<ApiClient>()),
  );
  // ========================================
  // END OF SERVICES
  // ========================================

  // ========================================
  // Network
  // ========================================
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      getToken: () => sl<StorageService>().read(StorageKeys.token),
      deviceService: sl<DeviceService>(),
    ),
  );
  // ========================================
  // END OF NETWORK
  // ========================================

  // ========================================
  // Blocs and Cubits can be registered here if needed
  // ========================================
  sl.registerFactory(
    () => ConnectivityBloc(
      service: sl<ConnectivityService>(),
      logger: sl<LoggerService>(),
    ),
  );
  sl.registerFactory<SecurityCubit>(
    () => SecurityCubit(service: sl<SafeDeviceService>()),
  );
  sl.registerFactoryParam<ThemeCubit, ThemeMode, void>(
    (initialTheme, _) =>
        ThemeCubit(storage: sl<StorageService>(), initialTheme: initialTheme),
  );
  sl.registerFactory<LocalNotificationCubit>(
    () => LocalNotificationCubit(service: sl<LocalNotificationService>()),
  );
  sl.registerFactory<MainNavigationCubit>(() => MainNavigationCubit());
  // ========================================
  // END OF Blocs and Cubits
  // ========================================
}
