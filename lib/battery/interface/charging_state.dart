import 'package:client_dart/battery/battery_module.dart';
import 'package:flutter/material.dart';

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
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.hasData) {
            String capitalisedStatus = _getStatusFromEnum(snapshot.data);

            return Text(capitalisedStatus);
          }

          return const CircularProgressIndicator();
        });
  }

  String _getStatusFromEnum(Object? snapshotData) {
    String status = snapshotData.toString().split('.')[1];
    String capitalisedStatus = status[0].toUpperCase() + status.substring(1);

    return capitalisedStatus;
  }
}
