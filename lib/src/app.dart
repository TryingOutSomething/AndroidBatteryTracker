import 'package:client_dart/src/battery/services/battery_module.dart';
import 'package:client_dart/src/error_alert.dart';
import 'package:flutter/material.dart';

import 'battery/widgets/battery_info.dart';
import 'device/widgets/register_device.dart';
import 'scheduler/scheduler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Duration _refreshInterval = const Duration(seconds: 5);
  late Scheduler _scheduler;
  bool _taskStarted = false;

  @override
  void initState() {
    _scheduler = Scheduler(onErrorCallback: showErrorAlertDialog);

    super.initState();

    showRegisterDeviceDialog(context);
  }

  Future<void> showErrorAlertDialog(String error) async {
    showDialog(context: context, builder: (_) => ErrorAlert(error: error));
  }

  void _toggleTaskButtonStates() {
    setState(() {
      _taskStarted = !_taskStarted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BatteryInfo(refreshInterval: _refreshInterval),
            ElevatedButton(
              onPressed: !_taskStarted
                  ? () {
                      if (!BatteryModule.isChargingState) {
                        showErrorAlertDialog(
                            'Ensure device is charging before tracking battery level!');
                        return;
                      }
                      _scheduler.startTask(duration: _refreshInterval);
                      _toggleTaskButtonStates();
                    }
                  : null,
              child: const Text('Start Tracking Battery Level'),
            ),
            ElevatedButton(
              onPressed: _taskStarted
                  ? () {
                      _scheduler.pauseTask();
                      _toggleTaskButtonStates();
                    }
                  : null,
              child: const Text('Stop Tracking Battery Level'),
            ),
            ElevatedButton(
              onPressed: _taskStarted
                  ? () {
                      _scheduler.stopTask();
                      _toggleTaskButtonStates();
                      showRegisterDeviceDialog(context);
                    }
                  : null,
              child: const Text('Unregister Device From Server'),
            )
          ],
        ),
      ),
    );
  }
}
