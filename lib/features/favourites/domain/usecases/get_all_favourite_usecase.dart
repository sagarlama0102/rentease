import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/core/usecases/app_usecase.dart';
import 'package:rentease/features/favourites/data/repositories/favourite_repository.dart';
import 'package:rentease/features/favourites/domain/entities/favourite_entity.dart';
import 'package:rentease/features/favourites/domain/repositories/favourite_repository.dart';

// Provider for the Use Case
final getAllFavouritesUsecaseProvider = Provider<GetAllFavouritesUsecase>((ref) {
  final favouriteRepository = ref.read(favouriteRepositoryProvider);
  return GetAllFavouritesUsecase(favouriteRepository: favouriteRepository);
});

class GetAllFavouritesUsecase implements UsecaseWithoutParams<List<FavouriteEntity>> {
  final IFavouriteRepository _favouriteRepository;

  GetAllFavouritesUsecase({required IFavouriteRepository favouriteRepository})
      : _favouriteRepository = favouriteRepository;

  @override
  Future<Either<Failure, List<FavouriteEntity>>> call() {
    return _favouriteRepository.getAllFavourites();
  }
}