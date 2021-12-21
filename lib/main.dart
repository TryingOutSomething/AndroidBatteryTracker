import 'package:client_dart/battery/interface/battery_info.dart';
import 'package:client_dart/battery/interface/charging_state.dart';
import 'package:client_dart/scheduler/scheduler.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Scheduler _scheduler = Scheduler();

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
            const BatteryInfo(),
            const BatteryChargingStatus(),
            ElevatedButton(
                onPressed: () =>
                    _scheduler.startTask(duration: const Duration(seconds: 5)),
                child: const Text('Request this shit')),
            ElevatedButton(
                onPressed: () => _scheduler.cancelAllTasks(),
                child: const Text('Stop this shit'))
          ],
        ),
      ),
    );
  }
}
