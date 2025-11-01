import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/free_rfr.dart';
import 'package:free_rfr/pages/channel_check.dart';
import 'package:free_rfr/pages/controls.dart';
import 'package:free_rfr/pages/cues.dart';
import 'package:free_rfr/pages/direct_selects.dart';
import 'package:free_rfr/pages/facepanel.dart';
import 'package:free_rfr/pages/facepanels/faders.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import 'mocks/MockOSC.dart';

const blackWhite = [Colors.black, Colors.white];
void main() {
  final MockOSC osc = MockOSC();
  Future<void> setUp(WidgetTester tester) async {
    var freeRFRContext = FreeRFRContext();
    freeRFRContext.commandLine = '';
    void setCurrentConnection(int index) {}
    await tester.pumpWidget(ChangeNotifierProvider(
        create: (context) => freeRFRContext,
        child: MaterialApp(
          home: Scaffold(
              body: FreeRFR(
                  osc: osc, setCurrentConnection: setCurrentConnection)),
        )));
  }

  testWidgets('Test FreeRFR Bottom Nav Bar', (WidgetTester tester) async {
    await setUp(tester);

    final keyboardWidgetFinder = find.byIcon(Icons.keyboard);
    expect(keyboardWidgetFinder, findsExactly(2));
    expect(find.byType(FacePanel), findsOneWidget);
    final freeRfrBottomNavBarFinder = find.byWidgetPredicate((widget) =>
        widget is BottomNavigationBar &&
        widget.items.first.label == 'Facepanel');
    final bottomNavBarWidget =
        tester.widget<BottomNavigationBar>(freeRfrBottomNavBarFinder);

    expect(bottomNavBarWidget.items.first.label, equals('Facepanel'));
    expect(bottomNavBarWidget.currentIndex, equals(0));
    expect(bottomNavBarWidget.items[1].label, equals('Faders'));
    expect(find.byIcon(Symbols.instant_mix), findsOneWidget);
    expect(bottomNavBarWidget.items[2].label, equals('Channel Check'));
    expect(find.byIcon(Icons.lightbulb), findsOneWidget);
    expect(bottomNavBarWidget.items[3].label, equals('Controls'));
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(bottomNavBarWidget.items[4].label, equals('Playback'));
    expect(find.byIcon(Symbols.play_pause), findsOneWidget);
    expect(bottomNavBarWidget.items[5].label, equals('Direct Selects'));
    expect(find.byIcon(Symbols.grid_on), findsOneWidget);
    expect(find.byIcon(Icons.power_settings_new), findsOneWidget);
    expect(find.byIcon(Icons.dialpad_rounded), findsOneWidget);
    expect(find.byIcon(Icons.backspace), findsOneWidget);

    await tester.tap(find.text("Faders"));
    await tester.pump();
    expect(find.byType(FaderControls), findsOneWidget);
    await tester.tap(find.text("Channel Check"));
    await tester.pump();
    expect(find.byType(ChannelCheck), findsOneWidget);
    await tester.tap(find.text("Controls"));
    await tester.pump();
    expect(find.byType(Controls), findsOneWidget);
    await tester.tap(find.text("Playback"));
    await tester.pump();
    expect(find.byType(Cues), findsOneWidget);
    await tester.tap(find.text("Direct Selects"));
    await tester.pump();
    expect(find.byType(DirectSelects), findsOneWidget);
  });

  testWidgets("Test App Bar", (WidgetTester tester) async {
    await setUp(tester);
    await tester.tap(find.byIcon(Icons.power_settings_new));
    await tester.pump();
    expect(find.text("Shut Down Eos Console"), findsOneWidget);
    expect(find.text("Are you sure you want to shut down your Eos Console?"),
        findsOneWidget);
    expect(find.text("Cancel"), findsOneWidget);
    expect(find.text("OK"), findsOneWidget);
    await tester.tap(find.text("Cancel"));
    expect(
        find.byWidgetPredicate((widget) =>
            widget is IconButton && widget.tooltip == "Clear Command Line"),
        findsOneWidget);
    expect(
        find.byWidgetPredicate((widget) =>
            widget is IconButton && widget.tooltip == "Shut Down MultiConsole"),
        findsOneWidget);
    var keypadPopupFinder = find.byWidgetPredicate(
        (widget) => widget is IconButton && widget.tooltip == "Keypad");
    final commandLineFinder = find.byWidgetPredicate((widget) =>
        widget is TextButton &&
        widget.child is Text &&
        (widget.child as Text).textAlign == TextAlign.left);
    expect(commandLineFinder, findsOneWidget);
    await tester.tap(commandLineFinder);
    await tester.pumpAndSettle();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    await tester.tap(keypadPopupFinder);
    await tester.pump();
    expect(find.byIcon(Icons.close), findsOneWidget);
    await tester.tap(commandLineFinder.last);
    await tester.pump();
    expect(commandLineFinder, findsNWidgets(2));
  });

  testWidgets('Test Backspace Functionality', (WidgetTester tester) async {
    await setUp(tester);
    when(() => osc.sendKey('clear_cmdline')).thenAnswer((invocation) async {});
    await tester.tap(find.byIcon(Icons.backspace));
    await tester.pump();
    verify(() => osc.sendKey('clear_cmdline')).called(1);
  });

  testWidgets('Test Shutdown MultiConsole', (WidgetTester tester) async {
    await setUp(tester);
    expect(
        tester
            .widget<IconButton>(find.byWidgetPredicate((widget) =>
                widget is IconButton &&
                widget.icon is Icon &&
                (widget.icon as Icon).icon == Icons.power_settings_new))
            .tooltip,
        equals('Shut Down MultiConsole'));
    await tester.tap(find.byIcon(Icons.power_settings_new));
    await tester.pump();
    when(() => osc.shutdownMultiConsole()).thenAnswer((invocation) async {});
    when(() => osc.close()).thenAnswer((invocation) async {});
    await tester.tap(find.text("OK"));
    verify(() => osc.shutdownMultiConsole()).called(1);
  });

  testWidgets('Test Keyboard Navigation', (WidgetTester tester) async {
    try {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      await setUp(tester);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.home);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.home);
      await tester.pump();
      expect(find.byType(FacePanel), findsOneWidget);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.end);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.end);
      await tester.pump();
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
  testWidgets('Test Mobile Platform', (WidgetTester tester) async {
    try {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      await setUp(tester);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}
