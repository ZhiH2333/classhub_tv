import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:classhub_tv/app.dart';

void main() {
  testWidgets('MainShell renders with navigation rail', (
    WidgetTester tester,
  ) async {
    // Build ClassHubTVApp and trigger a frame.
    await tester.pumpWidget(const ClassHubTVApp());

    // Verify that Dashboard is shown by default
    expect(find.text('Dashboard'), findsWidgets);

    // Verify navigation rail has all items
    expect(find.text('Folder'), findsOneWidget);
    expect(find.text('Notices'), findsOneWidget);
    expect(find.text('Apps'), findsOneWidget);
    expect(find.text('Chrome'), findsOneWidget);
    expect(find.text('Posts'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('Navigation changes page content', (WidgetTester tester) async {
    await tester.pumpWidget(const ClassHubTVApp());

    // Tap on Folder navigation item
    await tester.tap(find.text('Folder'));
    await tester.pumpAndSettle();

    // Verify Folder page title is now prominent (large heading)
    final folderTexts = tester.widgetList<Text>(find.text('Folder'));
    expect(
      folderTexts.length,
      greaterThanOrEqualTo(2),
    ); // Nav label + page title
  });
}
