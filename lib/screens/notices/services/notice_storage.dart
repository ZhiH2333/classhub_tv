import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/notice.dart';

/// 公告本地存储服务
class NoticeStorage {
  static const String _fileName = 'notices.json';

  /// 获取存储文件
  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  /// 读取所有公告
  Future<List<Notice>> loadNotices() async {
    try {
      final file = await _getFile();

      if (!await file.exists()) {
        return [];
      }

      final contents = await file.readAsString();
      if (contents.isEmpty) {
        return [];
      }

      return Notice.listFromJson(contents);
    } catch (e) {
      // JSON 解析失败或文件读取错误
      return [];
    }
  }

  /// 保存所有公告
  Future<bool> saveNotices(List<Notice> notices) async {
    try {
      final file = await _getFile();
      final jsonString = Notice.listToJson(notices);
      await file.writeAsString(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 添加新公告
  Future<bool> addNotice(Notice notice) async {
    final notices = await loadNotices();
    notices.insert(0, notice); // 最新在前
    return saveNotices(notices);
  }

  /// 删除公告
  Future<bool> deleteNotice(String id) async {
    final notices = await loadNotices();
    notices.removeWhere((n) => n.id == id);
    return saveNotices(notices);
  }
}
