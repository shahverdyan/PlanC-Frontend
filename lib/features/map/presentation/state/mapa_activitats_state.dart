import '../../../activitats/model/activitat.dart';



class MapaActivitatsState {
  final List<Activitat> activitats;
  final List<Activitat> activitatsVisibles;
  final Activitat? activitatSeleccionada;
  final Set<String> categoriesSeleccionades;

  const MapaActivitatsState({
    this.activitats = const [],
    this.activitatsVisibles = const [],
    this.activitatSeleccionada,
    this.categoriesSeleccionades = const {},
  });

  MapaActivitatsState copyWith({
    List<Activitat>? activitats,
    List<Activitat>? activitatsVisibles,
    Activitat? activitatSeleccionada,
    Set<String>? categoriesSeleccionades,
    bool clearActivitatSeleccionada = false,
    bool clearCategoriesSeleccionades = false,
  }) {
    return MapaActivitatsState(
      activitats: activitats ?? this.activitats,
      activitatsVisibles: activitatsVisibles ?? this.activitatsVisibles,
      activitatSeleccionada: clearActivitatSeleccionada
          ? null
          : (activitatSeleccionada ?? this.activitatSeleccionada),
      categoriesSeleccionades: clearCategoriesSeleccionades
          ? {}
          : (categoriesSeleccionades ?? this.categoriesSeleccionades),
    );
  }
}