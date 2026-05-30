import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/groups/data/providers.dart';

final unconfirmAttendanceProvider =
    AsyncNotifierProvider<UnconfirmAttendanceNotifier, void>(
  UnconfirmAttendanceNotifier.new,
);

class UnconfirmAttendanceNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> unconfirmAttendance({
    required String groupId,
    required String userId,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(groupRepositoryProvider);
      await repository.unconfirmAttendance(
        groupId: groupId,
        userId: userId,
      );
    });
  }
}