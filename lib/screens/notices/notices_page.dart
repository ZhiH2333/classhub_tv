import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'models/notice.dart';
import 'services/notice_storage.dart';

/// Notices 页面 - 本地公告系统
class NoticesPage extends StatefulWidget {
  const NoticesPage({super.key});

  @override
  State<NoticesPage> createState() => _NoticesPageState();
}

class _NoticesPageState extends State<NoticesPage> {
  final NoticeStorage _storage = NoticeStorage();
  List<Notice> _notices = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  Future<void> _loadNotices() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final notices = await _storage.loadNotices();
      setState(() {
        _notices = notices;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load notices';
        _isLoading = false;
      });
    }
  }

  Future<void> _addNotice(String title, String content) async {
    final notice = Notice(
      id: Notice.generateId(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );

    final success = await _storage.addNotice(notice);
    if (success) {
      setState(() {
        _notices.insert(0, notice);
      });
    }
  }

  Future<void> _deleteNotice(String id) async {
    final success = await _storage.deleteNotice(id);
    if (success) {
      setState(() {
        _notices.removeWhere((n) => n.id == id);
      });
    }
  }

  void _showAddNoticeDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddNoticeDialog(
        onSave: (title, content) {
          _addNotice(title, content);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 顶部标题和按钮
        Padding(
          padding: const EdgeInsets.all(32),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Notices',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              _AddNoticeButton(onPressed: _showAddNoticeDialog),
            ],
          ),
        ),

        // 内容区域
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
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
            ElevatedButton(onPressed: _loadNotices, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_notices.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 80,
              color: AppTheme.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              '暂无公告',
              style: TextStyle(fontSize: 24, color: AppTheme.textSecondary),
            ),
            SizedBox(height: 8),
            Text(
              '点击右上角按钮添加公告',
              style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      itemCount: _notices.length,
      itemBuilder: (context, index) {
        final notice = _notices[index];
        return _NoticeCard(
          notice: notice,
          onDelete: () => _deleteNotice(notice.id),
        );
      },
    );
  }
}

/// 添加公告按钮
class _AddNoticeButton extends StatefulWidget {
  const _AddNoticeButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_AddNoticeButton> createState() => _AddNoticeButtonState();
}

class _AddNoticeButtonState extends State<_AddNoticeButton> {
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
            minimumSize: const Size(180, 64),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.add, size: 24),
          label: const Text(
            'Add Notice',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

/// 公告卡片
class _NoticeCard extends StatefulWidget {
  const _NoticeCard({required this.notice, required this.onDelete});

  final Notice notice;
  final VoidCallback onDelete;

  @override
  State<_NoticeCard> createState() => _NoticeCardState();
}

class _NoticeCardState extends State<_NoticeCard> {
  bool _isFocused = false;

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

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
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: _isFocused ? AppTheme.primaryColor : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
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
            onTap: () {},
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.notice.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // 删除按钮
                      _DeleteButton(onPressed: widget.onDelete),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(widget.notice.createdAt),
                    style: TextStyle(
                      fontSize: 14,
                      color: _isFocused
                          ? AppTheme.textPrimary.withValues(alpha: 0.7)
                          : AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.notice.content,
                    style: TextStyle(
                      fontSize: 16,
                      color: _isFocused
                          ? AppTheme.textPrimary.withValues(alpha: 0.9)
                          : AppTheme.textPrimary,
                      height: 1.5,
                    ),
                    maxLines: 4,
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

/// 删除按钮
class _DeleteButton extends StatefulWidget {
  const _DeleteButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<_DeleteButton> {
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
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _isFocused ? Colors.redAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(8),
              child: Icon(
                Icons.delete_outline,
                color: _isFocused
                    ? AppTheme.textPrimary
                    : AppTheme.textSecondary,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 添加公告对话框
class _AddNoticeDialog extends StatefulWidget {
  const _AddNoticeDialog({required this.onSave});

  final void Function(String title, String content) onSave;

  @override
  State<_AddNoticeDialog> createState() => _AddNoticeDialogState();
}

class _AddNoticeDialogState extends State<_AddNoticeDialog> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      return;
    }

    widget.onSave(title, content);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Notice',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 24),

            // Title 输入
            const Text(
              'Title',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 18, color: AppTheme.textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppTheme.backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                hintText: 'Enter title...',
                hintStyle: TextStyle(
                  color: AppTheme.textSecondary.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Content 输入
            const Text(
              'Content',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contentController,
              maxLines: 5,
              style: const TextStyle(fontSize: 16, color: AppTheme.textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppTheme.backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
                hintText: 'Enter content...',
                hintStyle: TextStyle(
                  color: AppTheme.textSecondary.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // 取消按钮
                _DialogButton(
                  label: 'Cancel',
                  isPrimary: false,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 16),
                // 保存按钮
                _DialogButton(label: 'Save', isPrimary: true, onPressed: _save),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 对话框按钮
class _DialogButton extends StatefulWidget {
  const _DialogButton({
    required this.label,
    required this.isPrimary,
    required this.onPressed,
  });

  final String label;
  final bool isPrimary;
  final VoidCallback onPressed;

  @override
  State<_DialogButton> createState() => _DialogButtonState();
}

class _DialogButtonState extends State<_DialogButton> {
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
              ? Border.all(color: AppTheme.focusColor, width: 2)
              : null,
        ),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.isPrimary
                ? AppTheme.primaryColor
                : AppTheme.backgroundColor,
            foregroundColor: AppTheme.textPrimary,
            minimumSize: const Size(120, 56),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
