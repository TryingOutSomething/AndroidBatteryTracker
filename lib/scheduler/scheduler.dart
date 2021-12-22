import 'dart:async';

import 'package:flutter_background/flutter_background.dart';

import '../battery/services/battery_module.dart';
import 'background_process_handler.dart';

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

    List<Function> callbacks = <Function>[cancelAllTasks];
    BatteryModule.registerCallbacks(
        onBatteryFull: callbacks, onBatteryDischarging: callbacks);
    BatteryModule.subscribeToBatteryStateChange();

    _periodicTimer = createPeriodicTimer(duration, (timer) async {
      int batteryLevel = await BatteryModule.batteryLevel;
      // TODO: Perform http request to server;
    });
  }

  void cancelAllTasks() {
    print('cancelling');
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
