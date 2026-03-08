import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/features/favourites/domain/repositories/favourite_repository.dart';
import 'package:rentease/features/favourites/domain/usecases/is_favourite_usecase.dart';

// Mock the Repository
class MockFavouriteRepository extends Mock implements IFavouriteRepository {}

void main() {
  late IsFavouriteUsecase usecase;
  late MockFavouriteRepository mockRepository;

  setUp(() {
    mockRepository = MockFavouriteRepository();
    usecase = IsFavouriteUsecase(favouriteRepository: mockRepository);
  });

  const tPropertyId = 'prop123';

  group('IsFavouriteUsecase', () {
    test('should return true when the property is marked as favourite', () async {
      // Arrange
      when(() => mockRepository.isFavourite(any()))
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase(tPropertyId);

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.isFavourite(tPropertyId)).called(1);
    });

    test('should return false when the property is not marked as favourite', () async {
      // Arrange
      when(() => mockRepository.isFavourite(any()))
          .thenAnswer((_) async => const Right(false));

      // Act
      final result = await usecase(tPropertyId);

      // Assert
      expect(result, const Right(false));
      verify(() => mockRepository.isFavourite(tPropertyId)).called(1);
    });

    test('should return failure when repository check fails', () async {
      // Arrange
      const failure = LocalDatabaseFailure(message: 'Cache Error');
      when(() => mockRepository.isFavourite(any()))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(tPropertyId);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.isFavourite(tPropertyId)).called(1);
    });
  });
}