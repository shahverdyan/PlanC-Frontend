import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/search_remote_data_source.dart';
import '../../data/models/profile_search_result.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/usecases/cerca_predictiva_usecase.dart';
import '../../domain/usecases/cerca_amb_filtres_usecase.dart';
import '../../domain/usecases/cerca_qualitat_aire_usecase.dart';
import '../../domain/usecases/obtenir_historial_usecase.dart';
import '../../domain/usecases/search_profiles_usecase.dart';

// ---------- Infraestructura ----------

final httpClientProvider = Provider<http.Client>((ref) => http.Client());

final searchDataSourceProvider = Provider<SearchRemoteDataSource>((ref) {
  return SearchRemoteDataSource(ref.watch(httpClientProvider));
});

final searchRepositoryProvider = Provider<SearchRepositoryImpl>((ref) {
  return SearchRepositoryImpl(ref.watch(searchDataSourceProvider));
});

// ---------- Casos d'ús ----------

final cercaPredictivaUsecaseProvider = Provider<CercaPredictivaUsecase>((ref) {
  return CercaPredictivaUsecase(ref.watch(searchRepositoryProvider));
});

final cercaAmbFiltresUsecaseProvider = Provider<CercaAmbFiltresUsecase>((ref) {
  return CercaAmbFiltresUsecase(ref.watch(searchRepositoryProvider));
});

final obtenirHistorialUsecaseProvider = Provider<ObtenirHistorialUsecase>((ref) {
  return ObtenirHistorialUsecase(ref.watch(searchRepositoryProvider));
});

final searchProfilesUsecaseProvider = Provider<SearchProfilesUsecase>((ref) {
  return SearchProfilesUsecase(ref.watch(searchRepositoryProvider));
});

final cercaQualitatAireUsecaseProvider = Provider<CercaQualitatAireUsecase>((ref) {
  return CercaQualitatAireUsecase(ref.watch(searchRepositoryProvider));
});

// ---------- Estat de la cerca ----------

class SearchState {
  final String terme;
  final String tipus;
  final SearchResults results;
  final List<ProfileSearchResult> profileResults;
  final List<String> historial;
  final List<String> profileHistorial;
  final bool isLoading;
  final String? errorMessage;
  final List<AirQualityStation> airQualityEstacions;
  final int? airQualityErrorCode;

  const SearchState({
    this.terme = '',
    this.tipus = 'tots',
    this.results = const SearchResults(),
    this.profileResults = const [],
    this.historial = const [],
    this.profileHistorial = const [],
    this.isLoading = false,
    this.errorMessage,
    this.airQualityEstacions = const [],
    this.airQualityErrorCode,
  });

  SearchState copyWith({
    String? terme,
    String? tipus,
    SearchResults? results,
    List<ProfileSearchResult>? profileResults,
    List<String>? historial,
    List<String>? profileHistorial,
    bool? isLoading,
    String? errorMessage,
    List<AirQualityStation>? airQualityEstacions,
    int? airQualityErrorCode,
    bool clearAirQualityError = false,
  }) {
    return SearchState(
      terme: terme ?? this.terme,
      tipus: tipus ?? this.tipus,
      results: results ?? this.results,
      profileResults: profileResults ?? this.profileResults,
      historial: historial ?? this.historial,
      profileHistorial: profileHistorial ?? this.profileHistorial,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      airQualityEstacions: airQualityEstacions ?? this.airQualityEstacions,
      airQualityErrorCode: clearAirQualityError
          ? null
          : airQualityErrorCode ?? this.airQualityErrorCode,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final CercaPredictivaUsecase _cercaPredictiva;
  final CercaAmbFiltresUsecase _cercaAmbFiltres;
  final CercaQualitatAireUsecase _cercaQualitatAire;
  final ObtenirHistorialUsecase _obtenirHistorial;
  final SearchProfilesUsecase _searchProfiles;

  static const _profileHistoryKey = 'profile_search_history';
  static const _maxProfileHistory = 10;

  SearchNotifier({
    required CercaPredictivaUsecase cercaPredictiva,
    required CercaAmbFiltresUsecase cercaAmbFiltres,
    required CercaQualitatAireUsecase cercaQualitatAire,
    required ObtenirHistorialUsecase obtenirHistorial,
    required SearchProfilesUsecase searchProfiles,
  })  : _cercaPredictiva = cercaPredictiva,
        _cercaAmbFiltres = cercaAmbFiltres,
        _cercaQualitatAire = cercaQualitatAire,
        _obtenirHistorial = obtenirHistorial,
        _searchProfiles = searchProfiles,
        super(const SearchState());

  Future<void> cercar(String terme, {String? usuariId}) async {
    final trimmed = terme.trim();
    state = state.copyWith(terme: terme, isLoading: true, errorMessage: null);

    if (trimmed.isEmpty || trimmed.length < 2) {
      state = state.copyWith(
        results: SearchResults.empty(),
        profileResults: const [],
        isLoading: false,
      );
      return;
    }

    final searchActivities = state.tipus != 'perfils';
    final searchProfiles =
        state.tipus == 'tots' || state.tipus == 'perfils';

    try {
      SearchResults activityResults = SearchResults.empty();
      List<ProfileSearchResult> profileResults = const [];

      if (searchActivities && searchProfiles) {
        final futures = await Future.wait<dynamic>([
          _cercaPredictiva(
              terme: trimmed, tipus: state.tipus, usuariId: usuariId),
          if (usuariId != null && usuariId.isNotEmpty)
            _searchProfiles(query: trimmed, userId: usuariId)
          else
            Future.value(const <ProfileSearchResult>[]),
        ]);
        activityResults = futures[0] as SearchResults;
        profileResults =
            List<ProfileSearchResult>.from(futures[1] as List);
      } else if (searchActivities) {
        activityResults = await _cercaPredictiva(
          terme: trimmed,
          tipus: state.tipus,
          usuariId: usuariId,
        );
      } else {
        profileResults = (usuariId != null && usuariId.isNotEmpty)
            ? await _searchProfiles(query: trimmed, userId: usuariId)
            : const [];
      }

      state = state.copyWith(
        results: activityResults,
        profileResults: profileResults,
        isLoading: false,
      );

      if (searchProfiles) await _saveProfileHistory(trimmed);
    } catch (e) {
      final msg = e.toString();
      state = state.copyWith(
        isLoading: false,
        errorMessage: msg.contains('502')
            ? 'El servidor està arrancant, torna-ho a provar en uns instants.'
            : 'Error en la cerca. Torna-ho a intentar.',
      );
    }
  }

  Future<void> aplicarFiltres({
    String? dataInici,
    String? dataFi,
    bool? gratuit,
    double? preuMax,
    double? latitud,
    double? longitud,
    double? radiKm,
    List<String>? categories,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Sempre enviem com a mínim la data d'avui per evitar activitats passades
    final avui = DateTime.now();
    final avuiStr =
        '${avui.year}-${avui.month.toString().padLeft(2, '0')}-${avui.day.toString().padLeft(2, '0')}';

    try {
      final results = await _cercaAmbFiltres(
        dataInici: dataInici ?? avuiStr,
        dataFi: dataFi,
        gratuit: gratuit,
        preuMax: preuMax,
        latitud: latitud,
        longitud: longitud,
        radiKm: radiKm,
        categories: categories,
      );

      state = state.copyWith(
        results: results,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error aplicant filtres. Torna-ho a intentar.',
      );
    }
  }

  Future<void> carregarHistorial(String usuariId) async {
    try {
      final historial = await _obtenirHistorial(usuariId);
      state = state.copyWith(historial: historial);
    } catch (_) {
      // Historial no crític, no mostrem error
    }
  }

  Future<void> carregarHistorialPerfils() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList(_profileHistoryKey) ?? [];
      state = state.copyWith(profileHistorial: history);
    } catch (_) {}
  }

  Future<void> eliminarDeHistorialPerfils(String terme) async {
    try {
      final current = List<String>.from(state.profileHistorial);
      current.remove(terme);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_profileHistoryKey, current);
      state = state.copyWith(profileHistorial: current);
    } catch (_) {}
  }

  Future<void> _saveProfileHistory(String terme) async {
    try {
      final current = List<String>.from(state.profileHistorial);
      current.remove(terme);
      current.insert(0, terme);
      final trimmed = current.take(_maxProfileHistory).toList();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_profileHistoryKey, trimmed);
      state = state.copyWith(profileHistorial: trimmed);
    } catch (_) {}
  }

  void canviarTipus(String tipus) {
    // If the search term is empty, clear results immediately so the
    // discovery section shows as soon as the tab changes (no 300ms delay).
    if (state.terme.trim().isEmpty) {
      state = state.copyWith(
        tipus: tipus,
        results: SearchResults.empty(),
        profileResults: const [],
        isLoading: false,
        errorMessage: null,
      );
    } else {
      state = state.copyWith(tipus: tipus);
    }
  }

  Future<void> aplicarFiltresQualitatAire({
    required double lat,
    required double lng,
    required double radi,
    int? aqiMax,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      airQualityEstacions: const [],
      clearAirQualityError: true,
    );
    try {
      final result = await _cercaQualitatAire(
        lat: lat,
        lng: lng,
        radi: radi,
        aqiMax: aqiMax,
      );
      state = state.copyWith(
        isLoading: false,
        airQualityEstacions: result.estacions,
      );
    } catch (e) {
      int code = 400;
      final msg = e.toString();
      if (msg.contains('airQuality:503')) {
        code = 503;
      } else if (msg.contains('airQuality:404')) {
        code = 404;
      }
      state = state.copyWith(
        isLoading: false,
        airQualityErrorCode: code,
      );
    }
  }

  void netejarResultatsQualitatAire() {
    state = state.copyWith(
      airQualityEstacions: const [],
      clearAirQualityError: true,
    );
  }

  void netejarCerca() {
    // Preserve local histories — they are loaded independently
    state = SearchState(
      profileHistorial: state.profileHistorial,
      historial: state.historial,
    );
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(
    cercaPredictiva: ref.watch(cercaPredictivaUsecaseProvider),
    cercaAmbFiltres: ref.watch(cercaAmbFiltresUsecaseProvider),
    cercaQualitatAire: ref.watch(cercaQualitatAireUsecaseProvider),
    obtenirHistorial: ref.watch(obtenirHistorialUsecaseProvider),
    searchProfiles: ref.watch(searchProfilesUsecaseProvider),
  );
});
