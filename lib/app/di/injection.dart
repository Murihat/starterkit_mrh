import 'package:get_it/get_it.dart';

import '../../core/network/api_client.dart';
import '../../core/services/connectivity/connectivity_service.dart';
import '../../core/services/device/device_service.dart';
import '../../core/services/local_notification/local_notification_service.dart';
import '../../core/services/logger/logger_service.dart';
import '../../core/services/safe_device/safe_device_service.dart';
import '../../core/services/storage/storage_service.dart';
import '../observer/app_observer.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Services
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

  // Network
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      getToken: () => sl<StorageService>().read(StorageKeys.token),
      deviceService: sl<DeviceService>(),
    ),
  );

  sl.registerLazySingleton<LocalNotificationService>(
    () => LocalNotificationService(apiClient: sl<ApiClient>()),
  );
}
