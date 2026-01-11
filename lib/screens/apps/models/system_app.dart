import 'dart:typed_data';

import 'package:flutter/material.dart';

/// 系统应用数据模型
class SystemApp {
  const SystemApp({
    required this.packageName,
    required this.appName,
    required this.iconBytes,
  });

  final String packageName;
  final String appName;
  final Uint8List iconBytes;

  factory SystemApp.fromMap(Map<Object?, Object?> map) {
    return SystemApp(
      packageName: map['packageName'] as String,
      appName: map['appName'] as String,
      iconBytes: map['iconBytes'] as Uint8List,
    );
  }

  /// 获取图标 Widget
  Widget get iconWidget =>
      Image.memory(iconBytes, fit: BoxFit.contain, gaplessPlayback: true);
}
