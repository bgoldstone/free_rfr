import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/pages/facepanels/additional_keys.dart';
import 'package:free_rfr/widgets/button.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../mocks/MockOSC.dart';

void main() {
  MockOSC mockOSC = MockOSC();
  testWidgets(
    'Additional Keys Widget Test',
    (WidgetTester tester) async {
      await setUp(tester, mockOSC);
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(Button), findsNWidgets(15));
    },
  );
  testWidgets(
    'Additional Keys Button Press Test',
    (WidgetTester tester) async {
      await setUp(tester, mockOSC);
      final Map<String, String> buttonLabelsToKey = {
        'Mark': 'mark',
        'Sneak': 'sneak',
        'Rem Dim': 'rem_dim',
        'Select Manual': 'select_manual',
        'Select Last': 'select_last',
        'Select Active': 'select_active',
        'Home': 'home',
        'Level': 'level',
        'Time': 'time',
        'Undo': 'undo',
        'Enter': 'enter',
      };
      for (var entry in buttonLabelsToKey.entries) {
        final buttonFinder = find.text(entry.key);
        expect(buttonFinder, findsOneWidget);
        await tester.tap(buttonFinder);
        await tester.pump();
        verify(() => mockOSC.sendKey(entry.value)).called(1);
      }
      await tester.tap(find.text('Live'));
      await tester.pump();
      verify(() => mockOSC.sendLive()).called(1);
      await tester.tap(find.text('Blind'));
      await tester.pump();
      verify(() => mockOSC.sendBlind()).called(1);
    },
  );
}

Future<void> setUp(WidgetTester tester, MockOSC mockOSC) async {
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (context) => FreeRFRContext(),
      child: MaterialApp(
        home: Scaffold(
          body: AdditionalKeys(osc: mockOSC),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
