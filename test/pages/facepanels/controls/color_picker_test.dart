import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/pages/facepanels/controls/color_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../../mocks/MockOSC.dart';

void main() {
  MockOSC osc = MockOSC();
  testWidgets(
    'Targets Widget Test',
    (WidgetTester tester) async {
      final freeRFRContext = FreeRFRContext();
      freeRFRContext.hueSaturation = [0, 1];
      await setUp(tester, osc, freeRFRContext);
      var colorPickerFinder = find.byType(ColorPicker);
      expect(colorPickerFinder, findsOneWidget);
      when(() => osc.sendColor(any(), any(), any()))
          .thenAnswer((_) async => {});
      var colorWheel = find.byWidgetPredicate((widget) =>
          widget is CustomPaint && widget.painter is HUEColorWheelPainter);
      await tester.ensureVisible(colorWheel);

      await tester.tap(colorWheel);
      await tester.pumpAndSettle();
      verify(() => osc.sendColor(any(), any(), any())).called(1);

      var colorFinder = find.text('Color Home');
      expect(colorFinder, findsOneWidget);
      when(() => osc.sendCmd("select_last Color Home#"))
          .thenAnswer((_) async => {});
      await tester.tap(colorFinder);
      await tester.pump();
      verify(() => osc.sendCmd("select_last Color Home#")).called(1);
    },
  );
  testWidgets('Targets Button Press Test', (WidgetTester tester) async {
    final freeRFRContext = FreeRFRContext();
    freeRFRContext.hueSaturation = [0, 0];
    await setUp(tester, osc, freeRFRContext);
  });
}

Future<void> setUp(
    WidgetTester tester, MockOSC mockOSC, FreeRFRContext freeRFRContext) async {
  tester.view.physicalSize = const Size(4096, 2160);
  tester.view.devicePixelRatio = 1.0;
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (context) => freeRFRContext,
      child: MaterialApp(
        home: Scaffold(
          body: ColorPickerControl(mockOSC),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
