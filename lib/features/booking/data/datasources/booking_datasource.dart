import 'package:rentease/features/booking/data/models/booking_api_model.dart';
import 'package:rentease/features/booking/data/models/booking_hive_model.dart';

abstract interface class IBookingLocalDataSource {
  Future<bool> createBooking(BookingHiveModel booking);
  Future<List<BookingHiveModel>> getAllBookings();
  Future<void> cacheAllBookings(List<BookingHiveModel> bookings);
  Future<BookingHiveModel?> getBookingById(String bookingId);
  Future<bool> updateBookingStatus(String bookingId, String status);
  // Offline check for active bookings
  Future<BookingHiveModel?> findActiveBooking(String userId, String propertyId);
}
abstract interface class IBookingRemoteDataSource {
  Future<bool> createBooking(BookingApiModel booking);
  
  // Matches your backend pagination: Promise<{booking: IBooking[], total: number}>
  Future<List<BookingApiModel>> getAllBookings(int page, int size);
  
  Future<BookingApiModel?> getBookingById(String bookingId);
  
  // Used for both Admin (Confirm/Reject) and User (Cancel)
  Future<bool> updateBookingStatus(String bookingId, String status);
  
  // Checks backend if user has a pending/confirmed booking
  Future<BookingApiModel?> findActiveBooking(String userId, String propertyId);
}

