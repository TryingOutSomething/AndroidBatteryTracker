import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

import '../services/battery_module.dart';

typedef DeviceIsChargingCallback = Function(bool status);

class BatteryChargingStatus extends StatefulWidget {
  const BatteryChargingStatus({Key? key}) : super(key: key);

  @override
  _BatteryChargingStatusState createState() => _BatteryChargingStatusState();
}

class _BatteryChargingStatusState extends State<BatteryChargingStatus> {
  @override
  void dispose() {
    super.dispose();
    BatteryModule.unsubscribeBatteryStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: BatteryModule.chargingStatusStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String dataString = snapshot.data.toString();
            BatteryModule.chargingStatus = _toEnum(dataString);

            return Visibility(
              visible: BatteryModule.isChargingState,
              child: Icon(
                Icons.bolt,
                size: MediaQuery.of(context).size.width * 0.1,
              ),
            );
          }

          BatteryModule.chargingStatus = BatteryState.unknown;
          return const CircularProgressIndicator();
        });
  }

  BatteryState _toEnum(String snapshotDataString) {
    return BatteryState.values
        .firstWhere((e) => e.toString() == snapshotDataString);
  }
}
