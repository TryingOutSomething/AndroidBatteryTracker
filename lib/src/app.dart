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
  DateTime _firstBackPress = DateTime.now();
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
    final TextStyle _textStyle = TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.04,
    );

    final ButtonStyle _elevatedButtonStyle = ElevatedButton.styleFrom(
      primary: Colors.deepPurple.shade600,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      minimumSize: const Size(350, 60),
      textStyle: _textStyle,
    );

    return WillPopScope(
      onWillPop: () async {
        final canExitApp = _promptExitApp(context);

        if (canExitApp) {
          _scheduler.stopTask();
        }

        return canExitApp;
      },
      child: Scaffold(
        body: GridView.count(
          crossAxisCount: 2,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            BatteryInfo(
              refreshInterval: const Duration(minutes: 1),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  child: _isTrackingIndicator(_textStyle),
                  visible: _taskStarted,
                ),
                ElevatedButton(
                  style: _elevatedButtonStyle,
                  onPressed: !_taskStarted
                      ? () => _startTrackingDeviceBattery()
                      : null,
                  child: const Text('Start Tracking Battery Level'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton(
                    style: _elevatedButtonStyle,
                    onPressed: _taskStarted ? () => _pauseTask() : null,
                    child: const Text(
                      'Stop Tracking Battery Level',
                    ),
                  ),
                ),
                ElevatedButton(
                  style: _elevatedButtonStyle,
                  onPressed: () => _stopTaskAndUnregisterDevice(),
                  child: const Text(
                    'Unregister Device From Server',
                  ),
                )
              ],
            ),
          ],
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
      duration: const Duration(minutes: 5),
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
    const backPressInterval = Duration(seconds: 2);

    final timeDifference = DateTime.now().difference(_firstBackPress);
    final canExitApp = timeDifference < backPressInterval;
    _firstBackPress = DateTime.now();

    if (canExitApp) {
      return true;
    }

    const snack = SnackBar(
      content: Text('Press Back button again to Exit'),
      duration: backPressInterval,
    );

    ScaffoldMessenger.of(context).showSnackBar(snack);
    return false;
  }

  Padding _isTrackingIndicator(TextStyle _textStyle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Transform.scale(
            scale: 0.5,
            child: const CircularProgressIndicator(),
          ),
          Text(
            'Tracking Battery Level',
            style: _textStyle,
          )
        ],
      ),
    );
  }
}
