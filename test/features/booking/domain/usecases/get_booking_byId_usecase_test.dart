import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';
import 'package:rentease/features/booking/domain/repositories/booking_repository.dart';
import 'package:rentease/features/booking/domain/usecases/get_booking_byId_usecase.dart';


// Mock the Repository
class MockBookingRepository extends Mock implements IBookingRepository {}

void main() {
  late GetBookingByidUsecase usecase;
  late MockBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockBookingRepository();
    usecase = GetBookingByidUsecase(bookingRepository: mockRepository);
  });

  // Test Data
  const tBookingId = '1';
  const tParams = GetBookingByIdParams(bookingId: tBookingId);

  final tBookingEntity = BookingEntity(
    bookingId: tBookingId,
    propertyId: 'prop123',
    userId: 'user123',
    status: BookingStatus.confirmed,
    createdAt: DateTime.now(),
  );

  group('GetBookingByidUsecase', () {
    test('should return BookingEntity from the repository', () async {
      // Arrange
      when(() => mockRepository.getBookingById(any()))
          .thenAnswer((_) async => Right(tBookingEntity));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, Right(tBookingEntity));
      verify(() => mockRepository.getBookingById(tBookingId)).called(1);
    });

    test('should return failure when repository fails to find the booking', () async {
      // Arrange
      const failure = LocalDatabaseFailure(message: 'Booking not found');
      when(() => mockRepository.getBookingById(any()))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.getBookingById(tBookingId)).called(1);
    });
  });

  group('GetBookingByIdParams', () {
    test('should have correct props', () {
      expect(tParams.props, [tBookingId]);
    });

    test('two params with same bookingId should be equal', () {
      const params1 = GetBookingByIdParams(bookingId: '123');
      const params2 = GetBookingByIdParams(bookingId: '123');
      expect(params1, params2);
    });

    test('two params with different bookingId should not be equal', () {
      const params1 = GetBookingByIdParams(bookingId: '123');
      const params2 = GetBookingByIdParams(bookingId: '456');
      expect(params1, isNot(params2));
    });
  });
}