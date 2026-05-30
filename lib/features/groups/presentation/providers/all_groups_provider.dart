import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/groups/data/providers.dart';
import 'package:plan_c_frontend/features/groups/domain/models/group.dart';

/// Fetches all open quedades from GET /quedada.
/// Used by the feed section and the search discovery screen.
final allGroupsProvider = FutureProvider.autoDispose<List<Group>>((ref) {
  return ref.watch(groupRepositoryProvider).getAllGroups();
});
