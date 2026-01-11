import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Folder 页面
class FolderPage extends StatelessWidget {
  const FolderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Folder',
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }
}
