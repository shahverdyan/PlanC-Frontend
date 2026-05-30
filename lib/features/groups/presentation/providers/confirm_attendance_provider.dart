import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/groups/data/providers.dart';

final confirmAttendanceProvider =
    AsyncNotifierProvider<ConfirmAttendanceNotifier, void>(
  ConfirmAttendanceNotifier.new,
);

class ConfirmAttendanceNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> confirmAttendance({
    required String groupId,
    required String userId,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(groupRepositoryProvider);
      await repository.confirmAttendance(
        groupId: groupId,
        userId: userId,
      );
    });
  }
}