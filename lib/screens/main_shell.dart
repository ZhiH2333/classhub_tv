import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import 'dashboard/dashboard_page.dart';
import 'folder/folder_page.dart';
import 'notices/notices_page.dart';
import 'apps/apps_page.dart';
import 'chrome/chrome_page.dart';
import 'posts/posts_page.dart';
import 'settings/settings_page.dart';

/// 主界面外壳
///
/// 布局: Row = NavigationRail(左侧) + Content(右侧)
/// 使用 IndexedStack 保持页面状态
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  /// 所有页面列表
  final List<Widget> _pages = const [
    DashboardPage(),
    FolderPage(),
    NoticesPage(),
    AppsPage(),
    ChromePage(),
    PostsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 左侧导航栏
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: AppTheme.navRailColor,
            minWidth: AppSizes.navRailWidth,
            destinations: NavItem.values.map((item) {
              return NavigationRailDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.icon),
                label: Text(item.label),
                padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.spacingSmall,
                ),
              );
            }).toList(),
          ),
          // 分隔线
          const VerticalDivider(
            thickness: 1,
            width: 1,
            color: AppTheme.surfaceColor,
          ),
          // 右侧内容区域
          Expanded(
            child: IndexedStack(index: _selectedIndex, children: _pages),
          ),
        ],
      ),
    );
  }
}
