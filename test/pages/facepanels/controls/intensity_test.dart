import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/facepanels/controls/intensity.dart';
import 'package:free_rfr/widgets/button.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../common_test.dart';
import '../../../free_rfr_test.mocks.dart';

MockOSC osc = MockOSC();

void main() {
  testWidgets('Test Empty IntensityControl Widget',
      (WidgetTester tester) async {
    final freeRFRContext = FreeRFRContext();
    await setUp(tester, osc, freeRFRContext);
    expect(find.byType(IntensityControl), findsOneWidget);
    // Implement your test
  });

  testWidgets('Test IntensityControl Widget', (WidgetTester tester) async {
    final freeRFRContext = FreeRFRContext();
    await ignoreErrors();
    freeRFRContext.currentChannel = {
      ParameterType.intens: [0]
    };
    await setUp(tester, osc, freeRFRContext);
    expect(find.byType(IntensityControl), findsOneWidget);
    expect(find.byType(Button), findsNWidgets(5));
    final fullFinder = find.text('Full');
    expect(fullFinder, findsOneWidget);
    await tester.tap(fullFinder);
    await tester.pumpAndSettle();
    verify(osc.setParameter('Intens', 100)).called(1);
    final seventyFiveFinder = find.text('75%');
    expect(seventyFiveFinder, findsOneWidget);
    await tester.tap(seventyFiveFinder);
    await tester.pumpAndSettle();
    verify(osc.setParameter('Intens', 75)).called(1);
    final fiftyFinder = find.text('50%');
    expect(fiftyFinder, findsOneWidget);
    await tester.tap(fiftyFinder);
    await tester.pumpAndSettle();
    verify(osc.setParameter('Intens', 50)).called(1);
    final twentyFiveFinder = find.text('25%');
    expect(twentyFiveFinder, findsOneWidget);
    await tester.tap(twentyFiveFinder);
    await tester.pumpAndSettle();
    verify(osc.setParameter('Intens', 25)).called(1);
    final outFinder = find.text('Out');
    expect(outFinder, findsOneWidget);
    await tester.tap(outFinder);
    await tester.pumpAndSettle();
    verify(osc.setParameter('Intens', 0)).called(1);
    final sliderFinder = find.byType(Slider);
    expect(sliderFinder, findsOneWidget);
    await tester.drag(sliderFinder, const Offset(100.0, 0.0));
    await tester.pumpAndSettle();
    verify(osc.setParameter('Intens', any)).called(1);
  });
}

Future<void> setUp(
    WidgetTester tester, MockOSC mockOSC, FreeRFRContext freeRFRContext) async {
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (context) => freeRFRContext,
      child: MaterialApp(
        home: Scaffold(
          body: IntensityControl(osc: mockOSC),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
