import 'dart:async';

import 'package:flutter/material.dart';

import '../../battery/widgets/charging_state.dart';
import '../../scheduler/scheduler.dart';
import '../services/battery_module.dart';

typedef DeviceIsChargingCallback = Function(bool status);

class BatteryInfo extends StatefulWidget {
  late final Duration _refreshInterval;
  late final DeviceIsChargingCallback _onChargingDevice;

  BatteryInfo(
      {Key? key,
      required Duration refreshInterval,
      required DeviceIsChargingCallback onChargingDevice})
      : super(key: key) {
    _refreshInterval = refreshInterval;
    _onChargingDevice = onChargingDevice;
  }

  @override
  State<StatefulWidget> createState() => _BatteryInfoState();
}

class _BatteryInfoState extends State<BatteryInfo> with WidgetsBindingObserver {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _refreshBatteryInfo(widget._refreshInterval);
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        setState(() {});
        _refreshBatteryInfo(widget._refreshInterval);
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        _timer?.cancel();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  void _refreshBatteryInfo(Duration duration) {
    _timer =
        Scheduler.createPeriodicTimer(duration, (timer) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<int>(
            future: BatteryModule.batteryLevel,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.toString());
              }

              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              return const CircularProgressIndicator();
            }),
        BatteryChargingStatus(onChargingDevice: widget._onChargingDevice)
      ],
    );
  }
}
