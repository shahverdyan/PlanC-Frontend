import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/providers/storage_provider.dart';
import 'package:plan_c_frontend/features/perfil/data/profile_repository_impl.dart';
import 'package:plan_c_frontend/features/perfil/domain/models/profile.dart';
import 'package:plan_c_frontend/features/perfil/domain/repositories/profile_repository.dart';
import 'package:plan_c_frontend/core/providers/dio_provider.dart';


final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.watch(dioProvider));
});

final profileDataProvider = FutureProvider((ref) async {
  final repo = ref.watch(profileRepositoryProvider);
  final storage = ref.watch(storageProvider);
  final userId = await storage.read(key: 'auth_user_id') ?? '';
  return repo.getProfile(userId);
});

final profileByIdProvider = FutureProvider.family<Profile, String>((ref, userId) async {
  final repo = ref.watch(profileRepositoryProvider);
  return repo.getProfile(userId);
});