import 'dart:io';

abstract class AuthRepository {
  Future<String?> getCurrentSession();
  Future<String> signIn(String email, String password);
  Future<String> signInWithGoogle();
  Future<void> signUp({
    required String nomUsuari,
    required String email,
    required String contrasenya,
    required String nom,
    required String cognoms,
    File? fotoPerfil,
    String? biografia,
  });
  Future<String> signUpWithGoogle();
  Future<bool> checkEmailAvailable(String email);
  Future<bool> checkUsernameAvailable(String username);
  Future<void> resetPassword(String email);
  Future<void> resendVerificationEmail(String email);
  Future<void> logOut();
  Future<void> deleteAccount(String userId, String password);
}