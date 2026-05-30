import 'dart:io';
import 'package:plan_c_frontend/features/perfil/domain/models/profile.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile(String userId);
  Future<void> updateProfile({required String userId, String? username, String? description, String? name, String? surname});
  Future<void> updateProfilePicture({required String userId, required File imageFile});
}