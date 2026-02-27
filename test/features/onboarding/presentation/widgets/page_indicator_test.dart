import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentease/features/onboarding/presentation/widgets/page_indicator.dart';

void main() {
  group('PageIndicator Widget Tests', () {
    const int itemCount = 5;
    const int currentPage = 2; // Active dot index
    const Color activeColor = Colors.green;

    Widget createTestWidget({required int current}) {
      return MaterialApp(
        home: Scaffold(
          body: PageIndicator(
            itemCount: itemCount,
            currentPage: current,
            activeColor: activeColor,
          ),
        ),
      );
    }

    testWidgets('renders correct number of dots', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(current: currentPage));

      // There should be `itemCount` AnimatedContainers
      final dotsFinder = find.byType(AnimatedContainer);
      expect(dotsFinder, findsNWidgets(itemCount));
    });

    testWidgets(
      'active dot is wider than inactive dots and has correct color',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(current: currentPage));

        final activeDotFinder = find.byType(AnimatedContainer).at(currentPage);
        final activeDot = tester.widget<AnimatedContainer>(activeDotFinder);
        final activeSize = tester.getSize(activeDotFinder);

        // Width should be greater than inactive dots
        for (int i = 0; i < itemCount; i++) {
          if (i == currentPage) continue;
          final dotSize = tester.getSize(find.byType(AnimatedContainer).at(i));
          expect(activeSize.width, greaterThan(dotSize.width));
          expect(
            activeSize.height,
            equals(dotSize.height),
          ); // height should match
        }

        final decoration = activeDot.decoration as BoxDecoration;
        expect(decoration.color, activeColor);
      },
    );

    testWidgets('inactive dots have correct color', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget(current: currentPage));

      for (int i = 0; i < itemCount; i++) {
        if (i == currentPage) continue;

        final dot = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer).at(i),
        );
        final decoration = dot.decoration as BoxDecoration;
        expect(decoration.color, Colors.grey[400]);
      }
    });
  });
}
