import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/features/dashboard/domain/entities/property_entity.dart';
import 'package:rentease/features/dashboard/domain/usecases/get_all_property_usecase.dart';
import 'package:rentease/features/dashboard/domain/usecases/get_property_byid_usecase.dart';
import 'package:rentease/features/dashboard/presentation/state/property_state.dart';
import 'package:rentease/features/dashboard/presentation/view_model/property_viewmodel.dart';

// Mock Classes
class MockGetAllPropertyUsecase extends Mock implements GetAllPropertyUsecase {}
class MockGetPropertyByidUsecase extends Mock implements GetPropertyByidUsecase {}

void main() {
  late MockGetAllPropertyUsecase mockGetAllPropertyUsecase;
  late MockGetPropertyByidUsecase mockGetPropertyByidUsecase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(const GetPropertyByIdParams(propertyId: 'fallback'));
  });

  setUp(() {
    mockGetAllPropertyUsecase = MockGetAllPropertyUsecase();
    mockGetPropertyByidUsecase = MockGetPropertyByidUsecase();

    container = ProviderContainer(
      overrides: [
        getAllPropertyUsecaseProvider.overrideWithValue(mockGetAllPropertyUsecase),
        getPropertyByidUsecaseProvider.overrideWithValue(mockGetPropertyByidUsecase),
      ],
    );
  });

  tearDown(() => container.dispose());

  // Test Data
  final tProperties = [
    const PropertyEntity(
      propertyId: '1',
      title: 'Luxury Villa',
      city: 'Kathmandu',
      address: 'Kalanki',
      propertyType: 'HOUSE',
      bhk: '2BHK',
      price: 5000,
      propertyImages: ["http://image.com/test.jpg"],
      description: 'Test Description',
    ),
    const PropertyEntity(
      propertyId: '2',
      title: 'Modern Apartment',
      city: 'Pokhara',
      address: 'Lakeside',
      propertyType: 'APARTMENT',
      bhk: '1BHK',
      price: 2000,
      propertyImages: ["http://image.com/test2.jpg"],
      description: 'Test Description 2',
    ),
  ];

  group('PropertyViewmodel Tests', () {
    test('initial state should be initial', () {
      final state = container.read(propertyViewModelProvider);
      expect(state.status, PropertyStatus.initial);
      expect(state.properties, isEmpty);
      expect(state.selectedProperty, isNull);
    });

    group('getAllProperties', () {
      test('should emit loading then loaded state when successful', () async {
        // Arrange
        when(() => mockGetAllPropertyUsecase()).thenAnswer((_) async => Right(tProperties));

        final viewModel = container.read(propertyViewModelProvider.notifier);

        // Act
        await viewModel.getAllProperties();

        // Assert
        final state = container.read(propertyViewModelProvider);
        expect(state.status, PropertyStatus.loaded);
        expect(state.properties, tProperties);
        verify(() => mockGetAllPropertyUsecase()).called(1);
      });

      test('should emit error state when failed', () async {
        // Arrange
        const failure = ApiFailure(message: 'Failed to fetch properties');
        when(() => mockGetAllPropertyUsecase()).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(propertyViewModelProvider.notifier);

        // Act
        await viewModel.getAllProperties();

        // Assert
        final state = container.read(propertyViewModelProvider);
        expect(state.status, PropertyStatus.error);
        expect(state.errorMessage, 'Failed to fetch properties');
      });
    });

    group('searchProperties', () {
      test('should filter properties based on query (title, city, or address)', () async {
        // Arrange - Load properties first to fill the backup list
        when(() => mockGetAllPropertyUsecase()).thenAnswer((_) async => Right(tProperties));
        final viewModel = container.read(propertyViewModelProvider.notifier);
        await viewModel.getAllProperties();

        // Act - Search by city
        viewModel.searchProperties('Kathmandu');

        // Assert
        var state = container.read(propertyViewModelProvider);
        expect(state.properties.length, 1);
        expect(state.properties.first.city, 'Kathmandu');

        // Act - Search by title (partial)
        viewModel.searchProperties('Apart');
        state = container.read(propertyViewModelProvider);
        expect(state.properties.first.title, 'Modern Apartment');
      });

      test('should return all properties when query is empty', () async {
        // Arrange
        when(() => mockGetAllPropertyUsecase()).thenAnswer((_) async => Right(tProperties));
        final viewModel = container.read(propertyViewModelProvider.notifier);
        await viewModel.getAllProperties();

        // Act
        viewModel.searchProperties('');

        // Assert
        final state = container.read(propertyViewModelProvider);
        expect(state.properties, tProperties);
      });
    });

    group('getPropertyById', () {
      test('should emit loaded state with selectedProperty when successful', () async {
        // Arrange
        when(() => mockGetPropertyByidUsecase(any()))
            .thenAnswer((_) async => Right(tProperties[0]));

        final viewModel = container.read(propertyViewModelProvider.notifier);

        // Act
        await viewModel.getPropertyById('1');

        // Assert
        final state = container.read(propertyViewModelProvider);
        expect(state.status, PropertyStatus.loaded);
        expect(state.selectedProperty, tProperties[0]);
        verify(() => mockGetPropertyByidUsecase(any())).called(1);
      });
    });

    group('clear methods', () {
      test('clearError should reset error message', () async {
        // Arrange
        when(() => mockGetAllPropertyUsecase())
            .thenAnswer((_) async => const Left(ApiFailure(message: 'Error')));
        final viewModel = container.read(propertyViewModelProvider.notifier);
        await viewModel.getAllProperties();

        // Act
        viewModel.clearError();

        // Assert
        final state = container.read(propertyViewModelProvider);
        expect(state.errorMessage, isNull);
      });

      test('clearSelectedProperty should reset selected property', () async {
        // Arrange
        when(() => mockGetPropertyByidUsecase(any()))
            .thenAnswer((_) async => Right(tProperties[0]));
        final viewModel = container.read(propertyViewModelProvider.notifier);
        await viewModel.getPropertyById('1');

        // Act
        viewModel.clearSelectedProperty();

        // Assert
        final state = container.read(propertyViewModelProvider);
        expect(state.selectedProperty, isNull);
      });
    });
   group('PropertyState copyWith', () {
      test('should clear selected property when clearSelectedProperty is true', () {
        final state = PropertyState(selectedProperty: tProperties[0]);
        final newState = state.copyWith(clearSelectedProperty: true);
        expect(newState.selectedProperty, isNull);
      });

      test('should clear error message when clearErrorMessage is true', () {
        final state = const PropertyState(errorMessage: 'Error');
        final newState = state.copyWith(clearErrorMessage: true);
        expect(newState.errorMessage, isNull);
      });
    });
  });
}