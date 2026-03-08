import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/features/dashboard/domain/entities/property_entity.dart';
import 'package:rentease/features/dashboard/domain/repositories/property_repository.dart';
import 'package:rentease/features/dashboard/domain/usecases/get_property_byid_usecase.dart';

// Mock Repository
class MockPropertyRepository extends Mock implements IPropertyRepository {}

void main() {
  late GetPropertyByidUsecase usecase;
  late MockPropertyRepository mockPropertyRepository;

  setUp(() {
    mockPropertyRepository = MockPropertyRepository();
    usecase = GetPropertyByidUsecase(propertyRepository: mockPropertyRepository);
  });

  const tPropertyId = '1';
  const tParams = GetPropertyByIdParams(propertyId: tPropertyId);

  const tPropertyEntity = PropertyEntity(
    propertyId: tPropertyId,
    title: 'Modern House',
    description: 'Beautiful property in Kathmandu',
    price: 50000,
    propertyType: 'HOUSE',
    bhk: '2BHK',
    propertyImages: ["http://image.com/test.jpg"],
    city: 'Kathmandu',
    address: 'Kalanki',
  );

  group('GetPropertyByidUsecase', () {
    test(
      'should return PropertyEntity from the repository when call is successful',
      () async {
        // Arrange
        when(
          () => mockPropertyRepository.getPropertyById(any()),
        ).thenAnswer((_) async => const Right(tPropertyEntity));

        // Act
        final result = await usecase(tParams);

        // Assert
        expect(result, const Right(tPropertyEntity));
        verify(() => mockPropertyRepository.getPropertyById(tPropertyId)).called(1);
        verifyNoMoreInteractions(mockPropertyRepository);
      },
    );

    test(
      'should return Failure when repository call is unsuccessful',
      () async {
        // Arrange
        const failure = ApiFailure(message: 'Property not found');
        when(
          () => mockPropertyRepository.getPropertyById(any()),
        ).thenAnswer((_) async => const Left(failure));

        // Act
        final result = await usecase(tParams);

        // Assert
        expect(result, const Left(failure));
        verify(() => mockPropertyRepository.getPropertyById(tPropertyId)).called(1);
        verifyNoMoreInteractions(mockPropertyRepository);
      },
    );

    test(
      'should return LocalDatabaseFailure when property is missing in cache',
      () async {
        // Arrange
        const failure = LocalDatabaseFailure(message: 'Property not found in cache');
        when(
          () => mockPropertyRepository.getPropertyById(any()),
        ).thenAnswer((_) async => const Left(failure));

        // Act
        final result = await usecase(tParams);

        // Assert
        expect(result, const Left(failure));
        verify(() => mockPropertyRepository.getPropertyById(tPropertyId)).called(1);
      },
    );
  });
}