import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/features/dashboard/domain/usecases/get_all_property_usecase.dart';
import 'package:rentease/features/dashboard/domain/usecases/get_property_byid_usecase.dart';
import 'package:rentease/features/dashboard/presentation/state/property_state.dart';

final propertyViewModelProvider =
    NotifierProvider<PropertyViewmodel, PropertyState>(PropertyViewmodel.new);

class PropertyViewmodel extends Notifier<PropertyState> {
  late final GetAllPropertyUsecase _getAllPropertyUsecase;
  late final GetPropertyByidUsecase _getPropertyByidUsecase;

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
      print("FAILURE: ${failure.message}");
      state = state.copyWith(
        status: PropertyStatus.error,
        errorMessage: failure.message,
      );
    },
    (properties) {
      print("SUCCESS: fetched ${properties.length} properties");
      state = state.copyWith(
        status: PropertyStatus.loaded,
        properties: properties,
      );
    },
  );
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
