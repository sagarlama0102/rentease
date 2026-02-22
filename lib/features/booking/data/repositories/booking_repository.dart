import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/core/services/connectivity/network_info.dart';
import 'package:rentease/features/booking/data/datasources/booking_datasource.dart';
import 'package:rentease/features/booking/data/datasources/local/booking_local_datasource.dart';
import 'package:rentease/features/booking/data/datasources/remote/booking_remote_datasource.dart';
import 'package:rentease/features/booking/data/models/booking_api_model.dart';
import 'package:rentease/features/booking/data/models/booking_hive_model.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';
import 'package:rentease/features/booking/domain/repositories/booking_repository.dart';

class BookingRepository implements IBookingRepository {
  final BookingLocalDatasource _localDatasource;
  final IBookingRemoteDataSource _remoteDatasource;
  final NetworkInfo _networkInfo;

  BookingRepository({
    required BookingLocalDatasource localDatasource,
    required IBookingRemoteDataSource remoteDatasource,
    required NetworkInfo networkInfo,
  })  : _localDatasource = localDatasource,
        _remoteDatasource = remoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, BookingEntity>> createBooking(
    BookingEntity booking,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final bookingApiModel = BookingApiModel.fromEntity(booking);
        final success = await _remoteDatasource.createBooking(bookingApiModel);
        
        if (success) {
          // Typically, for a successful creation, you'd want to return 
          // the entity, but since 'success' is just a bool, we return the input.
          return Right(booking);
        } else {
          return const Left(ApiFailure(message: 'Failed to create booking'));
        }
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getAllBookings({
    required int page,
    required int size,
    String? status,
    String? userId,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDatasource.getAllBookings(page, size);
        
        // Cache the data locally
        final hiveModels = BookingHiveModel.fromApiModelList(models);
        await _localDatasource.cacheAllBookings(hiveModels);
        
        return Right(BookingApiModel.toEntityList(models));
      } catch (e) {
        return _getCachedBookings();
      }
    } else {
      return _getCachedBookings();
    }
  }

  // Helper method for offline fallback
  Future<Either<Failure, List<BookingEntity>>> _getCachedBookings() async {
    try {
      final localModels = await _localDatasource.getAllBookings();
      return Right(BookingHiveModel.toEntityList(localModels));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> updateBookingStatus({
    required String bookingId,
    required BookingStatus status,
  }) async {
    final statusString = BookingEntity.statusToString(status);
    
    if (await _networkInfo.isConnected) {
      try {
        final success = await _remoteDatasource.updateBookingStatus(bookingId, statusString);
        if (success) {
          // Update local cache too
          await _localDatasource.updateBookingStatus(bookingId, statusString);
          
          // Get the updated object from local to return as entity
          final updated = await _localDatasource.getBookingById(bookingId);
          return Right(updated!.toEntity());
        }
        return const Left(ApiFailure(message: "Failed to update status"));
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
       return const Left(NetworkFailure(message: 'No internet connection to update status'));
    }
  }

  @override
  Future<Either<Failure, BookingEntity?>> findActiveBooking({
    required String userId,
    required String propertyId,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDatasource.findActiveBooking(userId, propertyId);
        return Right(model?.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      final localModel = await _localDatasource.findActiveBooking(userId, propertyId);
      return Right(localModel?.toEntity());
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> getBookingById(String bookingId) async {
    // Similar logic: try remote, fallback to local
    try {
      final local = await _localDatasource.getBookingById(bookingId);
      if (local != null) return Right(local.toEntity());
      return const Left(LocalDatabaseFailure(message: "Booking not found"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}