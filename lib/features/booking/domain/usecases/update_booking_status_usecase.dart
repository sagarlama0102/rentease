import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/core/usecases/app_usecase.dart';
import 'package:rentease/features/booking/data/repositories/booking_repository.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';
import 'package:rentease/features/booking/domain/repositories/booking_repository.dart';

class UpdateBookingStatusParams extends Equatable {
  final String bookingId;
  final BookingStatus status;

  const UpdateBookingStatusParams({
    required this.bookingId,
    required this.status,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [bookingId, status];
}

final updateBookingByIdUsecaseProvider = Provider<UpdateBookingStatusUsecase>((
  ref,
) {
  final bookingRepository = ref.read(bookingRepositoryProvider);
  return UpdateBookingStatusUsecase(bookingRepository: bookingRepository);
});

class UpdateBookingStatusUsecase
    implements UsecaseWithParams<BookingEntity, UpdateBookingStatusParams> {
  final IBookingRepository _bookingRepository;

  UpdateBookingStatusUsecase({required IBookingRepository bookingRepository})
    : _bookingRepository = bookingRepository;

  @override
  Future<Either<Failure, BookingEntity>> call(
    UpdateBookingStatusParams params,
  ) {
    return _bookingRepository.updateBookingStatus(
      bookingId: params.bookingId,
      status: params.status,
    );
  }
}
