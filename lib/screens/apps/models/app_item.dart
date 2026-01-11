import 'package:flutter/material.dart';

/// App 数据模型
class AppItem {
  const AppItem({required this.id, required this.name, required this.icon});

  final String id;
  final String name;
  final IconData icon;
}

/// Mock App 列表
const List<AppItem> mockApps = [
  AppItem(id: 'whiteboard', name: 'Whiteboard', icon: Icons.draw),
  AppItem(id: 'browser', name: 'Browser', icon: Icons.public),
  AppItem(id: 'gallery', name: 'Gallery', icon: Icons.photo_library),
  AppItem(id: 'music', name: 'Music', icon: Icons.music_note),
  AppItem(id: 'files', name: 'Files', icon: Icons.folder),
  AppItem(id: 'settings', name: 'Settings', icon: Icons.settings),
  AppItem(id: 'camera', name: 'Camera', icon: Icons.camera_alt),
  AppItem(id: 'calculator', name: 'Calculator', icon: Icons.calculate),
  AppItem(id: 'calendar', name: 'Calendar', icon: Icons.calendar_month),
  AppItem(id: 'clock', name: 'Clock', icon: Icons.access_time),
  AppItem(id: 'notes', name: 'Notes', icon: Icons.note),
  AppItem(id: 'weather', name: 'Weather', icon: Icons.cloud),
];
