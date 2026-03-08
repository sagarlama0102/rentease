import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';
import 'package:rentease/features/booking/domain/repositories/booking_repository.dart';
import 'package:rentease/features/booking/domain/usecases/update_booking_status_usecase.dart';

// Mock the Repository
class MockBookingRepository extends Mock implements IBookingRepository {}

void main() {
  late UpdateBookingStatusUsecase usecase;
  late MockBookingRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(BookingStatus.pending); // Register the enum here
  });

  setUp(() {
    mockRepository = MockBookingRepository();
    usecase = UpdateBookingStatusUsecase(bookingRepository: mockRepository);
  });

  // Test Data
  const tBookingId = '1';
  const tStatus = BookingStatus.confirmed;
  const tParams = UpdateBookingStatusParams(bookingId: tBookingId, status: tStatus);

  final tBookingEntity = BookingEntity(
    bookingId: tBookingId,
    propertyId: 'prop123',
    userId: 'user123',
    status: tStatus,
    createdAt: DateTime.now(),
  );

  group('UpdateBookingStatusUsecase', () {
    test('should return updated BookingEntity from the repository', () async {
      // Arrange
      when(() => mockRepository.updateBookingStatus(
            bookingId: any(named: 'bookingId'),
            status: any(named: 'status'),
          )).thenAnswer((_) async => Right(tBookingEntity));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, Right(tBookingEntity));
      verify(() => mockRepository.updateBookingStatus(
            bookingId: tBookingId,
            status: tStatus,
          )).called(1);
    });

    test('should return failure when repository update fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Update failed');
      when(() => mockRepository.updateBookingStatus(
            bookingId: any(named: 'bookingId'),
            status: any(named: 'status'),
          )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.updateBookingStatus(
            bookingId: tBookingId,
            status: tStatus,
          )).called(1);
    });
  });

  group('UpdateBookingStatusParams', () {
    test('should have correct props', () {
      expect(tParams.props, [tBookingId, tStatus]);
    });

    test('two params with same values should be equal', () {
      const params1 = UpdateBookingStatusParams(bookingId: '1', status: BookingStatus.confirmed);
      const params2 = UpdateBookingStatusParams(bookingId: '1', status: BookingStatus.confirmed);
      expect(params1, params2);
    });
  });
}