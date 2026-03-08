import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/core/usecases/app_usecase.dart';
import 'package:rentease/features/dashboard/data/repositories/property_repository.dart';
import 'package:rentease/features/dashboard/domain/entities/property_entity.dart';
import 'package:rentease/features/dashboard/domain/repositories/property_repository.dart';

final getAllPropertyUsecaseProvider = Provider<GetAllPropertyUsecase>((ref) {
  final propertyRepository = ref.read(propertyRepositoryProvider);
  return GetAllPropertyUsecase(propertyRepository: propertyRepository);
});

class GetAllPropertyUsecase
    implements UsecaseWithoutParams<List<PropertyEntity>> {
  final IPropertyRepository _propertyRepository;

  GetAllPropertyUsecase({required IPropertyRepository propertyRepository})
    : _propertyRepository = propertyRepository;

  @override
  Future<Either<Failure, List<PropertyEntity>>> call() {
    return _propertyRepository.getAllProperty();
  }
}
