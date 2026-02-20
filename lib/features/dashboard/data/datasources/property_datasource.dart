import 'package:rentease/features/dashboard/data/models/property_api_model.dart';
import 'package:rentease/features/dashboard/data/models/property_hive_model.dart';

abstract interface class IPropertyLocalDataSource {
  Future<List<PropertyHiveModel>> getAllProperty();
  Future<PropertyHiveModel?> getPropertyById(String propertyId);
}

abstract interface class IPropertyRemoteDataSource {
  Future<List<PropertyApiModel>> getAllProperty();
  Future<PropertyApiModel?> getPropertyById(String propertyId);
}
