import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_notifier.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_repository.dart';
import 'package:plan_c_frontend/main.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<String?> getCurrentSession() async => null;

  @override
  Future<String> signIn(String email, String password) async => 'fake-user-id';

  @override
  Future<String> signInWithGoogle() async => 'fake-user-id';

  @override
  Future<void> signUp({
    required String nomUsuari,
    required String email,
    required String contrasenya,
    required String nom,
    required String cognoms,
    dynamic fotoPerfil,
    String? biografia,
  }) async {}

  @override
  Future<String> signUpWithGoogle() async => 'fake-user-id';

  @override
  Future<bool> checkEmailAvailable(String email) async => true;

  @override
  Future<bool> checkUsernameAvailable(String username) async => true;

  @override
  Future<void> resetPassword(String email) async {}

  @override
  Future<void> resendVerificationEmail(String email) async {}

  @override
  Future<void> logOut() async {}

  @override
  Future<void> deleteAccount(String userId, String password) async {}
}

void main() {
  testWidgets("L'aplicació arrenca correctament", (WidgetTester tester) async {
    // L'app és dissenyada per portrait. La mida per defecte del test (800×600)
    // és landscape i causa overflow al panell d'auth. Simulem un iPhone 12 (390×844 @3x).
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(
            (ref) => AuthNotifier(FakeAuthRepository()),
          ),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
