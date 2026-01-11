import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../apps/models/system_app.dart';

/// 系统 App 卡片组件
class SystemAppCard extends StatefulWidget {
  const SystemAppCard({super.key, required this.app, required this.onTap});

  final SystemApp app;
  final VoidCallback onTap;

  @override
  State<SystemAppCard> createState() => _SystemAppCardState();
}

class _SystemAppCardState extends State<SystemAppCard> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) {
        setState(() {
          _isFocused = focused;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _isFocused
                ? AppTheme.selectedBackground
                : AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: _isFocused
                ? Border.all(color: AppTheme.focusColor, width: 2)
                : Border.all(color: Colors.transparent, width: 2),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: AppTheme.focusColor.withValues(alpha: 0.25),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                constraints: const BoxConstraints(minHeight: 96, minWidth: 96),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 图标
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        // 不需要背景色，因为系统图标本身通常是圆角或透明的
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: widget.app.iconWidget,
                    ),
                    const SizedBox(height: 12),
                    // 名称
                    Text(
                      widget.app.appName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _isFocused
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
