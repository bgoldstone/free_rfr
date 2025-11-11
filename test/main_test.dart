import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/configurations/scroll_behavior.dart';
import 'package:free_rfr/main.dart' as entry;
import 'package:provider/provider.dart';

void main() {
  testWidgets('Test MyApp Widget', (WidgetTester tester) async {
    await tester.pumpWidget(ChangeNotifierProvider(
        create: (context) => FreeRFRContext(), child: const entry.MyApp()));
    final materialAppFinder = find.byType(MaterialApp);
    final materialAppWidget = tester.widget<MaterialApp>(materialAppFinder);

    expect(materialAppWidget.title, equals('Free RFR'));
    expect(materialAppWidget.theme?.brightness, equals(Brightness.light));
    expect(materialAppWidget.darkTheme?.brightness, equals(Brightness.dark));
    expect(materialAppWidget.scrollBehavior, isA<FreeRFRScrollBehavior>());
  });

  testWidgets('Test Main', (WidgetTester tester) async {
    try {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      entry.main();
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('Test MyApp', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => FreeRFRContext(),
        child: const entry.MyApp(),
      ),
    );
    await tester.pump();
    expect(find.text('Free RFR'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    var addFAB = find.byTooltip("Add Connection");
    await tester.tap(addFAB);
    await tester.pump();
    var consoleName = find.byWidgetPredicate((widget) =>
        widget is TextField && widget.decoration?.labelText == 'Console Name');

    await tester.tap(consoleName);
    await tester.enterText(consoleName, "test");
    expect(find.text('test'), findsOneWidget);

    var consoleIP = find.byWidgetPredicate((widget) =>
        widget is TextField && widget.decoration?.labelText == 'Console IP');
    await tester.tap(consoleIP);
    await tester.enterText(consoleIP, "127.0.0.1");
    expect(find.text('127.0.0.1'), findsOneWidget);
    var userId = find.byWidgetPredicate((widget) =>
        widget is TextField && widget.decoration?.labelText == 'User ID');
    await tester.tap(userId);
    await tester.enterText(userId, "");
    expect(find.text('0'), findsOneWidget);
    var addButton = find.byWidgetPredicate((widget) =>
        widget is TextButton &&
        widget.child is Text &&
        (widget.child as Text).data == 'Add');
    await tester.tap(addButton);
    expect(addFAB, findsOneWidget);
    await tester.pump();

    await tester.tap(addFAB);
    await tester.pump();

    await tester.tap(find.text('Cancel'));
    await tester.pump();

    expect(addFAB, findsOneWidget);
  });
  testWidgets('Test Main w/ mobile', (WidgetTester tester) async {
    try {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      entry.main();
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}
