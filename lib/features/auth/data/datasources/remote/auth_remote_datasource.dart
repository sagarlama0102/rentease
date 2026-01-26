import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/api/api_client.dart';
import 'package:rentease/core/api/api_endpoints.dart';
import 'package:rentease/core/services/storage/token_service.dart';
import 'package:rentease/core/services/storage/user_session_service.dart';
import 'package:rentease/features/auth/data/datasources/auth_datasource.dart';
import 'package:rentease/features/auth/data/models/auth_api_model.dart';

final authRemoteDatasourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService,
       _tokenService = tokenService;

  @override
  Future<AuthApiModel?> getUserById(String authId) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<AuthApiModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final user = AuthApiModel.fromJson(data);

      //save to session
      await _userSessionService.saveUserSession(
        userId: user.id!,
        email: user.email,
        username: user.username,
        firstName: user.firstName,
        lastName: user.lastName,
        phoneNumber: user.phoneNumber,
      );
      //save token to tokenService
      final token = response.data['token'];
      //later store token in secure storage
      await _tokenService.saveToken(token);
      return user;
    }
    return null;
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: user.toJson(),
    );
    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final registeredUser = AuthApiModel.fromJson(data);
      return registeredUser;
    }
    return user;
  }

  @override
  Future<String> uploadPhoto(File photo) async {
    final fileName = photo.path.split('/').last;
    final formData = FormData.fromMap({
      // 'profilePhoto': await MultipartFile.fromFile(
      'image': await MultipartFile.fromFile(
        photo.path,
        filename: fileName,
      ),
    });
    //get token from token service
    final token =  _tokenService.getToken();
    final response = await _apiClient.uploadFile(
      ApiEndpoints.userUploadPhoto,
      formData: formData,
      // options: Options(headers: {'Authorization': 'Bearer $token'}),
      options: Options(
        method: 'PUT',
        headers: {'Authorization': 'Bearer $token'},
      ),

    );
    return response.data['data']['profilePicture'];
    // Extract the profile picture URL from the response data
    // final data = response.data['data'] as Map<String, dynamic>;
    // return data['profilePicture'] as String;
  }
}
