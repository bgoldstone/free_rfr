import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/pages/cues.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../mocks/MockOSC.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const methodChannel = MethodChannel('dev.leanflutter.plugins/hotkey_manager');
  const eventChannel =
      EventChannel('dev.leanflutter.plugins/hotkey_manager_event');

  late List<String> methodCalls;

  setUp(() async {
    methodCalls = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      ..setMockMethodCallHandler(methodChannel, (call) async {
        methodCalls.add(call.method);
        return null;
      })
      ..setMockMessageHandler(
        eventChannel.name,
        (message) async =>
            const StandardMethodCodec().encodeSuccessEnvelope(null),
      );
    await hotKeyManager.unregisterAll();
    methodCalls.clear();
  });

  tearDown(() async {
    await hotKeyManager.unregisterAll();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      ..setMockMethodCallHandler(methodChannel, null)
      ..setMockMessageHandler(eventChannel.name, null);
  });

  Future<FreeRFRContext> setUpPage(
    WidgetTester tester, {
    required MockOSC osc,
    FreeRFRContext? context,
  }) async {
    final ctx = context ?? FreeRFRContext();
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => ctx,
        child: MaterialApp(
          home: Scaffold(body: Cues(osc: osc)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return ctx;
  }

  testWidgets('Cues renders cue list state', (tester) async {
    final ctx = FreeRFRContext()
      ..currentCueList = 7
      ..previousCueText = 'Previous'
      ..currentCueText = 'Current'
      ..nextCueText = 'Next';

    await setUpPage(tester, osc: MockOSC(), context: ctx);

    expect(find.text('Cue List: 7'), findsOneWidget);
    expect(find.text('Previous'), findsOneWidget);
    expect(find.text('Current'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('Cues enables Stop and Go for the default cue', (tester) async {
    await setUpPage(tester, osc: MockOSC());

    final stop = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Stop/Back'),
    );
    final go = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Go'),
    );

    expect(stop.onPressed, isNotNull);
    expect(go.onPressed, isNotNull);
  });

  testWidgets('Cues Stop and Go send keys when enabled', (tester) async {
    final osc = MockOSC();
    when(() => osc.sendKey('stop')).thenAnswer((invocation) async {});
    when(() => osc.sendKey('go_0')).thenAnswer((invocation) async {});
    final ctx = FreeRFRContext()
      ..currentCue = 2
      ..nextCueText = 'Next';
    await setUpPage(tester, osc: osc, context: ctx);

    await tester.tap(find.text('Stop/Back'));
    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();

    verify(() => osc.sendKey('stop')).called(1);
    verify(() => osc.sendKey('go_0')).called(1);
  });

  testWidgets('Cues label dialog sends setLabel and refreshes hotkeys',
      (tester) async {
    final osc = MockOSC();
    final ctx = FreeRFRContext()..currentCue = 3;
    await setUpPage(tester, osc: osc, context: ctx);

    await tester.longPress(find.text('Current Cue'));
    await tester.pumpAndSettle();

    expect(find.text('Modify Cue'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'New label');
    await tester.tap(find.text('Ok'));
    await tester.pumpAndSettle();

    verify(() => osc.setLabel(3.0, 'New label')).called(1);
    expect(ctx.hasHotKeyBeenUninitialized, isTrue);
    expect(methodCalls, contains('unregisterAll'));
  });
}
