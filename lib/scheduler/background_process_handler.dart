import 'package:flutter_background/flutter_background.dart';

abstract class ProcessHandler {
  void initialiseBackgroundProcess();

  void startBackgroundProcess();

  void stopBackgroundProcessing();
}

class BackgroundProcessHandler implements ProcessHandler {
  late FlutterBackgroundAndroidConfig _config;

  BackgroundProcessHandler(FlutterBackgroundAndroidConfig config) {
    _config = config;

    initialiseBackgroundProcess();
  }

  @override
  void startBackgroundProcess() async {
    bool success = await FlutterBackground.enableBackgroundExecution();

    if (!success) {
      print('cannot allow background exe');
      return;
    }

    print('done');
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
    bool hasPermission = await FlutterBackground.hasPermissions;

    if (!hasPermission) {
      print('enable perms');
      // TODO: Add notification to prompt enable notifications
    }

    await FlutterBackground.initialize(androidConfig: _config);
  }
}
