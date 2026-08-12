import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import '../../models/device_info/device_info_model.dart';
import '../storage/storage_service.dart';

class DeviceService {
  static const String _deviceIdPrefix = 'StarterApp-';

  final StorageService storage;

  const DeviceService({required this.storage});

  static const Uuid _uuid = Uuid();

  Future<String> _getDeviceId() async {
    final savedId = await storage.read(StorageKeys.deviceId);

    if (savedId != null && savedId.isNotEmpty) {
      return savedId;
    }

    final deviceId = '$_deviceIdPrefix${_uuid.v4()}';

    await storage.write(StorageKeys.deviceId, deviceId);

    return deviceId;
  }

  Future<DeviceInfoModel> get() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final deviceInfo = DeviceInfoPlugin();

    String deviceName = '';
    String model = '';
    String manufacturer = '';
    String osVersion = '';
    bool isPhysicalDevice = true;

    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;

      deviceName = info.brand;
      model = info.model;
      manufacturer = info.manufacturer;
      osVersion = info.version.release;
      isPhysicalDevice = info.isPhysicalDevice;
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;

      deviceName = info.name;
      model = info.model;
      manufacturer = 'Apple';
      osVersion = info.systemVersion;
      isPhysicalDevice = info.isPhysicalDevice;
    }

    return DeviceInfoModel(
      deviceId: await _getDeviceId(),
      deviceName: deviceName,
      deviceModel: model,
      manufacturer: manufacturer,
      platform: Platform.operatingSystem,
      osVersion: osVersion,
      appVersion: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
      locale: WidgetsBinding.instance.platformDispatcher.locale.toString(),
      timezone: DateTime.now().timeZoneName,
      isPhysicalDevice: isPhysicalDevice,
    );
  }
}
