import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/core/services/connectivity/network_info.dart';
import 'package:rentease/features/dashboard/data/datasources/local/property_local_datasource.dart';
import 'package:rentease/features/dashboard/data/datasources/property_datasource.dart';
import 'package:rentease/features/dashboard/data/models/property_api_model.dart';
import 'package:rentease/features/dashboard/data/models/property_hive_model.dart';
import 'package:rentease/features/dashboard/data/repositories/property_repository.dart';


// Mock Classes
class MockPropertyLocalDatasource extends Mock implements PropertyLocalDatasource {}
class MockPropertyRemoteDataSource extends Mock implements IPropertyRemoteDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late PropertyRepository repository;
  late MockPropertyLocalDatasource mockLocalDatasource;
  late MockPropertyRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDatasource = MockPropertyLocalDatasource();
    mockRemoteDataSource = MockPropertyRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = PropertyRepository(
      propertyDatasource: mockLocalDatasource,
      propertyRemoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  // Sample data for testing
  final tPropertyApiModelList = [
    PropertyApiModel(id: '1', title: 'Test Villa', description: 'Nice place', propertyType: 'HOUSE', bhk: '2BHK', price: 1000, city: 'Kathmandu',address: 'kuleshwor',propertyImages: ["http://image.com/test.jpg"], isRented: false ),
    PropertyApiModel(id: '2', title: 'Test Apartment', description: 'Cozy',propertyType: 'HOUSE', bhk: '2BHK', price: 1000, city: 'Kathmandu',address: 'Balkhu',propertyImages: ["http://image.com/test.jpg"], isRented: false),
  ];

  final tPropertyHiveModelList = [
    PropertyHiveModel(propertyId: '1', title: 'Test Villa', description: 'Nice place', propertyType: 'HOUSE', bhk: '2BHK', price: 1000, city: 'Kathmandu',address: 'kuleshwor',propertyImages: ["http://image.com/test.jpg"], isRented: false),
    PropertyHiveModel(propertyId: '2', title: 'Test Apartment', description: 'Cozy', propertyType: 'HOUSE', bhk: '2BHK', price: 1000, city: 'Kathmandu',address: 'kuleshwor',propertyImages: ["http://image.com/test.jpg"], isRented: false),
  ];

  const tPropertyId = '1';
  final tPropertyApiModel = PropertyApiModel(id: '1', title: 'Test Villa', description: 'Nice place',propertyType: 'HOUSE', bhk: '2BHK', price: 1000, city: 'Kathmandu',address: 'kuleshwor',propertyImages: ["http://image.com/test.jpg"], isRented: false);
  final tPropertyHiveModel = PropertyHiveModel(propertyId: '1', title: 'Test Villa', description: 'Nice place', propertyType: 'HOUSE', bhk: '2BHK', price: 1000, city: 'Kathmandu',address: 'kuleshwor',propertyImages: ["http://image.com/test.jpg"], isRented: false);

  group('getAllProperty', () {
    test('should return remote data and cache it when online call is successful', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getAllProperty()).thenAnswer((_) async => tPropertyApiModelList);
      when(() => mockLocalDatasource.cacheAllProperty(any())).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.getAllProperty();

      // Assert
      expect(result.isRight(), true);
      verify(() => mockRemoteDataSource.getAllProperty()).called(1);
      verify(() => mockLocalDatasource.cacheAllProperty(any())).called(1);
    });

    test('should return cached data when online call fails (DioException)', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getAllProperty()).thenThrow(
        DioException(requestOptions: RequestOptions(path: ''))
      );
      when(() => mockLocalDatasource.getAllProperty()).thenAnswer((_) async => tPropertyHiveModelList);

      // Act
      final result = await repository.getAllProperty();

      // Assert
      expect(result.isRight(), true);
      verify(() => mockLocalDatasource.getAllProperty()).called(1);
    });

    test('should return cached data when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.getAllProperty()).thenAnswer((_) async => tPropertyHiveModelList);

      // Act
      final result = await repository.getAllProperty();

      // Assert
      expect(result.isRight(), true);
      verifyZeroInteractions(mockRemoteDataSource);
      verify(() => mockLocalDatasource.getAllProperty()).called(1);
    });
  });

  group('getPropertyById', () {
    test('should return remote data when online and ID exists', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getPropertyById(tPropertyId)).thenAnswer((_) async => tPropertyApiModel);

      // Act
      final result = await repository.getPropertyById(tPropertyId);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockRemoteDataSource.getPropertyById(tPropertyId)).called(1);
    });

    test('should return cached data when remote call fails or user is offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.getPropertyById(tPropertyId)).thenAnswer((_) async => tPropertyHiveModel);

      // Act
      final result = await repository.getPropertyById(tPropertyId);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockLocalDatasource.getPropertyById(tPropertyId)).called(1);
    });

    test('should return LocalDatabaseFailure when property is not in cache and offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.getPropertyById(tPropertyId)).thenAnswer((_) async => null);

      // Act
      final result = await repository.getPropertyById(tPropertyId);

      // Assert
      expect(result, Left(LocalDatabaseFailure(message: "Property not found in cache")));
    });
  });
}