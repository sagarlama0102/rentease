import 'package:equatable/equatable.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';

// mirrors your teacher's state flow
enum BookingStatusState { initial, loading, loaded, error, created, updated, deleted }

class BookingState extends Equatable {
  final BookingStatusState status;
  final List<BookingEntity> bookings; // All bookings for the user
  final BookingEntity? activeBooking; // Result of findActiveBooking check
  final String? errorMessage;

  const BookingState({
    this.status = BookingStatusState.initial,
    this.bookings = const [],
    this.activeBooking,
    this.errorMessage,
  });

  // copyWith allows us to update only specific parts of the state
  BookingState copyWith({
    BookingStatusState? status,
    List<BookingEntity>? bookings,
    BookingEntity? activeBooking,
    bool resetActiveBooking = false,
    String? errorMessage,
    bool resetErrorMessage = false,
  }) {
    return BookingState(
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      activeBooking: resetActiveBooking 
          ? null 
          : (activeBooking ?? this.activeBooking),
      errorMessage: resetErrorMessage 
          ? null 
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        bookings,
        activeBooking,
        errorMessage,
      ];
}