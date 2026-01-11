import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/theme/app_theme.dart';

/// 文件系统项数据模型
class FileSystemItem {
  const FileSystemItem({
    required this.name,
    required this.path,
    required this.isDirectory,
    this.size,
  });

  final String name;
  final String path;
  final bool isDirectory;
  final int? size;

  IconData get icon => isDirectory ? Icons.folder : _getFileIcon();

  IconData _getFileIcon() {
    final ext = name.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return Icons.image;
      case 'mp4':
      case 'mkv':
      case 'avi':
      case 'mov':
        return Icons.video_file;
      case 'mp3':
      case 'wav':
      case 'flac':
      case 'aac':
        return Icons.audio_file;
      case 'txt':
      case 'md':
        return Icons.description;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.folder_zip;
      case 'apk':
        return Icons.android;
      default:
        return Icons.insert_drive_file;
    }
  }
}

/// Folder 页面 - 本地文件浏览器
class FolderPage extends StatefulWidget {
  const FolderPage({super.key});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  static const String _rootPath = '/storage/emulated/0';

  String? _currentPath;
  List<FileSystemItem> _items = [];
  bool _isLoading = true;
  String? _error;
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndLoad();
  }

  Future<void> _checkPermissionAndLoad() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // 检查并请求存储权限
    final hasPermission = await _requestStoragePermission();

    if (hasPermission) {
      _permissionGranted = true;
      await _loadDirectory(_rootPath);
    } else {
      setState(() {
        _permissionGranted = false;
        _isLoading = false;
        _error = 'Storage permission required';
      });
    }
  }

  Future<bool> _requestStoragePermission() async {
    // Android 11+ 需要 MANAGE_EXTERNAL_STORAGE
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    // 尝试请求 MANAGE_EXTERNAL_STORAGE（Android 11+）
    var status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      return true;
    }

    // 回退到普通存储权限（Android 10 及以下）
    if (await Permission.storage.isGranted) {
      return true;
    }

    status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<void> _loadDirectory(String path) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final dir = Directory(path);
      if (!await dir.exists()) {
        setState(() {
          _error = 'Directory does not exist';
          _isLoading = false;
        });
        return;
      }

      final entities = await dir.list().toList();
      final items = <FileSystemItem>[];

      for (final entity in entities) {
        final name = entity.path.split('/').last;
        if (name.startsWith('.')) continue; // 隐藏文件

        int? size;
        if (entity is File) {
          try {
            size = await entity.length();
          } catch (_) {}
        }

        items.add(
          FileSystemItem(
            name: name,
            path: entity.path,
            isDirectory: entity is Directory,
            size: size,
          ),
        );
      }

      // 排序：文件夹优先，然后按名称
      items.sort((a, b) {
        if (a.isDirectory && !b.isDirectory) return -1;
        if (!a.isDirectory && b.isDirectory) return 1;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

      setState(() {
        _currentPath = path;
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Permission denied or read error';
        _isLoading = false;
      });
    }
  }

  void _navigateToDirectory(String path) {
    _loadDirectory(path);
  }

  void _navigateUp() {
    if (_currentPath == null || _currentPath == _rootPath) return;

    final parent = Directory(_currentPath!).parent.path;
    if (parent.length >= _rootPath.length) {
      _loadDirectory(parent);
    }
  }

  bool get _canNavigateUp {
    if (_currentPath == null) return false;
    return _currentPath != _rootPath;
  }

  String get _displayPath {
    if (_currentPath == null) return '';
    if (_currentPath == _rootPath) return '/';
    return _currentPath!.substring(_rootPath.length);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 顶部标题和路径
        Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Folder',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildPathBar(),
            ],
          ),
        ),

        // 内容区域
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildPathBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 返回按钮
          if (_canNavigateUp) ...[
            _NavigationButton(icon: Icons.arrow_back, onPressed: _navigateUp),
            const SizedBox(width: 12),
          ],

          // 主目录按钮
          _NavigationButton(
            icon: Icons.home,
            onPressed: () {
              if (_permissionGranted) {
                _loadDirectory(_rootPath);
              }
            },
          ),
          const SizedBox(width: 16),

          // 当前路径
          Expanded(
            child: Text(
              _displayPath,
              style: const TextStyle(
                fontSize: 18,
                color: AppTheme.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // 刷新按钮
          _NavigationButton(
            icon: Icons.refresh,
            onPressed: () {
              if (_currentPath != null) {
                _loadDirectory(_currentPath!);
              } else {
                _checkPermissionAndLoad();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      );
    }

    // 权限未授予时显示授权按钮
    if (!_permissionGranted) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.folder_off,
              size: 80,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 24),
            const Text(
              'Storage Permission Required',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Please grant storage access to browse files',
              style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 32),
            _GrantPermissionButton(onPressed: _checkPermissionAndLoad),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => openAppSettings(),
              child: const Text(
                'Open App Settings',
                style: TextStyle(color: AppTheme.primaryColor, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(
                fontSize: 18,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _checkPermissionAndLoad,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 64, color: AppTheme.textSecondary),
            SizedBox(height: 16),
            Text(
              'Empty folder',
              style: TextStyle(fontSize: 18, color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return _FileListItem(
          item: item,
          onTap: () {
            if (item.isDirectory) {
              _navigateToDirectory(item.path);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Selected: ${item.name}'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        );
      },
    );
  }
}

/// 授权按钮
class _GrantPermissionButton extends StatefulWidget {
  const _GrantPermissionButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_GrantPermissionButton> createState() => _GrantPermissionButtonState();
}

class _GrantPermissionButtonState extends State<_GrantPermissionButton> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) {
        setState(() {
          _isFocused = focused;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
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
        child: ElevatedButton.icon(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: AppTheme.textPrimary,
            minimumSize: const Size(200, 64),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.security, size: 24),
          label: const Text(
            'Grant Permission',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

/// 导航按钮
class _NavigationButton extends StatefulWidget {
  const _NavigationButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  State<_NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<_NavigationButton> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) {
        setState(() {
          _isFocused = focused;
        });
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _isFocused
                ? AppTheme.primaryColor
                : AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: _isFocused
                ? Border.all(color: AppTheme.focusColor, width: 2)
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(8),
              child: Icon(
                widget.icon,
                color: _isFocused
                    ? AppTheme.textPrimary
                    : AppTheme.textSecondary,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 文件列表项
class _FileListItem extends StatefulWidget {
  const _FileListItem({required this.item, required this.onTap});

  final FileSystemItem item;
  final VoidCallback onTap;

  @override
  State<_FileListItem> createState() => _FileListItemState();
}

class _FileListItemState extends State<_FileListItem> {
  bool _isFocused = false;

  String _formatSize(int? bytes) {
    if (bytes == null) return '';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
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
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: _isFocused ? AppTheme.primaryColor : AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: _isFocused
                ? Border.all(color: AppTheme.focusColor, width: 2)
                : null,
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: AppTheme.focusColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                constraints: const BoxConstraints(minHeight: 72),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    // 图标
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _isFocused
                            ? AppTheme.textPrimary.withValues(alpha: 0.2)
                            : AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        widget.item.icon,
                        color: widget.item.isDirectory
                            ? (_isFocused ? AppTheme.textPrimary : Colors.amber)
                            : (_isFocused
                                  ? AppTheme.textPrimary
                                  : AppTheme.textSecondary),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // 名称
                    Expanded(
                      child: Text(
                        widget.item.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // 大小（仅文件显示）
                    if (!widget.item.isDirectory && widget.item.size != null)
                      Text(
                        _formatSize(widget.item.size),
                        style: TextStyle(
                          fontSize: 14,
                          color: _isFocused
                              ? AppTheme.textPrimary.withValues(alpha: 0.7)
                              : AppTheme.textSecondary,
                        ),
                      ),

                    // 箭头（仅文件夹显示）
                    if (widget.item.isDirectory)
                      Icon(
                        Icons.chevron_right,
                        color: _isFocused
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary,
                        size: 24,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
