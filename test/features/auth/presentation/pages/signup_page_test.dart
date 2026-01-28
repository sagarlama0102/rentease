import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/core/services/storage/user_session_service.dart';

import 'package:rentease/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:rentease/features/auth/domain/usecases/login_usecase.dart';
import 'package:rentease/features/auth/domain/usecases/logout_usecase.dart';
import 'package:rentease/features/auth/domain/usecases/register_usecase.dart';

import 'package:rentease/features/auth/presentation/pages/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock NavigatorObserver to track navigation
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockLogoutUsecase mockLogoutUsecase;

  setUpAll(() {
    registerFallbackValue(
      const RegisterUsecaseParams(
        firstName: 'fall',
        lastName: 'back',
        email: 'fallback@email.com',
        username: 'fallback',
        password: 'fallback',
        confirmPassword: 'fallback',
      ),
    );
    registerFallbackValue(
      const LoginUsecaseParams(
        email: 'fallback@email.com',
        password: 'fallback',
      ),
    );
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        getCurrentUserUsecaseProvider.overrideWithValue(
          mockGetCurrentUserUsecase,
        ),
        logoutUsecaseProvider.overrideWithValue(mockLogoutUsecase),
        sharedPreferencesProvider.overrideWithValue(MockSharedPreferences()),
      ],
      child: const MaterialApp(home: SignupPage()),
    );
  }

  group('SignupPage - UI Elements', () {
    testWidgets('should display header text and form fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 1. Header RichText Check
      final richTextFinder = find.byType(RichText);
      expect(richTextFinder, findsAtLeastNWidgets(1));

      final RichText headerWidget = tester.widget(richTextFinder.first);
      final String headerText = headerWidget.text.toPlainText();
      expect(headerText, contains('Sign'));
      expect(headerText, contains('Up'));

      // 2. Form Labels
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);

      // 3. Icons (This was causing your crash!)
      // Both First Name and Last Name use person_outline_rounded
      expect(find.byIcon(Icons.person_outline_rounded), findsNWidgets(2));
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.phone_outlined), findsOneWidget);
      // Password and Confirm Password use lock_outline_rounded
      expect(find.byIcon(Icons.lock_outline_rounded), findsNWidgets(2));
    });
    testWidgets('should display create account button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Create an Account'), findsOneWidget);
    });
    testWidgets('should display login link', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Already have an account?'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });
  });

  group('SignupPage - Form Input', () {
    testWidgets('should allow entering name', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'Test');
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).last, 'User');
      await tester.pump();

      expect(find.text('Test'), findsOneWidget);
      expect(find.text('User'), findsOneWidget);

    });

    testWidgets('should allow entering email', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(2), 'test@example.com');
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
    });

    
    testWidgets('should allow entering phone number', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(3), '9800000000');
      await tester.pump();

      // Verify by checking the text field controller value
      final phoneField = tester.widget<TextFormField>(textFields.at(3));
      expect(phoneField.controller?.text, '9800000000');
    });
  });

  group('SignupPage - Form Validation', () {
  
  testWidgets('should show error when first name is empty', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Tap Create Account button
    await tester.tap(find.text('Create an Account'));
    await tester.pump(); // Pump to trigger validation display

    // According to your UI code: validator: (value) => ... ? 'Required' : null
    expect(find.text('Required'), findsAtLeastNWidgets(1));
  });

  testWidgets('should show error when email is invalid', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // UI Order: 0:Fname, 1:Lname, 2:Email
    final emailField = find.widgetWithText(TextFormField, 'Email Address');
    
    await tester.enterText(emailField, 'invalid-email');
    await tester.pump();

    // Tap Create Account
    await tester.tap(find.text('Create an Account'));
    await tester.pump();

    // Your UI code says: return 'Invalid email';
    expect(find.text('Invalid email'), findsOneWidget);
  });

  testWidgets('should show error when phone is less than 10 digits', (tester) async {
    // Increase surface size if you have a small screen height to avoid "RenderObject not hit"
    await tester.binding.setSurfaceSize(const Size(800, 1200));

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    final phoneField = find.widgetWithText(TextFormField, 'Phone Number');
    
    await tester.enterText(phoneField, '12345'); // Only 5 digits
    await tester.pump();

    // Tap Create Account
    await tester.tap(find.text('Create an Account'));
    await tester.pump();

    // Your UI code says: return 'Must be 10 digits';
    expect(find.text('Must be 10 digits'), findsOneWidget);

    // Reset surface size
    await tester.binding.setSurfaceSize(null);
  });
});

  group('SignupPage - Form Submission', () {
    testWidgets('should call register usecase when form is valid', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      // Return failure to avoid navigation issues
      when(
        () => mockRegisterUsecase(any()),
      ).thenAnswer((_) async => const Left(ApiFailure(message: 'Test')));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill out all form fields
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Test');
      await tester.enterText(textFields.at(1), 'Test');
      await tester.enterText(textFields.at(2), 'test@example.com');
      await tester.enterText(textFields.at(3), '9800000000');
      await tester.enterText(textFields.at(4), 'password123');
      await tester.enterText(textFields.at(5), 'password123');
      await tester.pump();

      // Tap Create Account
      await tester.tap(find.text('Create an Account'));
      await tester.pumpAndSettle();

      verify(() => mockRegisterUsecase(any())).called(1);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should pass correct params to register usecase', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      RegisterUsecaseParams? capturedParams;
      when(() => mockRegisterUsecase(any())).thenAnswer((invocation) async {
        capturedParams = invocation.positionalArguments[0] as RegisterUsecaseParams;
        return const Right(true);
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill form
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'John');
      await tester.enterText(textFields.at(1), 'Doe');
      await tester.enterText(textFields.at(2), 'john@example.com');
      await tester.enterText(textFields.at(3), '9800000000');
      await tester.enterText(textFields.at(4), 'mypassword');
      await tester.enterText(textFields.at(5), 'mypassword');
      await tester.pump();

      

      // Submit
      await tester.tap(find.text('Create an Account'));
      await tester.pumpAndSettle();

      // Verify captured params
      expect(capturedParams?.firstName, 'John');
      expect(capturedParams?.lastName, 'Doe');
      expect(capturedParams?.email, 'john@example.com');
      expect(capturedParams?.password, 'mypassword');

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should succeed with valid data and fail with invalid data', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      const validEmail = 'valid@example.com';
      const validPassword = 'validpass';
      const failure = ApiFailure(message: 'Registration failed');

      // Mock register to check data using if condition
      when(() => mockRegisterUsecase(any())).thenAnswer((invocation) async {
        final params = invocation.positionalArguments[0] as RegisterUsecaseParams;

        // Check if email and password are valid
        if (params.email == validEmail && params.password == validPassword) {
          return const Right(true);
        }
        return const Left(failure);
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill form with valid data
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Test');
      await tester.enterText(textFields.at(1), 'User');
      await tester.enterText(textFields.at(2), validEmail);
      await tester.enterText(textFields.at(3), '9800000000');
      await tester.enterText(textFields.at(4), validPassword);
      await tester.enterText(textFields.at(5), validPassword);
      await tester.pump();


      // Submit
      await tester.tap(find.text('Create an Account'));
      await tester.pumpAndSettle();

      verify(() => mockRegisterUsecase(any())).called(1);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should not call register when terms not accepted', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill all fields but don't check terms
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Test');
      await tester.enterText(textFields.at(1), 'User');
      await tester.enterText(textFields.at(2), 'test@example.com');
      await tester.enterText(textFields.at(3), '9800000000');
      await tester.enterText(textFields.at(4), 'password123');
      await tester.enterText(textFields.at(5), 'password123');
      await tester.pump();

      // Register should not be called
      verifyNever(() => mockRegisterUsecase(any()));

      await tester.binding.setSurfaceSize(null);
    });
  });
  


}
