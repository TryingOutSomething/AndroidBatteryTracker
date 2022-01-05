import 'dart:async';

import 'package:flutter/material.dart';

import '../../battery/widgets/charging_state.dart';
import '../../scheduler/scheduler.dart';
import '../services/battery_module.dart';
import 'progress_bar/circular_progress.dart';

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
                Color progressColour = _getProgressBarColour(normalisedLevel);

                return Expanded(
                  child: AspectRatio(
                    aspectRatio: 0.7,
                    child: Stack(
                      children: [
                        Center(
                          child: CircularProgress(
                            circleColour: progressColour,
                            percentage: normalisedLevel,
                            strokeWidth: 15,
                          ),
                        ),
                        const Align(
                          child: BatteryChargingStatus(),
                          alignment: Alignment(0, -0.5),
                        ),
                        Center(
                          child: FittedBox(
                            child: Text(
                              '$batteryLevel%',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              return const CircularProgressIndicator();
            }),
      ],
    );
  }

  Color _getProgressBarColour(double percentage) {
    Color color = Colors.green;

    if (percentage < 0.3) {
      color = Colors.red;
    } else if (percentage < 0.7) {
      color = Colors.orange;
    }

    return color;
  }
}
