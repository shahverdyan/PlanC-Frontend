import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/activitats_repository.dart';
import '../../model/activitat.dart';
import '../../../map/presentation/state/mapa_activitats_state.dart';
import '../provider/activitats_providers.dart';


class MapaActivitatsNotifier extends AsyncNotifier<MapaActivitatsState> {
  late final ActivitatsRepository _repository;

  @override
  Future<MapaActivitatsState> build() async {
    _repository = ref.read(activitatsRepositoryProvider);

    final activitats = await _repository.getActivitats();

    return MapaActivitatsState(
      activitats: activitats,
      activitatsVisibles: activitats,
    );
  }

  void seleccionarActivitat(Activitat activitat) {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        activitatSeleccionada: activitat,
      ),
    );
  }

  void netejarSeleccio() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        clearActivitatSeleccionada: true,
      ),
    );
  }

  void toggleCategoria(String categoria) {
    final current = state.valueOrNull;
    if (current == null) return;

    final novesCategories = Set<String>.from(current.categoriesSeleccionades);

    if (novesCategories.contains(categoria)) {
      novesCategories.remove(categoria);
    } else {
      novesCategories.add(categoria);
    }

    final activitatsVisibles = novesCategories.isEmpty
        ? current.activitats
        : current.activitats
        .where((a) => novesCategories.contains(a.categoria.trim()))
        .toList();

    state = AsyncData(
      current.copyWith(
        categoriesSeleccionades: novesCategories,
        activitatsVisibles: activitatsVisibles,
        clearActivitatSeleccionada: true,
      ),
    );
  }

  void mostrarTotesLesCategories() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        clearCategoriesSeleccionades: true,
        activitatsVisibles: current.activitats,
        clearActivitatSeleccionada: true,
      ),
    );
  }
  List<String> getCategoriesDisponibles() {
    final current = state.valueOrNull;
    if (current == null) return [];

    final categories = current.activitats
        .map((a) => a.categoria.trim())
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    return categories;
  }

  Future<void> recarregarActivitats() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final activitats = await _repository.getActivitats();

      return MapaActivitatsState(
        activitats: activitats,
        activitatsVisibles: activitats,
      );
    });
  }
}