import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/services/hive/hive_service.dart';
import 'package:rentease/core/services/storage/user_session_service.dart';
import 'package:rentease/features/favourites/data/datasources/favourite_datasource.dart';
import 'package:rentease/features/favourites/data/models/favourite_hive_model.dart';

final favouriteLocalDatasourceProvider = Provider<FavouriteLocalDatasource>((
  ref,
) {
  final hiveService = ref.read(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return FavouriteLocalDatasource(
    hiveService: hiveService,
    userSessionService: userSessionService,
  );
});

class FavouriteLocalDatasource implements IFavouriteLocalDataSource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService;

  FavouriteLocalDatasource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
  }) : _hiveService = hiveService,
       _userSessionService = userSessionService;

  @override
  Future<void> cacheAllFavourites(List<FavouriteHiveModel> favourites) async {
    final userId = _userSessionService.getUserId() ?? "";
    await _hiveService.cacheAllFavourites(favourites, userId);
  }

  @override
  Future<List<FavouriteHiveModel>> getAllFavourites() async {
    try {
      final userId = _userSessionService.getUserId() ?? "";
      return _hiveService.getAllFavourites(userId);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> isFavourite(String propertyId) async{
   final userId = _userSessionService.getUserId() ?? "";
    return _hiveService.isFavourite(userId, propertyId);
  }

  @override
  Future<bool> toggleFavourite(FavouriteHiveModel favourite) async{
    try {
      return await _hiveService.toggleFavourite(favourite);
    } catch (e) {
      throw Exception("Local Toggle Failed: $e");
    }
  }
}
