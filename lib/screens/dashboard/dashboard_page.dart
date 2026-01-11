import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Dashboard 页面
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Dashboard',
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }
}
