import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/config/api_config.dart';
import 'package:plan_c_frontend/core/interceptors/auth_interceptor.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/chat/data/repositories/chat_repository.dart';

final chatRepositoryProvider = Provider((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: ApiConfig.httpTimeout,
    receiveTimeout: ApiConfig.httpTimeout,
    headers: {'Content-Type': 'application/json'},
  ));

  dio.interceptors.add(AuthInterceptor(
    onSessionExpired: () async {
      await ref.read(authProvider.notifier).handleSessionExpired();
    },
  ));

  return ChatRepository(dio: dio);
});
