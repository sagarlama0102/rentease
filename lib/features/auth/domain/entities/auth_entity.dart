import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String username;
  final String? password;

  const AuthEntity({
    this.authId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    required this.username,
    this.password,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    authId,
    firstName,
    lastName,
    email,
    phoneNumber,
    username,
    password,

  ];
}
