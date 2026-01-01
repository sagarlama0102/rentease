import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/features/auth/domain/usecases/login_usecase.dart';
import 'package:rentease/features/auth/domain/usecases/register_usecase.dart';
import 'package:rentease/features/auth/presentation/state/auth_state.dart';

//provider
final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;

  @override
  AuthState build() {
    // TODO: implement build
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    return AuthState();
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    String? phoneNumber,
    required String username,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    //wait for 2 sec
    await Future.delayed(Duration(seconds: 2));
    final params = RegisterUsecaseParams(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      username: username,
      password: password,
    );
    final result = await _registerUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (isRegistered) {
        state = state.copyWith(status: AuthStatus.registered);
      },
    );
  }
   //login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = LoginUsecaseParams(email: email, password: password);
    await Future.delayed(Duration(seconds: 2));
    final result = await _loginUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (authEntity) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: authEntity,
        );
      },
    );
  }
}
