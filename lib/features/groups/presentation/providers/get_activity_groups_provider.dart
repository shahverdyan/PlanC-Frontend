import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/group.dart';
import '../../data/providers.dart';

final activityGroupsProvider =
FutureProvider.family<List<Group>, String>((ref, activityId) async {
  final repository = ref.read(groupRepositoryProvider);
  return repository.getGroupsByActivity(activityId);
});