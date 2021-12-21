import 'dart:async';

import 'package:flutter/material.dart';

import '../../scheduler/scheduler.dart';
import '../battery_module.dart';

class BatteryInfo extends StatefulWidget {
  const BatteryInfo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BatteryInfoState();
}

class _BatteryInfoState extends State<BatteryInfo> with WidgetsBindingObserver {
  Timer? _timer;
  final int _refreshIntervalSeconds = 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _refreshBatteryInfo(_refreshIntervalSeconds);
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
        _refreshBatteryInfo(_refreshIntervalSeconds);
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

  void _refreshBatteryInfo([int refreshIntervalSeconds = 1]) {
    _timer = Scheduler.createPeriodicTimer(
        Duration(seconds: refreshIntervalSeconds), (timer) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
        future: BatteryModule.batteryLevel,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.toString());
          }

          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return const CircularProgressIndicator();
        });
  }
}
