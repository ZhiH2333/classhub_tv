import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Chrome 页面
class ChromePage extends StatelessWidget {
  const ChromePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Chrome',
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }
}
