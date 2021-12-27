class ResponseResult {
  final String serviceCode;
  final String message;

  const ResponseResult({required this.serviceCode, required this.message});

  factory ResponseResult.fromJson(dynamic response) {
    return ResponseResult(
        serviceCode: response['service_code'], message: response['message']);
  }
}
