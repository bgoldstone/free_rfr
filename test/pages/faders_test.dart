import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/pages/facepanels/faders.dart';
import 'package:provider/provider.dart';

import '../mocks/MockOSC.dart';

void main() {
  MockOSC mockOSC = MockOSC();
  testWidgets('Test Empty Faders', (WidgetTester tester) async {
    await setUp(tester, mockOSC);
    expect(find.text('Loading Faders...'), findsOneWidget);
  });
  //TODO: Fix broken tests.
  // testWidgets(
  //   'Fader Controls Widget Test',
  //   (WidgetTester tester) async {
  //     FreeRFRContext ctx = await setUp(tester, mockOSC);
  //     expect(find.byType(FaderControls), findsOneWidget);
  //     expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  //     expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
  //     expect(find.text('Faders (Page 1)'), findsOneWidget);
  //   },
  // );
  // testWidgets(
  //   'Fader Controls Page Change Test',
  //   (WidgetTester tester) async {
  //     await setUp(tester, mockOSC);
  //     final backButtonFinder = find.byIcon(Icons.arrow_back);
  //     final forwardButtonFinder = find.byIcon(Icons.arrow_forward);
  //     expect(backButtonFinder, findsOneWidget);
  //     expect(forwardButtonFinder, findsOneWidget);
  //     expect(find.text('Faders (Page 1)'), findsOneWidget);
  //     await tester.tap(forwardButtonFinder);
  //     await tester.pump();
  //     verify(() => mockOSC.send("/eos/fader/1/page/1", [])).called(1);
  //     expect(find.text('Faders (Page 2)'), findsOneWidget);
  //     await tester.tap(backButtonFinder);
  //     await tester.pump();
  //     verify(() => mockOSC.send("/eos/fader/1/page/-1", [])).called(1);
  //     expect(find.text('Faders (Page 1)'), findsOneWidget);
  //     await tester.tap(backButtonFinder);
  //     await tester.pump();
  //     // Should not go below page 1
  //     verifyNever(() => mockOSC.send("/eos/fader/1/page/-1", []));
  //     expect(find.text('Faders (Page 1)'), findsOneWidget);
  //   },
  // );
}

Future<FreeRFRContext> setUp(WidgetTester tester, MockOSC mockOSC) async {
  var ctx = FreeRFRContext();
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (context) => ctx,
      child: MaterialApp(
        home: Scaffold(
          body: FaderControls(osc: mockOSC),
        ),
      ),
    ),
  );
  return ctx;
}
