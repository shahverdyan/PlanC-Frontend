import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/group.dart';
import '../../data/providers.dart';

class CreateGroupNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> createGroup({
    required String title,
    required String description,
    required int minParticipants,
    required int maxParticipants,
    required DateTime dateTime,
    required String activityId,
    required String creatorId,
  }) async {
    state = const AsyncLoading();

    if (minParticipants >= maxParticipants) {
      final error = 'El nombre mínim de participants ha de ser menor al màxim.';
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception(error);
    }

    try {
      final repository = ref.read(groupRepositoryProvider);

      final newGroup = Group(
        id: '',
        title: title,
        description: description,
        minParticipants: minParticipants,
        maxParticipants: maxParticipants,
        currentParticipants: 1,
        participantIds: [creatorId],
        dateTime: dateTime,
        activityId: activityId,
        creatorId: creatorId,
        createdAt: DateTime.now(),
      );

      await repository.createGroup(newGroup);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
      rethrow;
    }
  }
}

final createGroupProvider = AsyncNotifierProvider<CreateGroupNotifier, void>(
  CreateGroupNotifier.new,
);