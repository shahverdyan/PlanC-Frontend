import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:plan_c_frontend/core/config/app_config.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import '../../model/valoracio.dart';

const _limit = 5;

// ── State ─────────────────────────────────────────────────────────────────────

class ValoracionsState {
  final List<Valoracio> valoracions;
  final double mitjana;
  final int total;
  final bool hasMore;
  final int page;
  final bool loading;
  final bool loadingMore;
  final String? error;

  const ValoracionsState({
    this.valoracions = const [],
    this.mitjana = 0,
    this.total = 0,
    this.hasMore = false,
    this.page = 1,
    this.loading = true,
    this.loadingMore = false,
    this.error,
  });

  ValoracionsState copyWith({
    List<Valoracio>? valoracions,
    double? mitjana,
    int? total,
    bool? hasMore,
    int? page,
    bool? loading,
    bool? loadingMore,
    String? error,
    bool clearError = false,
  }) {
    return ValoracionsState(
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
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class ValoracionsNotifier extends FamilyNotifier<ValoracionsState, String> {
  @override
  ValoracionsState build(String activitatId) {
    Future.microtask(() => _fetchPage(1, append: false));
    return const ValoracionsState();
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
        '${AppConfig.baseUrl}activitats/$arg/valoracions-activitat',
      ).replace(queryParameters: {
        'page': '$page',
        'limit': '$_limit',
      });

      final headers = <String, String>{};
      if (usuariId != null && usuariId.isNotEmpty) {
        headers['usuari-id'] = usuariId;
      }

      debugPrint('[Valoracions] GET $uri | usuari-id: $usuariId');

      final response = await http.get(uri, headers: headers);

      debugPrint('[Valoracions] resposta ${response.statusCode}: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final data = ValoracionsResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );

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
    } catch (e, st) {
      debugPrint('[Valoracions] error: $e\n$st');
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

final valoracionsProvider =
    NotifierProvider.family<ValoracionsNotifier, ValoracionsState, String>(
  ValoracionsNotifier.new,
);
