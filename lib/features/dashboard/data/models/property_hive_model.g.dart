// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PropertyHiveModelAdapter extends TypeAdapter<PropertyHiveModel> {
  @override
  final int typeId = 1;

  @override
  PropertyHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PropertyHiveModel(
      propertyId: fields[0] as String?,
      title: fields[1] as String,
      description: fields[2] as String,
      propertyType: fields[3] as String,
      bhk: fields[4] as String,
      city: fields[5] as String,
      address: fields[6] as String,
      price: fields[7] as double,
      propertyImages: (fields[8] as List).cast<String>(),
      isRented: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PropertyHiveModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.propertyId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.propertyType)
      ..writeByte(4)
      ..write(obj.bhk)
      ..writeByte(5)
      ..write(obj.city)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.price)
      ..writeByte(8)
      ..write(obj.propertyImages)
      ..writeByte(9)
      ..write(obj.isRented);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropertyHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
