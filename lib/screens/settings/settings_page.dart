import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'app_manager_page.dart';

/// Settings 页面 - 包含 App Manager 入口
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 32),

        _SettingsTile(
          icon: Icons.apps,
          title: 'App Launcher Manager',
          subtitle: 'Select apps to show in Launcher',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AppManagerPage()),
            );
          },
        ),
        const SizedBox(height: 16),
        _SettingsTile(
          icon: Icons.info_outline,
          title: 'About',
          subtitle: 'ClassHub TV v1.0.0',
          onTap: () {},
        ),
      ],
    );
  }
}

class _SettingsTile extends StatefulWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  State<_SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<_SettingsTile> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) => setState(() => _isFocused = focused),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _isFocused ? AppTheme.surfaceVariant : AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: _isFocused
                ? Border.all(color: AppTheme.focusColor, width: 2)
                : Border.all(color: Colors.transparent, width: 2),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 32,
                color: _isFocused
                    ? AppTheme.accentColor
                    : AppTheme.textSecondary,
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: _isFocused
                    ? AppTheme.accentColor
                    : AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
