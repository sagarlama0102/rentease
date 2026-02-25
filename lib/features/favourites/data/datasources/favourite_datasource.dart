import 'package:rentease/features/favourites/data/models/favourite_hive_model.dart';

abstract interface class IFavouriteLocalDataSource {
  Future<bool> toggleFavourite(FavouriteHiveModel favourite);
  Future<List<FavouriteHiveModel>> getAllFavourites();
  Future<void> cacheAllFavourites(List<FavouriteHiveModel> favourites);
  Future<bool> isFavourite(String propertyId);
}


