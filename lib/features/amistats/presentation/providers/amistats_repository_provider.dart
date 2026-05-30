import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/interceptors/auth_interceptor.dart';
import 'package:plan_c_frontend/features/amistats/data/repositories/amistats_repository_impl.dart';
import 'package:plan_c_frontend/features/amistats/domain/repositories/amistats_repository.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';

final amistatsDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://planc-backend-aff2.onrender.com/',
    contentType: 'application/json',
  ));

  dio.interceptors.add(AuthInterceptor(
    onSessionExpired: () async {
      await ref.read(authProvider.notifier).handleSessionExpired();
    },
  ));

  return dio;
});

final amistatsRepositoryProvider = Provider<AmistatsRepository>((ref) {
  return AmistatsRepositoryImpl(ref.watch(amistatsDioProvider));
});
