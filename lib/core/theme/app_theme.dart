import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

/// ClassHub TV 主题配置 - Material You · Android TV 风格
class AppTheme {
  AppTheme._();

  // ============================================================
  // 背景层级 (Material You Android TV)
  // ============================================================

  /// Scaffold 背景
  static const Color backgroundColor = Color(0xFF121212);

  /// NavigationRail 背景
  static const Color navRailColor = Color(0xFF1C1C1C);

  /// Content 区域背景
  static const Color contentBackground = Color(0xFF181818);

  /// Card / Surface 背景
  static const Color surfaceColor = Color(0xFF222222);

  /// 略微提亮的 Surface（用于 hover / 次级卡片）
  static const Color surfaceVariant = Color(0xFF2A2A2A);

  // ============================================================
  // 文字颜色
  // ============================================================

  /// 主要文字
  static const Color textPrimary = Color(0xFFE0E0E0);

  /// 次级文字
  static const Color textSecondary = Color(0xFF9E9E9E);

  /// 禁用状态文字
  static const Color textDisabled = Color(0xFF616161);

  // ============================================================
  // 强调色（仅用于选中 / focus）
  // ============================================================

  /// 浅蓝灰强调色
  static const Color accentColor = Color(0xFF8AB4F8);

  /// Focus 边框颜色
  static const Color focusColor = Color(0xFF8AB4F8);

  /// 选中态背景（略微提亮）
  static const Color selectedBackground = Color(0xFF2D2D2D);

  // ============================================================
  // 兼容旧代码的别名
  // ============================================================

  static const Color primaryColor = accentColor;
  static const Color primaryVariant = Color(0xFF6B9BF0);
  static const Color navRailSelectedColor = accentColor;

  // ============================================================
  // 深色主题
  // ============================================================

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: accentColor,
        secondary: accentColor,
        surface: surfaceColor,
        onPrimary: Color(0xFF121212),
        onSecondary: Color(0xFF121212),
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: backgroundColor,

      // 文字主题 - 适合远距离观看
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: AppSizes.pageTitleSize,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 0.5,
          height: 1.3,
        ),
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          height: 1.4,
        ),
        titleMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: textPrimary,
          height: 1.4,
        ),
        bodyLarge: TextStyle(fontSize: 18, color: textPrimary, height: 1.5),
        bodyMedium: TextStyle(fontSize: 16, color: textPrimary, height: 1.5),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: AppSizes.navLabelSize,
          color: textSecondary,
        ),
      ),

      // 导航栏主题 - Android TV 风格
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: navRailColor,
        elevation: 0,
        selectedIconTheme: const IconThemeData(
          color: accentColor,
          size: AppSizes.navIconSize,
        ),
        unselectedIconTheme: const IconThemeData(
          color: textSecondary,
          size: AppSizes.navIconSize,
        ),
        selectedLabelTextStyle: const TextStyle(
          color: accentColor,
          fontSize: AppSizes.navLabelSize,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: const TextStyle(
          color: textSecondary,
          fontSize: AppSizes.navLabelSize,
        ),
        indicatorColor: accentColor.withValues(alpha: 0.15),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Card 主题
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
      ),

      // 按钮主题 - TV 友好
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: surfaceVariant,
          foregroundColor: textPrimary,
          elevation: 0,
          minimumSize: const Size(
            AppSizes.minButtonSize,
            AppSizes.minButtonSize,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingLarge,
            vertical: AppSizes.spacingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),

      // 文本按钮
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          minimumSize: const Size(64, 48),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),

      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: TextStyle(color: textSecondary.withValues(alpha: 0.5)),
      ),

      // Dialog 主题
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // Divider 主题
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A2A2A),
        thickness: 1,
        space: 1,
      ),

      // SnackBar 主题
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceVariant,
        contentTextStyle: const TextStyle(color: textPrimary, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),

      // 进度条主题
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: accentColor,
        linearTrackColor: Color(0xFF2A2A2A),
      ),

      // 焦点主题
      focusColor: focusColor,
    );
  }
}
