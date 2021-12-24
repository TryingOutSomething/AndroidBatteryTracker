import 'dart:convert';

import 'package:client_dart/api/helpers/service_codes.dart';
import 'package:client_dart/api/routes.dart';
import 'package:http/http.dart' as http;

import 'dtos/device.dart';
import 'dtos/response.dart';

class HttpClient {
  static String? _baseEndpoint;
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

  static bool isValidUrl(String url) {
    if (url == '') return false;

    String pattern = r'^(http|https):\/\/[^ "]+$';
    RegExp regex = RegExp(pattern);

    return regex.hasMatch(url);
  }

  static Future<bool> registerDevice(Device device) async {
    final response = await http.post(
        Uri.parse(_baseEndpoint! + ApiRoutes.registerDevice),
        headers: _headers,
        body: jsonEncode(device.toJson()));

    ResponseResult? result = _parseResponse(response);

    switch (result?.serviceCode) {
      case ServiceCode.registerSuccess:
        // TODO: Inform user success
        return true;
      case ServiceCode.registerFailure:
        // TODO: Inform user error
        return false;
      case ServiceCode.fieldEmpty:
        // TODO: Inform user error
        return false;
      case ServiceCode.parameterValidationError:
        // TODO: Inform user error
        return false;
      default:
        // TODO: Inform user error
        return false;
    }
  }

  static Future<bool> unregisterDevice(UnregisterDevice device) async {
    final response = await http.post(
        Uri.parse(_baseEndpoint! + ApiRoutes.unregisterDevice),
        headers: _headers,
        body: jsonEncode(device.toJson()));

    ResponseResult? result = _parseResponse(response);

    switch (result?.serviceCode) {
      case ServiceCode.unregisterSuccess:
        // TODO: Inform user success
        return true;
      case ServiceCode.unregisterFailure:
        // TODO: Inform user error
        return false;
      case ServiceCode.fieldEmpty:
        // TODO: Inform user error
        return false;
      case ServiceCode.parameterValidationError:
        // TODO: Inform user error
        return false;
      default:
        // TODO: Inform user error
        return false;
    }
  }

  static Future<bool> emitBatteryLevel(
      DeviceBatteryInfo deviceBatteryInfo) async {
    final response = await http.put(
        Uri.parse(_baseEndpoint! + ApiRoutes.emitBatteryLevel),
        headers: _headers,
        body: jsonEncode(deviceBatteryInfo));

    ResponseResult? result = _parseResponse(response);

    switch (result?.serviceCode) {
      case ServiceCode.batteryLevelReceived:
        // TODO: Inform user success
        return true;
      case ServiceCode.batteryLevelError:
        // TODO: Inform user error
        return false;
      case ServiceCode.fieldEmpty:
        // TODO: Inform user error
        return false;
      case ServiceCode.parameterValidationError:
        // TODO: Inform user error
        return false;
      case ServiceCode.invalidBatteryRange:
        // TODO: Inform user error
        return false;
      default:
        // TODO: Inform user error
        return false;
    }
  }

  static ResponseResult? _parseResponse(http.Response response) {
    int statusCode = response.statusCode;

    if (statusCode == 502) {
      // TODO: Inform user that server is not up
      return null;
    }

    return ResponseResult.fromJson(jsonDecode(response.body));
  }
}
