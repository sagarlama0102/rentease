import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/api/api_client.dart';
import 'package:rentease/core/api/api_endpoints.dart';
import 'package:rentease/features/dashboard/data/datasources/property_datasource.dart';
import 'package:rentease/features/dashboard/data/models/property_api_model.dart';

final propertyRemoteProvider = Provider<IPropertyRemoteDataSource>((ref) {
  return PropertyRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class PropertyRemoteDatasource implements IPropertyRemoteDataSource {
  final ApiClient _apiClient;

  PropertyRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<PropertyApiModel>> getAllProperty() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.getAllProperty);

      final List<dynamic> data = response.data['data']; 
      
      return data.map((json) => PropertyApiModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Error fetching properties: $e");
    }
  }

  @override
  Future<PropertyApiModel?> getPropertyById(String propertyId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getPropertyById(propertyId),
      );
      
      return PropertyApiModel.fromJson(response.data['data']);
    } catch (e) {
      return null;
    }
  
  }
}
