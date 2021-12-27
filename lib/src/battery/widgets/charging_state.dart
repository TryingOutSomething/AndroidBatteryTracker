import 'package:flutter/material.dart';

import '../services/battery_module.dart';

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
        stream: BatteryModule.chargingStatus,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String capitalisedStatus =
                _getStatusFromEnum(snapshot.data.toString());
            return Text(capitalisedStatus);
          }

          return const CircularProgressIndicator();
        });
  }

  String _getStatusFromEnum(String snapshotDataString) {
    String status = snapshotDataString.split('.').last;
    String capitalisedStatus = status[0].toUpperCase() + status.substring(1);

    return capitalisedStatus;
  }
}
