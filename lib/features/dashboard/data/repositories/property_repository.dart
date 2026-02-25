import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/core/services/connectivity/network_info.dart';
import 'package:rentease/features/dashboard/data/datasources/local/property_local_datasource.dart';
import 'package:rentease/features/dashboard/data/datasources/property_datasource.dart';
import 'package:rentease/features/dashboard/data/datasources/remote/property_remote_datasource.dart';
import 'package:rentease/features/dashboard/data/models/property_api_model.dart';
import 'package:rentease/features/dashboard/data/models/property_hive_model.dart';
import 'package:rentease/features/dashboard/domain/entities/property_entity.dart';
import 'package:rentease/features/dashboard/domain/repositories/property_repository.dart';

final propertyRepositoryProvider = Provider<IPropertyRepository>((ref) {
  final propertyLocalDatasource = ref.read(propertyLocalDatasourceProvider);
  final propertyRemoteDataSource = ref.read(propertyRemoteProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return PropertyRepository(
    propertyDatasource: propertyLocalDatasource,
    propertyRemoteDataSource: propertyRemoteDataSource,
    networkInfo: networkInfo,
  );
});

class PropertyRepository implements IPropertyRepository {
  final PropertyLocalDatasource _propertyLocalDatasource;
  final IPropertyRemoteDataSource _propertyRemoteDataSource;
  final NetworkInfo _networkInfo;

  PropertyRepository({
    required PropertyLocalDatasource propertyDatasource,
    required IPropertyRemoteDataSource propertyRemoteDataSource,
    required NetworkInfo networkInfo,
  }) : _propertyLocalDatasource = propertyDatasource,
       _propertyRemoteDataSource = propertyRemoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<PropertyEntity>>> getAllProperty() async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModels = await _propertyRemoteDataSource.getAllProperty();

        final hiveModels = PropertyHiveModel.fromApiModelList(apiModels);
        await _propertyLocalDatasource.cacheAllProperty(hiveModels);
        final result = PropertyApiModel.toEntityList(apiModels);
        return Right(result);
      } on DioException {

        return _getCachedProperties();
      } catch (e) {

        return _getCachedProperties();
      }
    } else {
      return _getCachedProperties();
    }
  }


  Future<Either<Failure, List<PropertyEntity>>> _getCachedProperties() async {
    try {
      final models = await _propertyLocalDatasource.getAllProperty();
      final entities = PropertyHiveModel.toEntityList(models);
      return Right(entities);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
Future<Either<Failure, PropertyEntity>> getPropertyById(
  String propertyId,
) async {
  // 1. Check if the user is online
  if (await _networkInfo.isConnected) {
    try {
      // 2. Try to get the latest data from the Remote API
      final apiModel = await _propertyRemoteDataSource.getPropertyById(propertyId);
      
      if (apiModel != null) {
        return Right(apiModel.toEntity());
      }
    } catch (e) {
      // If API fails (server down), fallback to Local database below
    }
  }


  try {
    final model = await _propertyLocalDatasource.getPropertyById(propertyId);
    if (model != null) {
      final entity = model.toEntity();
      return Right(entity);
    }
    return Left(LocalDatabaseFailure(message: "Property not found in cache"));
  } catch (e) {
    return Left(LocalDatabaseFailure(message: e.toString()));
  }
}
}
