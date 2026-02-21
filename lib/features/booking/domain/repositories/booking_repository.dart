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

  /// Get all bookings (with pagination + filter)
  Future<Either<Failure, List<BookingEntity>>> getAllBookings({
    required int page,
    required int size,
    String? status,
    String? userId,
  });

  /// Update booking status (Admin action)
  Future<Either<Failure, BookingEntity>> updateBookingStatus({
    required String bookingId,
    required BookingStatus status,
  });

  /// Check if user has active booking (PENDING or CONFIRMED)
  Future<Either<Failure, BookingEntity?>> findActiveBooking({
    required String userId,
    required String propertyId,
  });
}