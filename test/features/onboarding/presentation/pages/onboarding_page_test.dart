import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentease/core/services/storage/user_session_service.dart';
import 'package:rentease/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:rentease/features/onboarding/presentation/widgets/page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences sharedPreferences;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
  });

  // Helper to pump the widget with necessary providers
  Future<void> pumpOnboardingPage(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const MaterialApp(home: OnboardingPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('OnboardingPage - UI Elements', () {
    testWidgets('should display Skip button', (tester) async {
      await pumpOnboardingPage(tester);
      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('should display PageView for swipeable content', (tester) async {
      await pumpOnboardingPage(tester);
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('should display first onboarding title', (tester) async {
      await pumpOnboardingPage(tester);
      // Using textContaining because of the \n in your string
      expect(find.textContaining('Discover your dream home'), findsOneWidget);
    });

    testWidgets('should display Next button on first page', (tester) async {
      await pumpOnboardingPage(tester);
      expect(find.text('NEXT'), findsOneWidget); // Note: Uppercase in your code
    });

    testWidgets('should display initial home_work icon', (tester) async {
      await pumpOnboardingPage(tester);
      expect(find.byIcon(Icons.home_work), findsOneWidget);
    });
  });

  group('OnboardingPage - Page Navigation', () {
    testWidgets('should navigate to second page on NEXT tap', (tester) async {
      await pumpOnboardingPage(tester);

      // Tap NEXT
      await tester.tap(find.text('NEXT'));
      await tester.pumpAndSettle();

      // Second page content
      expect(find.textContaining('Safe and Secure'), findsOneWidget);
      expect(find.byIcon(Icons.security), findsOneWidget);
    });

    testWidgets('should navigate to last page and show GET STARTED', (tester) async {
      await pumpOnboardingPage(tester);

      // Tap NEXT twice to reach 3rd page
      await tester.tap(find.text('NEXT'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('NEXT'));
      await tester.pumpAndSettle();

      // Third page content
      expect(find.textContaining('List your property'), findsOneWidget);
      expect(find.text('GET STARTED'), findsOneWidget);
      expect(find.byIcon(Icons.add_business), findsOneWidget);
    });

    testWidgets('should allow swiping between pages', (tester) async {
      await pumpOnboardingPage(tester);

      // Swipe left to go to second page
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(find.textContaining('Safe and Secure'), findsOneWidget);
    });
  });

  group('OnboardingPage - Logic and Layout', () {
    testWidgets('should have a Stack and PageIndicator', (tester) async {
      await pumpOnboardingPage(tester);
      
      expect(find.byType(Stack), findsWidgets);
      // Finding your custom PageIndicator widget
      expect(find.byType(typeOf<PageIndicator>()), findsWidgets); 
    });
  });
}

// Helper to handle types in find.byType if needed
Type typeOf<T>() => T;