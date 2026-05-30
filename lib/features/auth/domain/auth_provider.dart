import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plan_c_frontend/features/auth/data/auth_repository_impl.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_notifier.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_repository.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_state.dart' as auth_domain;

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authProvider = StateNotifierProvider<AuthNotifier, auth_domain.AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).userId;
});

final accessTokenProvider = FutureProvider<String?>((ref) async {
  const storage = FlutterSecureStorage();
  return await storage.read(key: 'auth_token');
});