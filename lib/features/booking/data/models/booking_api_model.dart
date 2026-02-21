import 'package:json_annotation/json_annotation.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';

part 'booking_api_model.g.dart';

@JsonSerializable()
class BookingApiModel {
  @JsonKey(name: '_id')
  final String? id;

  // These match your Mongoose Schema field names exactly
  @JsonKey(name: 'property')
  final dynamic propertyId;

  @JsonKey(name: 'user')
  final dynamic userId;

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
  });

  factory BookingApiModel.fromJson(Map<String, dynamic> json) =>
      _$BookingApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingApiModelToJson(this);

  /// 🔹 Convert API → Entity
  BookingEntity toEntity() {
    return BookingEntity(
      bookingId: id,
      propertyId: propertyId is Map ? propertyId['_id'] : propertyId.toString(),
      userId: userId is Map ? userId['_id'] : userId.toString(),
      status: BookingEntity.statusFromString(status),
      message: message,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  /// 🔹 Convert Entity → API (Matches your CreateBookingDTO)
  factory BookingApiModel.fromEntity(BookingEntity entity) {
    return BookingApiModel(
      id: entity.bookingId,
      propertyId: entity.propertyId,
      userId: entity.userId,
      status: BookingEntity.statusToString(entity.status),
      message: entity.message,
      // Timestamps are usually not sent back to the server
    );
  }

  static List<BookingEntity> toEntityList(List<BookingApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}