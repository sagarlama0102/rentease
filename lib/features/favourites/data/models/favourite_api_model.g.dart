// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavouriteApiModel _$FavouriteApiModelFromJson(Map<String, dynamic> json) =>
    FavouriteApiModel(
      id: json['_id'] as String?,
      propertyId: json['property'],
      userId: json['user'],
    );

Map<String, dynamic> _$FavouriteApiModelToJson(FavouriteApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'property': instance.propertyId,
      'user': instance.userId,
    };
