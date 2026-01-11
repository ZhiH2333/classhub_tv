import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../platform/system_apps_channel.dart';
import '../apps/models/system_app.dart';
import '../apps/services/app_selection_storage.dart';
import '../settings/widgets/system_app_card.dart';

/// Apps 页面 - 显示用户勾选的系统应用
class AppsPage extends StatefulWidget {
  const AppsPage({super.key});

  @override
  State<AppsPage> createState() => _AppsPageState();
}

class _AppsPageState extends State<AppsPage> {
  final _channel = SystemAppsChannel();
  final _storage = AppSelectionStorage();

  List<SystemApp> _displayedApps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  /// 每次页面可见时可能需要刷新（如果从 Settings 回来）
  /// 这里简单处理：初始化加载。实际项目中可以使用 RouteAware 或 Provider 监听。
  /// 由于当前架构是 IndexedStack，页面状态保持，所以提供一个刷新按钮更合适。
  Future<void> _loadApps() async {
    setState(() => _isLoading = true);

    try {
      final allApps = await _channel.getInstalledApps();
      final selectedPackages = await _storage.loadSelectedPackageNames();
      final selectedSet = selectedPackages.toSet();

      final filtered = allApps
          .where((app) => selectedSet.contains(app.packageName))
          .toList();

      // 按名称排序
      filtered.sort(
        (a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()),
      );

      setState(() {
        _displayedApps = filtered;
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  void _launchApp(SystemApp app) {
    _channel.launchApp(app.packageName);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Launching ${app.appName}...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 顶部标题
        Padding(
          padding: const EdgeInsets.all(32),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Apps',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              // 刷新按钮
              IconButton(
                onPressed: _loadApps,
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh Apps',
              ),
            ],
          ),
        ),

        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _displayedApps.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.apps_outage,
                        size: 64,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No apps selected',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Go to Settings to add apps',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Adaptive columns
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
                        itemCount: _displayedApps.length,
                        itemBuilder: (context, index) {
                          final app = _displayedApps[index];
                          return SystemAppCard(
                            app: app,
                            onTap: () => _launchApp(app),
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
