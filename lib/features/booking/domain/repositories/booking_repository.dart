import 'package:dartz/dartz.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';

abstract interface class IBookingRepository {

  /// Create booking
  Future<Either<Failure, BookingEntity>> createBooking(
    BookingEntity booking,
  );

  /// Get booking by ID
  Future<Either<Failure, BookingEntity>> getBookingById(
    String bookingId,
  );

  
  Future<Either<Failure, List<BookingEntity>>> getAllBookings({
    required int page,
    required int size,
    String? status,
    String? userId,
  });

  
  Future<Either<Failure, BookingEntity>> updateBookingStatus({
    required String bookingId,
    required BookingStatus status,
  });

  
  Future<Either<Failure, BookingEntity?>> findActiveBooking({
    required String userId,
    required String propertyId,
  });
}