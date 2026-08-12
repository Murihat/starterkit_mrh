import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/network/api_client.dart';
import '../../core/services/connectivity/connectivity_service.dart';
import '../../core/services/device/device_service.dart';
import '../../core/services/logger/logger_service.dart';
import '../../core/services/safe_device/safe_device_service.dart';
import '../../core/services/storage/storage_service.dart';
import '../../core/wrappers/connectivity/presentation/bloc/connectivity_bloc.dart';
import '../../core/wrappers/security/presentation/cubit/security_cubit.dart';
import '../../core/wrappers/theme/presentation/cubit/theme_cubit.dart';
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
  sl.registerFactory<MainNavigationCubit>(() => MainNavigationCubit());
  // ========================================
  // END OF Blocs and Cubits
  // ========================================
}
