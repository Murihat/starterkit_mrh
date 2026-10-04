import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:safe_device/safe_device.dart';

import '../../models/safe_device/safe_device_model.dart';

class SafeDeviceService {
  Future<SafeDeviceModel> check() async {
    try {
      // 1. Eksekusi pengecekan umum secara paralel
      final commonChecks = await Future.wait([
        SafeDevice.isJailBroken,
        SafeDevice.isRealDevice,
        SafeDevice.isSafeDevice,
      ]);

      final isJailBroken = commonChecks[0];
      final isRealDevice = commonChecks[1];
      final isSafeDevice = commonChecks[2];

      bool isMockLocation = false;
      bool isDevelopmentModeEnable = false;
      bool isOnExternalStorage = false;
      bool isJailBrokenCustom = false;
      Map<String, dynamic> jailbreakDetails = const {};
      Map<String, dynamic> rootDetectionDetails = const {};

      // 2. Eksekusi platform-specific secara paralel
      if (!kIsWeb && Platform.isAndroid) {
        final results = await Future.wait([
          SafeDevice.isMockLocation,
          SafeDevice.isDevelopmentModeEnable,
          SafeDevice.isOnExternalStorage,
          SafeDevice.rootDetectionDetails,
        ]);
        isMockLocation = results[0] as bool;
        isDevelopmentModeEnable = results[1] as bool;
        isOnExternalStorage = results[2] as bool;
        rootDetectionDetails = results[3] as Map<String, dynamic>;
      } else if (!kIsWeb && Platform.isIOS) {
        final results = await Future.wait([
          SafeDevice.isJailBrokenCustom,
          SafeDevice.jailbreakDetails,
        ]);
        isJailBrokenCustom = results[0] as bool;
        jailbreakDetails = results[1] as Map<String, dynamic>;
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
      debugPrint('SafeDeviceService Error: $e\n$s');
      rethrow;
      // return const SafeDeviceModel(
      //   isJailBroken: false,
      //   isJailBrokenCustom: false,
      //   isMockLocation: false,
      //   isRealDevice: true,
      //   isOnExternalStorage: false,
      //   isSafeDevice: true,
      //   isDevelopmentModeEnable: false,
      //   jailbreakDetails: {},
      //   rootDetectionDetails: {},
      // );
    }
  }
}
