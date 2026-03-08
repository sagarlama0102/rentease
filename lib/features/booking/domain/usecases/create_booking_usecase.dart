import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/core/usecases/app_usecase.dart';
import 'package:rentease/features/booking/data/repositories/booking_repository.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';
import 'package:rentease/features/booking/domain/repositories/booking_repository.dart';

class CreateBookingParams extends Equatable {
  final String propertyId;
  final String userId;
  final String? message;

  const CreateBookingParams({
    required this.propertyId,
    required this.userId,
    this.message,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [propertyId, userId, message];
}

final createBookingUsecaseProvider = Provider<CreateBookingUsecase>((ref) {
  final bookingRepository = ref.read(bookingRepositoryProvider);
  return CreateBookingUsecase(bookingRepository: bookingRepository);
});

class CreateBookingUsecase implements UsecaseWithParams<BookingEntity, CreateBookingParams> {
  final IBookingRepository _bookingRepository;

  CreateBookingUsecase({required IBookingRepository bookingRepository})
      : _bookingRepository = bookingRepository;

  @override
  Future<Either<Failure, BookingEntity>> call(CreateBookingParams params) {
    final bookingEntity = BookingEntity(
      propertyId: params.propertyId,
      userId: params.userId,
      message: params.message,
    );

    // This now matches: Both return Future<Either<Failure, BookingEntity>>
    return _bookingRepository.createBooking(bookingEntity);
  }
}

