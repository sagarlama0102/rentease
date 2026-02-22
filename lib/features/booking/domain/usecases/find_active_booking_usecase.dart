import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/core/usecases/app_usecase.dart';
import 'package:rentease/features/booking/data/repositories/booking_repository.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';
import 'package:rentease/features/booking/domain/repositories/booking_repository.dart';

class FindActiveBookingParams extends Equatable {
  final String userId;
  final String propertyId;

  const FindActiveBookingParams({
    required this.userId,
    required this.propertyId,
  });

  @override
  List<Object?> get props => [userId, propertyId];
}

final findActiveBookingUsecaseProvider = Provider<FindActiveBookingUsecase>((ref) {
  final repository = ref.read(bookingRepositoryProvider);
  return FindActiveBookingUsecase(repository: repository);
});

class FindActiveBookingUsecase 
    implements UsecaseWithParams<BookingEntity?, FindActiveBookingParams> {
  final IBookingRepository _repository;

  FindActiveBookingUsecase({required IBookingRepository repository}) 
      : _repository = repository;

  @override
  Future<Either<Failure, BookingEntity?>> call(FindActiveBookingParams params) {
    return _repository.findActiveBooking(
      userId: params.userId,
      propertyId: params.propertyId,
    );
  }
}