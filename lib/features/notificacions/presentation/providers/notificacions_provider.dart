import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/providers/dio_provider.dart';
import 'package:plan_c_frontend/features/notificacions/data/repositories/notificacions_repository.dart';
import 'package:plan_c_frontend/features/notificacions/domain/models/notificacio.dart';

final notificacionsRepositoryProvider = Provider<NotificacionsRepository>((ref) {
  return NotificacionsRepository(ref.read(dioProvider));
});

final notificacionsProvider = FutureProvider.family<List<Notificacio>, String>((
  ref,
  usuariId,
) async {
  final repo = ref.watch(notificacionsRepositoryProvider);
  return repo.obtenirNotificacions(usuariId: usuariId);
});

final teNoLlegidesProvider = FutureProvider.family<bool, String>((
  ref,
  usuariId,
) async {
  final repo = ref.watch(notificacionsRepositoryProvider);
  return repo.teNoLlegides(usuariId: usuariId);
});
