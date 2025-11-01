import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:free_rfr/widgets/parameter_widget.dart';

import '../mocks/MockOSC.dart';

final MockOSC mockOSC = MockOSC();
void main() {
  testWidgets('Parameter Widget Test', (WidgetTester tester) async {
    final freeRFRContext = FreeRFRContext();
    final paramType = ParameterType.pan;
    freeRFRContext.currentChannel = {
      paramType: [0]
    };
    await setupParameterWidget(tester, mockOSC, paramType, freeRFRContext);
    final maxButton = find.text('Max   ');
    expect(maxButton, findsOneWidget);
    await tester.tap(maxButton);
    await tester.pump();
    verify(() => mockOSC.sendCmd("select_last ${paramType.getEosName()} Full#"))
        .called(1);
    final plus10Button = find.text('+10');
    expect(plus10Button, findsOneWidget);
    await tester.tap(plus10Button);
    await tester.pump();
    verify(() => mockOSC.sendCmd("select_last ${paramType.getEosName()} +10#"))
        .called(1);
    final minus10Button = find.text('-10');
    expect(minus10Button, findsOneWidget);
    await tester.tap(minus10Button);
    await tester.pump();
    verify(() => mockOSC.sendCmd("select_last ${paramType.getEosName()} -10#"))
        .called(1);
    final plus1Button = find.text('+1');
    expect(plus1Button, findsOneWidget);
    await tester.tap(plus1Button);
    await tester.pump();
    verify(() => mockOSC.sendCmd("select_last ${paramType.getEosName()} +01#"))
        .called(1);
    final minus1Button = find.text('-1');
    expect(minus1Button, findsOneWidget);
    await tester.tap(minus1Button);
    await tester.pump();
    verify(() => mockOSC.sendCmd("select_last ${paramType.getEosName()} -01#"))
        .called(1);
    final homeButton = find.text('Home');
    expect(homeButton, findsOneWidget);
    await tester.tap(homeButton);
    await tester.pump();
    verify(() => mockOSC.sendCmd("select_last ${paramType.getEosName()} Home#"))
        .called(1);
    final minButton = find.text('Min    ');
    expect(minButton, findsOneWidget);
    await tester.tap(minButton);
    await tester.pump();
    verify(() => mockOSC.sendCmd("select_last ${paramType.getEosName()} Min#"))
        .called(1);
  });

  testWidgets('Parameter Widgets Test', (WidgetTester tester) async {
    final freeRFRContext = FreeRFRContext();
    ParameterRole role = ParameterRole.intens;
    freeRFRContext.currentChannel = {
      ParameterType.intens: [0]
    };
    await setupParametersWidget(tester, mockOSC, role, freeRFRContext);
    expect(find.byType(ParameterWidget), findsNWidgets(1));
  });

  testWidgets('Parameter Widgets Test No Channels',
      (WidgetTester tester) async {
    final freeRFRContext = FreeRFRContext();
    ParameterRole role = ParameterRole.intens;
    freeRFRContext.currentChannel = {};
    await setupParametersWidget(tester, mockOSC, role, freeRFRContext);
    expect(find.byType(ParameterWidget), findsNWidgets(0));
    expect(find.text("No Intensity Controls for this channel"), findsOneWidget);
  });
}

Future<void> setupParameterWidget(WidgetTester tester, MockOSC mockOSC,
    ParameterType type, FreeRFRContext freeRFRContext) async {
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => freeRFRContext,
        child: ParameterWidget(
          parameterType: type,
          osc: mockOSC,
        ),
      ),
    ),
  ));
  await tester.pumpAndSettle();
}

Future<void> setupParametersWidget(WidgetTester tester, MockOSC mockOSC,
    ParameterRole role, FreeRFRContext freeRFRContext) async {
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => freeRFRContext,
        child: ParameterWidgets(
          role: role,
          osc: mockOSC,
        ),
      ),
    ),
  ));
  await tester.pumpAndSettle();
}
