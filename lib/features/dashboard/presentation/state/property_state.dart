import 'package:equatable/equatable.dart';
import 'package:rentease/features/dashboard/domain/entities/property_entity.dart';

enum PropertyStatus { initial, loading, loaded, error }

class PropertyState extends Equatable {
  final PropertyStatus status;
  final List<PropertyEntity> properties;
  final PropertyEntity? selectedProperty;
  final String? errorMessage;

  const PropertyState({
    this.status = PropertyStatus.initial,
    this.properties = const [],
    this.selectedProperty,
    this.errorMessage,
  });

  PropertyState copyWith({
    PropertyStatus? status,
    List<PropertyEntity>? properties,
    PropertyEntity? selectedProperty,
    bool clearSelectedProperty = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return PropertyState(
      status: status ?? this.status,
      properties: properties ?? this.properties,
      selectedProperty: clearSelectedProperty
          ? null
          : (selectedProperty ?? this.selectedProperty),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
  
  @override
  List<Object?> get props => [status, properties, selectedProperty, errorMessage];
}
