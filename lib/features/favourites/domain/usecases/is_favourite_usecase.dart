import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/core/usecases/app_usecase.dart';
import 'package:rentease/features/favourites/data/repositories/favourite_repository.dart';
import 'package:rentease/features/favourites/domain/repositories/favourite_repository.dart';

final isFavouriteUsecaseProvider = Provider<IsFavouriteUsecase>((ref) {
  return IsFavouriteUsecase(
    favouriteRepository: ref.read(favouriteRepositoryProvider),
  );
});

class IsFavouriteUsecase implements UsecaseWithParams<bool, String> {
  final IFavouriteRepository _favouriteRepository;

  IsFavouriteUsecase({required IFavouriteRepository favouriteRepository})
      : _favouriteRepository = favouriteRepository;

  @override
  Future<Either<Failure, bool>> call(String propertyId) {

    return _favouriteRepository.isFavourite(propertyId);
  }
}