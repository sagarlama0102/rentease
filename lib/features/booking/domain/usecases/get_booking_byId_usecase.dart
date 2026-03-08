import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/core/usecases/app_usecase.dart';
import 'package:rentease/features/booking/data/repositories/booking_repository.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';
import 'package:rentease/features/booking/domain/repositories/booking_repository.dart';

class GetBookingByIdParams extends Equatable {
  final String bookingId;

  const GetBookingByIdParams({required this.bookingId});

  @override
  // TODO: implement props
  List<Object?> get props => [bookingId];
}

final getBookingByIdUsecaseProvider = Provider<GetBookingByidUsecase>((ref) {
  final bookingRepository = ref.read(bookingRepositoryProvider);
  return GetBookingByidUsecase(bookingRepository: bookingRepository);
});

class GetBookingByidUsecase
    implements UsecaseWithParams<BookingEntity, GetBookingByIdParams> {
  final IBookingRepository _bookingRepository;

  GetBookingByidUsecase({required IBookingRepository bookingRepository})
    : _bookingRepository = bookingRepository;

  @override
  Future<Either<Failure, BookingEntity>> call(GetBookingByIdParams params) {
    return _bookingRepository.getBookingById(params.bookingId);
  }
}
