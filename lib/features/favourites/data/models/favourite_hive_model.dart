import 'package:hive/hive.dart';
import 'package:rentease/core/constants/hive_table_constants.dart';
import 'package:rentease/features/favourites/data/models/favourite_api_model.dart';
import 'package:rentease/features/favourites/domain/entities/favourite_entity.dart';

part 'favourite_hive_model.g.dart';

@HiveType(typeId: HiveTableConstants.favouriteTypeId)
class FavouriteHiveModel extends HiveObject {
  @HiveField(0)
  final String? favouriteId;

  @HiveField(1)
  final String propertyId;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final List<String> propertyImages;

  @HiveField(4)
  final String? propertyTitle;

  FavouriteHiveModel({
    this.favouriteId,
    required this.propertyId,
    required this.userId,
    this.propertyTitle,
    required this.propertyImages,
  });

  FavouriteEntity toEntity() {
    return FavouriteEntity(
      favouriteId: favouriteId,
      propertyId: propertyId,
      userId: userId,
      propertyImages: propertyImages,
      propertyTitle: propertyTitle,
    );
  }

  static List<FavouriteEntity> toEntityList(List<FavouriteHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  //converty from API model to hive model for caching
  factory FavouriteHiveModel.fromApiModel(FavouriteApiModel apiModel) {
    return FavouriteHiveModel(
      favouriteId: apiModel.id,
      propertyId: apiModel.propertyId is Map
          ? apiModel.propertyId['_id']
          : apiModel.propertyId.toString(),
      userId: apiModel.userId is Map
          ? apiModel.userId['_id']
          : apiModel.userId.toString(),
      propertyImages: apiModel.propertyImages,
      propertyTitle: apiModel.propertyTitle,
    );
  }
  //convert list of API models to Hive models for caching
  static List<FavouriteHiveModel> fromApiModelList(
    List<FavouriteApiModel> apiModels,
  ) {
    return apiModels
        .map((model) => FavouriteHiveModel.fromApiModel(model))
        .toList();
  }
}
