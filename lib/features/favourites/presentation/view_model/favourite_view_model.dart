import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/features/favourites/domain/usecases/get_all_favourite_usecase.dart';
import 'package:rentease/features/favourites/domain/usecases/is_favourite_usecase.dart';
import 'package:rentease/features/favourites/domain/usecases/toggle_favourite_usecase.dart';
import 'package:rentease/features/favourites/presentation/state/favourite_state.dart';

final favouriteViewModelProvider =
    NotifierProvider<FavouriteViewModel, FavouriteState>(
      FavouriteViewModel.new,
    );

class FavouriteViewModel extends Notifier<FavouriteState> {
  late final GetAllFavouritesUsecase _getAllFavouritesUsecase;
  late final ToggleFavouriteUsecase _toggleFavouriteUsecase;
  late final IsFavouriteUsecase _isFavouriteUsecase;

  @override
  FavouriteState build() {
    _getAllFavouritesUsecase = ref.read(getAllFavouritesUsecaseProvider);
    _toggleFavouriteUsecase = ref.read(toggleFavouriteUsecaseProvider);
    _isFavouriteUsecase = ref.read(isFavouriteUsecaseProvider);

    return const FavouriteState();
  }

  Future<void> getAllFavourites() async {
    state = state.copyWith(status: FavouriteStatusState.loading);

    final result = await _getAllFavouritesUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: FavouriteStatusState.error,
        errorMessage: failure.message,
      ),
      (favourites) => state = state.copyWith(
        status: FavouriteStatusState.loaded,
        favourites: favourites,
      ),
    );
  }

 Future<void> toggleFavourite(String propertyId) async {
    
    final result = await _toggleFavouriteUsecase(propertyId);

    result.fold(
      (failure) => state = state.copyWith(
        status: FavouriteStatusState.error,
        errorMessage: failure.message,
      ),
      (isNowFavourite) {
        state = state.copyWith(
          status: FavouriteStatusState.updated,
          isFavourite: isNowFavourite, 
        );
        
        getAllFavourites();
      },
    );
  }


  Future<void> isFavourite(String propertyId) async {
    final result = await _isFavouriteUsecase(propertyId);

    result.fold(
      (failure) => state = state.copyWith(isFavourite: false),
      (isFav) => state = state.copyWith(isFavourite: isFav),
    );
  }

  void clearError() {
    state = state.copyWith(resetErrorMessage: true);
  }

  void resetState() {
    state = const FavouriteState();
  }
}
