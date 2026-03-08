import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/features/auth/domain/entities/auth_entity.dart';
import 'package:rentease/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:rentease/features/auth/domain/usecases/login_usecase.dart';
import 'package:rentease/features/auth/domain/usecases/logout_usecase.dart';
import 'package:rentease/features/auth/domain/usecases/register_usecase.dart';
import 'package:rentease/features/auth/domain/usecases/upload_photo_usecase.dart';
import 'package:rentease/features/auth/presentation/state/auth_state.dart';
import 'package:rentease/features/auth/presentation/view_model/auth_view_model.dart';

// Mock Classes
class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class MockUploadPhotoUsecase extends Mock implements UploadPhotoUsecase {}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
  late MockUploadPhotoUsecase mockUploadPhotoUsecase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(
      RegisterUsecaseParams(
        firstName: '',
        lastName: '',
        email: '',
        username: '',
        password: '',
        confirmPassword: '',
      ),
    );
    registerFallbackValue(const LoginUsecaseParams(email: '', password: ''));
    registerFallbackValue(File(''));
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
    mockUploadPhotoUsecase = MockUploadPhotoUsecase();

    container = ProviderContainer(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        getCurrentUserUsecaseProvider.overrideWithValue(
          mockGetCurrentUserUsecase,
        ),
        logoutUsecaseProvider.overrideWithValue(mockLogoutUsecase),
        uploadPhotoUsecaseProvider.overrideWithValue(mockUploadPhotoUsecase),
      ],
    );
  });

  tearDown(() => container.dispose());

  const tUser = AuthEntity(
    authId: '1',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@doe.com',
    username: 'johndoe',
  );

  group('AuthViewModel Tests', () {
    test('Initial state should be AuthStatus.initial', () {
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.initial);
      expect(state.errorMessage, isNull);
    });

    group('register', () {
      test(
        'should emit registered state when registration is successful',
        () async {
          // Arrange
          when(
            () => mockRegisterUsecase(any()),
          ).thenAnswer((_) async => const Right(true));

          final viewModel = container.read(authViewModelProvider.notifier);

          // Act
          await viewModel.register(
            firstName: 'John',
            lastName: 'Doe',
            email: 'john@doe.com',
            username: 'johndoe',
            password: 'password123',
            confirmPassword: 'password123',
          );

          // Assert
          final state = container.read(authViewModelProvider);
          expect(state.status, AuthStatus.registered);
        },
      );

      test('should emit error state when registration fails', () async {
        // Arrange
        when(() => mockRegisterUsecase(any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Registration Failed')),
        );

        final viewModel = container.read(authViewModelProvider.notifier);

        // Act
        await viewModel.register(
          firstName: 'John',
          lastName: 'Doe',
          email: 'john@doe.com',
          username: 'johndoe',
          password: 'password123',
          confirmPassword: 'password123',
        );

        // Assert
        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.error);
        expect(state.errorMessage, 'Registration Failed');
      });
      group('login', () {
        test(
          'should emit authenticated state when login is successful',
          () async {
            // Arrange
            when(
              () => mockLoginUsecase(any()),
            ).thenAnswer((_) async => const Right(tUser));

            final viewModel = container.read(authViewModelProvider.notifier);

            // Act
            await viewModel.login(
              email: 'john@doe.com',
              password: 'password123',
            );

            // Assert
            final state = container.read(authViewModelProvider);
            expect(state.status, AuthStatus.authenticated);
            expect(state.authEntity, tUser);
          },
        );

        test('should emit error state when login fails', () async {
          // Arrange
          when(() => mockLoginUsecase(any())).thenAnswer(
            (_) async => const Left(ApiFailure(message: 'Invalid Credentials')),
          );

          final viewModel = container.read(authViewModelProvider.notifier);

          // Act
          await viewModel.login(email: 'john@doe.com', password: 'password123');

          // Assert
          final state = container.read(authViewModelProvider);
          expect(state.status, AuthStatus.error);
          expect(state.errorMessage, 'Invalid Credentials');
        });
      });

      group('logout', () {
        test(
          'should emit unauthenticated state when logout is successful',
          () async {
            // Arrange
            when(
              () => mockLogoutUsecase(),
            ).thenAnswer((_) async => const Right(true));

            final viewModel = container.read(authViewModelProvider.notifier);

            // Act
            await viewModel.logout();

            // Assert
            final state = container.read(authViewModelProvider);
            expect(state.status, AuthStatus.unauthenticated);
            expect(state.authEntity, isNull);
          },
        );
      });

      group('uploadPhoto', () {
        test(
          'should emit loaded state and return url when successful',
          () async {
            // Arrange
            const tUrl = 'http://image.com/photo.jpg';
            when(
              () => mockUploadPhotoUsecase(any()),
            ).thenAnswer((_) async => const Right(tUrl));

            final viewModel = container.read(authViewModelProvider.notifier);

            // Act
            final result = await viewModel.uploadPhoto(File('test.jpg'));

            // Assert
            expect(result, tUrl);
            final state = container.read(authViewModelProvider);
            expect(state.status, AuthStatus.loaded);
            expect(state.uploadedPhotoUrl, tUrl);
          },
        );
      });
    });
  });
}
