import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../api/helpers/service_codes.dart';
import '../api/routes.dart';
import 'dtos/device.dart';
import 'dtos/response.dart';

class HttpClient {
  static String? _baseEndpoint;
  static const String _cannotConnectToServerMessage =
      'Unable to connect to server';
  static const Map<String, String> _headers = {
    'Content-type': 'application/json; charset=UTF-8'
  };

  static bool setBaseEndPoint(String url) {
    if (!isValidUrl(url)) {
      return false;
    }

    _baseEndpoint = url;

    return true;
  }

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

      return ResponseResult.fromJson(response, true);
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
      final response = await http.post(
          Uri.parse(_baseEndpoint! + ApiRoutes.unregisterDevice),
          headers: _headers,
          body: jsonEncode(device.toJson()));

      return ResponseResult.fromJson(response, true);
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

      return ResponseResult.fromJson(response, true);
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
