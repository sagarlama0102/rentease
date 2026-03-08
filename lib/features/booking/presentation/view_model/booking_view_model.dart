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
        getAllBookings();
      },
    );
  }


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

        getAllBookings();
      },
    );
  }


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
        activeBooking: booking, 
      ),
    );
  }


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
        
      ),
    );
  }


  void clearError() {
    state = state.copyWith(resetErrorMessage: true);
  }

  void resetState() {
    state = const BookingState();
  }

}
