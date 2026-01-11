import 'package:flutter/services.dart';

import '../screens/apps/models/system_app.dart';

/// 负责与 Android 原生层通信的 Channel
class SystemAppsChannel {
  static const MethodChannel _channel = MethodChannel('classhub/system_apps');

  /// 获取所有已安装的可启动应用
  Future<List<SystemApp>> getInstalledApps() async {
    try {
      final List<dynamic> result = await _channel.invokeMethod(
        'getInstalledApps',
      );
      return result
          .cast<Map<Object?, Object?>>()
          .map((map) => SystemApp.fromMap(map))
          .toList();
    } on PlatformException catch (_) {
      return [];
    }
  }

  /// 启动指定包名的应用
  Future<void> launchApp(String packageName) async {
    try {
      await _channel.invokeMethod('launchApp', {'packageName': packageName});
    } on PlatformException catch (_) {
      // 启动失败忽略
    }
  }
}
