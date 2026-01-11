import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';

/// TV 友好的大按钮组件
///
/// 特性:
/// - 最小尺寸 64dp (符合 Android TV 规范)
/// - 支持图标 + 标签
/// - 焦点状态视觉反馈
/// - 触摸友好
class TvButton extends StatefulWidget {
  const TvButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.autofocus = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool autofocus;

  @override
  State<TvButton> createState() => _TvButtonState();
}

class _TvButtonState extends State<TvButton> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: widget.autofocus,
      onFocusChange: (focused) {
        setState(() {
          _isFocused = focused;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: _isFocused
              ? Border.all(color: AppTheme.focusColor, width: 3)
              : null,
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: AppTheme.focusColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isFocused
                ? AppTheme.primaryColor
                : AppTheme.surfaceColor,
            foregroundColor: AppTheme.textPrimary,
            minimumSize: const Size(
              AppSizes.minButtonSize * 2,
              AppSizes.minButtonSize,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacingLarge,
              vertical: AppSizes.spacingMedium,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 24),
                const SizedBox(width: AppSizes.spacingSmall),
              ],
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
