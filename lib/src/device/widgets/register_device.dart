import 'package:flutter/material.dart';

class RegisterDeviceToServer extends StatefulWidget {
  const RegisterDeviceToServer({Key? key}) : super(key: key);

  @override
  State<RegisterDeviceToServer> createState() => _RegisterDeviceToServerState();
}

class _RegisterDeviceToServerState extends State<RegisterDeviceToServer> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Server Connection'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: "Enter the server's endpoint"),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              // final isValidUrl = HttpClient.isValidUrl(_controller.text);
              //
              // if (!isValidUrl) {
              //   return;
              // }
              //
              // HttpClient.setBaseEndPoint(_controller.text);
              //
              // // TODO: Move this to top level. Battery level must always be updated
              // final device = Device(
              //     deviceId: DeviceInfo.deviceId,
              //     deviceName: await DeviceInfo.deviceName,
              //     batteryLevel: (await BatteryModule.batteryLevel).toString());
              //
              // final success = await HttpClient.registerDevice(device);
              //
              // if (!success) {
              //   return;
              // }

              Navigator.pop(context);
            },
            child: const Text('Register Device'))
      ],
    );
  }
}
