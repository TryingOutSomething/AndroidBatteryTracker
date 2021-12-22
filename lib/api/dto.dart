class Device {
  final String deviceId;
  final String deviceName;
  final String batteryLevel;

  const Device(
      {required this.deviceId,
      required this.deviceName,
      required this.batteryLevel});

  Map<String, dynamic> toJson() => {
        'device_id': deviceId,
        'device_name': deviceName,
        'batteryLevel': batteryLevel,
      };
}

class UnregisterDevice {
  final String deviceId;

  const UnregisterDevice({required this.deviceId});

  Map<String, dynamic> toJson() => {'device_id': deviceId};
}

class DeviceBatteryInfo {
  final String deviceId;
  final String batteryLevel;

  const DeviceBatteryInfo({required this.deviceId, required this.batteryLevel});

  Map<String, dynamic> toJson() =>
      {'device_id': deviceId, 'current_battery_level': batteryLevel};
}
