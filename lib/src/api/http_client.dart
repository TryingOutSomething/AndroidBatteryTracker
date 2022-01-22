import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../api/helpers/service_codes.dart';
import 'dtos/device.dart';
import 'dtos/response.dart';
import 'helpers/routes.dart';

class HttpModule {
  static String? _baseEndpoint;
  static const String _cannotConnectToServerMessage =
      'Unable to connect to server';
  static const Map<String, String> _headers = {
    'Content-type': 'application/json; charset=UTF-8'
  };

  static set baseEndPoint(String url) => _baseEndpoint = url;

  static void clearBaseEndpoint() => _baseEndpoint = '';

  static bool isValidUrl(String url) {
    if (url == '') return false;

    String pattern = r'^(http|https):\/\/[^ "]+$';
    RegExp regex = RegExp(pattern);

    return regex.hasMatch(url);
  }

  static Future<ResponseResult> registerDevice(Device device) async {
    try {
      final response = await http
          .post(Uri.parse(_baseEndpoint! + ApiRoutes.registerDevice),
              headers: _headers, body: jsonEncode(device.toJson()))
          .timeout(const Duration(seconds: 3));

      bool isSuccessfulRequest =
          response.statusCode == 200 || response.statusCode == 201;

      return ResponseResult.fromJson(
          jsonDecode(response.body), isSuccessfulRequest);
    } on SocketException {
      return ResponseResult.unexpectedError(
          ServiceCode.cannotConnectToServer, _cannotConnectToServerMessage);
    } on TimeoutException {
      return ResponseResult.unexpectedError(
          ServiceCode.cannotConnectToServer, _cannotConnectToServerMessage);
    } catch (e) {
      return ResponseResult.unexpectedError(
          ServiceCode.unexpectedError, e.toString());
    }
  }

  static Future<ResponseResult> unregisterDevice(
      UnregisterDevice device) async {
    try {
      final response = await http.delete(
          Uri.parse(_baseEndpoint! + ApiRoutes.unregisterDevice),
          headers: _headers,
          body: jsonEncode(device.toJson()));

      bool isSuccessfulRequest = response.statusCode == 200;

      return ResponseResult.fromJson(
          jsonDecode(response.body), isSuccessfulRequest);
    } on SocketException {
      return ResponseResult.unexpectedError(
          ServiceCode.cannotConnectToServer, _cannotConnectToServerMessage);
    } on TimeoutException {
      return ResponseResult.unexpectedError(
          ServiceCode.cannotConnectToServer, _cannotConnectToServerMessage);
    } catch (e) {
      return ResponseResult.unexpectedError(
          ServiceCode.unexpectedError, e.toString());
    }
  }

  static Future<ResponseResult> emitBatteryLevel(
      DeviceBatteryInfo deviceBatteryInfo) async {
    try {
      final response = await http.put(
          Uri.parse(_baseEndpoint! + ApiRoutes.emitBatteryLevel),
          headers: _headers,
          body: jsonEncode(deviceBatteryInfo));

      bool isSuccessfulRequest = response.statusCode == 200;

      return ResponseResult.fromJson(
          jsonDecode(response.body), isSuccessfulRequest);
    } on SocketException {
      return ResponseResult.unexpectedError(
          ServiceCode.cannotConnectToServer, _cannotConnectToServerMessage);
    } on TimeoutException {
      return ResponseResult.unexpectedError(
          ServiceCode.cannotConnectToServer, _cannotConnectToServerMessage);
    } catch (e) {
      return ResponseResult.unexpectedError(
          ServiceCode.unexpectedError, e.toString());
    }
  }
}
