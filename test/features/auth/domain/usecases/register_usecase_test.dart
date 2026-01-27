import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/features/auth/domain/entities/auth_entity.dart';
import 'package:rentease/features/auth/domain/repositories/auth_repository.dart';
import 'package:rentease/features/auth/domain/usecases/register_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late RegisterUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = RegisterUsecase(authRepository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      const AuthEntity(
        firstName: 'fall',
        lastName: 'back',
        email: 'fallback@email.com',
        username: 'fallback',
      ),
    );
  });

  const tFirstName = 'Test';
  const tLastName = 'User';
  const tUsername = 'Test User';
  const tEmail = 'test@email.com';
  const tPassword = 'test123';
  const tConfirmPassword = 'test123';
  const tPhoneNumber = '1234567890';

  group('RegisterUsecase', () {
    test('should return true when registration is successful', () async {
      //Arrange
      when(
        () => mockRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      //Act
      final result = await usecase(
        const RegisterUsecaseParams(
          firstName: tFirstName,
          lastName: tLastName,
          email: tEmail,
          username: tUsername,
          password: tPassword,
          confirmPassword: tConfirmPassword,
        ),
      );
      //Assert
      expect(result, const Right(true));
      verify(() => mockRepository.register(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
    test('should pass AuthEntity with correct values to repository', () async {
      AuthEntity? capturedEntity;
      when(() => mockRepository.register(any())).thenAnswer((invocation) {
        capturedEntity = invocation.positionalArguments[0] as AuthEntity;
        return Future.value(const Right(true));
      });

      //Act
      await usecase(
        const RegisterUsecaseParams(
          firstName: tFirstName,
          lastName: tLastName,
          email: tEmail,
          username: tUsername,
          password: tPassword,
          confirmPassword: tConfirmPassword,
          phoneNumber: tPhoneNumber,
        ),
      );
      //Assert
      expect(capturedEntity?.firstName, tFirstName);
      expect(capturedEntity?.lastName, tLastName);
      expect(capturedEntity?.email, tEmail);
      expect(capturedEntity?.username, tUsername);
      expect(capturedEntity?.password, tPassword);
      expect(capturedEntity?.phoneNumber, tPhoneNumber);
      expect(capturedEntity?.confirmPassword, tConfirmPassword);
    });

    test('should handle optional parameters correctly', () async {
      // Arrange
      AuthEntity? capturedEntity;
      when(() => mockRepository.register(any())).thenAnswer((invocation) {
        capturedEntity = invocation.positionalArguments[0] as AuthEntity;
        return Future.value(const Right(true));
      });
      //ACT
      await usecase(
        const RegisterUsecaseParams(
          firstName: tFirstName,
          lastName: tLastName,
          email: tEmail,
          username: tUsername,
          password: tPassword,
          confirmPassword: tConfirmPassword,
        ),
      );

      //Assert
      expect(capturedEntity?.phoneNumber, isNull);
    });
    test('should return failure when registration fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Email already exists');
      when(
        () => mockRepository.register(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const RegisterUsecaseParams(
          firstName: tFirstName,
          lastName: tLastName,
          email: tEmail,
          username: tUsername,
          password: tPassword,
          confirmPassword: tConfirmPassword,
        ),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.register(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
    test('should return NetworkFailure when there is no internet', () async {
      // Arrange
      const failure = NetworkFailure();
      when(
        () => mockRepository.register(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const RegisterUsecaseParams(
          firstName: tFirstName,
          lastName: tLastName,
          email: tEmail,
          username: tUsername,
          password: tPassword,
          confirmPassword: tConfirmPassword,
        ),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.register(any())).called(1);
    });
  });
  group('RegisterParams', () {
    test('should have correct props with all values', () {
      // Arrange
      const params = RegisterUsecaseParams(
        firstName: tFirstName,
        lastName: tLastName,
        email: tEmail,
        phoneNumber: tPhoneNumber,
        username: tUsername,
        password: tPassword,
        confirmPassword: tConfirmPassword,
        
      );
      expect(params.props, [
        tFirstName,
        tLastName,
        tEmail,
        tUsername,
        tPassword,
        tConfirmPassword,
        tPhoneNumber,
      ]);
    });

    test('should have correct props with optional values as null', () {
      // Arrange
      const params = RegisterUsecaseParams(
        firstName: tFirstName,
        lastName: tLastName,
        email: tEmail,
        username: tUsername,
        password: tPassword,
        confirmPassword: tConfirmPassword,
        
      );
      expect(params.props, [
        tFirstName,
        tLastName,
        tEmail,
        tUsername,
        tPassword,
        tConfirmPassword,
        null,
      ]);
    });

    test('two params with same values should be equal', () {
      //Arrange
      const params1 = RegisterUsecaseParams(
        firstName: tFirstName,
        lastName: tLastName,
        email: tEmail,
        username: tUsername,
        password: tPassword,
        confirmPassword: tConfirmPassword,
      );

      const params2 = RegisterUsecaseParams(
        firstName: tFirstName,
        lastName: tLastName,
        email: tEmail,
        username: tUsername,
        password: tPassword,
        confirmPassword: tConfirmPassword,
      );

      // Assert
      expect(params1, params2);
    });
  });
}
