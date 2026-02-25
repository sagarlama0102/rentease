import 'package:equatable/equatable.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';


enum BookingStatusState { initial, loading, loaded, error, created, updated, deleted }

class BookingState extends Equatable {
  final BookingStatusState status;
  final List<BookingEntity> bookings; 
  final BookingEntity? activeBooking; 
  final String? errorMessage;

  const BookingState({
    this.status = BookingStatusState.initial,
    this.bookings = const [],
    this.activeBooking,
    this.errorMessage,
  });


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