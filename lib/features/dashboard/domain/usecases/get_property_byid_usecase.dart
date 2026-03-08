import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/core/usecases/app_usecase.dart';
import 'package:rentease/features/dashboard/data/repositories/property_repository.dart';
import 'package:rentease/features/dashboard/domain/entities/property_entity.dart';
import 'package:rentease/features/dashboard/domain/repositories/property_repository.dart';

class GetPropertyByIdParams extends Equatable {
  final String propertyId;

  const GetPropertyByIdParams({required this.propertyId});

  @override
  List<Object?> get props => [propertyId];
}

final getPropertyByidUsecaseProvider = Provider<GetPropertyByidUsecase>((ref) {
  final propertyRepository = ref.read(propertyRepositoryProvider);
  return GetPropertyByidUsecase(propertyRepository: propertyRepository);
});

class GetPropertyByidUsecase
    implements UsecaseWithParams<PropertyEntity, GetPropertyByIdParams> {
  final IPropertyRepository _propertyRepository;

  GetPropertyByidUsecase({required IPropertyRepository propertyRepository})
    : _propertyRepository = propertyRepository;

  @override
  Future<Either<Failure, PropertyEntity>> call(GetPropertyByIdParams params) {
    return _propertyRepository.getPropertyById(params.propertyId);
  }
}
