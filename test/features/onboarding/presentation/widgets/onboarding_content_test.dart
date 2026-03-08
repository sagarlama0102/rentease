import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentease/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:rentease/features/onboarding/presentation/widgets/onboarding_content.dart';

void main() {

  final testData = OnboardingPageData(
    title: "Discover your dream home",
    imagePath: 'assets/images/onboardingoneimage.png',
    icon: Icons.home_work,
  );

  Widget createTestWidget() {
    return MaterialApp(
      home: Scaffold(
        body: OnboardingContent(item: testData),
      ),
    );
  }

  group('OnboardingContent Widget Tests', () {

    testWidgets('should display correct title text',
        (WidgetTester tester) async {

      await tester.pumpWidget(createTestWidget());

      expect(find.text("Discover your dream home"),
          findsOneWidget);
    });

    testWidgets('should display correct icon',
        (WidgetTester tester) async {

      await tester.pumpWidget(createTestWidget());

      final iconFinder = find.byIcon(Icons.home_work);
      expect(iconFinder, findsOneWidget);

      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.size, 140);
      expect(iconWidget.color, const Color(0xff99DAB3));
    });

    testWidgets('should apply background image with dark overlay',
        (WidgetTester tester) async {

      await tester.pumpWidget(createTestWidget());

      final container =
          tester.widget<Container>(find.byType(Container));

      final decoration =
          container.decoration as BoxDecoration;

      final image = decoration.image!;

      expect(image.image, isA<AssetImage>());
      expect((image.image as AssetImage).assetName,
  testData.imagePath,);

      expect(image.fit, BoxFit.cover);
      expect(image.colorFilter, isNotNull);
    });

    testWidgets('should center content vertically',
        (WidgetTester tester) async {

      await tester.pumpWidget(createTestWidget());

      final column = tester.widget<Column>(
          find.byType(Column));

      expect(column.mainAxisAlignment,
          MainAxisAlignment.center);
    });
  });
}