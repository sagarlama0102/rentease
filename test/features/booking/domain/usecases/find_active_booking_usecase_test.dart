import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';
import 'package:rentease/features/booking/domain/repositories/booking_repository.dart';
import 'package:rentease/features/booking/domain/usecases/find_active_booking_usecase.dart';

// Mock the Repository
class MockBookingRepository extends Mock implements IBookingRepository {}

void main() {
  late FindActiveBookingUsecase usecase;
  late MockBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockBookingRepository();
    usecase = FindActiveBookingUsecase(repository: mockRepository);
  });

  // Test Data
  const tUserId = 'user123';
  const tPropertyId = 'prop123';
  final tBookingEntity = BookingEntity(
    bookingId: '1',
    propertyId: tPropertyId,
    userId: tUserId,
    status: BookingStatus.confirmed,
    createdAt: DateTime.now(),
  );

  const tParams = FindActiveBookingParams(
    userId: tUserId,
    propertyId: tPropertyId,
  );

  group('FindActiveBookingUsecase', () {
    test('should return BookingEntity from the repository when one exists', () async {
      // Arrange
      when(() => mockRepository.findActiveBooking(
        userId: any(named: 'userId'),
        propertyId: any(named: 'propertyId'),
      )).thenAnswer((_) async => Right(tBookingEntity));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, Right(tBookingEntity));
      verify(() => mockRepository.findActiveBooking(
        userId: tUserId,
        propertyId: tPropertyId,
      )).called(1);
    });

    test('should return null when no active booking is found', () async {
      // Arrange
      when(() => mockRepository.findActiveBooking(
        userId: any(named: 'userId'),
        propertyId: any(named: 'propertyId'),
      )).thenAnswer((_) async => const Right(null));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Right(null));
      verify(() => mockRepository.findActiveBooking(
        userId: tUserId,
        propertyId: tPropertyId,
      )).called(1);
    });

    test('should return failure when repository call fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Database error');
      when(() => mockRepository.findActiveBooking(
        userId: any(named: 'userId'),
        propertyId: any(named: 'propertyId'),
      )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(failure));
    });
  });

  group('FindActiveBookingParams', () {
    test('should have correct props', () {
      expect(tParams.props, [tUserId, tPropertyId]);
    });

    test('two params with same values should be equal', () {
      const params1 = FindActiveBookingParams(userId: '1', propertyId: '1');
      const params2 = FindActiveBookingParams(userId: '1', propertyId: '1');
      expect(params1, params2);
    });
  });
}