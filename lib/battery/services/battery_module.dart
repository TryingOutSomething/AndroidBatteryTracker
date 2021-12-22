import 'dart:async';

import 'package:battery_plus/battery_plus.dart';

class BatteryModule {
  static final Battery _instance = Battery();
  static List<Function>? _onBatteryFull;
  static List<Function>? _onBatteryCharging;
  static List<Function>? _onBatteryDischarging;
  static StreamSubscription? _chargingStateController;

  static Future<int> get batteryLevel async => await _instance.batteryLevel;

  static Stream get chargingStatus => _instance.onBatteryStateChanged;

  static void registerCallbacks(
      {List<Function>? onBatteryFull,
      List<Function>? onBatteryCharging,
      List<Function>? onBatteryDischarging}) {
    _ensureCallbackListsInitialised();

    _onBatteryFull?.addAll(onBatteryFull!);
    _onBatteryCharging?.addAll(onBatteryCharging!);
    _onBatteryDischarging?.addAll(onBatteryDischarging!);
  }

  static void _ensureCallbackListsInitialised() {
    _onBatteryFull ??= <Function>[];
    _onBatteryCharging ??= <Function>[];
    _onBatteryDischarging ??= <Function>[];
  }

  static void subscribeToBatteryStateChange() {
    _ensureCallbackListsInitialised();

    _chargingStateController =
        _instance.onBatteryStateChanged.listen((BatteryState state) {
      switch (state) {
        case BatteryState.full:
          for (Function fn in _onBatteryFull!) {
            fn();
          }
          _chargingStateController?.pause();
          break;
        case BatteryState.charging:
          for (Function fn in _onBatteryCharging!) {
            fn();
          }
          break;
        case BatteryState.discharging:
          for (Function fn in _onBatteryDischarging!) {
            fn();
          }

          _chargingStateController?.pause();
          break;
        case BatteryState.unknown:
          // TODO: Handle this case.
          break;
      }
    });
  }

  static void unsubscribeBatteryStateChanges() {
    _chargingStateController?.cancel();
  }
}
