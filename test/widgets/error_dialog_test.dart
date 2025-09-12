import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/widgets/error_dialog.dart';

void main() {
  testWidgets(
    'ErrorDialog displays the correct message',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => errorDialog("Test Error", context),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('An error occured connecting to eos!'), findsOneWidget);
      expect(find.text('Error has occured: Test Error'), findsOneWidget);
      var okFinder = find.text('OK');
      expect(okFinder, findsOneWidget);
      await tester.tap(okFinder);
    },
  );
}
