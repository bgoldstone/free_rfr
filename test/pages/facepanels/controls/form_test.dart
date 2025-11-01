import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/pages/facepanels/controls/form.dart';
import 'package:provider/provider.dart';

import '../../../mocks/MockOSC.dart';


MockOSC osc = MockOSC();
FreeRFRContext freeRFRContext = FreeRFRContext();
void main() {
  testWidgets('Test FormControl Widget', (WidgetTester tester) async {
    await setUp(tester, osc, freeRFRContext);
    expect(find.byType(FormControl), findsOneWidget);
    // Implement your test
  });
}

Future<void> setUp(
    WidgetTester tester, MockOSC mockOSC, FreeRFRContext freeRFRContext) async {
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (context) => freeRFRContext,
      child: MaterialApp(
        home: Scaffold(
          body: FormControl(osc: mockOSC),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
