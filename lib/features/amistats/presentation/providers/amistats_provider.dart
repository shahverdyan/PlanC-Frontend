import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/amistats/domain/models/amistat.dart';
import 'package:plan_c_frontend/features/amistats/presentation/providers/amistats_repository_provider.dart';
import 'package:plan_c_frontend/features/perfil/presentation/providers/profile_provider.dart';

final amistatsProvider = FutureProvider.family<List<SolicitudAmistat>, String>((
  ref,
  usuariId,
) async {
  final repository = ref.watch(amistatsRepositoryProvider);
  return repository.obtenirAmistats(usuariId: usuariId);
});

final sollicitudsRebudesProvider = FutureProvider.family<List<SolicitudAmistat>, String>((
  ref,
  usuariId,
) async {
  final repository = ref.watch(amistatsRepositoryProvider);
  return repository.obtenirAmistatsPendents(usuariId: usuariId);
});

final sollicitudsEnviadesProvider = FutureProvider.family<List<SolicitudAmistat>, String>((
  ref,
  usuariId,
) async {
  final repository = ref.watch(amistatsRepositoryProvider);
  return repository.obtenirSolicitudsEnviades(usuariId: usuariId);
});

class AmistatsActions {
  final Ref ref;

  AmistatsActions(this.ref);

  Future<void> acceptarSolicitud({
    required String usuariId,
    required String altreUsuariId,
  }) async {
    final repository = ref.read(amistatsRepositoryProvider);
    await repository.acceptarSolicitud(
      usuariId: usuariId,
      altreUsuariId: altreUsuariId,
    );
    _refresh(usuariId);
  }

  Future<void> rebutjarSolicitud({
    required String usuariId,
    required String altreUsuariId,
  }) async {
    final repository = ref.read(amistatsRepositoryProvider);
    await repository.rebutjarSolicitud(
      usuariId: usuariId,
      altreUsuariId: altreUsuariId,
    );
    _refresh(usuariId);
  }

  Future<void> cancelarSolicitud({
    required String usuariId,
    required String altreUsuariId,
  }) async {
    final repository = ref.read(amistatsRepositoryProvider);
    await repository.cancelarSolicitud(
      usuariId: usuariId,
      altreUsuariId: altreUsuariId,
    );
    _refresh(usuariId);
  }

  Future<void> eliminarAmistat({
    required String usuariId,
    required String altreUsuariId,
  }) async {
    final repository = ref.read(amistatsRepositoryProvider);
    await repository.eliminarAmistat(
      usuariId: usuariId,
      altreUsuariId: altreUsuariId,
    );
    _refresh(usuariId);
  }

  void _refresh(String usuariId) {
    ref.invalidate(amistatsProvider(usuariId));
    ref.invalidate(sollicitudsRebudesProvider(usuariId));
    ref.invalidate(sollicitudsEnviadesProvider(usuariId));
    ref.invalidate(profileByIdProvider(usuariId));
  }
}

final amistatsActionsProvider = Provider<AmistatsActions>((ref) {
  return AmistatsActions(ref);
});