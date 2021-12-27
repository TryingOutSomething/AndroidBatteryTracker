import 'package:flutter/material.dart';

import '../../api/dtos/device.dart';
import '../../api/http_client.dart';
import '../../battery/services/battery_module.dart';
import '../services/device_info.dart';

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
  String _errorMessage = '';

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
            errorText: _inputHasError ? _errorMessage : null),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              final isValidUrl = HttpClient.isValidUrl(_controller.text);

              if (!isValidUrl) {
                setState(() {
                  _inputHasError = true;
                  _errorMessage = 'Invalid endpoint!';
                });

                return;
              }

              HttpClient.setBaseEndPoint(_controller.text);

              // TODO: Move this to top level. Battery level must always be updated
              final device = Device(
                  deviceId: DeviceInfo.deviceId,
                  deviceName: await DeviceInfo.deviceName,
                  batteryLevel: (await BatteryModule.batteryLevel).toString());

              final responseResult = await HttpClient.registerDevice(device);

              if (!responseResult.success) {
                _errorMessage = responseResult.message;
                _inputHasError = true;
                return;
              }

              Navigator.of(context).pop();
            },
            child: const Text('Register Device'))
      ],
    );
  }
}
