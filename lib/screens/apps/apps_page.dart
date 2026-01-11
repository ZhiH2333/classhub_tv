import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'models/app_item.dart';
import 'widgets/app_card.dart';

/// Apps 页面 - 本地 App Launcher
class AppsPage extends StatelessWidget {
  const AppsPage({super.key});

  void _launchApp(BuildContext context, AppItem app) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Launching ${app.name}'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 页面标题
        const Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Apps',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ),

        // App Grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // 根据屏幕宽度计算每行数量 (96dp 卡片 + 16dp 间距)
                final crossAxisCount = (constraints.maxWidth / 140)
                    .floor()
                    .clamp(4, 6);

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: mockApps.length,
                  itemBuilder: (context, index) {
                    final app = mockApps[index];
                    return AppCard(
                      app: app,
                      onTap: () => _launchApp(context, app),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
