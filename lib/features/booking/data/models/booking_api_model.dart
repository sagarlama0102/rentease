import 'package:json_annotation/json_annotation.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';

part 'booking_api_model.g.dart';

@JsonSerializable()
class BookingApiModel {
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

  final String status;
  final String? message;
  final String? createdAt;
  final String? updatedAt;

  BookingApiModel({
    this.id,
    required this.propertyId,
    required this.userId,
    required this.status,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.propertyImages = const [],
    this.propertyTitle,
  });

  // 🔹 Update this factory to handle the nested extraction manually
  factory BookingApiModel.fromJson(Map<String, dynamic> json) {
    // 1. Manually extract the nested property data first
    final propertyData = json['property'] is Map<String, dynamic> 
        ? json['property'] as Map<String, dynamic> 
        : null;

    final List<String> images = propertyData != null && propertyData['propertyImages'] != null
        ? List<String>.from(propertyData['propertyImages'])
        : [];

    final String? title = propertyData?['title'];

    // 2. Call the generated code but override the missing fields
    return _$BookingApiModelFromJson(json).copyWithImages(images, title);
  }

  // Helper method to keep everything clean
  BookingApiModel copyWithImages(List<String> images, String? title) {
    return BookingApiModel(
      id: id,
      propertyId: propertyId,
      userId: userId,
      status: status,
      message: message,
      createdAt: createdAt,
      updatedAt: updatedAt,
      propertyImages: images,
      propertyTitle: title,
    );
  }

  Map<String, dynamic> toJson() => _$BookingApiModelToJson(this);

  BookingEntity toEntity() {
    return BookingEntity(
      bookingId: id,
      propertyId: propertyId is Map ? propertyId['_id'] : propertyId.toString(),
      userId: userId is Map ? userId['_id'] : userId.toString(),
      status: BookingEntity.statusFromString(status),
      propertyImages: propertyImages, // Now correctly populated
      propertyTitle: propertyTitle,   // Now correctly populated
      message: message,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  factory BookingApiModel.fromEntity(BookingEntity entity) {
    return BookingApiModel(
      id: entity.bookingId,
      propertyId: entity.propertyId,
      userId: entity.userId,
      status: BookingEntity.statusToString(entity.status),
      message: entity.message,
      propertyImages: entity.propertyImages,
      propertyTitle: entity.propertyTitle,
    );
  }

  static List<BookingEntity> toEntityList(List<BookingApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}

