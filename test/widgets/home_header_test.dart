import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:rentease/features/auth/domain/entities/auth_entity.dart';
import 'package:rentease/features/auth/presentation/state/auth_state.dart';
import 'package:rentease/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:rentease/widgets/home_header.dart';

class FakeAuthViewModel extends AuthViewModel {
  final AuthState _testState;

  FakeAuthViewModel(this._testState);

  @override
  AuthState build() {
    return _testState;
  }
}

void main() {

  Widget createTestWidget(AuthState state) {
    return ProviderScope(
      overrides: [
        authViewModelProvider.overrideWith(
          () => FakeAuthViewModel(state),
        ),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: HomeHeader(),
        ),
      ),
    );
  }

  group('HomeHeader Widget Tests', () {

    testWidgets(
      'should display default "User" and "U" when state is initial',
      (tester) async {

        await tester.pumpWidget(
          createTestWidget(const AuthState()),
        );

        expect(find.text('Welcome back,'), findsOneWidget);
        expect(find.text('User'), findsOneWidget);
        expect(find.text('U'), findsOneWidget);
      },
    );

    testWidgets(
      'should display username and first initial when authenticated',
      (tester) async {

        const tUser = AuthEntity(
          authId: '1',
          firstName: 'Suman',
          lastName: 'Bist',
          username: 'Suman',
          email: 'suman@example.com',
        );

        final loggedInState = const AuthState(
          status: AuthStatus.authenticated,
          authEntity: tUser,
        );

        await tester.pumpWidget(
          createTestWidget(loggedInState),
        );

        expect(find.text('Suman'), findsOneWidget);
        expect(find.text('S'), findsOneWidget);
      },
    );

    testWidgets(
      'should display NetworkImage when profilePicture is available',
      (tester) async {

        const tUser = AuthEntity(
          authId: '1',
          firstName: 'Suman',
          lastName: 'Bist',
          username: 'Suman',
          email: 'suman@example.com',
          profilePicture: 'uploads/profile.png',
        );

        final stateWithImage = const AuthState(
          status: AuthStatus.authenticated,
          authEntity: tUser,
        );

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            createTestWidget(stateWithImage),
          );

          // Initial text should NOT appear
          expect(find.text('S'), findsNothing);

          final avatarFinder = find.byType(CircleAvatar);
          expect(avatarFinder, findsOneWidget);

          final avatar =
              tester.widget<CircleAvatar>(avatarFinder);

          expect(avatar.backgroundImage, isNotNull);
        });
      },
    );
  });
}