import 'dart:convert';

/// 公告数据模型
class Notice {
  Notice({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  /// 从 JSON Map 创建 Notice
  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// 转换为 JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// 从 JSON 字符串解析列表
  static List<Notice> listFromJson(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((json) => Notice.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// 列表转换为 JSON 字符串
  static String listToJson(List<Notice> notices) {
    return jsonEncode(notices.map((n) => n.toJson()).toList());
  }

  /// 生成唯一 ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
