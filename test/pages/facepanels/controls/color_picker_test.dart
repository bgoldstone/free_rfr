import 'package:material_ui/material_ui.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/facepanels/controls/color_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../../mocks/MockOSC.dart';

void main() {
  testWidgets('sends the tapped orange color as RGB', (tester) async {
    final osc = MockOSC();
    when(() => osc.sendColor(any(), any(), any())).thenAnswer((_) async => {});
    final ctx = FreeRFRContext()..hueSaturation = [0, 1];
    await setUp(tester, osc, ctx);

    final colorWheel = find.byWidgetPredicate(
      (widget) =>
          widget is CustomPaint && widget.painter is HUEColorWheelPainter,
    );
    await tester.ensureVisible(colorWheel);
    await tester.tapAt(tester.getCenter(colorWheel) + const Offset(121, -70));
    await tester.pumpAndSettle();

    final captured = verify(
      () => osc.sendColor(captureAny(), captureAny(), captureAny()),
    ).captured;
    expect(captured[0] as double, closeTo(1.0, 0.01));
    expect(captured[1] as double, closeTo(0.5, 0.01));
    expect(captured[2] as double, closeTo(0.0, 0.01));
  });

  testWidgets('uses RGBW wheel values when Eos saturation is zero',
      (tester) async {
    final osc = MockOSC();
    final ctx = FreeRFRContext()
      ..hueSaturation = [0, 0]
      ..putCurrentChannel(ParameterType('Red', ParameterRole.color), [100])
      ..putCurrentChannel(ParameterType('Green', ParameterRole.color), [50])
      ..putCurrentChannel(ParameterType('Blue', ParameterRole.color), [0])
      ..putCurrentChannel(ParameterType('White', ParameterRole.color), [0]);
    await setUp(tester, osc, ctx);

    final hsv = wheelHsv(tester);
    expect(hsv.hue, closeTo(30.0, 1.0));
    expect(hsv.saturation, closeTo(1.0, 0.01));
    expect(hsv.value, closeTo(1.0, 0.01));
  });

  testWidgets('uses CMY wheel values for non-RGBW fixtures', (tester) async {
    final osc = MockOSC();
    final ctx = FreeRFRContext()
      ..putCurrentChannel(ParameterType('Cyan', ParameterRole.color), [0])
      ..putCurrentChannel(ParameterType('Magenta', ParameterRole.color), [50])
      ..putCurrentChannel(ParameterType('Yellow', ParameterRole.color), [100]);
    await setUp(tester, osc, ctx);

    final hsv = wheelHsv(tester);
    expect(hsv.hue, closeTo(30.0, 1.0));
    expect(hsv.saturation, closeTo(1.0, 0.01));
    expect(hsv.value, closeTo(1.0, 0.01));
  });

  testWidgets('uses Eos hue and saturation as HSV', (tester) async {
    final osc = MockOSC();
    final ctx = FreeRFRContext()..hueSaturation = [210.0, 0.75];
    await setUp(tester, osc, ctx);

    final hsv = wheelHsv(tester);
    expect(hsv.hue, closeTo(210.0, 1.0));
    expect(hsv.saturation, closeTo(0.75, 0.01));
    expect(hsv.value, closeTo(1.0, 0.01));
  });

  testWidgets('Color Home resets the selected color', (tester) async {
    final osc = MockOSC();
    when(() => osc.sendCmd('select_last Color Home#')).thenAnswer((_) async {});
    await setUp(tester, osc, FreeRFRContext());

    final colorFinder = find.text('Color Home');
    expect(colorFinder, findsOneWidget);
    await tester.ensureVisible(colorFinder);
    await tester.tap(colorFinder);
    await tester.pump();
    verify(() => osc.sendCmd('select_last Color Home#')).called(1);
  });
}

/// Returns the HSV color currently rendered by the hue wheel painter.
HSVColor wheelHsv(WidgetTester tester) {
  final colorWheel = find.byWidgetPredicate(
    (widget) => widget is CustomPaint && widget.painter is HUEColorWheelPainter,
  );
  final painter = tester.widget<CustomPaint>(colorWheel).painter;
  return (painter as HUEColorWheelPainter).hsvColor;
}

Future<void> setUp(
  WidgetTester tester,
  MockOSC mockOSC,
  FreeRFRContext freeRFRContext,
) async {
  tester.view.physicalSize = const Size(800, 600);
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
