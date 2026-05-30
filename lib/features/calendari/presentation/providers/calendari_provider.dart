import 'package:device_calendar/device_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/activitats/model/activitat.dart';
import 'package:plan_c_frontend/features/calendari/data/repositories/calendari_repository_impl.dart';
import 'package:plan_c_frontend/features/calendari/domain/entities/calendari_compte.dart';
import 'package:plan_c_frontend/features/calendari/domain/entities/calendari_event.dart';
import 'package:plan_c_frontend/features/calendari/domain/repositories/i_calendari_repository.dart';
import 'package:plan_c_frontend/features/calendari/domain/usecases/afegir_al_calendari_usecase.dart';
import 'package:plan_c_frontend/features/groups/domain/models/group.dart';

final _deviceCalendarPluginProvider = Provider<DeviceCalendarPlugin>(
  (_) => DeviceCalendarPlugin(),
);

final _calendariRepositoryProvider = Provider<ICalendariRepository>(
  (ref) => CalendariRepositoryImpl(ref.watch(_deviceCalendarPluginProvider)),
);

final _afegirUseCaseProvider = Provider<AfegirAlCalendariUseCase>(
  (ref) => AfegirAlCalendariUseCase(ref.watch(_calendariRepositoryProvider)),
);

// ── State ──────────────────────────────────────────────────────────────────

enum CalendariStatus {
  initial,
  loading,
  seleccionantCalendari,
  success,
  permisDenega,
  error,
}

class CalendariState {
  final CalendariStatus status;
  final CalendariEvent? event;
  final String? errorMessage;
  final List<CalendariCompte> calendarisDisponibles;

  const CalendariState({
    this.status = CalendariStatus.initial,
    this.event,
    this.errorMessage,
    this.calendarisDisponibles = const [],
  });

  CalendariState copyWith({
    CalendariStatus? status,
    CalendariEvent? event,
    String? errorMessage,
    List<CalendariCompte>? calendarisDisponibles,
  }) {
    return CalendariState(
      status: status ?? this.status,
      event: event ?? this.event,
      errorMessage: errorMessage ?? this.errorMessage,
      calendarisDisponibles:
          calendarisDisponibles ?? this.calendarisDisponibles,
    );
  }
}

// ── Notifier ───────────────────────────────────────────────────────────────

class CalendariNotifier extends Notifier<CalendariState> {
  @override
  CalendariState build() => const CalendariState();

  static CalendariEvent buildEvent({
    required Activitat activitat,
    required Group group,
  }) {
    final ubicacioParts = [
      if (activitat.nomEspai.isNotEmpty) activitat.nomEspai,
      if (activitat.adreca.isNotEmpty) activitat.adreca,
      if (activitat.localitat.isNotEmpty) activitat.localitat,
    ];

    final descParts = [
      'Quedada: ${group.title}',
      if (activitat.descripcio.isNotEmpty) activitat.descripcio,
      'Obre a l\'app PlanC: planc://quedada/${group.id}',
    ];

    return CalendariEvent(
      titol: activitat.titol,
      ubicacio: ubicacioParts.join(', '),
      descripcio: descParts.join('\n\n'),
      dataInici: group.dateTime,
      dataFi: group.dateTime.add(const Duration(hours: 2)),
      alertaMinuts: 30,
    );
  }

  void actualitzarEvent(CalendariEvent event) {
    state = state.copyWith(event: event);
  }

  /// Fase 1: comprova permisos i obté els calendaris de Google disponibles.
  /// Transiciona a [CalendariStatus.seleccionantCalendari] per tal que la UI
  /// mostri el diàleg de selecció.
  Future<void> iniciarAfegirAlCalendari(CalendariEvent event) async {
    state = state.copyWith(
      event: event,
      status: CalendariStatus.loading,
      calendarisDisponibles: const [],
    );

    final resultat =
        await ref.read(_afegirUseCaseProvider).obtenirCalendaris();

    switch (resultat) {
      case CalendariNecessitaSeleccio(:final calendaris):
        state = state.copyWith(
          status: CalendariStatus.seleccionantCalendari,
          calendarisDisponibles: calendaris,
        );
      case CalendariPermisDenega():
        state = state.copyWith(status: CalendariStatus.permisDenega);
      case CalendariError(:final missatge):
        state = state.copyWith(
          status: CalendariStatus.error,
          errorMessage: missatge,
        );
      case CalendariSuccess():
        break;
    }
  }

  /// Fase 2: crea l'esdeveniment al calendari seleccionat per l'usuari.
  Future<void> confirmarCalendari(String calendarId) async {
    final event = state.event;
    if (event == null) return;

    state = state.copyWith(
      status: CalendariStatus.loading,
      calendarisDisponibles: const [],
    );

    final resultat = await ref.read(_afegirUseCaseProvider)(event, calendarId);

    switch (resultat) {
      case CalendariSuccess():
        state = state.copyWith(status: CalendariStatus.success);
      case CalendariPermisDenega():
        state = state.copyWith(status: CalendariStatus.permisDenega);
      case CalendariError(:final missatge):
        state = state.copyWith(
          status: CalendariStatus.error,
          errorMessage: missatge,
        );
      case CalendariNecessitaSeleccio():
        break;
    }
  }

  void reiniciar() => state = const CalendariState();
}

final calendariProvider = NotifierProvider<CalendariNotifier, CalendariState>(
  CalendariNotifier.new,
);
