import 'dart:async';

import 'package:flutter/material.dart';

import '../../battery/widgets/charging_state.dart';
import '../../scheduler/scheduler.dart';
import '../services/battery_module.dart';

typedef DeviceIsChargingCallback = Function(bool status);

class BatteryInfo extends StatefulWidget {
  late final Duration _refreshInterval;

  BatteryInfo({Key? key, required Duration refreshInterval}) : super(key: key) {
    _refreshInterval = refreshInterval;
  }

  @override
  State<StatefulWidget> createState() => _BatteryInfoState();
}

class _BatteryInfoState extends State<BatteryInfo> with WidgetsBindingObserver {
  Timer? _timer;
  final double _circularIndicatorSize = 200.0;

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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FutureBuilder<int>(
            future: BatteryModule.batteryLevel,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                String batteryLevel = snapshot.data.toString();
                double normalisedLevel = double.parse(batteryLevel) / 100.0;

                Color indicatorColor = Colors.blue;
                if (normalisedLevel < 0.2) {
                  indicatorColor = Colors.red;
                }

                return SizedBox(
                  width: _circularIndicatorSize,
                  height: _circularIndicatorSize,
                  child: Stack(children: <Widget>[
                    ShaderMask(
                      shaderCallback: (rect) {
                        return SweepGradient(
                          center: Alignment.center,
                          startAngle: 0,
                          endAngle: 3.14,
                          stops: [normalisedLevel, normalisedLevel],
                          colors: [indicatorColor, Colors.grey.withAlpha(55)],
                        ).createShader(rect);
                      },
                      child: Container(
                        width: _circularIndicatorSize,
                        height: _circularIndicatorSize,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: _circularIndicatorSize - 30,
                        height: _circularIndicatorSize - 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            '$batteryLevel%',
                            style: const TextStyle(fontSize: 60),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ]),
                );
              }

              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              return const CircularProgressIndicator();
            }),
        const BatteryChargingStatus()
      ],
    );
  }
}
