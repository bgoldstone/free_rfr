import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/shortcuts.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:material_ui/material_ui.dart';

import 'mocks/MockOSC.dart';

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

  bool hasHotKey(
    LogicalKeyboardKey key,
    List<HotKeyModifier> modifiers,
  ) {
    return hotKeyManager.registeredHotKeyList.any((hotKey) {
      if (hotKey.logicalKey != key || hotKey.scope != HotKeyScope.inapp) {
        return false;
      }
      final actual = hotKey.modifiers ?? const <HotKeyModifier>[];
      if (actual.length != modifiers.length) {
        return false;
      }
      for (var i = 0; i < modifiers.length; i++) {
        if (actual[i] != modifiers[i]) {
          return false;
        }
      }
      return true;
    });
  }

  test('registerHotKeys registers representative shortcuts', () async {
    await registerHotKeys(MockOSC());

    expect(
      hasHotKey(LogicalKeyboardKey.keyG, [
        HotKeyModifier.control,
        HotKeyModifier.shift,
      ]),
      isTrue,
    );
    expect(
      hasHotKey(LogicalKeyboardKey.keyA, [HotKeyModifier.alt]),
      isTrue,
    );
    expect(
      hasHotKey(LogicalKeyboardKey.digit1, [HotKeyModifier.alt]),
      isTrue,
    );
    expect(hasHotKey(LogicalKeyboardKey.slash, []), isTrue);
  });

  testWidgets('unregisterHotKeys clears registrations and calls platform',
      (tester) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (builderContext) {
            context = builderContext;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await registerHotKeys(MockOSC());
    expect(hotKeyManager.registeredHotKeyList, isNotEmpty);

    await unregisterHotKeys(context);

    expect(hotKeyManager.registeredHotKeyList, isEmpty);
    expect(methodCalls, contains('unregisterAll'));
  });
}
