import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/amistats/presentation/providers/amistats_repository_provider.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/perfil/domain/models/relationship_status.dart';

final relationshipStatusProvider =
    FutureProvider.family<RelationshipStatus, String>((ref, profileUserId) async {
  final currentUserId = ref.watch(currentUserIdProvider) ?? '';
  if (currentUserId.isEmpty) return RelationshipStatus.stranger;

  final repository = ref.watch(amistatsRepositoryProvider);

  final results = await Future.wait([
    repository.obtenirAmistats(usuariId: currentUserId),
    repository.obtenirAmistatsPendents(usuariId: currentUserId),
    repository.obtenirSolicitudsEnviades(usuariId: currentUserId),
  ]);

  final friends = results[0];
  final received = results[1];
  final sent = results[2];

  if (friends.any((f) => f.usuariId == profileUserId)) {
    return RelationshipStatus.friends;
  }
  if (received.any((r) => r.usuariId == profileUserId)) {
    return RelationshipStatus.requestReceived;
  }
  if (sent.any((s) => s.usuariId == profileUserId)) {
    return RelationshipStatus.requestSent;
  }
  return RelationshipStatus.stranger;
});