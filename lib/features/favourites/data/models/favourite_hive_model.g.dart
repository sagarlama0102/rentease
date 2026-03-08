// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavouriteHiveModelAdapter extends TypeAdapter<FavouriteHiveModel> {
  @override
  final int typeId = 3;

  @override
  FavouriteHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavouriteHiveModel(
      favouriteId: fields[0] as String?,
      propertyId: fields[1] as String,
      userId: fields[2] as String,
      propertyTitle: fields[4] as String?,
      propertyImages: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, FavouriteHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.favouriteId)
      ..writeByte(1)
      ..write(obj.propertyId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.propertyImages)
      ..writeByte(4)
      ..write(obj.propertyTitle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavouriteHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
