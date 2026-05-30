import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_state.dart' as auth_domain;
import 'package:plan_c_frontend/features/auth/presentation/auth_main_screen.dart';
import 'package:plan_c_frontend/features/navigation/presentation/home_screen.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class MainAuthWrapper extends ConsumerWidget {
  const MainAuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    debugPrint('🚦 Estado de Autenticación actual: ${authState.status}');

    // 1. Si está comprobando la sesión, mostramos un loader de espera.
    if (authState.status == auth_domain.AuthStatus.initial) {
      debugPrint('⏳ Comprobando sesión existente...');
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.authWrapperCheckingSession,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 2. Si tiene sesión activa, va al Home
    if (authState.status == auth_domain.AuthStatus.authenticated) {
      debugPrint('✅ Usuario autenticado: ${authState.userId}');
      return const HomeScreen();
    }

    // 3. Si NO tiene sesión (unauthenticated, error, etc), va al Login
    debugPrint('🔐 Usuario no autenticado - Mostrando pantalla de login');
    return const AuthMainScreen();
  }
}