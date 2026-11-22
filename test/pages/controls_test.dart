import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/controls.dart';
import 'package:free_rfr/pages/facepanels/controls/color.dart';
import 'package:free_rfr/pages/facepanels/controls/color_picker.dart';
import 'package:free_rfr/pages/facepanels/controls/focus.dart';
import 'package:free_rfr/pages/facepanels/controls/form.dart';
import 'package:free_rfr/pages/facepanels/controls/image.dart';
import 'package:free_rfr/pages/facepanels/controls/pan_tilt.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../mocks/MockOSC.dart';

void main() {
  Future<FreeRFRContext> setUpPage(
    WidgetTester tester, {
    required MockOSC osc,
    FreeRFRContext? context,
  }) async {
    final ctx = context ?? FreeRFRContext();
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => ctx,
        child: MaterialApp(
          home: Scaffold(body: Controls(osc: osc)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return ctx;
  }

  FreeRFRContext contextWithPanTilt() {
    return FreeRFRContext()
      ..putCurrentChannel(ParameterType.pan, [0.0])
      ..putCurrentChannel(ParameterType.tilt, [0.0])
      ..putCurrentChannel(ParameterType.maxPan, [270.0])
      ..putCurrentChannel(ParameterType.maxTilt, [135.0])
      ..putCurrentChannel(ParameterType.minPan, [-270.0])
      ..putCurrentChannel(ParameterType.minTilt, [-135.0]);
  }

  testWidgets('Controls shows fallback without pan/tilt parameters',
      (tester) async {
    await setUpPage(tester, osc: MockOSC());

    await tester.tap(find.text('Pan/Tilt'));
    await tester.pumpAndSettle();

    expect(
      find.text('No Pan Tilt Controls for this channel'),
      findsOneWidget,
    );
  });

  testWidgets('Controls shows PanTiltControl with all parameters',
      (tester) async {
    await setUpPage(
      tester,
      osc: MockOSC(),
      context: contextWithPanTilt(),
    );

    await tester.tap(find.text('Pan/Tilt'));
    await tester.pumpAndSettle();

    expect(find.byType(PanTiltControl), findsOneWidget);
  });

  testWidgets('Controls gates color picker on color parameter', (tester) async {
    final ctx = FreeRFRContext()..hueSaturation = [240.0, 1.0];
    await setUpPage(tester, osc: MockOSC(), context: ctx);

    await tester.tap(find.text('Color Picker'));
    await tester.pumpAndSettle();
    expect(
      find.text('No Color Picker Controls for this channel'),
      findsOneWidget,
    );

    ctx.putCurrentChannel(
      ParameterType('Color', ParameterRole.color),
      [50.0],
    );
    await tester.pumpAndSettle();

    expect(find.byType(ColorPickerControl), findsOneWidget);
  });

  testWidgets('Controls shows color picker for arbitrary color wheels',
      (tester) async {
    final ctx = FreeRFRContext()
      ..putCurrentChannel(ParameterType('Color Wheel', ParameterRole.color), [
        50.0,
      ]);
    await setUpPage(tester, osc: MockOSC(), context: ctx);

    await tester.tap(find.text('Color Picker'));
    await tester.pumpAndSettle();

    expect(find.byType(ColorPickerControl), findsOneWidget);
  });

  testWidgets('Controls switches between control pages', (tester) async {
    await setUpPage(tester, osc: MockOSC());

    await tester.tap(find.text('Focus'));
    await tester.pumpAndSettle();
    expect(find.byType(FocusControl), findsOneWidget);

    await tester.tap(find.text('Color'));
    await tester.pumpAndSettle();
    expect(find.byType(ColorControl), findsOneWidget);

    await tester.tap(find.text('Image'));
    await tester.pumpAndSettle();
    expect(find.byType(ImageControl), findsOneWidget);

    await tester.tap(find.text('Form'));
    await tester.pumpAndSettle();
    expect(find.byType(FormControl), findsOneWidget);
  });
}
