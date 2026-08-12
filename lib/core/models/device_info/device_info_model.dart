class DeviceInfoModel {
  final String deviceId;
  final String deviceName;
  final String deviceModel;
  final String manufacturer;
  final String platform;
  final String osVersion;
  final String appVersion;
  final String buildNumber;
  final String locale;
  final String timezone;
  final bool isPhysicalDevice;

  const DeviceInfoModel({
    required this.deviceId,
    required this.deviceName,
    required this.deviceModel,
    required this.manufacturer,
    required this.platform,
    required this.osVersion,
    required this.appVersion,
    required this.buildNumber,
    required this.locale,
    required this.timezone,
    required this.isPhysicalDevice,
  });

  factory DeviceInfoModel.fromJson(Map<String, dynamic> json) {
    return DeviceInfoModel(
      deviceId: json['device_id'] ?? '',
      deviceName: json['device_name'] ?? '',
      deviceModel: json['device_model'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      platform: json['platform'] ?? '',
      osVersion: json['os_version'] ?? '',
      appVersion: json['app_version'] ?? '',
      buildNumber: json['build_number'] ?? '',
      locale: json['locale'] ?? '',
      timezone: json['timezone'] ?? '',
      isPhysicalDevice: json['is_physical_device'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'device_name': deviceName,
      'device_model': deviceModel,
      'manufacturer': manufacturer,
      'platform': platform,
      'os_version': osVersion,
      'app_version': appVersion,
      'build_number': buildNumber,
      'locale': locale,
      'timezone': timezone,
      'is_physical_device': isPhysicalDevice,
    };
  }

  DeviceInfoModel copyWith({
    String? deviceId,
    String? deviceName,
    String? deviceModel,
    String? manufacturer,
    String? platform,
    String? osVersion,
    String? appVersion,
    String? buildNumber,
    String? locale,
    String? timezone,
    bool? isPhysicalDevice,
  }) {
    return DeviceInfoModel(
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      deviceModel: deviceModel ?? this.deviceModel,
      manufacturer: manufacturer ?? this.manufacturer,
      platform: platform ?? this.platform,
      osVersion: osVersion ?? this.osVersion,
      appVersion: appVersion ?? this.appVersion,
      buildNumber: buildNumber ?? this.buildNumber,
      locale: locale ?? this.locale,
      timezone: timezone ?? this.timezone,
      isPhysicalDevice: isPhysicalDevice ?? this.isPhysicalDevice,
    );
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
