import 'package:equatable/equatable.dart';

class FavouriteEntity extends Equatable {
  final String? favouriteId;
  final String propertyId;
  final String userId;
  final String? propertyTitle; 
  final List<String> propertyImages;

  const FavouriteEntity({
    this.favouriteId,
    required this.propertyId,
    required this.userId,
    this.propertyTitle,
    this.propertyImages = const [],
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    favouriteId,
    propertyId,
    userId,
    propertyTitle,
    propertyImages,
  ];
}
