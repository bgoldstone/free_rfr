import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:free_rfr/pages/facepanels/controls/pan_tilt.dart';
import 'package:free_rfr/widgets/parameter_widget.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../../common.dart';
import '../../../mocks/MockOSC.dart';

MockOSC osc = MockOSC();
late FreeRFRContext freeRFRContext;
void main() {
  when(() => osc.updatePanTilt(any(), any())).thenReturn(null);
  testWidgets('Test PanTiltControl Widget', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(4096, 2160);
    tester.view.devicePixelRatio = 1.0;
    freeRFRContext = FreeRFRContext();
    freeRFRContext.currentChannel = {
      ParameterType.pan: [0],
      ParameterType.tilt: [0],
      ParameterType.maxPan: [540],
      ParameterType.minPan: [-540],
      ParameterType.maxTilt: [270],
      ParameterType.minTilt: [-270],
    };
    await setUp(tester, osc, freeRFRContext);
    expect(find.byType(PanTiltControl), findsOneWidget);
    final panTextFinder = find.byKey(const Key('panText'));
    final tiltTextFinder = find.byKey(const Key('tiltText'));
    expect(panTextFinder, findsOneWidget);
    expect(tiltTextFinder, findsOneWidget);
    final sliderFinder = find.byType(Slider);
    expect(sliderFinder, findsNWidgets(2));
    expect(find.byType(Container), findsNWidgets(3));
    await tester
        .tapAt(tester.getCenter(sliderFinder.first) + const Offset(100.0, 0.0));
    await tester.pumpAndSettle();
    await tester
        .tapAt(tester.getCenter(sliderFinder.last) + const Offset(0.0, -100.0));
    await tester.pumpAndSettle();

    final boxFinder = find.byWidgetPredicate(
        (widget) => widget is Container && widget.color == Colors.transparent);
    expect(boxFinder, findsOneWidget);
    await tester.tapAt(tester.getCenter(boxFinder) + const Offset(50, -50));
    await tester.pumpAndSettle();

    await tester.drag(boxFinder, const Offset(50, -50));
    await tester.pumpAndSettle();
    await tester.drag(boxFinder, const Offset(50, 0));
    await tester.tap(boxFinder);
    await tester.pumpAndSettle();
    verify(() => osc.updatePanTilt(any(), any())).called(6);

    await tester.tapAt(tester.getCenter(panTextFinder));
    await tester.pumpAndSettle();
    await tester.drag(panTextFinder, const Offset(-100, 0));
    await tester.pumpAndSettle();
    await tester.tapAt(tester.getCenter(tiltTextFinder));
    await tester.pumpAndSettle();
    await tester.drag(tiltTextFinder, const Offset(0, 100));
    await tester.pumpAndSettle();
    // Implement your test
  });

  testWidgets('Find PanTiltControl too small screen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(300, 300);
    tester.view.devicePixelRatio = 1.0;
    freeRFRContext = FreeRFRContext();
    freeRFRContext.currentChannel = {
      ParameterType.pan: [0],
      ParameterType.tilt: [0],
      ParameterType.maxPan: [540],
      ParameterType.minPan: [-540],
      ParameterType.maxTilt: [270],
      ParameterType.minTilt: [-270],
    };
    await setUp(tester, osc, freeRFRContext);
    expect(find.byType(PanTiltControl), findsOneWidget);
    expect(find.byType(ParameterWidget), findsNWidgets(2));
    expect(find.byType(ParameterWidgets), findsNWidgets(1));
  });
}

Future<void> setUp(
    WidgetTester tester, MockOSC mockOSC, FreeRFRContext freeRFRContext) async {
  await ignoreErrors();
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (context) => freeRFRContext,
      child: MaterialApp(
        home: Scaffold(
          body: PanTiltControl(osc: mockOSC),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
