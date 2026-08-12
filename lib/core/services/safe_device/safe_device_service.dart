import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:safe_device/safe_device.dart';

import '../../models/safe_device/safe_device_model.dart';

class SafeDeviceService {
  Future<SafeDeviceModel> check() async {
    try {
      final isJailBroken = await SafeDevice.isJailBroken;

      final isRealDevice = await SafeDevice.isRealDevice;

      final isSafeDevice = await SafeDevice.isSafeDevice;

      bool isMockLocation = false;
      bool isDevelopmentModeEnable = false;
      bool isOnExternalStorage = false;
      bool isJailBrokenCustom = false;

      Map<String, dynamic> jailbreakDetails = {};
      Map<String, dynamic> rootDetectionDetails = {};

      if (Platform.isAndroid) {
        isMockLocation = await SafeDevice.isMockLocation;

        isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;

        isOnExternalStorage = await SafeDevice.isOnExternalStorage;

        rootDetectionDetails = await SafeDevice.rootDetectionDetails;
      }

      if (Platform.isIOS) {
        isJailBrokenCustom = await SafeDevice.isJailBrokenCustom;

        jailbreakDetails = await SafeDevice.jailbreakDetails;
      }

      return SafeDeviceModel(
        isJailBroken: isJailBroken,
        isJailBrokenCustom: isJailBrokenCustom,
        isMockLocation: isMockLocation,
        isRealDevice: isRealDevice,
        isOnExternalStorage: isOnExternalStorage,
        isSafeDevice: isSafeDevice,
        isDevelopmentModeEnable: isDevelopmentModeEnable,
        jailbreakDetails: jailbreakDetails,
        rootDetectionDetails: rootDetectionDetails,
      );
    } catch (e, s) {
      debugPrint('DeviceSecurityService Error: $e');

      debugPrint(s.toString());

      return const SafeDeviceModel(
        isJailBroken: false,
        isJailBrokenCustom: false,
        isMockLocation: false,
        isRealDevice: true,
        isOnExternalStorage: false,
        isSafeDevice: true,
        isDevelopmentModeEnable: false,
        jailbreakDetails: {},
        rootDetectionDetails: {},
      );
    }
  }
}
