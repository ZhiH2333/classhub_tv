import 'package:flutter/material.dart';

/// 导航项枚举
enum NavItem {
  dashboard(icon: Icons.dashboard, label: 'Dashboard'),
  folder(icon: Icons.folder, label: 'Folder'),
  notices(icon: Icons.notifications, label: 'Notices'),
  apps(icon: Icons.apps, label: 'Apps'),
  chrome(icon: Icons.public, label: 'Chrome'),
  posts(icon: Icons.article, label: 'Posts'),
  settings(icon: Icons.settings, label: 'Settings');

  const NavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// UI 尺寸常量 - TV 友好设计
class AppSizes {
  AppSizes._();

  /// 导航栏宽度
  static const double navRailWidth = 100.0;

  /// 最小按钮尺寸 (符合 Android TV 规范)
  static const double minButtonSize = 64.0;

  /// 导航图标尺寸
  static const double navIconSize = 32.0;

  /// 页面标题字体大小
  static const double pageTitleSize = 48.0;

  /// 导航标签字体大小
  static const double navLabelSize = 14.0;

  /// 标准间距
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
}
