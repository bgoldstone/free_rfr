import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/objects/parameters.dart';

void main() {
  testWidgets('Test FreeRFRContext', (WidgetTester tester) async {
    final context = FreeRFRContext();
    expect(context, isNotNull);

    ParameterMap parameters = {
      ParameterType.intens: [50],
      ParameterType.pan: [0]
    };
    expect(context.currentChannel, equals({}));
    context.currentChannel = parameters;

    expect(context.currentChannel[ParameterType.intens], [50]);
    expect(context.currentChannel[ParameterType.pan], [0]);
    expect(context.currentChannel, {
      ParameterType.intens: [50],
      ParameterType.pan: [0]
    });

    expect(context.currentConnectionIndex, equals(-1));
    context.currentConnectionIndex = 2;
    expect(context.currentConnectionIndex, equals(2));

    expect(context.currentCue, equals(-1));
    context.currentCue = 0;
    expect(context.currentCue, equals(0));

    expect(context.currentCueText, equals(''));
    context.currentCueText = 'Test Cue Text';
    expect(context.currentCueText, equals('Test Cue Text'));

    expect(context.previousCue, equals(-1));
    context.previousCue = 3;
    expect(context.previousCue, equals(3));

    expect(context.previousCueText, equals(''));
    context.previousCueText = 'Prev Cue Text';
    expect(context.previousCueText, equals('Prev Cue Text'));

    expect(context.nextCue, equals(-1));
    context.nextCue = 5;
    expect(context.nextCue, equals(5));

    expect(context.nextCueText, equals(''));
    context.nextCueText = 'Next Cue Text';
    expect(context.nextCueText, equals('Next Cue Text'));

    expect(context.hueSaturation, equals([]));
    context.hueSaturation = [1, 5];
    expect(context.hueSaturation, equals([1, 5]));

    expect(context.commandLine, equals(''));
    context.commandLine = 'Test Command Line';
    expect(context.commandLine, equals('Test Command Line'));
    expect(context.directSelects, equals({}));
    context.directSelects = {1: DS(1, "test")};
    expect(context.directSelects, hasLength(1));

    expect(context.currentCueList, equals(1));
    context.currentCueList = 2;
    expect(context.currentCueList, equals(2));
  });

  testWidgets('Test DS', (WidgetTester tester) async {
    final ds = DS(1, "test");
    expect(ds, isNotNull);
    expect(ds.name, equals("test"));
    expect(ds.objectNumber, equals(1));
  });
}
