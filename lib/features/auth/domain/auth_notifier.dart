import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plan_c_frontend/features/auth/data/auth_repository_impl.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_repository.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState()) {
    // Cargar sesión existente al inicializar
    _checkCurrentSession();
  }

  /// Checquear si hay una sesión activa de Supabase
  /// Se ejecuta automáticamente al inicializar
  Future<void> _checkCurrentSession() async {
    try {
      debugPrint('🔐 Buscando sesión existente de Supabase...');
      
      final userId = await _repository.getCurrentSession();
      
      if (userId != null && userId.isNotEmpty) {
        debugPrint('✅ Sesión encontrada para usuario: $userId');
        state = state.copyWith(
          status: AuthStatus.authenticated,
          userId: userId,
          errorMessage: null,
        );
      } else {
        debugPrint('❌ No hay sesión activa');
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          userId: null,
          errorMessage: null,
        );
      }
    } catch (e) {
      debugPrint('⚠️ Error al checquear sesión: $e');
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        userId: null,
        errorMessage: null,
      );
    }
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final userId = await _repository.signIn(email, password);

      state = state.copyWith(
        status: AuthStatus.authenticated,
        userId: userId,
        errorMessage: null,
      );
      debugPrint('Sessió iniciada correctament');
    } catch (e) {
      if (e is EmailNotConfirmedException) {
        state = state.copyWith(
          status: AuthStatus.awaitingEmailVerification,
          email: e.email,
          errorMessage: null,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: e.toString(),
        );
      }
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final userId = await _repository.signInWithGoogle();
      state = state.copyWith(
        status: AuthStatus.authenticated,
        userId: userId,
        errorMessage: null,
      );
    } catch (e) {
      debugPrint('Error al sign in amb Google: $e');
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> signUp({
    required String nomUsuari,
    required String email,
    required String contrasenya,
    required String nom,
    required String cognoms,
    File? fotoPerfil,
    String? biografia,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      await _repository.signUp(
        nomUsuari: nomUsuari,
        email: email,
        contrasenya: contrasenya,
        nom: nom,
        cognoms: cognoms,
        fotoPerfil: fotoPerfil,
        biografia: biografia,
      );
      state = state.copyWith(
        status: AuthStatus.awaitingEmailVerification,
        email: email,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> resendVerificationEmail(String email) async {
    try {
      await _repository.resendVerificationEmail(email);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> signUpWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final userId = await _repository.signUpWithGoogle();
      state = state.copyWith(
        status: AuthStatus.authenticated,
        userId: userId,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> resetPassword(String email) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      await _repository.resetPassword(email);
      state = state.copyWith(status: AuthStatus.successful);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> logOut() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _repository.logOut();
    } catch (e) {
      debugPrint('⚠️ Error en tancar sessió al backend (continuem amb logout local): $e');
    }
    try {
      await FirebaseMessaging.instance.deleteToken();
      debugPrint('✅ Token FCM eliminat de Firebase');
    } catch (e) {
      debugPrint('⚠️ No s\'ha pogut eliminar el token FCM: $e');
    }
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'auth_token');
    await storage.delete(key: 'auth_user_id');
    await storage.delete(key: 'auth_refresh_token');
    // AuthState() fresc: userId = null, cosa que força la re-creació de tots
    // els providers que observen currentUserIdProvider (chatListProvider, etc.)
    state = AuthState(status: AuthStatus.unauthenticated);
  }
  
  Future<void> deleteAccount(String password) async {
    try {
      final userId = state.userId;
      if (userId == null) throw Exception('No s\'ha trobat l\'usuari');
      await _repository.deleteAccount(userId, password);
      state = AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      rethrow;
    }
  }

  /// Gestiona l'expiració del token mid-sessió (p.ex. 401 del backend).
  /// Neteja les credencials i marca l'usuari com a no autenticat.
  Future<void> handleSessionExpired() async {
    debugPrint('🔒 Token caducat mid-sessió. Tancant sessió...');
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'auth_token');
    await storage.delete(key: 'auth_user_id');
    await storage.delete(key: 'auth_refresh_token');
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}
