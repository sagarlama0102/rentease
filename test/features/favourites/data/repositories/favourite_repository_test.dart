import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/core/services/connectivity/network_info.dart';
import 'package:rentease/features/favourites/data/datasources/favourite_datasource.dart';
import 'package:rentease/features/favourites/data/datasources/local/favourite_local_datasource.dart';
import 'package:rentease/features/favourites/data/models/favourite_api_model.dart';
import 'package:rentease/features/favourites/data/models/favourite_hive_model.dart';
import 'package:rentease/features/favourites/data/repositories/favourite_repository.dart';
import 'package:rentease/features/favourites/domain/entities/favourite_entity.dart';

class MockFavouriteLocalDatasource extends Mock implements FavouriteLocalDatasource {}
class MockFavouriteRemoteDataSource extends Mock implements IFavouriteRemoteDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late FavouriteRepository repository;
  late MockFavouriteLocalDatasource mockLocalDatasource;
  late MockFavouriteRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDatasource = MockFavouriteLocalDatasource();
    mockRemoteDataSource = MockFavouriteRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = FavouriteRepository(
      localDatasource: mockLocalDatasource,
      remoteDatasource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  setUpAll(() {
    registerFallbackValue(<FavouriteHiveModel>[]);
  });

  // Sample Data
  final tFavouriteApiModel = FavouriteApiModel(userId: '1', propertyId: 'prop1');
  final tFavouriteHiveModel = FavouriteHiveModel(userId: '1', propertyId: 'prop1',propertyImages:["http://image.com/test.jpg"] );
  final tFavouriteEntity = FavouriteEntity(userId: '1', propertyId: 'prop1');

  group('getAllFavourites', () {
    test('should return remote data and cache it when online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getAllFavourites())
          .thenAnswer((_) async => [tFavouriteApiModel]);
      when(() => mockLocalDatasource.cacheAllFavourites(any()))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.getAllFavourites();

      // Assert
      expect(result.isRight(), true);
      final list = result.getOrElse(() => []);
      expect(list[0].propertyId, tFavouriteEntity.propertyId);
      verify(() => mockRemoteDataSource.getAllFavourites()).called(1);
      verify(() => mockLocalDatasource.cacheAllFavourites(any())).called(1);
    });

    test('should return cached data when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.getAllFavourites())
          .thenAnswer((_) async => [tFavouriteHiveModel]);

      // Act
      final result = await repository.getAllFavourites();

      // Assert
      expect(result.isRight(), true);
      verifyZeroInteractions(mockRemoteDataSource);
      verify(() => mockLocalDatasource.getAllFavourites()).called(1);
    });
  });

  group('toggleFavourite', () {
    const tPropertyId = 'prop1';

    test('should toggle remote and refresh cache when online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.toggleFavourite(any())).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getAllFavourites()).thenAnswer((_) async => []);
      when(() => mockLocalDatasource.cacheAllFavourites(any())).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.toggleFavourite(tPropertyId);

      // Assert
      expect(result, const Right(true));
      verify(() => mockRemoteDataSource.toggleFavourite(tPropertyId)).called(1);
      verify(() => mockRemoteDataSource.getAllFavourites()).called(1);
      verify(() => mockLocalDatasource.cacheAllFavourites(any())).called(1);
    });

    test('should return NetworkFailure when toggling offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.toggleFavourite(tPropertyId);

      // Assert
      expect(result, const Left(NetworkFailure(message: "No internet connection to toggle favourites")));
      verifyNever(() => mockRemoteDataSource.toggleFavourite(any()));
    });
  });

  group('isFavourite', () {
    test('should return status from local datasource', () async {
      // Arrange
      when(() => mockLocalDatasource.isFavourite(any())).thenAnswer((_) async => true);

      // Act
      final result = await repository.isFavourite('prop1');

      // Assert
      expect(result, const Right(true));
      verify(() => mockLocalDatasource.isFavourite('prop1')).called(1);
    });

    test('should return LocalDatabaseFailure when local call fails', () async {
      // Arrange
      when(() => mockLocalDatasource.isFavourite(any())).thenThrow(Exception('DB Error'));

      // Act
      final result = await repository.isFavourite('prop1');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<LocalDatabaseFailure>()),
        (_) => fail('Should have failed'),
      );
    });
  });
}