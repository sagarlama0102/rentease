import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/core/services/connectivity/network_info.dart';
import 'package:rentease/features/favourites/data/datasources/favourite_datasource.dart';
import 'package:rentease/features/favourites/data/datasources/local/favourite_local_datasource.dart';
import 'package:rentease/features/favourites/data/datasources/remote/favourite_remote_datasource.dart';
import 'package:rentease/features/favourites/data/models/favourite_hive_model.dart';
import 'package:rentease/features/favourites/domain/entities/favourite_entity.dart';
import 'package:rentease/features/favourites/domain/repositories/favourite_repository.dart';

final favouriteRepositoryProvider = Provider<IFavouriteRepository>((ref) {
  final localDatasource = ref.read(favouriteLocalDatasourceProvider);
  final remoteDatasource = ref.read(favouriteRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return FavouriteRepository(
    localDatasource: localDatasource,
    remoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class FavouriteRepository implements IFavouriteRepository {
  final FavouriteLocalDatasource _localDatasource;
  final IFavouriteRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  FavouriteRepository({
    required FavouriteLocalDatasource localDatasource,
    required IFavouriteRemoteDataSource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _localDatasource = localDatasource,
       _remoteDataSource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<FavouriteEntity>>> getAllFavourites() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getAllFavourites();
        final hiveModels = FavouriteHiveModel.fromApiModelList(models);
        
        // Cache the new data
        await _localDatasource.cacheAllFavourites(hiveModels);
        
        // Return the fresh data
        return Right(FavouriteHiveModel.toEntityList(hiveModels));
      } catch (e) {
        // Fallback to local if API fails despite being connected
        return _getCachedFavourites();
      }
    } else {
      return _getCachedFavourites();
    }
  }

  @override
  Future<Either<Failure, bool>> isFavourite(String propertyId) async {
    try {
      // We prioritize local check for instant UI response (Heart color)
      final status = await _localDatasource.isFavourite(propertyId);
      return Right(status);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavourite(String propertyId) async {
    if (await _networkInfo.isConnected) {
      try {
        // 1. Tell the server to toggle
        final result = await _remoteDataSource.toggleFavourite(propertyId);
        
        // 2. Refresh Local Cache
        // Since we don't have the full property details here to build a HiveModel 
        // manually, we just re-fetch all favorites from the API to sync Hive.
        final freshApiModels = await _remoteDataSource.getAllFavourites();
        final freshHiveModels = FavouriteHiveModel.fromApiModelList(freshApiModels);
        await _localDatasource.cacheAllFavourites(freshHiveModels);

        return Right(result);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: "No internet connection to toggle favourites"));
    }
  }

  // Helper method for offline fallback
  Future<Either<Failure, List<FavouriteEntity>>> _getCachedFavourites() async {
    try {
      final localModels = await _localDatasource.getAllFavourites();
      return Right(FavouriteHiveModel.toEntityList(localModels));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
