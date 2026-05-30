import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/groups/data/providers.dart';
import 'package:plan_c_frontend/features/groups/domain/models/group.dart';

final editGroupProvider =
AsyncNotifierProvider<EditGroupNotifier, void>(EditGroupNotifier.new);

class EditGroupNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> updateGroup({
    required String groupId,
    required String title,
    required String description,
    required int minParticipants,
    required int maxParticipants,
    required int currentParticipants,
    required List<String> participantIds,
    required DateTime dateTime,
    required String activityId,
    required String creatorId,
    required DateTime createdAt,
  }) async {
    state = const AsyncValue.loading();

    if (minParticipants >= maxParticipants) {
      final error = 'El nombre mínim de participants ha de ser menor al màxim.';
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception(error);
    }

    try {
      final groupRepository = ref.read(groupRepositoryProvider);

      final updatedGroup = Group(
        id: groupId,
        title: title,
        description: description,
        minParticipants: minParticipants,
        maxParticipants: maxParticipants,
        currentParticipants: currentParticipants,
        participantIds: participantIds,
        dateTime: dateTime,
        activityId: activityId,
        creatorId: creatorId,
        createdAt: createdAt,
      );

      await groupRepository.updateGroup(groupId, updatedGroup);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
      rethrow;
    }
  }
}