import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../api/dtos/device.dart';
import '../../api/http_client.dart';
import '../../battery/services/battery_module.dart';
import '../services/device_info.dart';

void showRegisterDeviceDialog(BuildContext context) {
  Future(
    () => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: const RegisterDeviceToServer(),
      ),
    ),
  );
}

class RegisterDeviceToServer extends StatefulWidget {
  const RegisterDeviceToServer({Key? key}) : super(key: key);

  @override
  State<RegisterDeviceToServer> createState() => _RegisterDeviceToServerState();
}

class _RegisterDeviceToServerState extends State<RegisterDeviceToServer> {
  final _controller = TextEditingController();
  bool _inputHasError = false;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleLoadingStatus() {
    setState(() {
      _isLoading = !_isLoading;
    });
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
            _toggleLoadingStatus();

            final success = await _registerDevice();

            // if (!success) {
            //   _toggleLoadingStatus();
            //   return;
            // }
            //
            // Navigator.of(context).pop();
            return;
          },
          child: _isLoading
              ? Transform.scale(
                  scale: 0.5,
                  child: const CircularProgressIndicator(),
                )
              : const Text('Register Device'),
        ),
        TextButton(
          onPressed: () => SystemNavigator.pop(animated: true),
          child: const Text(
            'Exit App',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        )
      ],
    );
  }

  Future<bool> _registerDevice() async {
    final isValidUrl = HttpModule.isValidUrl(_controller.text);

    if (!isValidUrl) {
      setState(() {
        _errorMessage = 'Invalid endpoint!';
        _inputHasError = true;
      });

      return false;
    }

    HttpModule.baseEndPoint = _controller.text;

    final device = Device(
        deviceId: DeviceInfo.deviceId,
        deviceName: await DeviceInfo.deviceName,
        batteryLevel: (await BatteryModule.batteryLevel).toString());

    final responseResult = await HttpModule.registerDevice(device);

    if (!responseResult.success) {
      setState(() {
        _errorMessage = responseResult.message;
        _inputHasError = true;
      });
      return false;
    }

    return true;
  }
}
