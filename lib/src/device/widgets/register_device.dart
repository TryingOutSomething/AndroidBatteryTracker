import 'package:flutter/material.dart';

import '../../api/http_client.dart';

void showRegisterDeviceDialog(BuildContext context) {
  Future(() => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const RegisterDeviceToServer()));
}

class RegisterDeviceToServer extends StatefulWidget {
  const RegisterDeviceToServer({Key? key}) : super(key: key);

  @override
  State<RegisterDeviceToServer> createState() => _RegisterDeviceToServerState();
}

class _RegisterDeviceToServerState extends State<RegisterDeviceToServer> {
  final _controller = TextEditingController();
  bool _inputHasError = false;

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
        decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: "Enter the server's endpoint",
            errorText: _inputHasError ? 'Invalid endpoint!' : null),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              final isValidUrl = HttpClient.isValidUrl(_controller.text);

              if (!isValidUrl) {
                setState(() {
                  _inputHasError = true;
                });

                return;
              }

              HttpClient.setBaseEndPoint(_controller.text);
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

              Navigator.of(context).pop();
            },
            child: const Text('Register Device'))
      ],
    );
  }
}
