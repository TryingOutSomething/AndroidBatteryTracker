import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';

class DeviceInfo {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  static late String _deviceName;
  static final String _deviceId = const Uuid().v4();

  static Future<String> get deviceName async {
    AndroidDeviceInfo androidDeviceInfo = await _deviceInfoPlugin.androidInfo;
    _deviceName = androidDeviceInfo.model!;

    return _deviceName;
  }

  static String get deviceId => _deviceId;
}
