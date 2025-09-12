import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/main.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Test Create Connection', (WidgetTester tester) async {
    await tester.pumpWidget(ChangeNotifierProvider(
        create: (context) => FreeRFRContext(), child: const MyApp()));

    Finder iconFinder = find.byIcon(Icons.add);
    expect(iconFinder, findsOneWidget);

    final fabFinder = find.byType(FloatingActionButton);
    final fabWidget = tester.widget<FloatingActionButton>(fabFinder);
    expect(fabWidget.tooltip, equals('Add Connection'));
    await tester.tap(fabFinder);
    await tester.pump();
    // expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Add Connection'), findsOneWidget);
    final consoleNameText = find.widgetWithText(TextField, 'Console Name');
    final consoleIPText = find.widgetWithText(TextField, 'Console IP');
    final userIdText = find.widgetWithText(TextField, '0');
    expect(consoleNameText, findsOneWidget);
    expect(consoleIPText, findsOneWidget);
    expect(userIdText, findsOneWidget);
    await tester.enterText(consoleNameText, 'Test Console Name');
    await tester.enterText(consoleIPText, '127.0.0.1');
    await tester.enterText(userIdText, '1');
    final cancelFinder = find.text('Cancel');
    expect(cancelFinder, findsOneWidget);
    await tester.tap(find.text('Add'));
    await tester.pump();

    await tester.tap(fabFinder);
    await tester.pump();
    await tester.tap(cancelFinder);
    await tester.tap(fabFinder);
    await tester.pump();
    await tester.tapAt(const Offset(0, 0));
  });

  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/path_provider');

  setUp(() {
    channel.setMethodCallHandler((MethodCall methodCall) async {
      // Return a temp directory for testing
      return Directory.systemTemp.path;
    });
  });

  tearDown(() {
    channel.setMethodCallHandler(null);
  });
}
