import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/services/connectivity/network_info.dart';
import 'package:rentease/features/auth/data/datasources/auth_datasource.dart';
import 'package:rentease/features/auth/data/models/auth_api_model.dart';
import 'package:rentease/features/auth/data/models/auth_hive_model.dart';
import 'package:rentease/features/auth/data/repositories/auth_repository.dart';
import 'package:rentease/features/auth/domain/entities/auth_entity.dart';

// Mock Classes
class MockAuthLocalDataSource extends Mock implements IAuthLocalDatasource {}
class MockAuthRemoteDataSource extends Mock implements IAuthRemoteDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late AuthRepository repository;
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockAuthLocalDataSource();
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthRepository(
      authDatasource: mockLocalDataSource,
      authRemoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  setUpAll(() {
    // Registering fallback values with your updated fields
    registerFallbackValue(const AuthEntity(
      firstName: '', 
      lastName: '', 
      username: '',
      email: '', 
      phoneNumber: '', 
      password: ''
    ));
    registerFallbackValue(AuthApiModel(
      firstName: '', 
      lastName: '', 
      username: '',
      email: '', 
      phoneNumber: ''
    ));
    registerFallbackValue(AuthHiveModel(
      firstName: '', 
      lastName: '', 
      username: '',
      email: '', 
      phoneNumber: '', 
      password: ''
    ));
    registerFallbackValue(File(''));
  });

  // Updated Test Constants
  const tAuthEntity = AuthEntity(
    authId: '1',
    firstName: 'John',
    lastName: 'Doe',
    username: 'John_Doe',
    email: 'john@gmail.com',
    phoneNumber: '9876543210',
    password: 'password123',
  );

  final tAuthApiModel = AuthApiModel(
    id: '1',
    firstName: 'John',
    lastName: 'Doe',
    username: 'John_Doe',
    email: 'john@gmail.com',
    phoneNumber: '9876543210',
  );

  final tAuthHiveModel = AuthHiveModel(
    authId: '1',
    firstName: 'John',
    lastName: 'Doe',
    username: 'John_Doe',
    email: 'john@gmail.com',
    phoneNumber: '9876543210',
    password: 'password123',
  );

  group('register', () {
    test('should return Right(true) when online and registration succeeds', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      
      // FIX: Return the model, not a boolean
      when(() => mockRemoteDataSource.register(any()))
          .thenAnswer((_) async => tAuthApiModel); 

      // Act
      final result = await repository.register(tAuthEntity);

      // Assert
      expect(result, const Right(true));
      verify(() => mockRemoteDataSource.register(any())).called(1);
    });

    test('should return Right(true) and register locally when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.register(any())).thenAnswer((_) async => true);

      final result = await repository.register(tAuthEntity);

      expect(result, const Right(true));
      verify(() => mockLocalDataSource.register(any())).called(1);
    });
  });

  group('login', () {
    const tEmail = 'john@gmail.com';
    const tPassword = 'password123';

    test('should return AuthEntity and save locally when online login succeeds', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.login(any(), any())).thenAnswer((_) async => tAuthApiModel);
      when(() => mockLocalDataSource.register(any())).thenAnswer((_) async => true);

      final result = await repository.login(tEmail, tPassword);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should be right'),
        (r) => expect(r.email, tEmail),
      );
      verify(() => mockRemoteDataSource.login(tEmail, tPassword)).called(1);
      verify(() => mockLocalDataSource.register(any())).called(1);
    });
  });

  group('getCurrentUser', () {
    test('should return AuthEntity when user exists in local storage', () async {
      when(() => mockLocalDataSource.getCurrentUser()).thenAnswer((_) async => tAuthHiveModel);

      final result = await repository.getCurrentUser();

      expect(result.isRight(), true);
      verify(() => mockLocalDataSource.getCurrentUser()).called(1);
    });

    test('should return Left(LocalDatabaseFailure) when no user is found', () async {
      when(() => mockLocalDataSource.getCurrentUser()).thenAnswer((_) async => null);

      final result = await repository.getCurrentUser();

      result.fold(
        (failure) => expect(failure.message, "No user logged in"),
        (_) => fail("Should have failed"),
      );
    });
  });

  group('uploadPhoto', () {
    final tFile = File('test.jpg');
    const tUrl = "http://image.com/test.jpg";

    test('should return image URL when online and upload succeeds', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.uploadPhoto(any())).thenAnswer((_) async => tUrl);

      final result = await repository.uploadPhoto(tFile);

      expect(result, const Right(tUrl));
    });
  });
}