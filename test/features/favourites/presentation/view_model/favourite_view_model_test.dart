import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/features/favourites/domain/entities/favourite_entity.dart';
import 'package:rentease/features/favourites/domain/usecases/get_all_favourite_usecase.dart';
import 'package:rentease/features/favourites/domain/usecases/is_favourite_usecase.dart';
import 'package:rentease/features/favourites/domain/usecases/toggle_favourite_usecase.dart';
import 'package:rentease/features/favourites/presentation/state/favourite_state.dart';
import 'package:rentease/features/favourites/presentation/view_model/favourite_view_model.dart';

// Mock UseCases
class MockGetAllFavouritesUsecase extends Mock
    implements GetAllFavouritesUsecase {}

class MockToggleFavouriteUsecase extends Mock
    implements ToggleFavouriteUsecase {}

class MockIsFavouriteUsecase extends Mock implements IsFavouriteUsecase {}

void main() {
  late ProviderContainer container;
  late MockGetAllFavouritesUsecase mockGetAllFavourites;
  late MockToggleFavouriteUsecase mockToggleFavourite;
  late MockIsFavouriteUsecase mockIsFavourite;

  setUp(() {
    mockGetAllFavourites = MockGetAllFavouritesUsecase();
    mockToggleFavourite = MockToggleFavouriteUsecase();
    mockIsFavourite = MockIsFavouriteUsecase();

    container = ProviderContainer(
      overrides: [
        getAllFavouritesUsecaseProvider.overrideWithValue(mockGetAllFavourites),
        toggleFavouriteUsecaseProvider.overrideWithValue(mockToggleFavourite),
        isFavouriteUsecaseProvider.overrideWithValue(mockIsFavourite),
      ],
    );
  });

  tearDown(() => container.dispose());

  const tPropertyId = 'prop123';
  final tFavouritesList = [
    const FavouriteEntity(userId: '1', propertyId: tPropertyId),
  ];

  group('getAllFavourites', () {
    test('should emit loading and then loaded state with data', () async {
      // Arrange
      when(
        () => mockGetAllFavourites(),
      ).thenAnswer((_) async => Right(tFavouritesList));

      // Act
      await container
          .read(favouriteViewModelProvider.notifier)
          .getAllFavourites();

      // Assert
      final state = container.read(favouriteViewModelProvider);
      expect(state.status, FavouriteStatusState.loaded);
      expect(state.favourites, tFavouritesList);
      verify(() => mockGetAllFavourites()).called(1);
    });

    test('should emit error state when fetching fails', () async {
      // Arrange
      when(() => mockGetAllFavourites()).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Fetch failed')),
      );

      // Act
      await container
          .read(favouriteViewModelProvider.notifier)
          .getAllFavourites();

      // Assert
      final state = container.read(favouriteViewModelProvider);
      expect(state.status, FavouriteStatusState.error);
      expect(state.errorMessage, 'Fetch failed');
    });
  });

  group('toggleFavourite', () {
    test('should transition through updated and then loaded status', () async {
      final states = <FavouriteState>[];

      container.listen<FavouriteState>(
        favouriteViewModelProvider,
        (previous, next) => states.add(next),
        fireImmediately: false,
      );

      when(
        () => mockToggleFavourite(any()),
      ).thenAnswer((_) async => const Right(true));

      when(
        () => mockGetAllFavourites(),
      ).thenAnswer((_) async => Right(tFavouritesList));

      await container
          .read(favouriteViewModelProvider.notifier)
          .toggleFavourite(tPropertyId);

      await Future.delayed(Duration.zero);

      expect(states.any((s) => s.status == FavouriteStatusState.updated), true);
      expect(states.last.status, FavouriteStatusState.loaded);
    });
    test('should emit error state when toggle fails', () async {
      // Arrange
      when(() => mockToggleFavourite(any())).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Toggle failed')),
      );

      // Act
      await container
          .read(favouriteViewModelProvider.notifier)
          .toggleFavourite(tPropertyId);

      // Assert
      final state = container.read(favouriteViewModelProvider);
      expect(state.status, FavouriteStatusState.error);
      expect(state.errorMessage, 'Toggle failed');
    });
  });

  group('isFavourite', () {
    test('should update isFavourite state based on usecase result', () async {
      // Arrange
      when(
        () => mockIsFavourite(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      await container
          .read(favouriteViewModelProvider.notifier)
          .isFavourite(tPropertyId);

      // Assert
      final state = container.read(favouriteViewModelProvider);
      expect(state.isFavourite, true);
      verify(() => mockIsFavourite(tPropertyId)).called(1);
    });
  });

  test('resetState should return state to initial values', () {
    container.read(favouriteViewModelProvider.notifier).resetState();
    final state = container.read(favouriteViewModelProvider);
    expect(state.status, FavouriteStatusState.initial);
    expect(state.favourites, isEmpty);
  });
}
