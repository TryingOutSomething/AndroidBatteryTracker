import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:client_dart/src/api/dtos/response.dart';
import 'package:client_dart/src/api/helpers/service_codes.dart';
import 'package:client_dart/src/api/http_client.dart';
import 'package:flutter_background/flutter_background.dart';

import '../api/dtos/device.dart';
import '../battery/services/battery_module.dart';
import '../device/services/device_info.dart';
import 'background/process_handler.dart';

typedef TimerCallback = Function(Timer timer);
typedef ErrorMessageCallback = Function(String error);

class Scheduler {
  Timer? _periodicTimer;
  late ProcessHandler _handler;
  late final ErrorMessageCallback _onErrorCallback;
  Function? _onStopTaskCallback;

  Scheduler({required ErrorMessageCallback onErrorCallback}) {
    FlutterBackgroundAndroidConfig config =
        const FlutterBackgroundAndroidConfig(
            notificationTitle: 'Tracking battery level',
            notificationText: 'Tracking in progress...',
            notificationImportance: AndroidNotificationImportance.Default);

    _handler = BackgroundProcessHandler(
        config: config, onErrorCallback: onErrorCallback);

    _onErrorCallback = onErrorCallback;
  }

  void startTask({required Duration duration, Function? onStopTaskCallback}) {
    BatteryModule.registerCallback(BatteryState.full, pauseTask);
    BatteryModule.registerCallback(BatteryState.discharging, pauseTask);
    BatteryModule.subscribeToBatteryStateChange();

    _handler.startBackgroundProcess();
    _periodicTimer = createPeriodicTimer(duration, _emitBatteryInfoToServer);
    _onStopTaskCallback = onStopTaskCallback;
  }

  Future<void> _emitBatteryInfoToServer(Timer timer) async {
    final device = DeviceBatteryInfo(
        deviceId: DeviceInfo.deviceId,
        batteryLevel: (await BatteryModule.batteryLevel).toString());

    final responseResult = await HttpModule.emitBatteryLevel(device);

    if (responseResult.success) {
      return;
    }

    _handleError(responseResult);
    _stopPeriodicTask(timer);
  }

  void _handleError(ResponseResult result) {
    switch (result.serviceCode) {
      case ServiceCode.unexpectedError:
        _onErrorCallback('Unexpected error occurred. Try again later');
        break;
      case ServiceCode.cannotConnectToServer:
        _onErrorCallback('Unable to connect to server! Try again later.');
        break;
      default:
        _onErrorCallback(result.message);
    }
  }

  void pauseTask() {
    _stopPeriodicTask(_periodicTimer);
  }

  void stopTask() {
    _stopPeriodicTask(_periodicTimer);
    BatteryModule.unregisterCallbacksFromAllStates();

    final device = UnregisterDevice(deviceId: DeviceInfo.deviceId);
    HttpModule.unregisterDevice(device);
    HttpModule.clearBaseEndpoint();
  }

  void _stopPeriodicTask(Timer? timer) {
    if (timer == null || !timer.isActive) {
      return;
    }

    _handler.stopBackgroundProcessing();
    BatteryModule.unsubscribeBatteryStateChanges();

    timer.cancel();
    _onStopTaskCallback!();
  }

  static Timer createPeriodicTimer(Duration duration, TimerCallback callback) {
    return Timer.periodic(duration, callback);
  }
}
