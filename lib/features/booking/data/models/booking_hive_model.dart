import 'package:hive/hive.dart';
import 'package:rentease/core/constants/hive_table_constants.dart';
import 'package:rentease/features/booking/data/models/booking_api_model.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';

part 'booking_hive_model.g.dart';

@HiveType(typeId: HiveTableConstants.bookingTypeId)
class BookingHiveModel extends HiveObject {
  @HiveField(0)
  final String? bookingId;

  @HiveField(1)
  final String propertyId;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final String status; // stored as String

  @HiveField(4)
  final String? message;

  @HiveField(5)
  final String? createdAt; // stored as ISO String

  @HiveField(6)
  final String? updatedAt;

  BookingHiveModel({
    this.bookingId,
    required this.propertyId,
    required this.userId,
    required this.status,
    this.message,
    this.createdAt,
    this.updatedAt,
  });

  /// 🔹 Convert Hive → Entity
  BookingEntity toEntity() {
    return BookingEntity(
      bookingId: bookingId,
      propertyId: propertyId,
      userId: userId,
      status: BookingEntity.statusFromString(status),
      message: message,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  /// 🔹 Convert Entity → Hive
  factory BookingHiveModel.fromEntity(BookingEntity entity) {
    return BookingHiveModel(
      bookingId: entity.bookingId,
      propertyId: entity.propertyId,
      userId: entity.userId,
      status: BookingEntity.statusToString(entity.status),
      message: entity.message,
      createdAt: entity.createdAt?.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
    );
  }

  static List<BookingEntity> toEntityList(List<BookingHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  //convert from API model to Hive model for caching
  factory BookingHiveModel.fromApiModel(BookingApiModel apiModel) {
  return BookingHiveModel(
    bookingId: apiModel.id,
    propertyId: apiModel.propertyId is Map ? apiModel.propertyId['_id'] : apiModel.propertyId.toString(),
    userId: apiModel.userId is Map ? apiModel.userId['_id'] : apiModel.userId.toString(),
    status: apiModel.status,
    message: apiModel.message,
    createdAt: apiModel.createdAt,
    updatedAt: apiModel.updatedAt,
  );
}
  //convert list of API models to Hive models for caching
  static List<BookingHiveModel> fromApiModelList(
    List<BookingApiModel> apiModels,
  ) {
    return apiModels
        .map((model) => BookingHiveModel.fromApiModel(model))
        .toList();
  }
}
