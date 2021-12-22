import 'dart:async';

import 'package:battery_plus/battery_plus.dart';

class BatteryModule {
  static final Battery _instance = Battery();
  static final Map<BatteryState, List<Function>> _stateCallbackMap = {
    BatteryState.full: <Function>[],
    BatteryState.charging: <Function>[],
    BatteryState.discharging: <Function>[],
    BatteryState.unknown: <Function>[],
  };

  static StreamSubscription? _chargingStateController;

  static Future<int> get batteryLevel async => await _instance.batteryLevel;

  static Stream get chargingStatus => _instance.onBatteryStateChanged;

  static void registerCallback(BatteryState state, Function callback) {
    _stateCallbackMap[state]?.add(callback);
  }

  static void _unregisterCallbacksFromState(BatteryState state) {
    _stateCallbackMap[state]?.clear();
  }

  static void unregisterCallbacksFromAllStates() {
    for (BatteryState state in BatteryState.values) {
      _unregisterCallbacksFromState(state);
    }
  }

  static void _invokeStateCallbacks(BatteryState state) {
    for (Function fn in _stateCallbackMap[state]!) {
      fn();
    }
  }

  static void subscribeToBatteryStateChange() {
    _chargingStateController =
        _instance.onBatteryStateChanged.listen((BatteryState state) {
      _invokeStateCallbacks(state);

      switch (state) {
        case BatteryState.full:
          _chargingStateController?.pause();
          break;
        case BatteryState.charging:
          break;
        case BatteryState.discharging:
          _chargingStateController?.pause();
          break;
        case BatteryState.unknown:
          break;
      }
    });
  }

  static void unsubscribeBatteryStateChanges() {
    _chargingStateController?.cancel();
  }
}
