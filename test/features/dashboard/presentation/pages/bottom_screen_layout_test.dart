import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/features/dashboard/presentation/pages/bottom_screen_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({}); // Mock prefs
  });

  group('BottomScreenLayout Widget Tests', () {
    testWidgets('renders bottom navigation items', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MaterialApp(home: BottomScreenLayout()),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Bookings'), findsOneWidget);
      expect(find.text('Wishlist'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('default tab is Home', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MaterialApp(home: BottomScreenLayout()),
        ),
      );

      expect(find.text('Real Estate Offers'), findsOneWidget);
    });

    testWidgets('tap tabs switches content', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MaterialApp(home: BottomScreenLayout()),
        ),
      );

      // Tap Profile
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.text('Profile Settings'), findsOneWidget);

      // Tap Home
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Real Estate Offers'), findsOneWidget);
    });
  });
}