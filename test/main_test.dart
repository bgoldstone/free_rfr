import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/configurations/scroll_behavior.dart';
import 'package:free_rfr/main.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Test MyApp Widget', (WidgetTester tester) async {
    await tester.pumpWidget(ChangeNotifierProvider(
        create: (context) => FreeRFRContext(), child: const MyApp()));
    final materialAppFinder = find.byType(MaterialApp);
    final materialAppWidget = tester.widget<MaterialApp>(materialAppFinder);

    expect(materialAppWidget.title, equals('Free RFR'));
    expect(materialAppWidget.theme?.brightness, equals(Brightness.light));
    expect(materialAppWidget.darkTheme?.brightness, equals(Brightness.dark));
    expect(materialAppWidget.scrollBehavior, isA<FreeRFRScrollBehavior>());
  });
}
