import 'dart:convert';

import 'package:http/http.dart' as http;

import 'dto.dart';

class HttpClient {
  static Uri? _baseEndpoint;
  static const String _registerDeviceRoute = '/device/register';
  static const String _unregisterDeviceRoute = '/device/unregister';
  static const String _emitBatteryLevelRoute = '/battery_level/update';
  static const Map<String, String> _headers = {
    'Content-type': 'application/json; charset=UTF-8'
  };

  static Future<void> sendPost() async {
    print('Sending...');

    final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': 'test',
          'body': 'bodeh',
          'userID': 100
        }));

    print(response.statusCode);
    print(response.body);
  }

  static Future<void> registerDevice(Device device) async {
    // TODO: Handle uri parsing

    final response = await http.post(Uri.parse(''),
        headers: _headers, body: jsonEncode(device.toJson()));
  }

  static Future<void> unregisterDevice(UnregisterDevice device) async {
    // TODO: Handle uri parsing

    final response = await http.post(Uri.parse(''),
        headers: _headers, body: jsonEncode(device.toJson()));
  }

  static Future<void> emitBatteryLevel(
      DeviceBatteryInfo deviceBatteryInfo) async {
    // TODO: Handle uri parsing

    final response = await http.put(Uri.parse(''),
        headers: _headers, body: jsonEncode(deviceBatteryInfo));
  }
}
