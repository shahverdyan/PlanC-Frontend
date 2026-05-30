import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

import '../domain/auth_repository.dart';

class EmailNotConfirmedException implements Exception {
  final String email;
  EmailNotConfirmedException(this.email);
}

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://planc-backend-aff2.onrender.com',
      contentType: 'application/json',
    ),
  );

  final supabase = Supabase.instance.client;
  final storage = const FlutterSecureStorage();

  String _extractUserId(dynamic data) {
    final candidates = [
      data?['id'],
      data?['userId'],
      data?['usuariId'],
      data?['user']?['id'],
      data?['usuari']?['id'],
      data?['usuario']?['id'],
      data?['data']?['id'],
      data?['data']?['userId'],
      data?['data']?['usuariId'],
    ];

    for (final candidate in candidates) {
      if (candidate != null && candidate.toString().isNotEmpty) {
        return candidate.toString();
      }
    }

    throw Exception('No s’ha pogut obtenir el userId de la resposta');
  }

  String _extractErrorMessage(DioException e, String fallback) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'];

      if (message is String && message.isNotEmpty) {
        return message;
      }

      if (message is List && message.isNotEmpty) {
        return message.join(', ');
      }
    }

    return fallback;
  }

  @override
  Future<String?> getCurrentSession() async {
    try {
      // 1. Comprovar sessió activa de Supabase (usuaris de Google)
      final currentUser = supabase.auth.currentUser;
      if (currentUser != null) {
        if (currentUser.emailConfirmedAt == null) {
          debugPrint('⚠️ Sessió de Supabase trobada però correu no verificat: ${currentUser.id}');
          return null;
        }
        debugPrint('✅ Sessió de Supabase trobada: ${currentUser.id}');
        return currentUser.id;
      }

      // 2. Intentar refrescar la sessió de Supabase
      try {
        final refreshed = await supabase.auth.refreshSession();
        if (refreshed.session != null) {
          debugPrint('✅ Sessió de Supabase refrescada: ${refreshed.session!.user.id}');
          return refreshed.session!.user.id;
        }
      } catch (_) {
        // No hi ha sessió de Supabase per refrescar
      }

      // 2.5. Reconstruir sessió de Supabase amb refresh_token (usuaris email/password)
      final storedRefreshToken = await storage.read(key: 'auth_refresh_token');
      if (storedRefreshToken != null && storedRefreshToken.isNotEmpty) {
        try {
          final restored = await supabase.auth.setSession(storedRefreshToken);
          if (restored.session != null) {
            await storage.write(key: 'auth_token', value: restored.session!.accessToken);
            debugPrint('✅ Sessió reconstruïda amb refresh_token: ${restored.session!.user.id}');
            return restored.session!.user.id;
          }
        } catch (_) {
          // refresh_token invàlid o caducat, continuar a fase 3
        }
      }

      // 3. Usuaris email/password: validar el token emmagatzemat contra el backend
      final storedUserId = await storage.read(key: 'auth_user_id');
      final storedToken = await storage.read(key: 'auth_token');

      if (storedUserId != null && storedUserId.isNotEmpty &&
          storedToken != null && storedToken.isNotEmpty) {
        debugPrint('🔍 Validant token emmagatzemat per a userId=$storedUserId...');
        try {
          final response = await dio.get(
            '/auth/me',
            options: Options(headers: {'Authorization': 'Bearer $storedToken'}),
          );
          if (response.statusCode == 200) {
            debugPrint('✅ Token vàlid. Sessió restaurada per a userId=$storedUserId');
            return storedUserId;
          }
        } on DioException catch (e) {
          if (e.response?.statusCode == 401) {
            debugPrint('❌ Token caducat (401). Netejant credencials emmagatzemades...');
            await storage.delete(key: 'auth_token');
            await storage.delete(key: 'auth_user_id');
            return null;
          } else {
            // Error de xarxa (sense connexió, timeout, etc.): mantenim les
            // credencials i assumim que el token és vàlid. L'interceptor
            // renovarà el token si cal quan es recuperi la connexió.
            debugPrint('⚠️ Error de xarxa en validar token. Mantenint credencials.');
            return storedUserId;
          }
        }
      }

      debugPrint('❌ No hi ha sessió activa');
      return null;
    } catch (e) {
      debugPrint('⚠️ Error en verificar sessió: $e');
      return null;
    }
  }

  @override
  Future<String> signIn(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'identificador': email, 'contrasenya': password},
      );

      final token = response.data['token'];

      if (token == null || token.toString().isEmpty) {
        throw Exception('No s’ha rebut cap token al login');
      }

      await storage.write(key: 'auth_token', value: token.toString());

      final refreshToken = response.data['refresh_token'];
      if (refreshToken != null && refreshToken.toString().isNotEmpty) {
        await storage.write(key: 'auth_refresh_token', value: refreshToken.toString());
      }

      final meResponse = await dio.get(
        '/auth/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final userId = _extractUserId(meResponse.data);
      await storage.write(key: 'auth_user_id', value: userId);
      await storage.write(key: 'auth_email', value: email);

      debugPrint('Login correcte. userId=$userId');
      return userId;
    } on DioException catch (e) {
      final data = e.response?.data;
      final code = data is Map ? data['code']?.toString() : null;
      final msg = _extractErrorMessage(e, '');
      if (code == 'email_not_confirmed' || msg.contains('email_not_confirmed')) {
        throw EmailNotConfirmedException(email);
      }
      throw Exception(_extractErrorMessage(e, 'Error en iniciar sessió'));
    }
  }

  @override
  Future<String> signInWithGoogle() async {
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://callback',
        queryParams: {'prompt': 'select_account'},
        authScreenLaunchMode: LaunchMode.externalApplication,
      );

      final user = supabase.auth.currentUser;

      if (user == null) {
        throw Exception('No s’ha pogut obtenir l’usuari de Google');
      }

      final userId = user.id;
      final accessToken = supabase.auth.currentSession?.accessToken;

      if (accessToken != null && accessToken.isNotEmpty) {
        await storage.write(key: 'auth_token', value: accessToken);
      }

      await storage.write(key: 'auth_user_id', value: userId);

      return userId;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Error en iniciar sessió amb Google: $e');
    }
  }

  @override
  Future<void> signUp({
    required String nomUsuari,
    required String email,
    required String contrasenya,
    required String nom,
    required String cognoms,
    File? fotoPerfil,
    String? biografia,
  }) async {
    try {
      // Registre sempre en JSON — el backend no accepta multipart a /register
      await dio.post('/auth/register', data: <String, dynamic>{
        'nomUsuari': nomUsuari,
        'email': email,
        'contrasenya': contrasenya,
        'nom': nom,
        'cognoms': cognoms,
        'biografia': biografia,
      });

      debugPrint('Registre correcte. Pendent de verificació de correu electrònic.');
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, 'Error en registre'));
    }
  }

  @override
  Future<String> signUpWithGoogle() async {
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://callback',
        queryParams: {'prompt': 'select_account'},
        authScreenLaunchMode: LaunchMode.externalApplication,
      );

      final user = supabase.auth.currentUser;

      if (user == null) {
        throw Exception('No s’ha pogut obtenir l’usuari de Google');
      }

      final userId = user.id;
      final accessToken = supabase.auth.currentSession?.accessToken;

      if (accessToken != null && accessToken.isNotEmpty) {
        await storage.write(key: 'auth_token', value: accessToken);
      }

      await storage.write(key: 'auth_user_id', value: userId);

      return userId;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Error en registrar-se amb Google: $e');
    }
  }

  @override
  Future<bool> checkEmailAvailable(String email) async {
    try {
      final response = await dio.get(
        '/auth/check-email',
        queryParameters: {'email': email},
      );
      return response.data['available'] == true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) return false;
      rethrow;
    }
  }

  @override
  Future<bool> checkUsernameAvailable(String username) async {
    try {
      final response = await dio.get(
        '/auth/check-username',
        queryParameters: {'username': username},
      );
      return response.data['available'] == true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) return false;
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await dio.post('/auth/forgot-password', data: {'email': email});
    } on DioException catch (e) {
      throw Exception(
        _extractErrorMessage(e, 'Error en recuperar la contrasenya'),
      );
    }
  }

  @override
  Future<void> resendVerificationEmail(String email) async {
    try {
      await supabase.auth.resend(type: OtpType.email, email: email);
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await dio.post('auth/logout');
    } catch (_) {
      // Continuem amb el logout local encara que el backend falli
    }
    try {
      await supabase.auth.signOut();
    } catch (_) {
      // Ignorar errors de Supabase signOut
    }
  }

  @override
  Future<void> deleteAccount(String userId, String password) async {
    final currentUser = supabase.auth.currentUser;
    final provider = currentUser?.appMetadata['provider'] as String? ?? 'email';
    final isGoogleUser = provider == 'google';

    // Re-authenticate email/password users before deletion
    if (!isGoogleUser && password.isNotEmpty) {
      String email = await storage.read(key: 'auth_email') ?? '';
      debugPrint('deleteAccount: auth_email from storage = "$email"');

      // Fallback: email not cached (session predates the fix) — fetch from /auth/me
      if (email.isEmpty) {
        final token = await storage.read(key: 'auth_token') ?? '';
        debugPrint('deleteAccount: no cached email, fetching from /auth/me with token=${token.isNotEmpty}');
        if (token.isNotEmpty) {
          try {
            final meResponse = await dio.get(
              '/auth/me',
              options: Options(headers: {'Authorization': 'Bearer $token'}),
            );
            debugPrint('deleteAccount: /auth/me response = ${meResponse.data}');
            final data = meResponse.data;
            email = (data is Map)
                ? (data['email']?.toString() ?? data['correu']?.toString() ?? '')
                : '';
            if (email.isNotEmpty) {
              await storage.write(key: 'auth_email', value: email);
            }
          } catch (e) {
            debugPrint('deleteAccount: /auth/me failed: $e');
          }
        }
      }

      if (email.isEmpty) {
        throw Exception('No s\'ha pogut verificar la identitat. Tanca la sessió, torna a entrar i reintenta.');
      }

      debugPrint('deleteAccount: re-authenticating with identificador="$email"');
      try {
        final loginResponse = await dio.post(
          '/auth/login',
          data: {'identificador': email, 'contrasenya': password},
        );
        debugPrint('deleteAccount: re-auth OK, status=${loginResponse.statusCode}');
      } on DioException catch (e) {
        debugPrint('deleteAccount: re-auth FAILED: ${e.response?.statusCode} ${e.response?.data}');
        throw Exception('Contrasenya incorrecta');
      }
    }

    final token = await storage.read(key: 'auth_token') ?? '';
    debugPrint('deleteAccount: calling DELETE /usuari/perfil with usuari-id=$userId, hasToken=${token.isNotEmpty}');
    try {
      final deleteResponse = await dio.delete(
        '/usuari/perfil',
        options: Options(headers: {
          'usuari-id': userId,
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        }),
      );
      debugPrint('deleteAccount: DELETE OK, status=${deleteResponse.statusCode}, body=${deleteResponse.data}');
    } on DioException catch (e) {
      debugPrint('deleteAccount: DELETE FAILED: ${e.response?.statusCode} ${e.response?.data}');
      if (e.response?.statusCode == 404) {
        throw Exception('No s\'ha trobat l\'usuari especificat.');
      }
      final body = e.response?.data;
      final message = body is Map
          ? (body['message']?.toString() ?? 'Error eliminant el compte')
          : 'Error eliminant el compte';
      throw Exception(message);
    }

    debugPrint('deleteAccount: signing out from Supabase');
    try {
      await supabase.auth.signOut();
    } catch (e) {
      debugPrint('deleteAccount: signOut error (ignored): $e');
    }
    debugPrint('deleteAccount: clearing storage');
    await storage.deleteAll();
    debugPrint('deleteAccount: done, userId=$userId');
  }
}
