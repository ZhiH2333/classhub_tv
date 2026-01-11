import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Recent App 数据模型
class RecentApp {
  const RecentApp({required this.name, required this.icon});

  final String name;
  final IconData icon;
}

/// Storage 数据模型
class StorageInfo {
  const StorageInfo({
    required this.name,
    required this.usedGB,
    required this.totalGB,
    required this.icon,
  });

  final String name;
  final double usedGB;
  final double totalGB;
  final IconData icon;

  double get usageRatio => usedGB / totalGB;
  String get usedText => '${usedGB.toStringAsFixed(0)}GB';
  String get totalText => '${totalGB.toStringAsFixed(0)}GB';
}

/// Mock 数据
const List<RecentApp> _mockRecentApps = [
  RecentApp(name: 'YouTube', icon: Icons.play_circle_fill),
  RecentApp(name: 'Netflix', icon: Icons.movie),
  RecentApp(name: 'Spotify', icon: Icons.music_note),
  RecentApp(name: 'Gallery', icon: Icons.photo_library),
  RecentApp(name: 'Camera', icon: Icons.camera_alt),
  RecentApp(name: 'Files', icon: Icons.folder),
];

const StorageInfo _mockLocalStorage = StorageInfo(
  name: 'Local Storage',
  usedGB: 7,
  totalGB: 16,
  icon: Icons.storage,
);

const StorageInfo _mockUsbStorage = StorageInfo(
  name: 'USB Storage',
  usedGB: 1,
  totalGB: 16,
  icon: Icons.usb,
);

/// Dashboard 页面
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 页面标题
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 32),

          // 三区域布局
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左侧：时间日期
              Expanded(
                flex: 2,
                child: _DateTimeCard(currentTime: _currentTime),
              ),
              const SizedBox(width: 24),

              // 右侧：Storage 状态
              Expanded(flex: 1, child: _StorageSection()),
            ],
          ),
          const SizedBox(height: 32),

          // Recent Apps 区域
          _RecentAppsSection(),
        ],
      ),
    );
  }
}

/// 时间日期卡片
class _DateTimeCard extends StatelessWidget {
  const _DateTimeCard({required this.currentTime});

  final DateTime currentTime;

  String get _weekday {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weekdays[currentTime.weekday - 1];
  }

  String get _date {
    return '${currentTime.year}.${currentTime.month.toString().padLeft(2, '0')}.${currentTime.day.toString().padLeft(2, '0')}';
  }

  String get _time {
    return '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 星期
          Text(
            _weekday,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),

          // 日期
          Text(
            _date,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // 时间（大字体）
          Text(
            _time,
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
              letterSpacing: 4,
            ),
          ),
        ],
      ),
    );
  }
}

/// Storage 区域
class _StorageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StorageCard(storage: _mockLocalStorage),
        const SizedBox(height: 16),
        _StorageCard(storage: _mockUsbStorage),
      ],
    );
  }
}

/// Storage 卡片
class _StorageCard extends StatelessWidget {
  const _StorageCard({required this.storage});

  final StorageInfo storage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(storage.icon, color: AppTheme.primaryColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  storage.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 进度条
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: storage.usageRatio,
              minHeight: 12,
              backgroundColor: AppTheme.backgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                storage.usageRatio > 0.8
                    ? Colors.redAccent
                    : AppTheme.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 使用量文字
          Text(
            '${storage.usedText} / ${storage.totalText}',
            style: const TextStyle(fontSize: 16, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Recent Apps 区域
class _RecentAppsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Apps',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 20),

        // App Grid
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: _mockRecentApps.map((app) => _AppTile(app: app)).toList(),
        ),
      ],
    );
  }
}

/// App 图块
class _AppTile extends StatefulWidget {
  const _AppTile({required this.app});

  final RecentApp app;

  @override
  State<_AppTile> createState() => _AppTileState();
}

class _AppTileState extends State<_AppTile> {
  bool _isFocused = false;

  void _onTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Launching ${widget.app.name}'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) {
        setState(() {
          _isFocused = focused;
        });
      },
      child: GestureDetector(
        onTap: _onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: _isFocused ? AppTheme.primaryColor : AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: _isFocused
                ? Border.all(color: AppTheme.focusColor, width: 3)
                : null,
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: AppTheme.focusColor.withValues(alpha: 0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _onTap,
              borderRadius: BorderRadius.circular(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.app.icon,
                    size: 40,
                    color: _isFocused
                        ? AppTheme.textPrimary
                        : AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.app.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _isFocused
                          ? AppTheme.textPrimary
                          : AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
