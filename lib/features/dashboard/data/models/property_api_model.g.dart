// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyApiModel _$PropertyApiModelFromJson(Map<String, dynamic> json) =>
    PropertyApiModel(
      id: json['_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      propertyType: json['propertyType'] as String,
      bhk: json['bhk'] as String,
      city: json['city'] as String,
      address: json['address'] as String,
      price: (json['price'] as num).toDouble(),
      propertyImages: (json['propertyImages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isRented: json['isRented'] as bool? ?? false,
    );

Map<String, dynamic> _$PropertyApiModelToJson(PropertyApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'propertyType': instance.propertyType,
      'bhk': instance.bhk,
      'city': instance.city,
      'address': instance.address,
      'price': instance.price,
      'propertyImages': instance.propertyImages,
      'isRented': instance.isRented,
    };
