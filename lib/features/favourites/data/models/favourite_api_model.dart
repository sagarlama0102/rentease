import 'package:json_annotation/json_annotation.dart';
import 'package:rentease/features/favourites/domain/entities/favourite_entity.dart';

part 'favourite_api_model.g.dart';

@JsonSerializable()
class FavouriteApiModel {
  @JsonKey(name: '_id')
  final String? id;

  @JsonKey(name: 'property')
  final dynamic propertyId;

  @JsonKey(name: 'user')
  final dynamic userId;


  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<String> propertyImages;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? propertyTitle;

  FavouriteApiModel({
    this.id,
    required this.propertyId,
    required this.userId,
    this.propertyImages = const [],
    this.propertyTitle,
  });

factory FavouriteApiModel.fromJson(Map<String, dynamic> json) {

  try {

    final propertyData = json['property'] is Map<String, dynamic>
        ? json['property'] as Map<String, dynamic>
        : null;


    List<String> images = [];
    if (propertyData != null && propertyData['propertyImages'] is List) {
      for (var item in propertyData['propertyImages']) {
        if (item != null) images.add(item.toString());
      }
    }

    final String? title = propertyData?['title'];

    // 3. Return the model
    return _$FavouriteApiModelFromJson(json).copyWithPopulatedData(images, title);
  } catch (e) {
    // If parsing fails, return a "Skeleton" model instead of crashing the app
    return FavouriteApiModel(
      id: json['_id']?.toString(),
      propertyId: json['property'],
      userId: json['user'],
      propertyImages: [],
      propertyTitle: "Error loading details",
    );
  }
}

  // Helper method to inject the populated data into the model
  FavouriteApiModel copyWithPopulatedData(List<String> images, String? title) {
    return FavouriteApiModel(
      id: id,
      propertyId: propertyId,
      userId: userId,
      propertyImages: images,
      propertyTitle: title,
    );
  }

  Map<String, dynamic> toJson() => _$FavouriteApiModelToJson(this);

  // Convert to Domain Entity
  FavouriteEntity toEntity() {
    return FavouriteEntity(
      favouriteId: id,
      // If populated, propertyId is a Map, we extract the _id. Otherwise, use it as is.
      propertyId: propertyId is Map ? propertyId['_id'].toString() : propertyId.toString(),
      userId: userId is Map ? userId['_id'].toString() : userId.toString(),
      propertyImages: propertyImages,
      propertyTitle: propertyTitle,
    );
  }

  // Convert from Domain Entity (Usually for sending data to API)
  factory FavouriteApiModel.fromEntity(FavouriteEntity entity) {
    return FavouriteApiModel(
      id: entity.favouriteId,
      propertyId: entity.propertyId,
      userId: entity.userId,
      propertyImages: entity.propertyImages,
      propertyTitle: entity.propertyTitle,
    );
  }

  static List<FavouriteEntity> toEntityList(List<FavouriteApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}