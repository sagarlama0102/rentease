import 'package:hive/hive.dart';
import 'package:rentease/core/constants/hive_table_constants.dart';
import 'package:rentease/features/dashboard/data/models/property_api_model.dart';
import 'package:rentease/features/dashboard/domain/entities/property_entity.dart';
import 'package:uuid/uuid.dart';

part 'property_hive_model.g.dart';

@HiveType(typeId: HiveTableConstants.propertyTypeId)
class PropertyHiveModel extends HiveObject {
  @HiveField(0)
  final String? propertyId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String propertyType;

  @HiveField(4)
  final String bhk;

  @HiveField(5)
  final String city;

  @HiveField(6)
  final String address;

  @HiveField(7)
  final double price;

  @HiveField(8)
  final List<String> propertyImages;

  @HiveField(9)
  final bool isRented;

  PropertyHiveModel({
    this.propertyId,
    required this.title,
    required this.description,
    required this.propertyType,
    required this.bhk,
    required this.city,
    required this.address,
    required this.price,
    required this.propertyImages,
    this.isRented = false,
  });

  //to entity
  PropertyEntity toEntity({PropertyEntity? batch}) {
    return PropertyEntity(
      propertyId: propertyId,
      title: title,
      description: description,
      propertyType: propertyType,
      bhk: bhk,
      city: city,
      address: address,
      price: price,
      propertyImages: propertyImages,
      isRented: isRented,
    );
  }

  //from Entity
  factory PropertyHiveModel.fromEntity(PropertyEntity entity) {
    return PropertyHiveModel(
      propertyId: entity.propertyId,
      title: entity.title,
      description: entity.description,
      propertyType: entity.propertyType,
      bhk: entity.bhk,
      city: entity.city,
      address: entity.address,
      price: entity.price,
      propertyImages: entity.propertyImages,
      isRented: entity.isRented,
    );
  }
  

  static List<PropertyEntity> toEntityList(List<PropertyHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  ///Convert from API model to Hive model for caching
  factory PropertyHiveModel.fromApiModel(PropertyApiModel apiModel){
    return PropertyHiveModel(
      propertyId: apiModel.id,
      title: apiModel.title,
      description: apiModel.description,
      propertyType: apiModel.propertyType,
      bhk: apiModel.bhk,
      city: apiModel.city,
      address: apiModel.address,
      price: apiModel.price,
      propertyImages: apiModel.propertyImages,
      isRented: apiModel.isRented,
    );
  }

  ///Convert list of API models to Hive models for caching 
  static List<PropertyHiveModel> fromApiModelList(List<PropertyApiModel> apiModels){
    return apiModels.map((model)=> PropertyHiveModel.fromApiModel(model)).toList();
  }
}

