import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/pages/facepanels/targets.dart';
import 'package:free_rfr/widgets/button.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../free_rfr_test.mocks.dart';

void main() {
  MockOSC mockOSC = MockOSC();
  testWidgets(
    'Targets Widget Test',
    (WidgetTester tester) async {
      await setUp(tester, mockOSC);
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(Button), findsNWidgets(15));
    },
  );
  testWidgets(
    'Targets Button Press Test',
    (WidgetTester tester) async {
      await setUp(tester, mockOSC);
      final Map<String, String> buttonLabelsToKey = {
        'Part': 'part',
        'Cue': 'cue',
        'Record': 'record',
        'Preset': 'preset',
        'Sub': 'sub',
        'Delay': 'delay',
        'Delete': 'delete',
        'Copy To': 'copy_to',
        'Recall From': 'recall_from',
        'Update': 'update',
        'Q-Only/Track': 'cueonlytrack',
        'Save': 'save_show',
        'Last': 'last',
        'Next': 'next',
        'Enter': 'enter',
      };
      for (var entry in buttonLabelsToKey.entries) {
        final buttonFinder = find.text(entry.key);
        expect(buttonFinder, findsOneWidget);
        await tester.tap(buttonFinder);
        await tester.pump();
        verify(mockOSC.sendKey(entry.value)).called(1);
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
          body: Target(osc: mockOSC),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
