import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/services/storage/user_session_service.dart';
import 'package:rentease/features/splash/presentation/pages/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


// Mock the Session Service
class MockUserSessionService extends Mock implements UserSessionService {}

void main() {
  late MockUserSessionService mockUserSessionService;
  late SharedPreferences sharedPreferences;

  setUpAll(() async {
    // Initializing SharedPreferences for the test environment
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
  });

  setUp(() {
    mockUserSessionService = MockUserSessionService();
    // Default to not logged in for UI tests
    when(() => mockUserSessionService.isLoggedIn()).thenReturn(false);
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        userSessionServiceProvider.overrideWithValue(mockUserSessionService),
      ],
      child: const MaterialApp(
        home: SplashPage(),
      ),
    );
  }

  group('SplashPage Functional Tests', () {
    
    testWidgets('should show RENTEASE and clear all background timers', (tester) async {
      // 1. Build the widget
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(RichText), findsOneWidget);

      final rentFinder = find.byWidgetPredicate(
        (widget) => widget is RichText && widget.text.toPlainText().contains('RENT'),
      );
      final easeFinder = find.byWidgetPredicate(
        (widget) => widget is RichText && widget.text.toPlainText().contains('EASE'),
      );

      expect(rentFinder, findsOneWidget);
      expect(easeFinder, findsOneWidget);

      await tester.pump(const Duration(seconds: 1)); 
      await tester.pumpAndSettle(const Duration(seconds: 4));
      
      verify(() => mockUserSessionService.isLoggedIn()).called(1);
    });

    testWidgets('should have the correct brand background color', (tester) async {
      await tester.pumpWidget(createTestWidget());
      
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xff142725));

      await tester.pumpAndSettle(const Duration(seconds: 5));
    });

    testWidgets('should display SafeArea and transitions', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(FadeTransition), findsWidgets);
      expect(find.byType(SlideTransition), findsWidgets);

      await tester.pumpAndSettle(const Duration(seconds: 5));
    });

    testWidgets('should navigate to next screen after 3 seconds', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.pump(const Duration(seconds: 3));

      await tester.pump(const Duration(milliseconds: 100));

      verify(() => mockUserSessionService.isLoggedIn()).called(1);
      
      await tester.pumpAndSettle();
    });
  });
}