import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/features/favourites/domain/entities/favourite_entity.dart';
import 'package:rentease/features/favourites/domain/repositories/favourite_repository.dart';
import 'package:rentease/features/favourites/domain/usecases/get_all_favourite_usecase.dart';


// Mock the Repository
class MockFavouriteRepository extends Mock implements IFavouriteRepository {}

void main() {
  late GetAllFavouritesUsecase usecase;
  late MockFavouriteRepository mockRepository;

  setUp(() {
    mockRepository = MockFavouriteRepository();
    usecase = GetAllFavouritesUsecase(favouriteRepository: mockRepository);
  });

  // Sample Test Data
  final tFavouritesList = [
    const FavouriteEntity(userId: '1', propertyId: 'prop123'),
    const FavouriteEntity(userId: '2', propertyId: 'prop456'),
  ];

  group('GetAllFavouritesUsecase', () {
    test('should return a list of FavouriteEntity from the repository', () async {
      // Arrange
      when(() => mockRepository.getAllFavourites())
          .thenAnswer((_) async => Right(tFavouritesList));

      // Act
      final result = await usecase();

      // Assert
      expect(result, Right(tFavouritesList));
      verify(() => mockRepository.getAllFavourites()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository call is unsuccessful', () async {
      // Arrange
      const failure = ApiFailure(message: 'Server Error');
      when(() => mockRepository.getAllFavourites())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.getAllFavourites()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}