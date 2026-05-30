import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/groups/data/providers.dart';

final deleteGroupProvider = AsyncNotifierProvider<DeleteGroupNotifier, void>(DeleteGroupNotifier.new);

class DeleteGroupNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async => const AsyncValue.data(null);

  // ARA DEMANEM TAMBÉ EL userId
  Future<void> deleteGroup({required String groupId, required String userId}) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(groupRepositoryProvider);
      
      // PASSEM ELS DOS PARÀMETRES AL REPOSITORI
      await repository.deleteGroup(groupId: groupId, userId: userId);
      
      state = const AsyncValue.data(null);
    } catch (e, st) {
      // AIXÍ EL FRONTEND MOSTRARÀ EL MISSATGE HUMÀ (ex: "No tens permís")
      state = AsyncValue.error(e.toString(), st);
    }
  }
}