import 'package:dartz/dartz.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/features/favourites/domain/entities/favourite_entity.dart';

abstract interface class IFavouriteRepository {
  // Matches toggleFavorite: flips between added/removed
  Future<Either<Failure, bool>> toggleFavourite(String propertyId);

  // Matches getAllFavorites: gets the list for the user
  Future<Either<Failure, List<FavouriteEntity>>> getAllFavourites();

  // Matches isFavorited: checks status for the Heart icon UI
  Future<Either<Failure, bool>> isFavourite(String propertyId);
}
