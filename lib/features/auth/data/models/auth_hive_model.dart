import 'package:hive/hive.dart';
import 'package:rentease/core/constants/hive_table_constants.dart';
import 'package:rentease/features/auth/domain/entities/auth_entity.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstants.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? authId;
  @HiveField(1)
  final String firstName;
  @HiveField(2)
  final String lastName;
  @HiveField(3)
  final String email;
  @HiveField(4)
  final String? phoneNumber;
  @HiveField(5)
  final String username;
  @HiveField(6)
  final String? password;

  AuthHiveModel({
    String? authId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    required this.username,
    this.password,
  }) : authId = authId ?? Uuid().v4();

  //From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      authId: entity.authId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      username: entity.username,
      password: entity.password,
    );
  }

  //to entity
  AuthEntity toEntity() {
    return AuthEntity(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      username: username,
      password: password,
    );
  }

  //to entity list
  static List<AuthEntity> toEntityList(List<AuthHiveModel> models){
    return models.map((model)=> model.toEntity()).toList();
  }

}
