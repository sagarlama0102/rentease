import 'package:rentease/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String username;
  final String? password;
  final String? confirmPassword;
  final String? profilePicture;

  const AuthApiModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    this.phoneNumber,
    this.password,
    this.profilePicture,
    this.confirmPassword,
  });

  //toJson
  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phoneNumber": phoneNumber,
      "username": username,
      "password": password,
      "confirmPassword": confirmPassword,
      "profilePicture": profilePicture,
    };
  }

  //fromJson
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      phoneNumber: json['phoneNumber'] as String,
      profilePicture: json['profilePicture'] as String?,
      password: json['password'] as String?,
    );
  }

  //toEntity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      password: password,
      profilePicture: profilePicture,
    );
  }

  //FromEntity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      username: entity.username,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      profilePicture: entity.profilePicture,
    );
  }
  //toEntityList
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
