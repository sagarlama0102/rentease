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
        
       
        await _localDatasource.cacheAllFavourites(hiveModels);
        

        return Right(FavouriteHiveModel.toEntityList(hiveModels));
      } catch (e) {

        return _getCachedFavourites();
      }
    } else {
      return _getCachedFavourites();
    }
  }

  @override
  Future<Either<Failure, bool>> isFavourite(String propertyId) async {
    try {

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
        
        final result = await _remoteDataSource.toggleFavourite(propertyId);

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


  Future<Either<Failure, List<FavouriteEntity>>> _getCachedFavourites() async {
    try {
      final localModels = await _localDatasource.getAllFavourites();
      return Right(FavouriteHiveModel.toEntityList(localModels));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
