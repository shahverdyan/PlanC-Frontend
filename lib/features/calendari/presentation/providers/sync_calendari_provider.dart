import 'package:device_calendar/device_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plan_c_frontend/features/calendari/data/repositories/calendari_repository_impl.dart';
import 'package:plan_c_frontend/features/calendari/data/services/google_calendar_sync_service.dart';
import 'package:plan_c_frontend/features/calendari/domain/entities/calendari_compte.dart';
import 'package:plan_c_frontend/features/calendari/domain/repositories/i_calendari_repository.dart';
import 'package:plan_c_frontend/features/calendari/domain/usecases/afegir_al_calendari_usecase.dart';
import 'package:plan_c_frontend/features/calendari/presentation/providers/quedades_calendari_provider.dart';

// ── State ──────────────────────────────────────────────────────────────────

enum SyncCalendariStatus {
  initial,
  loading,
  seleccionantCalendari,
  syncing,
  success,
  permisDenega,
  error,
}

class SyncCalendariState {
  final SyncCalendariStatus status;
  final List<CalendariCompte> calendaris;
  final SyncResult? result;
  final String? errorMessage;

  const SyncCalendariState({
    this.status = SyncCalendariStatus.initial,
    this.calendaris = const [],
    this.result,
    this.errorMessage,
  });

  SyncCalendariState copyWith({
    SyncCalendariStatus? status,
    List<CalendariCompte>? calendaris,
    SyncResult? result,
    String? errorMessage,
  }) {
    return SyncCalendariState(
      status: status ?? this.status,
      calendaris: calendaris ?? this.calendaris,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// ── Providers ──────────────────────────────────────────────────────────────

final _syncPluginProvider = Provider<DeviceCalendarPlugin>(
  (_) => DeviceCalendarPlugin(),
);

final _syncRepositoryProvider = Provider<ICalendariRepository>(
  (ref) => CalendariRepositoryImpl(ref.watch(_syncPluginProvider)),
);

final _syncUseCaseProvider = Provider<AfegirAlCalendariUseCase>(
  (ref) => AfegirAlCalendariUseCase(ref.watch(_syncRepositoryProvider)),
);

// ── Notifier ───────────────────────────────────────────────────────────────

class SyncCalendariNotifier extends Notifier<SyncCalendariState> {
  @override
  SyncCalendariState build() => const SyncCalendariState();

  Future<void> iniciarSync() async {
    state = const SyncCalendariState(status: SyncCalendariStatus.loading);

    final resultat = await ref.read(_syncUseCaseProvider).obtenirCalendaris();

    switch (resultat) {
      case CalendariNecessitaSeleccio(:final calendaris):
        state = state.copyWith(
          status: SyncCalendariStatus.seleccionantCalendari,
          calendaris: calendaris,
        );
      case CalendariPermisDenega():
        state = state.copyWith(status: SyncCalendariStatus.permisDenega);
      case CalendariError(:final missatge):
        state = state.copyWith(
          status: SyncCalendariStatus.error,
          errorMessage: missatge,
        );
      case CalendariSuccess():
        break;
    }
  }

  Future<void> confirmarCalendari(String calendarId) async {
    state = state.copyWith(
      status: SyncCalendariStatus.syncing,
      calendaris: const [],
    );

    try {
      final quedades = await ref.read(quedadesCalendariProvider.future);
      final service = GoogleCalendarSyncService(
        storage: const FlutterSecureStorage(),
      );
      final result = await service.syncQuedades(quedades, calendarId);
      state = state.copyWith(
        status: SyncCalendariStatus.success,
        result: result,
      );
    } catch (e) {
      state = state.copyWith(
        status: SyncCalendariStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void reiniciar() => state = const SyncCalendariState();
}

final syncCalendariProvider =
    NotifierProvider<SyncCalendariNotifier, SyncCalendariState>(
  SyncCalendariNotifier.new,
);
