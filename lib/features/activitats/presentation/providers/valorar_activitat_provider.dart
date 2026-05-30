import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:plan_c_frontend/core/config/app_config.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/calendari/data/models/quedada_apuntada_model.dart';
import 'package:plan_c_frontend/features/calendari/presentation/providers/quedades_calendari_provider.dart';
import 'valoracions_provider.dart';

// ── Quedades elegibles per valorar ───────────────────────────────────────────

final quedadesEligiblesProvider =
    FutureProvider.family<List<QuedadaApuntadaModel>, String>(
        (ref, activitatId) async {
  final totes = await ref.watch(quedadesCalendariProvider.future);
  final now = DateTime.now();
  final result = totes.where((q) {
    return q.activitatId == activitatId &&
        q.estat == 'VALIDAT_GEOLOCALITZACIO' &&
        q.dataHoraTrobada.isBefore(now);
  }).toList();
  debugPrint('[EligiblesProvider] activitatId=$activitatId → elegibles: ${result.length}');
  return result;
});

// Comprova si una quedada concreta encara es pot valorar pel usuari actual.
Future<bool> _potValorar(String quedadaId, String usuariId) async {
  try {
    final uri = Uri.parse(
        '${AppConfig.baseUrl}activitats/quedades/$quedadaId/pot-valorar');
    final response = await http.get(uri, headers: {'usuari-id': usuariId});
    if (response.statusCode != 200) return false;
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['potValorar'] as bool? ?? false;
  } catch (_) {
    return false;
  }
}

// Retorna només les quedades elegibles que encara no han estat valorades.
final quedadesPerValorarProvider =
    FutureProvider.family<List<QuedadaApuntadaModel>, String>(
        (ref, activitatId) async {
  final elegibles = await ref.watch(quedadesEligiblesProvider(activitatId).future);
  final usuariId = ref.read(currentUserIdProvider);
  if (usuariId == null || usuariId.isEmpty || elegibles.isEmpty) return [];

  final checks = await Future.wait(
    elegibles.map((q) => _potValorar(q.quedadaId, usuariId)),
  );

  return [
    for (var i = 0; i < elegibles.length; i++)
      if (checks[i]) elegibles[i],
  ];
});

// ── Estat del formulari ───────────────────────────────────────────────────────

enum ValorarStatus { initial, loading, success, error }

class ValorarActivitatState {
  final String? quedadaIdSeleccionada;
  final int puntuacio;
  final String comentari;
  final Set<String> jaValorades;
  final ValorarStatus status;
  final int? puntsBonificacio;
  final String? errorMessage;

  const ValorarActivitatState({
    this.quedadaIdSeleccionada,
    this.puntuacio = 0,
    this.comentari = '',
    this.jaValorades = const {},
    this.status = ValorarStatus.initial,
    this.puntsBonificacio,
    this.errorMessage,
  });

  ValorarActivitatState copyWith({
    String? quedadaIdSeleccionada,
    bool clearQuedada = false,
    int? puntuacio,
    String? comentari,
    Set<String>? jaValorades,
    ValorarStatus? status,
    int? puntsBonificacio,
    String? errorMessage,
    bool clearError = false,
  }) =>
      ValorarActivitatState(
        quedadaIdSeleccionada: clearQuedada
            ? null
            : (quedadaIdSeleccionada ?? this.quedadaIdSeleccionada),
        puntuacio: puntuacio ?? this.puntuacio,
        comentari: comentari ?? this.comentari,
        jaValorades: jaValorades ?? this.jaValorades,
        status: status ?? this.status,
        puntsBonificacio: puntsBonificacio ?? this.puntsBonificacio,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      );
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class ValorarActivitatNotifier
    extends FamilyNotifier<ValorarActivitatState, String> {
  @override
  ValorarActivitatState build(String activitatId) =>
      const ValorarActivitatState();

  void seleccionarQuedada(String quedadaId) =>
      state = state.copyWith(quedadaIdSeleccionada: quedadaId, clearError: true);

  void setPuntuacio(int p) =>
      state = state.copyWith(puntuacio: p, clearError: true);

  void setComentari(String c) => state = state.copyWith(comentari: c);

  Future<void> enviar() async {
    final quedadaId = state.quedadaIdSeleccionada;
    if (quedadaId == null || state.puntuacio == 0) return;

    state = state.copyWith(status: ValorarStatus.loading, clearError: true);

    try {
      final usuariId = ref.read(currentUserIdProvider);
      if (usuariId == null || usuariId.isEmpty) {
        state = state.copyWith(
          status: ValorarStatus.error,
          errorMessage: 'Has de ser a la sessió per valorar.',
        );
        return;
      }

      final uri = Uri.parse(
          '${AppConfig.baseUrl}activitats/quedades/$quedadaId/valorar');
      final body = jsonEncode({
        'puntuacio': state.puntuacio,
        'comentari': state.comentari,
      });

      debugPrint('[ValorarActivitat] POST $uri');
      debugPrint('[ValorarActivitat] headers: usuari-id=$usuariId');
      debugPrint('[ValorarActivitat] body: $body');

      final response = await http.post(
        uri,
        headers: {
          'usuari-id': usuariId,
          'Content-Type': 'application/json',
        },
        body: body,
      );

      debugPrint('[ValorarActivitat] resposta ${response.statusCode}: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        state = state.copyWith(
          status: ValorarStatus.success,
          puntsBonificacio: data['puntsBonificacio'] as int? ?? 0,
          jaValorades: {...state.jaValorades, quedadaId},
          puntuacio: 0,
          comentari: '',
          clearQuedada: true,
        );
        ref.read(valoracionsProvider(arg).notifier).recarregar();
      } else if (response.statusCode == 409) {
        // Ja valorada: amaga-la del selector
        final updated = {...state.jaValorades, quedadaId};
        state = state.copyWith(
          jaValorades: updated,
          status: ValorarStatus.error,
          errorMessage: 'Ja has valorat aquesta quedada.',
          clearQuedada: true,
        );
      } else if (response.statusCode == 400) {
        state = state.copyWith(
          status: ValorarStatus.error,
          errorMessage:
              "L'assistència no ha estat validada o la puntuació no és vàlida.",
        );
      } else if (response.statusCode == 404) {
        state = state.copyWith(
          status: ValorarStatus.error,
          errorMessage: 'Quedada no trobada.',
        );
      } else {
        state = state.copyWith(
          status: ValorarStatus.error,
          errorMessage: "No s'ha pogut enviar la valoració.",
        );
      }
    } catch (e, st) {
      debugPrint('[ValorarActivitat] excepció: $e\n$st');
      state = state.copyWith(
        status: ValorarStatus.error,
        errorMessage: 'Error de connexió. Torna-ho a intentar.',
      );
    }
  }
}

final valorarActivitatProvider = NotifierProvider.family<ValorarActivitatNotifier,
    ValorarActivitatState, String>(
  ValorarActivitatNotifier.new,
);
