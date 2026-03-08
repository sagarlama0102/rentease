import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';
import 'package:rentease/features/booking/domain/repositories/booking_repository.dart';
import 'package:rentease/features/booking/domain/usecases/get_all_booking_usecase.dart';


// Mock the Repository
class MockBookingRepository extends Mock implements IBookingRepository {}

void main() {
  late GetAllBookingsUsecase usecase;
  late MockBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockBookingRepository();
    usecase = GetAllBookingsUsecase(bookingRepository: mockRepository);
  });

  // Test Data
  const tPage = 1;
  const tSize = 10;
  const tParams = GetAllBookingParams(page: tPage, size: tSize);

  final tBookingList = [
    BookingEntity(
      bookingId: '1',
      propertyId: 'prop1',
      userId: 'user1',
      status: BookingStatus.confirmed,
      createdAt: DateTime.now(),
    ),
    BookingEntity(
      bookingId: '2',
      propertyId: 'prop2',
      userId: 'user1',
      status: BookingStatus.pending,
      createdAt: DateTime.now(),
    ),
  ];

  group('GetAllBookingsUsecase', () {
    test('should return List<BookingEntity> from the repository', () async {
      // Arrange
      when(() => mockRepository.getAllBookings(
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => Right(tBookingList));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, Right(tBookingList));
      verify(() => mockRepository.getAllBookings(
            page: tPage,
            size: tSize,
          )).called(1);
    });

    test('should return failure when repository call fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Failed to fetch bookings');
      when(() => mockRepository.getAllBookings(
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.getAllBookings(
            page: tPage,
            size: tSize,
          )).called(1);
    });
  });

  group('GetAllBookingParams', () {
    test('should have correct props', () {
      expect(tParams.props, [tPage, tSize]);
    });

    test('two params with same values should be equal', () {
      const params1 = GetAllBookingParams(page: 1, size: 10);
      const params2 = GetAllBookingParams(page: 1, size: 10);
      expect(params1, params2);
    });
    
    test('two params with different values should not be equal', () {
      const params1 = GetAllBookingParams(page: 1, size: 10);
      const params2 = GetAllBookingParams(page: 2, size: 10);
      expect(params1, isNot(params2));
    });
  });
}