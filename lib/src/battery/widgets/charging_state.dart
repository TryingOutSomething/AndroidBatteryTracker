import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

import '../services/battery_module.dart';

typedef DeviceIsChargingCallback = Function(bool status);

class BatteryChargingStatus extends StatefulWidget {
  late final DeviceIsChargingCallback _onChargingDevice;

  BatteryChargingStatus(
      {Key? key, required DeviceIsChargingCallback onChargingDevice})
      : super(key: key) {
    _onChargingDevice = onChargingDevice;
  }

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
            String dataString = snapshot.data.toString();
            String capitalisedStatus = _getStatusFromEnum(dataString);
            widget._onChargingDevice(_phoneIsCharging(dataString));

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

  bool _phoneIsCharging(String snapshotDataString) {
    BatteryState state = BatteryState.values
        .firstWhere((e) => e.toString() == snapshotDataString);

    return state == BatteryState.charging;
  }
}
