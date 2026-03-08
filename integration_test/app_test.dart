import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rentease/app/app.dart';
import 'package:rentease/core/services/hive/hive_service.dart';
import 'package:rentease/core/services/storage/user_session_service.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('RentEase Integration Tests', () {
    late SharedPreferences sharedPreferences;

    setUpAll(() async {
      // Initialize Hive
      await HiveService().init();

      // Initialize SharedPreferences for Testing
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
    });

    Widget createTestApp() {
      return ProviderScope(
        overrides: [
          // This is the CRITICAL part. 
          // It replaces the "UnimplementedError" provider with your actual instance.
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const App(),
      );
    }

testWidgets('Full Flow: Splash to Onboarding to Login', (tester) async {
  await tester.pumpWidget(createTestApp());

  // 1. Verify Splash
  expect(find.textContaining('RENT'), findsOneWidget);

  // 2. Settle Splash (Waiting 4s for your 3s timer + animations)
  await tester.pumpAndSettle(const Duration(seconds: 4));

  // 3. Handle Onboarding - Corrected Logic
  final getStartedButton = find.text('Get Started'); 
  // We use tester.any() to check if the widget is on screen
  if (tester.any(getStartedButton)) {
      await tester.tap(getStartedButton);
      await tester.pumpAndSettle();
  }

  // 4. Login Interaction
  // Finding by labelText 'Email' is safer than textContaining('Log')
  final emailField = find.widgetWithText(TextFormField, 'Email');
  final passwordField = find.widgetWithText(TextFormField, 'Password');
  
  expect(emailField, findsOneWidget);
  
  await tester.enterText(emailField, 'test@gmail.com');
  await tester.enterText(passwordField, 'password123');
  
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
  
  // 5. Tap Login
  final loginButton = find.widgetWithText(ElevatedButton, 'Login');
  await tester.tap(loginButton);
  
  // Wait for API response and navigation to Dashboard
  await tester.pumpAndSettle(const Duration(seconds: 2));

  // 6. Final Verification (Optional but recommended)
  // expect(find.text('Dashboard'), findsOneWidget);
});
  });
}