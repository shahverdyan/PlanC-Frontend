import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/calendari/data/models/quedada_apuntada_model.dart';
import 'package:plan_c_frontend/features/calendari/data/repositories/quedades_calendari_repository.dart';

final quedadesCalendariProvider =
    FutureProvider<List<QuedadaApuntadaModel>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null || userId.isEmpty) return [];
  return QuedadesCalendariRepository().getQuedadesApuntades(userId);
});
