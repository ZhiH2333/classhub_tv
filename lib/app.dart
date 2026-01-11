import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/main_shell.dart';

/// ClassHub TV 应用根 Widget
class ClassHubTVApp extends StatelessWidget {
  const ClassHubTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClassHub TV',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainShell(),
    );
  }
}
