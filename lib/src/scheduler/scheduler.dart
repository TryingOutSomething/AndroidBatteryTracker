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
  late Timer _periodicTimer;
  late ProcessHandler _handler;
  late final ErrorMessageCallback _onErrorCallback;

  Scheduler({required ErrorMessageCallback onErrorCallback}) {
    FlutterBackgroundAndroidConfig config =
        const FlutterBackgroundAndroidConfig(
            notificationTitle: 'background',
            notificationText: 'running',
            notificationImportance: AndroidNotificationImportance.Default);

    _handler = BackgroundProcessHandler(config);
    _onErrorCallback = onErrorCallback;
  }

  void startTask({required Duration duration}) {
    _handler.startBackgroundProcess();

    BatteryModule.registerCallback(BatteryState.full, cancelAllTasks);
    BatteryModule.registerCallback(BatteryState.discharging, cancelAllTasks);
    BatteryModule.subscribeToBatteryStateChange();

    _periodicTimer = createPeriodicTimer(duration, _emitBatteryInfoToServer);
  }

  Future<void> _emitBatteryInfoToServer(Timer timer) async {
    final device = DeviceBatteryInfo(
        deviceId: DeviceInfo.deviceId,
        batteryLevel: (await BatteryModule.batteryLevel).toString());

    final responseResult = await HttpClient.emitBatteryLevel(device);

    if (responseResult.success) {
      return;
    }

    _handleError(responseResult);
  }

  void _handleError(ResponseResult result) {
    // TODO: activate error alert
    switch (result.serviceCode) {
      case ServiceCode.batteryLevelError:
        _onErrorCallback('');
        break;
      case ServiceCode.invalidBatteryRange:
        _onErrorCallback('');
        break;
      case ServiceCode.fieldEmpty:
        _onErrorCallback('');
        break;
      case ServiceCode.parameterValidationError:
        _onErrorCallback('');
        break;
      case ServiceCode.unexpectedError:
        _onErrorCallback('');
        break;
      case ServiceCode.cannotConnectToServer:
        _onErrorCallback('');
        break;
    }
  }

  void cancelAllTasks() {
    _handler.stopBackgroundProcessing();
    _cancelPeriodicTask();
  }

  void _cancelPeriodicTask() {
    BatteryModule.unsubscribeBatteryStateChanges();
    BatteryModule.unregisterCallbacksFromAllStates();
    _periodicTimer.cancel();
  }

  static Timer createPeriodicTimer(Duration duration, TimerCallback callback) {
    return Timer.periodic(duration, callback);
  }
}
