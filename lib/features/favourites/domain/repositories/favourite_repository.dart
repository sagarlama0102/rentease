import 'package:dartz/dartz.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/features/favourites/domain/entities/favourite_entity.dart';

abstract interface class IFavouriteRepository {
  
  Future<Either<Failure, bool>> toggleFavourite(String propertyId);


  Future<Either<Failure, List<FavouriteEntity>>> getAllFavourites();

  Future<Either<Failure, bool>> isFavourite(String propertyId);
}
