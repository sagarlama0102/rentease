import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';
import 'package:rentease/features/booking/domain/usecases/create_booking_usecase.dart';
import 'package:rentease/features/booking/domain/usecases/find_active_booking_usecase.dart';
import 'package:rentease/features/booking/domain/usecases/get_all_booking_usecase.dart';
import 'package:rentease/features/booking/domain/usecases/get_booking_byId_usecase.dart';
import 'package:rentease/features/booking/domain/usecases/update_booking_status_usecase.dart';
import 'package:rentease/features/booking/presentation/state/booking_state.dart';

final bookingViewModelProvider = NotifierProvider<BookingViewModel, BookingState>( 
  BookingViewModel.new,
);
class BookingViewModel extends Notifier<BookingState> {
  late final GetAllBookingsUsecase _getAllBookingsUsecase;
  late final CreateBookingUsecase _createBookingUsecase;
  late final GetBookingByidUsecase _bookingByidUsecase;
  late final UpdateBookingStatusUsecase _updateBookingStatusUsecase;
  late final FindActiveBookingUsecase _activeBookingUsecase;

  @override
  BookingState build() {
    _createBookingUsecase = ref.read(createBookingUsecaseProvider);
    _getAllBookingsUsecase = ref.read(getAllBookingsUsecaseProvider);
    _bookingByidUsecase = ref.read(getBookingByIdUsecaseProvider);
    _updateBookingStatusUsecase = ref.read(updateBookingByIdUsecaseProvider);
    _activeBookingUsecase = ref.read(findActiveBookingUsecaseProvider);

    return const BookingState();
  }

  // 1. Get All Bookings (My Bookings)
  Future<void> getAllBookings({int page = 1, int size = 10}) async {
    state = state.copyWith(status: BookingStatusState.loading);

    final result = await _getAllBookingsUsecase(
      GetAllBookingParams(page: page, size: size),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: BookingStatusState.error,
        errorMessage: failure.message,
      ),
      (bookings) => state = state.copyWith(
        status: BookingStatusState.loaded,
        bookings: bookings,
      ),
    );
  }

  // 2. Create a New Booking
  Future<void> createBooking({
    required String propertyId,
    required String userId,
    String? message,
  }) async {
    state = state.copyWith(status: BookingStatusState.loading);

    final result = await _createBookingUsecase(
      CreateBookingParams(
        propertyId: propertyId,
        userId: userId,
        message: message,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: BookingStatusState.error,
        errorMessage: failure.message,
      ),
      (booking) {
        state = state.copyWith(status: BookingStatusState.created);
        // Refresh the list after creating a new one
        getAllBookings();
      },
    );
  }

  // 3. Cancel/Update Booking Status
  Future<void> updateBookingStatus({
    required String bookingId,
    required BookingStatus status,
  }) async {
    state = state.copyWith(status: BookingStatusState.loading);

    final result = await _updateBookingStatusUsecase(
      UpdateBookingStatusParams(bookingId: bookingId, status: status),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: BookingStatusState.error,
        errorMessage: failure.message,
      ),
      (updatedBooking) {
        state = state.copyWith(status: BookingStatusState.updated);
        // Refresh list to show updated status (e.g., Cancelled)
        getAllBookings();
      },
    );
  }

  // 4. Find if User has an active booking for this property
  Future<void> findActiveBooking({
    required String userId,
    required String propertyId,
  }) async {
    state = state.copyWith(status: BookingStatusState.loading);

    final result = await _activeBookingUsecase(
      FindActiveBookingParams(userId: userId, propertyId: propertyId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: BookingStatusState.error,
        errorMessage: failure.message,
      ),
      (booking) => state = state.copyWith(
        status: BookingStatusState.loaded,
        activeBooking: booking, // Store the result (null or entity)
      ),
    );
  }

  // 5. Get Single Booking by ID
  Future<void> getBookingById(String bookingId) async {
    state = state.copyWith(status: BookingStatusState.loading);

    final result = await _bookingByidUsecase(GetBookingByIdParams(bookingId: bookingId));

    result.fold(
      (failure) => state = state.copyWith(
        status: BookingStatusState.error,
        errorMessage: failure.message,
      ),
      (booking) => state = state.copyWith(
        status: BookingStatusState.loaded,
        // You could add a 'selectedBooking' field to state if needed
      ),
    );
  }

  // Helper Methods (Same as teacher's logic)
  void clearError() {
    state = state.copyWith(resetErrorMessage: true);
  }

  void resetState() {
    state = const BookingState();
  }

}
