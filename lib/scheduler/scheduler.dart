import 'dart:async';

import 'package:client_dart/battery/battery_module.dart';
import 'package:client_dart/scheduler/background_process_handler.dart';
import 'package:flutter_background/flutter_background.dart';

typedef TimerCallback = Function(Timer timer);

class Scheduler {
  late Timer _periodicTimer;
  late ProcessHandler _handler;

  Scheduler() {
    FlutterBackgroundAndroidConfig config =
        const FlutterBackgroundAndroidConfig(
            notificationTitle: 'background',
            notificationText: 'running',
            notificationImportance: AndroidNotificationImportance.Default);

    _handler = BackgroundProcessHandler(config);
  }

  void startTask({required Duration duration}) {
    _handler.startBackgroundProcess();

    _periodicTimer = createPeriodicTimer(duration, (timer) async {
      int batteryLevel = await BatteryModule.batteryLevel;
      // TODO: Perform http request to server;
      // BatteryModule.resubscribeToBatteryStateChange();
    });
  }

  void cancelAllTasks() {
    _handler.stopBackgroundProcessing();
    _cancelPeriodicTask();
  }

  void _cancelPeriodicTask() {
    BatteryModule.unsubscribeBatteryStateChanges();
    _periodicTimer.cancel();
  }

  static Timer createPeriodicTimer(Duration duration, TimerCallback callback) {
    return Timer.periodic(duration, callback);
  }
}
