import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// 管理用户选择的 App (Apps 页面显示的 App)
class AppSelectionStorage {
  static const String _fileName = 'selected_apps.json';

  /// 获取存储文件
  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  /// 加载已选择的包名列表
  Future<List<String>> loadSelectedPackageNames() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return [];

      final content = await file.readAsString();
      final List<dynamic> list = jsonDecode(content);
      return list.cast<String>();
    } catch (_) {
      return [];
    }
  }

  /// 保存已选择的包名列表
  Future<void> saveSelectedPackageNames(List<String> packageNames) async {
    try {
      final file = await _getFile();
      await file.writeAsString(jsonEncode(packageNames));
    } catch (_) {}
  }
}
