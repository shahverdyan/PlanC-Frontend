import 'dart:io';

import 'package:plan_c_frontend/features/groups/domain/models/group.dart';

abstract class GroupRepository {
  Future<void> createGroup(Group group);
  Future<void> updateGroup(String groupId, Group group);

  Future<void> joinGroup({
    required String groupId,
    required String userId,
  });

  Future<void> confirmAttendance({
    required String groupId,
    required String userId,
  });

  Future<void> unconfirmAttendance({
    required String groupId,
    required String userId,
  });

  Future<void> leaveGroup({
    required String groupId,
    required String userId,
  });

  Future<void> deleteGroup({
    required String groupId,
    required String userId,
  });

  Future<List<Group>> getGroupsByActivity(String activityId);
  Future<Group> getGroupById(String groupId);
  Future<List<Group>> getAllGroups();

  Future<String> uploadGroupPhoto({
    required String quedadaId,
    required File imageFile,
  });
}