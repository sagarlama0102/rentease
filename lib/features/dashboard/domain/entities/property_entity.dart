import 'package:equatable/equatable.dart';

class PropertyEntity extends Equatable {
  final String? propertyId;
  final String title;
  final String description;
  final String propertyType;
  final String bhk;
  final String city;
  final String address;
  final double price;
  final List<String> propertyImages;
  final bool isRented;

  const PropertyEntity({
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

  @override
  // TODO: implement props
  List<Object?> get props => [
    propertyId,
    title,
    description,
    propertyType,
    bhk,
    city,
    address,
    price,
    propertyImages,
    isRented,
  ];
}
