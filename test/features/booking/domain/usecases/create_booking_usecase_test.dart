import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';
import 'package:rentease/features/booking/domain/repositories/booking_repository.dart';
import 'package:rentease/features/booking/domain/usecases/create_booking_usecase.dart';

// Mock the Repository
class MockBookingRepository extends Mock implements IBookingRepository {}

void main() {
  late CreateBookingUsecase usecase;
  late MockBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockBookingRepository();
    usecase = CreateBookingUsecase(bookingRepository: mockRepository);
  });

  // Register fallback for BookingEntity since it's used as an argument in the repository
  setUpAll(() {
    registerFallbackValue(
      BookingEntity(
        bookingId: 'fallback',
        propertyId: 'fallback',
        userId: 'fallback',
        status: BookingStatus.pending,
        createdAt: DateTime.now(),
      ),
    );
  });

  // Test Data
  const tPropertyId = 'prop123';
  const tUserId = 'user123';
  const tMessage = 'I want to rent this.';
  final tBookingEntity = BookingEntity(
    bookingId: '1',
    propertyId: tPropertyId,
    userId: tUserId,
    status: BookingStatus.pending,
    createdAt: DateTime.now(),
  );

  const tParams = CreateBookingParams(
    propertyId: tPropertyId,
    userId: tUserId,
    message: tMessage,
  );

  group('CreateBookingUsecase', () {
    test('should return BookingEntity when booking is created successfully', () async {
      // Arrange
      when(() => mockRepository.createBooking(any()))
          .thenAnswer((_) async => Right(tBookingEntity));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, Right(tBookingEntity));
      verify(() => mockRepository.createBooking(any())).called(1);
    });

    test('should return failure when repository creation fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Failed to create booking');
      when(() => mockRepository.createBooking(any()))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.createBooking(any())).called(1);
    });

    test('should pass correct booking entity data to repository', () async {
      // Arrange
      when(() => mockRepository.createBooking(any()))
          .thenAnswer((_) async => Right(tBookingEntity));

      // Act
      await usecase(tParams);

      // Assert
      // We capture the BookingEntity passed to the repository to check its values
      final captured = verify(
        () => mockRepository.createBooking(captureAny()),
      ).captured.first as BookingEntity;

      expect(captured.propertyId, tPropertyId);
      expect(captured.userId, tUserId);
      expect(captured.message, tMessage);
    });
  });

  group('CreateBookingParams', () {
    test('should have correct props', () {
      expect(tParams.props, [tPropertyId, tUserId, tMessage]);
    });

    test('two params with same values should be equal', () {
      const params1 = CreateBookingParams(
        propertyId: tPropertyId,
        userId: tUserId,
      );
      const params2 = CreateBookingParams(
        propertyId: tPropertyId,
        userId: tUserId,
      );
      expect(params1, params2);
    });
  });
}