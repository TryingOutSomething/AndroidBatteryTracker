import 'package:flutter/material.dart';

import 'battery/services/battery_module.dart';
import 'battery/widgets/battery_info.dart';
import 'device/widgets/register_device.dart';
import 'error_alert.dart';
import 'scheduler/scheduler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _backPressedCounter = 0;
  final Duration _refreshInterval = const Duration(seconds: 5);
  late Scheduler _scheduler;
  bool _taskStarted = false;

  @override
  void initState() {
    _scheduler = Scheduler(onErrorCallback: _showErrorAlertDialog);

    super.initState();

    showRegisterDeviceDialog(context);
  }

  Future<void> _showErrorAlertDialog(String error) async {
    showDialog(context: context, builder: (_) => ErrorAlert(error: error));
  }

  void _setTaskStartedStatus() {
    setState(() {
      _taskStarted = true;
    });
  }

  void _setTaskStoppedStatus() {
    if (!_taskStarted) return;

    setState(() {
      _taskStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final canExitApp = _promptExitApp(context);

        if (canExitApp) {
          _scheduler.stopTask();
        }

        return canExitApp;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              BatteryInfo(refreshInterval: _refreshInterval),
              ElevatedButton(
                onPressed:
                    !_taskStarted ? () => _startTrackingDeviceBattery() : null,
                child: const Text('Start Tracking Battery Level'),
              ),
              ElevatedButton(
                onPressed: _taskStarted ? () => _pauseTask() : null,
                child: const Text('Stop Tracking Battery Level'),
              ),
              ElevatedButton(
                onPressed: () => _stopTaskAndUnregisterDevice(),
                child: const Text('Unregister Device From Server'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _startTrackingDeviceBattery() {
    if (!BatteryModule.isChargingState) {
      _showErrorAlertDialog(
          'Ensure device is charging before tracking battery level!');
      return;
    }

    _scheduler.startTask(
      duration: _refreshInterval,
      onStopTaskCallback: _setTaskStoppedStatus,
    );

    _setTaskStartedStatus();
  }

  void _pauseTask() {
    _scheduler.pauseTask();
  }

  void _stopTaskAndUnregisterDevice() {
    _scheduler.stopTask();
    showRegisterDeviceDialog(context);
  }

  bool _promptExitApp(BuildContext context) {
    ++_backPressedCounter;

    if (_backPressedCounter >= 2) return true;

    const snackBar = SnackBar(
      content: Text('Press Back Button again to Exit'),
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    return false;
  }
}
