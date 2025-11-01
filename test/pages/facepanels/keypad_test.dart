import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/pages/facepanels/keypad.dart';
import 'package:free_rfr/widgets/button.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../mocks/MockOSC.dart';

void main() {
  MockOSC mockOSC = MockOSC();
  testWidgets(
    'Keypad Widget Test',
    (WidgetTester tester) async {
      await setUp(tester, mockOSC);
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(Button), findsNWidgets(24));
    },
  );
  testWidgets(
    'Keypad Button Press Test',
    (WidgetTester tester) async {
      await setUp(tester, mockOSC);
      final Map<String, String> buttonLabelsToKey = {
        'Go To Cue': 'go_to_cue',
        'Addr': 'address',
        'Last': 'last',
        'Next': 'next',
        '+': 'plus',
        'Thru': 'thru',
        '-': '-',
        'Group': 'group',
        '7': '7',
        '8': '8',
        '9': '9',
        'Out': 'out',
        '4': '4',
        '5': '5',
        '6': '6',
        'Full': 'full',
        '1': '1',
        '2': '2',
        '3': '3',
        'At': 'at',
        'Clear': 'clear_cmd',
        '0': '0',
        '.': '.',
        'Enter': 'enter'
      };
      for (var entry in buttonLabelsToKey.entries) {
        final buttonFinder = find.text(entry.key);
        expect(buttonFinder, findsOneWidget);
        await tester.tap(buttonFinder);
        await tester.pump();
        verify(() => mockOSC.sendKey(entry.value)).called(1);
      }
    },
  );
}

Future<void> setUp(WidgetTester tester, MockOSC mockOSC) async {
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (context) => FreeRFRContext(),
      child: MaterialApp(
        home: Scaffold(
          body: Keypad(osc: mockOSC),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
