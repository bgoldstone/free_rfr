import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/pages/direct_selects.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:osc/osc.dart';
import 'package:provider/provider.dart';

import '../mocks/MockOSC.dart';

class RecordingMockOSC extends MockOSC {
  final sent = <OSCMessage>[];

  @override
  Future<void> sendOSCMessage(OSCMessage message) async {
    sent.add(message);
  }
}

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
    required RecordingMockOSC osc,
  }) async {
    final ctx = FreeRFRContext();
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => ctx,
        child: MaterialApp(
          home: Scaffold(body: DirectSelects(osc: osc)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return ctx;
  }

  testWidgets('DirectSelects requests the initial bank', (tester) async {
    final osc = RecordingMockOSC();
    final sent = osc.sent;

    await setUpPage(tester, osc: osc);

    expect(
      sent.map((message) => message.address),
      contains('/eos/ds/1/group/flexi/1/16'),
    );
    expect(find.text('Page: 1'), findsOneWidget);
  });

  testWidgets('DirectSelects switches type and clears selection',
      (tester) async {
    final osc = RecordingMockOSC();
    final sent = osc.sent;
    final ctx = await setUpPage(tester, osc: osc);
    ctx.updateDirectSelects(1, 2.0, 'Group');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Macros'));
    await tester.pumpAndSettle();

    expect(ctx.directSelects, isEmpty);
    expect(find.text('Page: 1'), findsOneWidget);
    expect(
      sent.map((message) => message.address),
      contains('/eos/ds/1/macro/flexi/1/16'),
    );
  });

  testWidgets('DirectSelects pages through banks', (tester) async {
    final osc = RecordingMockOSC();
    final sent = osc.sent;
    final ctx = await setUpPage(tester, osc: osc);
    ctx.updateDirectSelects(1, 2.0, 'Group');
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Page Down'));
    await tester.pumpAndSettle();

    expect(ctx.directSelects, isEmpty);
    expect(find.text('Page: 2'), findsOneWidget);
    expect(
      sent.map((message) => message.address),
      contains('/eos/ds/1/group/flexi/2/16'),
    );

    await tester.tap(find.byTooltip('Page Up'));
    await tester.pumpAndSettle();

    expect(find.text('Page: 1'), findsOneWidget);
    expect(
      sent.map((message) => message.address),
      contains('/eos/ds/1/group/flexi/1/16'),
    );
  });

  testWidgets('DirectSelects button sends its address', (tester) async {
    final osc = RecordingMockOSC();
    final ctx = await setUpPage(tester, osc: osc);
    ctx.updateDirectSelects(5, 12.0, 'Group');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Group\n(12.0)'));
    await tester.pumpAndSettle();

    verify(() => osc.send('/eos/ds/1/5', [1])).called(1);
  });

  testWidgets('DirectSelects label dialog sends formatted command',
      (tester) async {
    final osc = RecordingMockOSC();
    final ctx = await setUpPage(tester, osc: osc);
    await tester.tap(find.text('Intensity Palettes'));
    await tester.pumpAndSettle();
    ctx.updateDirectSelects(5, 12.0, 'Focus');
    await tester.pumpAndSettle();

    await tester.longPress(find.text('Focus\n(12.0)'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Label'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Intensity');
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    verify(
      () => osc.send('/eos/newcmd', ['Intensity Palette 12 Label Intensity#']),
    ).called(1);
    expect(ctx.hasHotKeyBeenUninitialized, isTrue);
    expect(methodCalls, contains('unregisterAll'));
  });
}
