class ResponseResult {
  final bool success;
  final String serviceCode;
  final String message;

  const ResponseResult(
      {required this.success,
      required this.serviceCode,
      required this.message});

  factory ResponseResult.fromJson(dynamic response, bool successStatus,
      [String? customMessage]) {
    return ResponseResult(
        success: successStatus,
        serviceCode: response['service_code'],
        message: customMessage ?? response['message']);
  }

  factory ResponseResult.connectionError(String serviceCode,
      [String? message]) {
    return ResponseResult(
        success: false,
        serviceCode: serviceCode,
        message: message ?? 'Unable to connect to server!');
  }
}
