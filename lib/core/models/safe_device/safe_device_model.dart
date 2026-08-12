import 'dart:io';

class SafeDeviceModel {
  final bool isJailBroken;
  final bool isJailBrokenCustom;
  final bool isMockLocation;
  final bool isRealDevice;
  final bool isOnExternalStorage;
  final bool isSafeDevice;
  final bool isDevelopmentModeEnable;

  final Map<String, dynamic> jailbreakDetails;
  final Map<String, dynamic> rootDetectionDetails;

  const SafeDeviceModel({
    required this.isJailBroken,
    required this.isJailBrokenCustom,
    required this.isMockLocation,
    required this.isRealDevice,
    required this.isOnExternalStorage,
    required this.isSafeDevice,
    required this.isDevelopmentModeEnable,
    required this.jailbreakDetails,
    required this.rootDetectionDetails,
  });

  factory SafeDeviceModel.fromJson(Map<String, dynamic> json) {
    return SafeDeviceModel(
      isJailBroken: json['isJailBroken'] ?? false,
      isJailBrokenCustom: json['isJailBrokenCustom'] ?? false,
      isMockLocation: json['isMockLocation'] ?? false,
      isRealDevice: json['isRealDevice'] ?? true,
      isOnExternalStorage: json['isOnExternalStorage'] ?? false,
      isSafeDevice: json['isSafeDevice'] ?? true,
      isDevelopmentModeEnable: json['isDevelopmentModeEnable'] ?? false,
      jailbreakDetails: Map<String, dynamic>.from(
        json['jailbreakDetails'] ?? {},
      ),
      rootDetectionDetails: Map<String, dynamic>.from(
        json['rootDetectionDetails'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isJailBroken': isJailBroken,
      'isJailBrokenCustom': isJailBrokenCustom,
      'isMockLocation': isMockLocation,
      'isRealDevice': isRealDevice,
      'isOnExternalStorage': isOnExternalStorage,
      'isSafeDevice': isSafeDevice,
      'isDevelopmentModeEnable': isDevelopmentModeEnable,
      'jailbreakDetails': jailbreakDetails,
      'rootDetectionDetails': rootDetectionDetails,
      'isBlocked': isBlocked,
      'violations': violations,
      'message': message,
    };
  }

  SafeDeviceModel copyWith({
    bool? isJailBroken,
    bool? isJailBrokenCustom,
    bool? isMockLocation,
    bool? isRealDevice,
    bool? isOnExternalStorage,
    bool? isSafeDevice,
    bool? isDevelopmentModeEnable,
    Map<String, dynamic>? jailbreakDetails,
    Map<String, dynamic>? rootDetectionDetails,
  }) {
    return SafeDeviceModel(
      isJailBroken: isJailBroken ?? this.isJailBroken,
      isJailBrokenCustom: isJailBrokenCustom ?? this.isJailBrokenCustom,
      isMockLocation: isMockLocation ?? this.isMockLocation,
      isRealDevice: isRealDevice ?? this.isRealDevice,
      isOnExternalStorage: isOnExternalStorage ?? this.isOnExternalStorage,
      isSafeDevice: isSafeDevice ?? this.isSafeDevice,
      isDevelopmentModeEnable:
          isDevelopmentModeEnable ?? this.isDevelopmentModeEnable,
      jailbreakDetails: jailbreakDetails ?? this.jailbreakDetails,
      rootDetectionDetails: rootDetectionDetails ?? this.rootDetectionDetails,
    );
  }

  bool get isBlocked {
    if (isMockLocation) return true;
    if (isDevelopmentModeEnable) return true;
    if (isJailBroken) return true;
    if (!isRealDevice) return true;
    if (!isSafeDevice) return true;

    return false;
  }

  List<String> get violations {
    final result = <String>[];

    if (isMockLocation) {
      result.add('Mock Location');
    }

    if (isDevelopmentModeEnable) {
      result.add('Developer Mode');
    }

    if (isJailBroken) {
      result.add(Platform.isIOS ? 'Jailbreak' : 'Root Device');
    }

    if (!isRealDevice) {
      result.add('Emulator');
    }

    if (!isSafeDevice) {
      result.add('Unsafe Device');
    }

    return result;
  }

  String get message =>
      violations.isEmpty ? 'Device is secure' : violations.join(', ');
}
