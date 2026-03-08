import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/features/favourites/domain/repositories/favourite_repository.dart';
import 'package:rentease/features/favourites/domain/usecases/toggle_favourite_usecase.dart';

// Mock the Repository
class MockFavouriteRepository extends Mock implements IFavouriteRepository {}

void main() {
  late ToggleFavouriteUsecase usecase;
  late MockFavouriteRepository mockRepository;

  setUp(() {
    mockRepository = MockFavouriteRepository();
    usecase = ToggleFavouriteUsecase(favouriteRepository: mockRepository);
  });

  const tPropertyId = 'prop123';

  group('ToggleFavouriteUsecase', () {
    test('should return true when property is successfully toggled', () async {
      // Arrange
      when(() => mockRepository.toggleFavourite(any()))
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase(tPropertyId);

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.toggleFavourite(tPropertyId)).called(1);
    });

    test('should return failure when toggling fails in the repository', () async {
      // Arrange
      const failure = ApiFailure(message: 'Network Error');
      when(() => mockRepository.toggleFavourite(any()))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(tPropertyId);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.toggleFavourite(tPropertyId)).called(1);
    });

    test('should verify that the correct property ID is passed to the repository', () async {
      // Arrange
      when(() => mockRepository.toggleFavourite(any()))
          .thenAnswer((_) async => const Right(true));

      // Act
      await usecase(tPropertyId);

      // Assert
      // Using captureAny to ensure the logic isn't modifying the string
      final captured = verify(() => mockRepository.toggleFavourite(captureAny())).captured;
      expect(captured.first, tPropertyId);
    });
  });
}