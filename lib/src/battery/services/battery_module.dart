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

  static StreamSubscription? _chargingStateSubscription;
  static bool _chargingStateIsSubscribed = false;
  static BatteryState _chargingStatus = BatteryState.unknown;

  static Future<int> get batteryLevel async => await _instance.batteryLevel;

  static Stream get chargingStatusStream => _instance.onBatteryStateChanged;

  static set chargingStatus(BatteryState state) => _chargingStatus = state;

  static bool get isChargingState => _chargingStatus == BatteryState.charging;

  static void registerCallback(BatteryState state, Function callback) {
    if (_stateCallbackMap[state]!.contains(callback)) {
      return;
    }

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
    _chargingStateSubscription =
        _instance.onBatteryStateChanged.listen((BatteryState state) {
      _invokeStateCallbacks(state);
    });

    _chargingStateIsSubscribed = true;
  }

  static void unsubscribeBatteryStateChanges() {
    if (!_chargingStateIsSubscribed) {
      return;
    }
    _chargingStateSubscription?.cancel();
    _chargingStateIsSubscribed = false;
  }
}
