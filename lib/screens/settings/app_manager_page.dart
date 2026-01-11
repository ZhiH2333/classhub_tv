import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../platform/system_apps_channel.dart';
import '../apps/models/system_app.dart';
import '../apps/services/app_selection_storage.dart';

/// App 管理设置页面
///
/// 允许用户勾选要在 Apps 页面显示的应用
class AppManagerPage extends StatefulWidget {
  const AppManagerPage({super.key});

  @override
  State<AppManagerPage> createState() => _AppManagerPageState();
}

class _AppManagerPageState extends State<AppManagerPage> {
  final _channel = SystemAppsChannel();
  final _storage = AppSelectionStorage();

  List<SystemApp> _allApps = [];
  Set<String> _selectedPackages = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // 并行从原生获取 App 列表 + 读取本地存储的选中项
    final results = await Future.wait([
      _channel.getInstalledApps(),
      _storage.loadSelectedPackageNames(),
    ]);

    final apps = results[0] as List<SystemApp>;
    final selected = results[1] as List<String>;

    if (mounted) {
      setState(() {
        _allApps = apps;
        // 排序：优先按是否选中，再按应用名
        _allApps.sort((a, b) {
          final aSelected = selected.contains(a.packageName);
          final bSelected = selected.contains(b.packageName);
          if (aSelected && !bSelected) return -1;
          if (!aSelected && bSelected) return 1;
          return a.appName.toLowerCase().compareTo(b.appName.toLowerCase());
        });
        _selectedPackages = selected.toSet();
        _isLoading = false;
      });
    }
  }

  void _toggleSelection(String packageName) {
    setState(() {
      if (_selectedPackages.contains(packageName)) {
        _selectedPackages.remove(packageName);
      } else {
        _selectedPackages.add(packageName);
      }
    });
    // save immediately
    _storage.saveSelectedPackageNames(_selectedPackages.toList());
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_allApps.isEmpty) {
      return const Center(child: Text('No apps found'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Apps'),
        backgroundColor: AppTheme.backgroundColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        itemCount: _allApps.length,
        itemBuilder: (context, index) {
          final app = _allApps[index];
          final isSelected = _selectedPackages.contains(app.packageName);

          return _AppCheckItem(
            app: app,
            isSelected: isSelected,
            onToggle: () => _toggleSelection(app.packageName),
          );
        },
      ),
    );
  }
}

class _AppCheckItem extends StatefulWidget {
  const _AppCheckItem({
    required this.app,
    required this.isSelected,
    required this.onToggle,
  });

  final SystemApp app;
  final bool isSelected;
  final VoidCallback onToggle;

  @override
  State<_AppCheckItem> createState() => _AppCheckItemState();
}

class _AppCheckItemState extends State<_AppCheckItem> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) => setState(() => _isFocused = focused),
      child: GestureDetector(
        onTap: widget.onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isFocused ? AppTheme.surfaceVariant : AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: _isFocused
                ? Border.all(color: AppTheme.focusColor, width: 2)
                : Border.all(color: Colors.transparent, width: 2),
          ),
          child: Row(
            children: [
              SizedBox(width: 48, height: 48, child: widget.app.iconWidget),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.app.appName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              if (widget.isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppTheme.accentColor,
                  size: 32,
                )
              else
                Icon(
                  Icons.circle_outlined,
                  color: AppTheme.textSecondary.withValues(alpha: 0.5),
                  size: 32,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
