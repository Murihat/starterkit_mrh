import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/services/connectivity/connectivity_service.dart';
import '../../core/services/logger/logger_service.dart';
import '../../core/services/safe_device/safe_device_service.dart';
import '../../core/services/storage/storage_service.dart';
import '../../core/wrappers/connectivity/presentation/bloc/connectivity_bloc.dart';
import '../../core/wrappers/security/presentation/cubit/security_cubit.dart';
import '../../core/wrappers/theme/presentation/cubit/theme_cubit.dart';
import '../observer/app_observer.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  //Storage
  sl.registerLazySingleton<StorageService>(() => StorageService());

  //Logger
  sl.registerLazySingleton<LoggerService>(() => LoggerService());

  //Observer
  sl.registerLazySingleton<AppObserver>(
    () => AppObserver(logger: sl<LoggerService>()),
  );

  //Connectivity
  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  sl.registerFactory(
    () => ConnectivityBloc(
      service: sl<ConnectivityService>(),
      logger: sl<LoggerService>(),
    ),
  );

  //Safe Device
  sl.registerLazySingleton<SafeDeviceService>(() => SafeDeviceService());
  sl.registerFactory<SecurityCubit>(
    () => SecurityCubit(service: sl<SafeDeviceService>()),
  );

  //Theme
  sl.registerFactoryParam<ThemeCubit, ThemeMode, void>(
    (initialTheme, _) =>
        ThemeCubit(storage: sl<StorageService>(), initialTheme: initialTheme),
  );
}
