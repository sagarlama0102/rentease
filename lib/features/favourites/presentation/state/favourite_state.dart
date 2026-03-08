import 'package:equatable/equatable.dart';
import 'package:rentease/features/favourites/domain/entities/favourite_entity.dart';

enum FavouriteStatusState { initial, loading, loaded, error, created, updated }

class FavouriteState extends Equatable {
  final FavouriteStatusState status;
  final List<FavouriteEntity> favourites;
  final bool isFavourite;
  final String? errorMessage;

  const FavouriteState({
    this.status = FavouriteStatusState.initial,
    this.favourites = const [],
    this.isFavourite = false,
    this.errorMessage,
  });

  FavouriteState copyWith({
    FavouriteStatusState? status,
    List<FavouriteEntity>? favourites,
    bool? isFavourite,
    bool resetisFavourite = false,
    String? errorMessage,
    bool resetErrorMessage = false,
  }) {
    return FavouriteState(
      status: status ?? this.status,
      favourites: favourites ?? this.favourites,
      isFavourite: isFavourite ?? this.isFavourite, 
      errorMessage: resetErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    status,
    favourites,
    isFavourite,
    errorMessage,
  ];
}
