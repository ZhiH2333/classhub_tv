import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Apps 页面
class AppsPage extends StatelessWidget {
  const AppsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Apps',
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }
}
