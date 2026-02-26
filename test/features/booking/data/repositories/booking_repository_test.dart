import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/core/services/connectivity/network_info.dart';
import 'package:rentease/features/booking/data/datasources/booking_datasource.dart';
import 'package:rentease/features/booking/data/datasources/local/booking_local_datasource.dart';
import 'package:rentease/features/booking/data/models/booking_api_model.dart';
import 'package:rentease/features/booking/data/models/booking_hive_model.dart';
import 'package:rentease/features/booking/data/repositories/booking_repository.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';

// Mock Classes
class MockBookingLocalDatasource extends Mock implements BookingLocalDatasource {}
class MockBookingRemoteDataSource extends Mock implements IBookingRemoteDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late BookingRepository repository;
  late MockBookingLocalDatasource mockLocalDatasource;
  late MockBookingRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  // Use a fixed date to avoid millisecond mismatches during comparison
  final tFixedDate = DateTime(2024, 1, 1);
  final tFixedDateString = tFixedDate.toIso8601String();

  // 1. REGISTER FALLBACK VALUES
  setUpAll(() {
    registerFallbackValue(BookingStatus.pending);
    registerFallbackValue(
      BookingApiModel(
        id: '0',
        propertyId: '0',
        userId: '0',
        status: 'pending',
        createdAt: tFixedDateString,
      ),
    );
    registerFallbackValue(<BookingHiveModel>[]);
  });

  setUp(() {
    mockLocalDatasource = MockBookingLocalDatasource();
    mockRemoteDataSource = MockBookingRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = BookingRepository(
      localDatasource: mockLocalDatasource,
      remoteDatasource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  // Sample Test Data
  final tBookingEntity = BookingEntity(
    bookingId: '1',
    propertyId: 'prop123',
    userId: 'user123',
    status: BookingStatus.pending,
    createdAt: tFixedDate,
  );

  final tBookingApiModel = BookingApiModel(
    id: '1',
    propertyId: 'prop123',
    userId: 'user123',
    status: 'pending',
    createdAt: tFixedDateString,
  );

  final tBookingHiveModel = BookingHiveModel(
    bookingId: '1',
    propertyId: 'prop123',
    userId: 'user123',
    status: 'pending',
    createdAt: tFixedDateString,
  );

  group('createBooking', () {
    test('should return Right(BookingEntity) when remote creation is successful', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.createBooking(any())).thenAnswer((_) async => true);

      // Act
      final result = await repository.createBooking(tBookingEntity);

      // Assert
      expect(result, Right(tBookingEntity));
      verify(() => mockRemoteDataSource.createBooking(any())).called(1);
    });

    test('should return NetworkFailure when offline during creation', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.createBooking(tBookingEntity);

      // Assert
      expect(result, const Left(NetworkFailure(message: 'No internet connection')));
      verifyNever(() => mockRemoteDataSource.createBooking(any()));
    });
  });

  group('getAllBookings', () {
    test('should return remote data and cache it when online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getAllBookings(any(), any()))
          .thenAnswer((_) async => [tBookingApiModel]);
      when(() => mockLocalDatasource.cacheAllBookings(any()))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.getAllBookings(page: 1, size: 10);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockRemoteDataSource.getAllBookings(1, 10)).called(1);
      verify(() => mockLocalDatasource.cacheAllBookings(any())).called(1);
    });

    test('should fallback to local cache when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.getAllBookings())
          .thenAnswer((_) async => [tBookingHiveModel]);

      // Act
      final result = await repository.getAllBookings(page: 1, size: 10);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockLocalDatasource.getAllBookings()).called(1);
      verifyZeroInteractions(mockRemoteDataSource);
    });
  });
 group('updateBookingStatus', () {
  const tBookingId = '1';
  const tStatus = BookingStatus.confirmed;

  test('should update remote and local when online', () async {
    final tStatusString =
        BookingEntity.statusToString(tStatus);

    when(() => mockNetworkInfo.isConnected)
        .thenAnswer((_) async => true);

    when(() => mockRemoteDataSource.updateBookingStatus(
          tBookingId,
          tStatusString,
        )).thenAnswer((_) async => true);

    when(() => mockLocalDatasource.updateBookingStatus(
          tBookingId,
          tStatusString,
        )).thenAnswer((_) async => true);

    when(() => mockLocalDatasource.getBookingById(tBookingId))
        .thenAnswer((_) async => BookingHiveModel(
              bookingId: '1',
              propertyId: 'prop123',
              userId: 'user123',
              status: 'CONFIRMED', // ✅ important
              createdAt: tFixedDateString,
            ));

    final result = await repository.updateBookingStatus(
      bookingId: tBookingId,
      status: tStatus,
    );

    result.fold(
      (failure) => fail('Should not fail'),
      (entity) {
        expect(entity.status, BookingStatus.confirmed);
      },
    );

    verify(() => mockRemoteDataSource.updateBookingStatus(
          tBookingId,
          tStatusString,
        )).called(1);

    verify(() => mockLocalDatasource.updateBookingStatus(
          tBookingId,
          tStatusString,
        )).called(1);
  });
});

  group('findActiveBooking', () {
    test('should return remote active booking when online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.findActiveBooking(any(), any()))
          .thenAnswer((_) async => tBookingApiModel);

      // Act
      final result = await repository.findActiveBooking(userId: 'u1', propertyId: 'p1');

      // Assert
      expect(result.isRight(), true);
      verify(() => mockRemoteDataSource.findActiveBooking('u1', 'p1')).called(1);
    });
  });

  group('getBookingById', () {
    test('should return booking from local datasource', () async {
      // Arrange
      when(() => mockLocalDatasource.getBookingById(any()))
          .thenAnswer((_) async => tBookingHiveModel);

      // Act
      final result = await repository.getBookingById('1');

      // Assert
      expect(result.isRight(), true);
      verify(() => mockLocalDatasource.getBookingById('1')).called(1);
    });

    test('should return LocalDatabaseFailure when booking not found', () async {
      // Arrange
      when(() => mockLocalDatasource.getBookingById(any()))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getBookingById('1');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<LocalDatabaseFailure>()),
        (_) => fail('Should have returned Left'),
      );
    });
  });
}