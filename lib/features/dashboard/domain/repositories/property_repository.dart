import 'package:dartz/dartz.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/features/dashboard/domain/entities/property_entity.dart';

abstract interface class IPropertyRepository {
  Future<Either<Failure, List<PropertyEntity>>> getAllProperty();
  Future<Either<Failure, PropertyEntity>> getPropertyById(String propertyId);
}
