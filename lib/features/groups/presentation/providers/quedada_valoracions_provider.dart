import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:plan_c_frontend/core/config/app_config.dart';
import 'package:plan_c_frontend/features/activitats/model/valoracio.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';

// ── Pot Valorar ───────────────────────────────────────────────────────────────

class PotValorarResult {
  final bool potValorar;
  final String? motiu;

  const PotValorarResult({required this.potValorar, this.motiu});

  factory PotValorarResult.fromJson(Map<String, dynamic> json) =>
      PotValorarResult(
        potValorar: json['potValorar'] as bool? ?? false,
        motiu: json['motiu'] as String?,
      );
}

final potValorarQuedadaProvider =
    FutureProvider.family<PotValorarResult, String>((ref, quedadaId) async {
  final usuariId = ref.watch(currentUserIdProvider);
  if (usuariId == null || usuariId.isEmpty) {
    return const PotValorarResult(potValorar: false);
  }

  final uri = Uri.parse(
      '${AppConfig.baseUrl}activitats/quedades/$quedadaId/pot-valorar');

  try {
    final response =
        await http.get(uri, headers: {'usuari-id': usuariId});
    if (response.statusCode != 200) {
      return const PotValorarResult(potValorar: false);
    }
    return PotValorarResult.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } catch (_) {
    return const PotValorarResult(potValorar: false);
  }
});

// ── Llistat de valoracions ────────────────────────────────────────────────────

const _limitQuedada = 10;

class ValoracionsQuedadaState {
  final List<Valoracio> valoracions;
  final double mitjana;
  final int total;
  final bool hasMore;
  final int page;
  final bool loading;
  final bool loadingMore;
  final String? error;

  const ValoracionsQuedadaState({
    this.valoracions = const [],
    this.mitjana = 0,
    this.total = 0,
    this.hasMore = false,
    this.page = 1,
    this.loading = true,
    this.loadingMore = false,
    this.error,
  });

  ValoracionsQuedadaState copyWith({
    List<Valoracio>? valoracions,
    double? mitjana,
    int? total,
    bool? hasMore,
    int? page,
    bool? loading,
    bool? loadingMore,
    String? error,
    bool clearError = false,
  }) =>
      ValoracionsQuedadaState(
        valoracions: valoracions ?? this.valoracions,
        mitjana: mitjana ?? this.mitjana,
        total: total ?? this.total,
        hasMore: hasMore ?? this.hasMore,
        page: page ?? this.page,
        loading: loading ?? this.loading,
        loadingMore: loadingMore ?? this.loadingMore,
        error: clearError ? null : (error ?? this.error),
      );
}

class ValoracionsQuedadaNotifier
    extends FamilyNotifier<ValoracionsQuedadaState, String> {
  @override
  ValoracionsQuedadaState build(String quedadaId) {
    Future.microtask(() => _fetchPage(1, append: false));
    return const ValoracionsQuedadaState();
  }

  Future<void> _fetchPage(int page, {required bool append}) async {
    if (append) {
      state = state.copyWith(loadingMore: true, clearError: true);
    } else {
      state = state.copyWith(loading: true, clearError: true);
    }

    try {
      final usuariId = ref.read(currentUserIdProvider);
      final uri = Uri.parse(
        '${AppConfig.baseUrl}activitats/quedades/$arg/valoracions',
      ).replace(queryParameters: {
        'page': '$page',
        'limit': '$_limitQuedada',
      });

      final headers = <String, String>{};
      if (usuariId != null && usuariId.isNotEmpty) {
        headers['usuari-id'] = usuariId;
      }

      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) throw Exception();

      final data = ValoracionsResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);

      state = state.copyWith(
        valoracions: append
            ? [...state.valoracions, ...data.valoracions]
            : data.valoracions,
        mitjana: append ? state.mitjana : data.mitjana,
        total: append ? state.total : data.total,
        hasMore: data.hasMore,
        page: page,
        loading: false,
        loadingMore: false,
      );
    } catch (_) {
      state = state.copyWith(
        loading: false,
        loadingMore: false,
        error: "No s'han pogut carregar les valoracions.",
      );
    }
  }

  Future<void> carregarMes() => _fetchPage(state.page + 1, append: true);
  void recarregar() => _fetchPage(1, append: false);
}

final valoracionsQuedadaProvider = NotifierProvider.family<
    ValoracionsQuedadaNotifier, ValoracionsQuedadaState, String>(
  ValoracionsQuedadaNotifier.new,
);

// ── Enviar valoració ──────────────────────────────────────────────────────────

enum EnviarValoracioStatus { initial, loading, success, error }

class EnviarValoracioState {
  final EnviarValoracioStatus status;
  final int? puntsBonificacio;
  final String? errorMessage;

  const EnviarValoracioState({
    this.status = EnviarValoracioStatus.initial,
    this.puntsBonificacio,
    this.errorMessage,
  });

  EnviarValoracioState copyWith({
    EnviarValoracioStatus? status,
    int? puntsBonificacio,
    String? errorMessage,
  }) =>
      EnviarValoracioState(
        status: status ?? this.status,
        puntsBonificacio: puntsBonificacio ?? this.puntsBonificacio,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}

class EnviarValoracioNotifier
    extends FamilyNotifier<EnviarValoracioState, String> {
  @override
  EnviarValoracioState build(String quedadaId) =>
      const EnviarValoracioState();

  Future<void> enviar({
    required int puntuacio,
    required String comentari,
  }) async {
    state = state.copyWith(status: EnviarValoracioStatus.loading);

    try {
      final usuariId = ref.read(currentUserIdProvider);
      if (usuariId == null || usuariId.isEmpty) {
        state = state.copyWith(
          status: EnviarValoracioStatus.error,
          errorMessage: 'Has de ser a la sessió per valorar.',
        );
        return;
      }

      final uri = Uri.parse(
          '${AppConfig.baseUrl}activitats/quedades/$arg/valorar');

      final response = await http.post(
        uri,
        headers: {
          'usuari-id': usuariId,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'puntuacio': puntuacio, 'comentari': comentari}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        state = state.copyWith(
          status: EnviarValoracioStatus.success,
          puntsBonificacio: data['puntsBonificacio'] as int? ?? 0,
        );
        ref.invalidate(potValorarQuedadaProvider(arg));
        ref.read(valoracionsQuedadaProvider(arg).notifier).recarregar();
      } else if (response.statusCode == 409) {
        state = state.copyWith(
          status: EnviarValoracioStatus.error,
          errorMessage: 'Ja has valorat aquesta quedada.',
        );
      } else if (response.statusCode == 400) {
        state = state.copyWith(
          status: EnviarValoracioStatus.error,
          errorMessage:
              "L'assistència no ha estat validada o la puntuació no és vàlida.",
        );
      } else if (response.statusCode == 404) {
        state = state.copyWith(
          status: EnviarValoracioStatus.error,
          errorMessage: 'Quedada no trobada.',
        );
      } else {
        state = state.copyWith(
          status: EnviarValoracioStatus.error,
          errorMessage: "No s'ha pogut enviar la valoració.",
        );
      }
    } catch (_) {
      state = state.copyWith(
        status: EnviarValoracioStatus.error,
        errorMessage: "Error de connexió. Torna-ho a intentar.",
      );
    }
  }
}

final enviarValoracioProvider = NotifierProvider.family<EnviarValoracioNotifier,
    EnviarValoracioState, String>(
  EnviarValoracioNotifier.new,
);
