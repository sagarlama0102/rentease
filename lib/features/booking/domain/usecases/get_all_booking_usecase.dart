import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/core/usecases/app_usecase.dart';
import 'package:rentease/features/booking/data/repositories/booking_repository.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';
import 'package:rentease/features/booking/domain/repositories/booking_repository.dart';

class GetAllBookingParams extends Equatable {
  final int page;
  final int size;

  const GetAllBookingParams({
    required this.page,
    required this.size,
  });

  @override
  List<Object?> get props => [page, size];
}

final getAllBookingsUsecaseProvider = Provider<GetAllBookingsUsecase>((ref) {
  final bookingRepository = ref.read(bookingRepositoryProvider);
  return GetAllBookingsUsecase(bookingRepository: bookingRepository);
});

class GetAllBookingsUsecase implements UsecaseWithParams<List<BookingEntity>, GetAllBookingParams> {
  final IBookingRepository _bookingRepository;

  GetAllBookingsUsecase({required IBookingRepository bookingRepository})
      : _bookingRepository = bookingRepository;

  @override
  Future<Either<Failure, List<BookingEntity>>> call(GetAllBookingParams params) {
    return _bookingRepository.getAllBookings(
      page: params.page,
      size: params.size,
    );
  }
}