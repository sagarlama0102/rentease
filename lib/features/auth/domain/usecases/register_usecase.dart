import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/error/failures.dart';
import 'package:rentease/core/usecases/app_usecase.dart';
import 'package:rentease/features/auth/data/repositories/auth_repository.dart';
import 'package:rentease/features/auth/domain/entities/auth_entity.dart';
import 'package:rentease/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecaseParams extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String username;
  final String password;
  final String confirmPassword;

  const RegisterUsecaseParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    required this.username,
    required this.password,
    required this.confirmPassword,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    username,
    password,
    confirmPassword,
    phoneNumber,
  ];
}

//provider
final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase
    implements UsecaseWithParams<bool, RegisterUsecaseParams> {
  final IAuthRepository _authRepository;
  RegisterUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final entity = AuthEntity(
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      username: params.username,
      password: params.password,
      confirmPassword: params.confirmPassword,
    );
    return _authRepository.register(entity);
  }
}
