import 'dart:convert';
import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/main.dart';
import 'package:free_rfr/pages/connections.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:provider/provider.dart';

class FakePathProviderPlatform extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  final String documentsPath;

  FakePathProviderPlatform(this.documentsPath);

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return documentsPath;
  }
}

late Directory testDirectory;

File get configFile => File('${testDirectory.path}/free_rfr.json');

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
    await tester.pump();
    await tester.tap(fabFinder);
    await tester.pump();
    await tester.tapAt(const Offset(0, 0));
  });

  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/path_provider');

  setUp(() {
    testDirectory = Directory.systemTemp.createTempSync('free_rfr_test_');
    PathProviderPlatform.instance = FakePathProviderPlatform(
      testDirectory.path,
    );
    channel.setMethodCallHandler((MethodCall methodCall) async {
      // Return a temp directory for testing
      return Directory.systemTemp.path;
    });
  });

  tearDown(() {
    channel.setMethodCallHandler(null);
    if (testDirectory.existsSync()) {
      try {
        testDirectory.deleteSync(recursive: true);
      } on PathAccessException {}
    }
  });

  Future<void> waitForSavedConnection(
    WidgetTester tester,
    String name,
  ) async {
    await tester.runAsync(() async {
      for (var i = 0; i < 50; i++) {
        if (configFile.existsSync() &&
            configFile.readAsStringSync().contains(name)) {
          return;
        }
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
    });
    await tester.pumpAndSettle();
  }

  Future<FreeRFRContext> setUpConnectionsPage(WidgetTester tester) async {
    final ctx = FreeRFRContext();
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => ctx,
        child: MaterialApp(
          home: Connections(
            (connection, index, context) {},
            currentConnectionIndex: -1,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return ctx;
  }

  testWidgets('Connections shows No Connections for empty config',
      (tester) async {
    await setUpConnectionsPage(tester);

    expect(find.text('No Connections'), findsOneWidget);
  });

  testWidgets('Connections writes newly added connection to config',
      (tester) async {
    await setUpConnectionsPage(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Console Name'),
      'New Console',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Console IP'),
      '10.0.0.1',
    );
    await tester.enterText(find.widgetWithText(TextField, '0'), '3');
    await tester.tap(find.text('Add'));
    await waitForSavedConnection(tester, 'New Console');

    expect(configFile.existsSync(), isTrue);
    final saved =
        jsonDecode(configFile.readAsStringSync()) as Map<String, dynamic>;
    final connections = saved['connections'] as List<dynamic>;
    expect(connections, hasLength(1));
    expect(connections.first, {
      'name': 'New Console',
      'ip': '10.0.0.1',
      'userId': 3,
    });
  });

  testWidgets('Connections resets malformed config', (tester) async {
    configFile.writeAsStringSync('{invalid json');

    await setUpConnectionsPage(tester);

    expect(find.text('No Connections'), findsOneWidget);
    final saved =
        jsonDecode(configFile.readAsStringSync()) as Map<String, dynamic>;
    expect(saved['connections'], isEmpty);
  });

  testWidgets('Connections removes dismissed connection from config',
      (tester) async {
    configFile.writeAsStringSync(jsonEncode({
      'connections': [
        {'name': 'Old Console', 'ip': '10.0.0.1', 'userId': 1},
      ],
    }));

    await setUpConnectionsPage(tester);
    expect(find.text('Old Console'), findsOneWidget);

    await tester.drag(find.byType(Dismissible), const Offset(500, 0));
    await tester.pumpAndSettle();

    expect(find.text('No Connections'), findsOneWidget);
    final saved =
        jsonDecode(configFile.readAsStringSync()) as Map<String, dynamic>;
    expect(saved['connections'], isEmpty);
  });
}
