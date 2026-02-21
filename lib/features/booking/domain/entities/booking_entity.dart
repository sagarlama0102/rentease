import 'package:equatable/equatable.dart';

/// Enum that mirrors your backend BookingStatusEnum
enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  rejected,
}

class BookingEntity extends Equatable {
  final String? bookingId;
  final String propertyId;
  final String userId;
  final BookingStatus status;
  final String? message;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BookingEntity({
    this.bookingId,
    required this.propertyId,
    required this.userId,
    this.status = BookingStatus.pending,
    this.message,
    this.createdAt,
    this.updatedAt,
  });

  /// Convert backend string (e.g. "CONFIRMED") to enum
  static BookingStatus statusFromString(String status) {
    switch (status.toUpperCase()) {
      case "CONFIRMED":
        return BookingStatus.confirmed;
      case "CANCELLED":
        return BookingStatus.cancelled;
      case "REJECTED":
        return BookingStatus.rejected;
      case "PENDING":
      default:
        return BookingStatus.pending;
    }
  }

  /// Convert enum to backend string
  static String statusToString(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return "CONFIRMED";
      case BookingStatus.cancelled:
        return "CANCELLED";
      case BookingStatus.rejected:
        return "REJECTED";
      case BookingStatus.pending:
      default:
        return "PENDING";
    }
  }

  @override
  List<Object?> get props => [
        bookingId,
        propertyId,
        userId,
        status,
        message,
        createdAt,
        updatedAt,
      ];
}