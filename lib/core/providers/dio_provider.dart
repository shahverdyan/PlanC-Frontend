import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/interceptors/auth_interceptor.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://planc-backend-aff2.onrender.com/',
      contentType: 'application/json',
    ),
  );

  dio.interceptors.add(AuthInterceptor(
    onSessionExpired: () async {
      await ref.read(authProvider.notifier).handleSessionExpired();
    },
  ));

  return dio;
});
