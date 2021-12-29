import 'package:flutter_background/flutter_background.dart';

abstract class ProcessHandler {
  void initialiseBackgroundProcess();

  void startBackgroundProcess();

  void stopBackgroundProcessing();
}

typedef ErrorMessageCallback = Function(String error);

class BackgroundProcessHandler implements ProcessHandler {
  late final FlutterBackgroundAndroidConfig _config;
  late final ErrorMessageCallback _onErrorCallback;

  BackgroundProcessHandler(
      {required FlutterBackgroundAndroidConfig config,
      required ErrorMessageCallback onErrorCallback}) {
    _config = config;
    _onErrorCallback = onErrorCallback;

    initialiseBackgroundProcess();
  }

  @override
  void startBackgroundProcess() async {
    bool success = await FlutterBackground.enableBackgroundExecution();

    if (success) {
      return;
    }

    _onErrorCallback('Unable to start service in background.');
  }

  @override
  void stopBackgroundProcessing() {
    if (!FlutterBackground.isBackgroundExecutionEnabled) {
      return;
    }

    FlutterBackground.disableBackgroundExecution();
  }

  @override
  void initialiseBackgroundProcess() async {
    await FlutterBackground.hasPermissions;
    await FlutterBackground.initialize(androidConfig: _config);
  }
}
