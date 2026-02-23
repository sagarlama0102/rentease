import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/features/dashboard/domain/entities/property_entity.dart';
import 'package:rentease/features/dashboard/domain/usecases/get_all_property_usecase.dart';
import 'package:rentease/features/dashboard/domain/usecases/get_property_byid_usecase.dart';
import 'package:rentease/features/dashboard/presentation/state/property_state.dart';

final propertyViewModelProvider =
    NotifierProvider<PropertyViewmodel, PropertyState>(PropertyViewmodel.new);

class PropertyViewmodel extends Notifier<PropertyState> {
  late final GetAllPropertyUsecase _getAllPropertyUsecase;
  late final GetPropertyByidUsecase _getPropertyByidUsecase;

  // A local list to hold all properties for searching without refetching from API
  List<PropertyEntity> _allPropertiesBackup = [];

  @override
  PropertyState build() {
    _getAllPropertyUsecase = ref.read(getAllPropertyUsecaseProvider);
    _getPropertyByidUsecase = ref.read(getPropertyByidUsecaseProvider);

    return const PropertyState();
  }
  

 Future<void> getAllProperties() async {
  state = state.copyWith(status: PropertyStatus.loading);

  final result = await _getAllPropertyUsecase();

  result.fold(
    (failure) {
      
      state = state.copyWith(
        status: PropertyStatus.error,
        errorMessage: failure.message,
      );
    },
    (properties) {
      _allPropertiesBackup = properties;
      state = state.copyWith(
        status: PropertyStatus.loaded,
        properties: properties,
      );
    },
  );

}


  void searchProperties(String query) {
    if (query.isEmpty) {
      // If search is empty, restore the full list from backup
      state = state.copyWith(properties: _allPropertiesBackup);
      return;
    }

    // Filter logic
    final filteredList = _allPropertiesBackup.where((property) {
      final searchLower = query.toLowerCase();
      final titleLower = property.title.toLowerCase();
      final cityLower = property.city.toLowerCase();
      final addressLower = property.address.toLowerCase();

      return titleLower.contains(searchLower) || 
             cityLower.contains(searchLower) || 
             addressLower.contains(searchLower);
    }).toList();

    state = state.copyWith(properties: filteredList);
  }

  Future<void> getPropertyById(String propertyId) async {
    state = state.copyWith(status: PropertyStatus.loading);

    final result = await _getPropertyByidUsecase(
      GetPropertyByIdParams(propertyId: propertyId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: PropertyStatus.error,
        errorMessage: failure.message,
      ),
      (property) => state = state.copyWith(
        status: PropertyStatus.loaded,
        selectedProperty: property,
      ),
    );
  }

  void clearError() {
    state = state.copyWith(clearErrorMessage: true);
  }

  void clearSelectedProperty() {
    state = state.copyWith(clearSelectedProperty: true);
  }
}
