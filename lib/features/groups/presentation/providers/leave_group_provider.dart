import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/groups/data/providers.dart';
import 'package:plan_c_frontend/features/chat/presentation/providers/chat_list_provider.dart';

final leaveGroupProvider = AsyncNotifierProvider<LeaveGroupNotifier, void>(LeaveGroupNotifier.new);

class LeaveGroupNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async => const AsyncValue.data(null);

  Future<void> leaveGroup({
    required String groupId,
    required String userId,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(groupRepositoryProvider);
      // Aquí se gestionaría la liberación de plaza y el aviso al chat (Criterios #3 y #4)
      await repository.leaveGroup(groupId: groupId, userId: userId);
      
      // ✅ SOLUCIÓN: Invalidar el cache de chats después de abandonar grupo
      // Esto fuerza que chatListProvider recargue la lista desde el backend
      ref.invalidate(chatListProvider);
    });
  }
}