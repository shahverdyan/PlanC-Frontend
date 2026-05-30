import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/groups/domain/models/group.dart';
import 'package:plan_c_frontend/features/groups/data/providers.dart';
import 'package:plan_c_frontend/features/chat/presentation/providers/chat_list_provider.dart';

final joinGroupProvider = AsyncNotifierProvider<JoinGroupNotifier, void>(JoinGroupNotifier.new);

class JoinGroupNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async => const AsyncValue.data(null);

  Future<void> joinGroup({
    required Group group,
    required int currentParticipants,
    required String userId,
  }) async {
    state = const AsyncValue.loading();

    if (currentParticipants >= group.maxParticipants) {
      state = AsyncValue.error('El grup està ple', StackTrace.current);
      return;
    }

    state = await AsyncValue.guard(() async {
      await ref.read(groupRepositoryProvider).joinGroup(
        groupId: group.id,
        userId: userId,
      );
      
      // ✅ SOLUCIÓN: Invalidar el cache de chats después de unirse
      // Esto fuerza que chatListProvider recargue la lista desde el backend
      ref.invalidate(chatListProvider);
    });
  }
}