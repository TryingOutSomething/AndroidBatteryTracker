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

  @override
  void initState() {
    super.initState();

    showRegisterDeviceDialog(context);
  }

  Future<void> showErrorAlertDialog(String error) async {
    showDialog(context: context, builder: (_) => ErrorAlert(error: error));
  }

  @override
  Widget build(BuildContext context) {
    final Scheduler _scheduler =
        Scheduler(onErrorCallback: showErrorAlertDialog);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BatteryInfo(_refreshInterval),
            ElevatedButton(
                onPressed: () =>
                    _scheduler.startTask(duration: _refreshInterval),
                child: const Text('Start Tracking Battery Level')),
            ElevatedButton(
                onPressed: () => _scheduler.cancelAllTasks(),
                child: const Text('Stop Tracking Battery Level')),
            ElevatedButton(
                onPressed: () {
                  _scheduler.cancelAllTasks();
                  showRegisterDeviceDialog(context);
                },
                child: const Text('Unregister Device From Server'))
          ],
        ),
      ),
    );
  }
}
