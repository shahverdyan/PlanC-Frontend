import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/amistats/presentation/providers/amistats_repository_provider.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/perfil/domain/models/relationship_status.dart';
import 'package:plan_c_frontend/features/perfil/presentation/providers/relationship_status_provider.dart';

class RelationshipActionsNotifier
    extends StateNotifier<RelationshipActionsState> {
  final Ref _ref;
  final String _profileUserId;

  RelationshipActionsNotifier(this._ref, this._profileUserId)
      : super(const RelationshipActionsState());

  String get _currentUserId => _ref.read(currentUserIdProvider) ?? '';

  void clearError() {
    state = RelationshipActionsState(loadingAction: state.loadingAction);
  }

  Future<void> afegirAmic() => _execute(RelationshipAction.add, () async {
        await _ref.read(amistatsRepositoryProvider).enviarSolicitud(
              usuariId: _currentUserId,
              altreUsuariId: _profileUserId,
            );
      });

  Future<void> eliminarAmic() =>
      _execute(RelationshipAction.remove, () async {
        await _ref.read(amistatsRepositoryProvider).eliminarAmistat(
              usuariId: _currentUserId,
              altreUsuariId: _profileUserId,
            );
      });

  Future<void> acceptarSolicitud() =>
      _execute(RelationshipAction.accept, () async {
        await _ref.read(amistatsRepositoryProvider).acceptarSolicitud(
              usuariId: _currentUserId,
              altreUsuariId: _profileUserId,
            );
      });

  Future<void> rebutjarSolicitud() =>
      _execute(RelationshipAction.reject, () async {
        await _ref.read(amistatsRepositoryProvider).rebutjarSolicitud(
              usuariId: _currentUserId,
              altreUsuariId: _profileUserId,
            );
      });

  Future<void> cancelarSolicitud() =>
      _execute(RelationshipAction.cancel, () async {
        await _ref.read(amistatsRepositoryProvider).cancelarSolicitud(
              usuariId: _currentUserId,
              altreUsuariId: _profileUserId,
            );
      });

  Future<void> _execute(
    RelationshipAction action,
    Future<void> Function() call,
  ) async {
    if (state.loadingAction != null) return;
    state = RelationshipActionsState(loadingAction: action);
    try {
      await call();
      _ref.invalidate(relationshipStatusProvider(_profileUserId));
      state = const RelationshipActionsState();
    } catch (e) {
      state = RelationshipActionsState(error: e.toString());
    }
  }
}

final relationshipActionsProvider = StateNotifierProvider.family<
    RelationshipActionsNotifier,
    RelationshipActionsState,
    String>((ref, profileUserId) {
  return RelationshipActionsNotifier(ref, profileUserId);
});