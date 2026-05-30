import 'package:flutter/foundation.dart'; // Añadido para usar debugPrint
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/chat/presentation/providers/chat_repository_provider.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';

final chatInitializationProvider = FutureProvider<void>((ref) async {
  // ✅ Esperamos (await) a que se lea la bóveda asíncrona
  final accessToken = await ref.watch(accessTokenProvider.future);
  final userId = ref.watch(currentUserIdProvider);
  
  if (accessToken == null || accessToken.isEmpty) {
    debugPrint('❌ No hay sesión activa en SecureStorage. Usuario no autenticado.');
    throw Exception('Usuario no autenticado. Por favor inicia sesión.');
  }
  
  if (userId == null || userId.isEmpty) {
    debugPrint('❌ No se pudo obtener el ID del usuario.');
    throw Exception('No se pudo obtener el ID del usuario.');
  }
  
  final repository = ref.watch(chatRepositoryProvider);
  
  try {
    await repository.connect(
      userId: userId,
      token: accessToken,
    );
    debugPrint('🚀 Chat System Inicializado correctamente');
  } catch (e) {
    debugPrint('❌ Error inicializando Chat System: $e');
    rethrow;
  }
});