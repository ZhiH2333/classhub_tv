import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

/// ClassHub TV 主题配置 - TV 优化的深色主题
class AppTheme {
  AppTheme._();

  /// 主色调
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color primaryVariant = Color(0xFF4F46E5);

  /// 背景色
  static const Color backgroundColor = Color(0xFF0F172A); // Slate-900
  static const Color surfaceColor = Color(0xFF1E293B); // Slate-800

  /// 导航栏颜色
  static const Color navRailColor = Color(0xFF1E293B);
  static const Color navRailSelectedColor = Color(0xFF6366F1);

  /// 文字颜色
  static const Color textPrimary = Color(0xFFF8FAFC); // Slate-50
  static const Color textSecondary = Color(0xFF94A3B8); // Slate-400

  /// 焦点颜色
  static const Color focusColor = Color(0xFF818CF8); // Indigo-400

  /// 深色主题
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryVariant,
        surface: surfaceColor,
        onPrimary: textPrimary,
        onSecondary: textPrimary,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: backgroundColor,

      // 文字主题
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: AppSizes.pageTitleSize,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 18, color: textPrimary),
        labelMedium: TextStyle(
          fontSize: AppSizes.navLabelSize,
          color: textSecondary,
        ),
      ),

      // 导航栏主题
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: navRailColor,
        selectedIconTheme: const IconThemeData(
          color: navRailSelectedColor,
          size: AppSizes.navIconSize,
        ),
        unselectedIconTheme: IconThemeData(
          color: textSecondary,
          size: AppSizes.navIconSize,
        ),
        selectedLabelTextStyle: const TextStyle(
          color: navRailSelectedColor,
          fontSize: AppSizes.navLabelSize,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: textSecondary,
          fontSize: AppSizes.navLabelSize,
        ),
        indicatorColor: primaryColor.withValues(alpha: 0.2),
      ),

      // 按钮主题 - TV 友好的大按钮
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(
            AppSizes.minButtonSize,
            AppSizes.minButtonSize,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingLarge,
            vertical: AppSizes.spacingMedium,
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),

      // 焦点主题
      focusColor: focusColor,
    );
  }
}
