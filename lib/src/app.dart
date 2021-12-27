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
  final Scheduler _scheduler = Scheduler();
  final Duration _refreshInterval = const Duration(seconds: 5);

  @override
  void initState() {
    super.initState();

    showRegisterDeviceDialog();
  }

  void showRegisterDeviceDialog() {
    Future(() => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const RegisterDeviceToServer()));
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
            BatteryInfo(_refreshInterval),
            ElevatedButton(
                onPressed: () =>
                    _scheduler.startTask(duration: _refreshInterval),
                child: const Text('Request this shit')),
            ElevatedButton(
                onPressed: () => _scheduler.cancelAllTasks(),
                child: const Text('Stop this shit')),
            ElevatedButton(
                onPressed: () => showRegisterDeviceDialog(),
                child: const Text('Popup'))
          ],
        ),
      ),
    );
  }
}
