import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:plan_c_frontend/features/perfil/domain/models/profile.dart';
import 'package:plan_c_frontend/features/perfil/domain/repositories/profile_repository.dart';
import 'package:dio/dio.dart';

class ProfileRepositoryImpl implements ProfileRepository{
  final Dio dio;

  ProfileRepositoryImpl(this.dio);
  @override
  Future<Profile> getProfile(String userId) async {
    try {
      final Response response = await dio.get('/usuari/$userId/perfil');
      if (response.statusCode == 200) {
        return Profile.fromJson(response.data);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }

  @override
  Future<void> updateProfile({required String userId, String? username, String? description, String? name, String? surname}) async {
    try {
      final body = <String, dynamic>{};
      if (username != null) body['username'] = username;
      if (description != null) body['biografia'] = description;
      if (name != null) body['name'] = name;
      if (surname != null) body['surname'] = surname;

      debugPrint('[updateProfile] userId: $userId');
      debugPrint('[updateProfile] body: $body');

      final response = await dio.patch('/usuari/perfil',
        data: body,
        options: Options(
          headers: {
            'usuari-id': userId,
          }
        )
      );

      debugPrint('[updateProfile] status: ${response.statusCode}');
      debugPrint('[updateProfile] response: ${response.data}');
    } on DioException catch(e) {
      debugPrint('[updateProfile] DioException: ${e.response?.statusCode} ${e.response?.data}');
      throw Exception('Error fetching profile: $e');
    }
  }

  @override
  Future<void> updateProfilePicture({required String userId, required File imageFile}) async {
    
    final fileName = imageFile.path.split('/').last;

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
      ),
    });

    await dio.patch('/usuari/perfil/foto',
    data: formData,
    options: Options(
      headers: {
        'usuari-id': userId,
      } 
    )
  );
  }
}