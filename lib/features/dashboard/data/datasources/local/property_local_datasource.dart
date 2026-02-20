import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/services/hive/hive_service.dart';
import 'package:rentease/features/dashboard/data/datasources/property_datasource.dart';
import 'package:rentease/features/dashboard/data/models/property_hive_model.dart';

final propertyLocalDatasourceProvider = Provider<PropertyLocalDatasource>((
  ref,
) {
  final hiveService = ref.read(hiveServiceProvider);
  return PropertyLocalDatasource(hiveService: hiveService);
});

class PropertyLocalDatasource implements IPropertyLocalDataSource {
  // dependency Injection
  final HiveService _hiveService;

  PropertyLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;
  @override
  Future<List<PropertyHiveModel>> getAllProperty() async {
    try {
      return _hiveService.getAllProperty();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<PropertyHiveModel?> getPropertyById(String propertyId) async {
    try {
      return _hiveService.getPropertyById(propertyId);
    } catch (e) {
      return null;
    }
  }

  ///cache all property from API response

  Future<void> cacheAllProperty(List<PropertyHiveModel> properties) async {
    await _hiveService.cacheAllProperty(properties);
  }
}
