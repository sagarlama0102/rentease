import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/api/api_client.dart';
import 'package:rentease/core/api/api_endpoints.dart';
import 'package:rentease/core/services/storage/token_service.dart';
import 'package:rentease/features/favourites/data/datasources/favourite_datasource.dart';
import 'package:rentease/features/favourites/data/models/favourite_api_model.dart';

final favouriteRemoteDatasourceProvider = Provider<IFavouriteRemoteDataSource>((
  ref,
) {
  return FavouriteRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class FavouriteRemoteDatasource implements IFavouriteRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  FavouriteRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  Future<Options> _getOptions() async {
    final token = _tokenService.getToken();
    return Options(headers: {'Authorization': 'Bearer $token'});
  }
  
  @override
  Future<List<FavouriteApiModel>> getAllFavourites() async{
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getMyFavourites,
        options: await _getOptions(),
      );

      // Based on your backend: { favorites: [...], total: 10 }
      final List data = response.data['data'];

      return data.map((json) => FavouriteApiModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Failed to fetch favourites: $e");
    }
  }
  
  @override
  Future<bool> isFavourite(String propertyId) async {
   try {
      final response = await _apiClient.get(
        ApiEndpoints.checkFavouriteStatus(propertyId),
        options: await _getOptions(),
      );

      // Matches your backend controller: returns { isFavorited: true/false }
      return response.data['isFavorited'] ?? false;
    } catch (e) {
      return false; // Default to false if check fails
    }
  }
  
  @override
  Future<bool> toggleFavourite(String propertyId) async{
    try {
      final response = await _apiClient.post(
        ApiEndpoints.toggleFavourite,
        data: {'propertyId': propertyId}, // Sending propertyId in request body
        options: await _getOptions(),
      );

      // Matches backend: returns { favorited: true/false }
      return response.data['favorited'] ?? false;
    } catch (e) {
      throw Exception("Remote Toggle Failed: $e");
    }
  }
}


