import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/activitats_data_source.dart';
import '../../data/activitats_repository.dart';
import '../../data/activitats_repository_impl.dart';
import '../../model/activitat.dart';
import '../../model/amic_assistent.dart';
import '../../model/qualitat_aire.dart';
import '../notifier/mapa_activitats_notifier.dart';
import '../../../auth/domain/auth_provider.dart';
import '../../../map/presentation/state/mapa_activitats_state.dart';

final activitatsDataSourceProvider = Provider<ActivitatsDataSource>((ref) {
  return ActivitatsRemoteDataSource();
});

final activitatsRepositoryProvider = Provider<ActivitatsRepository>((ref) {
  final dataSource = ref.read(activitatsDataSourceProvider);
  return ActivitatsRepositoryImpl(dataSource);
});

final mapaActivitatsProvider =
AsyncNotifierProvider<MapaActivitatsNotifier, MapaActivitatsState>(
  MapaActivitatsNotifier.new,
);

final activitatByIdProvider =
    FutureProvider.autoDispose.family<Activitat, String>((ref, id) {
  return ref.read(activitatsRepositoryProvider).getActivitatById(id);
});

final qualitatAireProvider =
    FutureProvider.autoDispose.family<QualitatAire?, String>((ref, id) {
  return ref.read(activitatsRepositoryProvider).getQualitatAire(id);
});

final amicsAssistentsProvider =
    FutureProvider.autoDispose.family<List<AmicAssistentModel>, String>((ref, activitatId) async {
  final userId = ref.watch(currentUserIdProvider);
  debugPrint('[amicsAssistents] activitatId=$activitatId | userId=$userId');
  if (userId == null || userId.isEmpty) {
    debugPrint('[amicsAssistents] userId null/buit → retorna []');
    return [];
  }
  try {
    final result = await ref.read(activitatsRepositoryProvider).getAmicsAssistents(activitatId, userId);
    debugPrint('[amicsAssistents] resposta: ${result.length} amics per activitat $activitatId');
    return result;
  } catch (e) {
    debugPrint('[amicsAssistents] ERROR: $e');
    return [];
  }
});

final activitatsProvider = FutureProvider<List<Activitat>>((ref) async {
  final repository = ref.watch(activitatsRepositoryProvider);
  return await repository.getActivitats(); 
});

final activitatsByUserIdProvider = FutureProvider.family<List<Activitat>, String>((ref, userId) async {
  final repository = ref.watch(activitatsRepositoryProvider);
  return await repository.getActivitatsByUserId(userId); 
});