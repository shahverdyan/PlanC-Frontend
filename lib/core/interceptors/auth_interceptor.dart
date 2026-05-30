import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Interceptor de Dio que:
/// 1. Injecta el token Bearer a cada petició.
/// 2. En rebre un 401, intenta renovar el token via Supabase.
/// 3. Si la renovació funciona, reintenta la petició original.
/// 4. Si la renovació falla, crida [onSessionExpired] per tancar sessió.
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final Future<void> Function() _onSessionExpired;

  bool _isRefreshing = false;
  Completer<bool>? _refreshCompleter;

  AuthInterceptor({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
    required Future<void> Function() onSessionExpired,
  })  : _storage = storage,
        _onSessionExpired = onSessionExpired;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: 'auth_token');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Si ja s'està renovant, esperar el resultat i reintentar
    if (_isRefreshing) {
      final success = await _refreshCompleter!.future;
      if (success) {
        final newToken = await _storage.read(key: 'auth_token');
        try {
          final response = await _retry(err.requestOptions, newToken);
          return handler.resolve(response);
        } catch (_) {}
      }
      return handler.next(err);
    }

    // Iniciar renovació
    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    final refreshed = await _tryRefresh();
    _refreshCompleter!.complete(refreshed);
    _isRefreshing = false;
    _refreshCompleter = null;

    if (refreshed) {
      final newToken = await _storage.read(key: 'auth_token');
      try {
        final response = await _retry(err.requestOptions, newToken);
        return handler.resolve(response);
      } catch (_) {}
    }

    await _onSessionExpired();
    handler.next(err);
  }

  Future<bool> _tryRefresh() async {
    final supabase = Supabase.instance.client;

    // 1. Renovació estàndard de Supabase (Google + email/password)
    try {
      final result = await supabase.auth.refreshSession();
      if (result.session != null) {
        await _storage.write(
          key: 'auth_token',
          value: result.session!.accessToken,
        );
        debugPrint('✅ [AuthInterceptor] Token renovat via refreshSession');
        return true;
      }
    } catch (_) {}

    // 2. Fallback: setSession amb refresh_token guardat (email/password)
    try {
      final refreshToken = await _storage.read(key: 'auth_refresh_token');
      if (refreshToken != null && refreshToken.isNotEmpty) {
        final result = await supabase.auth.setSession(refreshToken);
        if (result.session != null) {
          await _storage.write(
            key: 'auth_token',
            value: result.session!.accessToken,
          );
          debugPrint('✅ [AuthInterceptor] Token renovat via setSession');
          return true;
        }
      }
    } catch (_) {}

    debugPrint('❌ [AuthInterceptor] No s\'ha pogut renovar el token');
    return false;
  }

  Future<Response<dynamic>> _retry(RequestOptions options, String? newToken) {
    // Dio sense interceptors per evitar bucle infinit
    final dio = Dio(BaseOptions(baseUrl: options.baseUrl));
    return dio.request<dynamic>(
      options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      options: Options(
        method: options.method,
        headers: {
          ...options.headers,
          if (newToken != null) 'Authorization': 'Bearer $newToken',
        },
        contentType: options.contentType,
        responseType: options.responseType,
      ),
    );
  }
}
