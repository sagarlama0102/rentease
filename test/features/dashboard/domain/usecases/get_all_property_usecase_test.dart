import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/features/dashboard/domain/entities/property_entity.dart';
import 'package:rentease/features/dashboard/domain/repositories/property_repository.dart';
import 'package:rentease/features/dashboard/domain/usecases/get_all_property_usecase.dart';

// Create a Mock for the Repository
class MockPropertyRepository extends Mock implements IPropertyRepository {}

void main() {
  late GetAllPropertyUsecase usecase;
  late MockPropertyRepository mockPropertyRepository;

  setUp(() {
    mockPropertyRepository = MockPropertyRepository();
    usecase = GetAllPropertyUsecase(propertyRepository: mockPropertyRepository);
  });

  // Sample data for testing
  final tProperties = [
    const PropertyEntity(
      propertyId: '1',
      title: 'Luxury Villa',
      description: 'A beautiful villa by the beach',
      price: 5000,
      propertyType: 'HOUSE',
      bhk: '3BHK',
      propertyImages: ["http://image.com/test.jpg"],
      city: 'Kathmandu',
      address: 'Kalimati'
    ),
    const PropertyEntity(
      propertyId: '2',
      title: 'Modern Apartment',
      description: 'City center apartment with great views',
      price: 1200,
      propertyType: 'HOUSE',
      bhk: '2BHK',
      propertyImages: ["http://image.com/test.jpg"],
      city: 'Kathmandu',
      address: 'Kalanki'
    ),
  ];

  group('GetAllPropertyUsecase', () {
    test(
      'should return list of properties when repository call is successful',
      () async {
        // Arrange
        when(
          () => mockPropertyRepository.getAllProperty(),
        ).thenAnswer((_) async => Right(tProperties));

        // Act
        final result = await usecase();

        // Assert
        expect(result, Right(tProperties));
        verify(() => mockPropertyRepository.getAllProperty()).called(1);
        verifyNoMoreInteractions(mockPropertyRepository);
      },
    );

    test('should return failure when repository call fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Failed to fetch properties');
      when(
        () => mockPropertyRepository.getAllProperty(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockPropertyRepository.getAllProperty()).called(1);
      verifyNoMoreInteractions(mockPropertyRepository);
    });

    test('should return empty list when no properties exist', () async {
      // Arrange
      when(
        () => mockPropertyRepository.getAllProperty(),
      ).thenAnswer((_) async => const Right([]));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Right(<PropertyEntity>[]));
      verify(() => mockPropertyRepository.getAllProperty()).called(1);
    });

    test('should return NetworkFailure when there is no internet', () async {
      // Arrange
      const failure = NetworkFailure(message: 'No Internet Connection');
      when(
        () => mockPropertyRepository.getAllProperty(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockPropertyRepository.getAllProperty()).called(1);
    });
  });
}