import 'package:json_annotation/json_annotation.dart';
import 'package:rentease/features/dashboard/domain/entities/property_entity.dart';

part 'property_api_model.g.dart';

@JsonSerializable()
class PropertyApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  final String description;
  final String propertyType;
  final String bhk;
  final String city;
  final String address;
  final double price;
  @JsonKey(name: 'propertyImages') 
  final List<String> propertyImages;
  
  @JsonKey(defaultValue: false)
  final bool isRented;

  PropertyApiModel({
    this.id,
    required this.title,
    required this.description,
    required this.propertyType,
    required this.bhk,
    required this.city,
    required this.address,
    required this.price,
    required this.propertyImages,
    required this.isRented,
  });

  Map<String, dynamic> toJson() => _$PropertyApiModelToJson(this);

  factory PropertyApiModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyApiModelFromJson(json);

  //toEntity
  PropertyEntity toEntity() {
    return PropertyEntity(
      propertyId: id,
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

  //from entity
  factory PropertyApiModel.fromEntity(PropertyEntity entity) {
    return PropertyApiModel(
      id: entity.propertyId,
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
  //toEntityList
  static List<PropertyEntity> toEntityList(List<PropertyApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
