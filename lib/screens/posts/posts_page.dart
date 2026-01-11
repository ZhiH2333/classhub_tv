import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Posts 页面
class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Posts',
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }
}
