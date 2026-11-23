import 'package:flutter_test/flutter_test.dart';
import 'package:free_rfr/widgets/button.dart';
import 'package:free_rfr/widgets/grid.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('Button invokes tap and long press callbacks', (tester) async {
    var taps = 0;
    var longPresses = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Button(
            'Press',
            () => taps++,
            onLongPress: () => longPresses++,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Press'));
    await tester.longPress(find.text('Press'));
    await tester.pump();

    expect(taps, 1);
    expect(longPresses, 1);
  });

  testWidgets('Button highlights selected text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Button('Selected', () {}, isSelected: true),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('Selected'));
    expect(text.style?.color, Colors.yellow);
  });

  testWidgets('Button scales long text to fit', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 80,
              height: 48,
              child: Button('A very long button label', () {}),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(FittedBox), findsOneWidget);
    final text = tester.widget<Text>(find.text('A very long button label'));
    expect(text.maxLines, isNull);
    expect(text.overflow, isNull);
  });

  testWidgets('Grid renders nothing when empty', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 200,
            child: Grid(3, []),
          ),
        ),
      ),
    );

    expect(find.byType(GridView), findsNothing);
  });

  testWidgets('Grid lays out children with configured spacing', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 200,
            child: Grid(
              3,
              [
                const Text('One'),
                const Text('Two'),
                const Text('Three'),
                const Text('Four'),
              ],
              scale: 8.0,
            ),
          ),
        ),
      ),
    );

    final grid = tester.widget<GridView>(find.byType(GridView));
    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisCount, 3);
    expect(delegate.mainAxisSpacing, 8.0);
    expect(delegate.crossAxisSpacing, 8.0);
    expect(grid.shrinkWrap, isTrue);
    expect(grid.physics, isA<NeverScrollableScrollPhysics>());
    expect(grid.childrenDelegate.estimatedChildCount, 4);

    final itemWidth = (300 - 2 * 8.0) / 3;
    final itemHeight = (200 - 1 * 8.0) / 2;
    expect(delegate.childAspectRatio, closeTo(itemWidth / itemHeight, 0.0001));
  });
}
