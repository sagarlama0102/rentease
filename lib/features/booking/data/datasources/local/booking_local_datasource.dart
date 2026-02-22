import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/services/hive/hive_service.dart';
import 'package:rentease/features/booking/data/datasources/booking_datasource.dart';
import 'package:rentease/features/booking/data/models/booking_hive_model.dart';

final bookingLocalDatasourceProvider = Provider<BookingLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return BookingLocalDatasource(hiveService: hiveService);
});

class BookingLocalDatasource implements IBookingLocalDataSource {
  final HiveService _hiveService;

  BookingLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<void> cacheAllBookings(List<BookingHiveModel> bookings) async {
    await _hiveService.cacheAllBooking(bookings);
  }

  @override
  Future<bool> createBooking(BookingHiveModel booking) async {
    try {
      await _hiveService.createBooking(booking);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<BookingHiveModel?> findActiveBooking(
    String userId,
    String propertyId,
  ) async {
    try {
      return _hiveService.findActiveBooking(
        userId: userId,
        propertyId: propertyId,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<BookingHiveModel>> getAllBookings() async {
    try {
      return _hiveService.getAllBookings();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<BookingHiveModel?> getBookingById(String bookingId) async {
    try {
      return _hiveService.getBookingById(bookingId);
    } catch (e) {
      return null;
    }
  }

  @override
  
  Future<bool> updateBookingStatus(String bookingId, String status) async {
    try {
      // 1. Get the existing booking from Hive
      final existingBooking = await _hiveService.getBookingById(bookingId);
      
      if (existingBooking != null) {
        // 2. Create a NEW instance with the updated status 
        // (Assuming you want to keep other fields the same)
        final updatedBooking = BookingHiveModel(
          bookingId: existingBooking.bookingId,
          propertyId: existingBooking.propertyId,
          userId: existingBooking.userId,
          status: status, // The new status (e.g., "CANCELLED")
          message: existingBooking.message,
          createdAt: existingBooking.createdAt,
          updatedAt: DateTime.now().toIso8601String(), // Update timestamp
        );

        // 3. Save it back to Hive using the service
        await _hiveService.updateBookingStatus(updatedBooking);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
