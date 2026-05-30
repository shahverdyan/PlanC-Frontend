import 'package:flutter_test/flutter_test.dart';
import 'package:plan_c_frontend/features/cercador/presentation/providers/search_provider.dart';
import 'package:plan_c_frontend/features/cercador/domain/usecases/cerca_predictiva_usecase.dart';
import 'package:plan_c_frontend/features/cercador/domain/usecases/cerca_amb_filtres_usecase.dart';
import 'package:plan_c_frontend/features/cercador/domain/usecases/obtenir_historial_usecase.dart';
import 'package:plan_c_frontend/features/cercador/domain/entities/search_result.dart';
import 'package:plan_c_frontend/features/cercador/domain/repositories/i_search_repository.dart';
import 'package:plan_c_frontend/features/cercador/data/models/profile_search_result.dart';

// ============================================================
// Fake repository — simula el backend sense Mockito
// ============================================================
class FakeSearchRepository implements ISearchRepository {
  // Respostes configurables per cada test
  SearchResults? cercaPredictivaResult;
  SearchResults? cercarAmbFiltresResult;
  List<String>? historialResult;

  // Per verificar quins paràmetres es van enviar
  Map<String, dynamic>? lastFiltresCall;
  Map<String, dynamic>? lastPredictivaCall;
  String? lastHistorialUserId;

  // Per simular errors
  bool shouldThrowOnPredictiva = false;
  bool shouldThrowOnFiltres = false;
  bool shouldThrowOnHistorial = false;

  // Comptadors de crides
  int predictivaCallCount = 0;
  int filtresCallCount = 0;
  int historialCallCount = 0;

  @override
  Future<SearchResults> cercaPredictiva({
    required String terme,
    String tipus = 'tots',
    String? usuariId,
  }) async {
    predictivaCallCount++;
    lastPredictivaCall = {
      'terme': terme,
      'tipus': tipus,
      'usuariId': usuariId,
    };

    if (shouldThrowOnPredictiva) {
      throw Exception('Network error');
    }

    return cercaPredictivaResult ?? const SearchResults();
  }

  @override
  Future<SearchResults> cercarAmbFiltres({
    String? dataInici,
    String? dataFi,
    bool? gratuit,
    double? preuMax,
    double? latitud,
    double? longitud,
    double? radiKm,
    List<String>? categories,
  }) async {
    filtresCallCount++;
    lastFiltresCall = {
      'dataInici': dataInici,
      'dataFi': dataFi,
      'gratuit': gratuit,
      'preuMax': preuMax,
      'latitud': latitud,
      'longitud': longitud,
      'radiKm': radiKm,
      'categories': categories,
    };

    if (shouldThrowOnFiltres) {
      throw Exception('Server error');
    }

    return cercarAmbFiltresResult ?? const SearchResults();
  }

  @override
  Future<List<String>> obtenirHistorial(String usuariId) async {
    historialCallCount++;
    lastHistorialUserId = usuariId;

    if (shouldThrowOnHistorial) {
      throw Exception('DB error');
    }

    return historialResult ?? [];
  }

  @override
  Future<List<ProfileSearchResult>> searchProfiles({
    required String query,
    required String userId,
  }) async {
    return const [];
  }

  @override
  Future<AirQualitySearchResult> cercaQualitatAire({
    required double lat,
    required double lng,
    double? radi,
    int? aqiMax,
  }) async {
    return const AirQualitySearchResult();
  }
}

// ============================================================
// Versió testable del SearchNotifier (sense StateNotifier/Riverpod)
// ============================================================
class TestableSearchNotifier {
  final CercaPredictivaUsecase _cercaPredictiva;
  final CercaAmbFiltresUsecase _cercaAmbFiltres;
  final ObtenirHistorialUsecase _obtenirHistorial;

  SearchState state = const SearchState();

  TestableSearchNotifier({
    required CercaPredictivaUsecase cercaPredictiva,
    required CercaAmbFiltresUsecase cercaAmbFiltres,
    required ObtenirHistorialUsecase obtenirHistorial,
  })  : _cercaPredictiva = cercaPredictiva,
        _cercaAmbFiltres = cercaAmbFiltres,
        _obtenirHistorial = obtenirHistorial;

  Future<void> cercar(String terme, {String? usuariId}) async {
    state = state.copyWith(terme: terme, isLoading: true, errorMessage: null);
    if (terme.length < 2) {
      state = state.copyWith(results: SearchResults.empty(), isLoading: false);
      return;
    }
    try {
      final results = await _cercaPredictiva(
        terme: terme,
        tipus: state.tipus,
        usuariId: usuariId,
      );
      state = state.copyWith(results: results, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error en la cerca. Torna-ho a intentar.',
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
    try {
      final results = await _cercaAmbFiltres(
        dataInici: dataInici,
        dataFi: dataFi,
        gratuit: gratuit,
        preuMax: preuMax,
        latitud: latitud,
        longitud: longitud,
        radiKm: radiKm,
        categories: categories,
      );
      state = state.copyWith(results: results, isLoading: false);
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
    } catch (_) {}
  }

  void canviarTipus(String tipus) {
    state = state.copyWith(tipus: tipus);
  }

  void netejarCerca() {
    state = const SearchState();
  }
}

// ============================================================
// TESTS
// ============================================================
void main() {
  late FakeSearchRepository fakeRepository;
  late TestableSearchNotifier notifier;

  setUp(() {
    fakeRepository = FakeSearchRepository();
    notifier = TestableSearchNotifier(
      cercaPredictiva: CercaPredictivaUsecase(fakeRepository),
      cercaAmbFiltres: CercaAmbFiltresUsecase(fakeRepository),
      obtenirHistorial: ObtenirHistorialUsecase(fakeRepository),
    );
  });

  // ==================== cercar ====================

  group('SearchNotifier.cercar', () {
    test('should not search if terme length < 2', () async {
      await notifier.cercar('a');

      expect(notifier.state.results.isEmpty, isTrue);
      expect(notifier.state.isLoading, isFalse);
      expect(fakeRepository.predictivaCallCount, 0);
    });

    test('should return empty results for single character', () async {
      await notifier.cercar('x');

      expect(notifier.state.results.activitats, isEmpty);
      expect(notifier.state.results.espais, isEmpty);
    });

    test('should return results for valid search term', () async {
      fakeRepository.cercaPredictivaResult = SearchResults(
        activitats: [
          const ActivitySearchResult(id: '1', titol: 'Concert de Jazz'),
        ],
        espais: [],
      );

      await notifier.cercar('jazz');

      expect(notifier.state.results.activitats.length, 1);
      expect(notifier.state.results.activitats.first.titol, 'Concert de Jazz');
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.errorMessage, isNull);
    });

    test('should send correct parameters to repository', () async {
      await notifier.cercar('teatre', usuariId: 'user-1');

      expect(fakeRepository.lastPredictivaCall?['terme'], 'teatre');
      expect(fakeRepository.lastPredictivaCall?['tipus'], 'tots');
      expect(fakeRepository.lastPredictivaCall?['usuariId'], 'user-1');
    });

    test('should set error message on exception', () async {
      fakeRepository.shouldThrowOnPredictiva = true;

      await notifier.cercar('test');

      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.errorMessage, isNotNull);
      expect(notifier.state.results.isEmpty, isTrue);
    });

    test('should update terme in state', () async {
      await notifier.cercar('teatre');

      expect(notifier.state.terme, 'teatre');
    });

    test('should call repository exactly once', () async {
      await notifier.cercar('concert');

      expect(fakeRepository.predictivaCallCount, 1);
    });
  });

  // ==================== aplicarFiltres ====================

  group('SearchNotifier.aplicarFiltres', () {
    test('should send gratuit=true to backend', () async {
      fakeRepository.cercarAmbFiltresResult = const SearchResults(
        activitats: [
          ActivitySearchResult(id: '1', titol: 'Festa Major', preu: 0),
        ],
      );

      await notifier.aplicarFiltres(gratuit: true);

      expect(fakeRepository.lastFiltresCall?['gratuit'], true);
      expect(fakeRepository.filtresCallCount, 1);
      expect(notifier.state.results.activitats.length, 1);
    });

    test('should send gratuit=false for paid events', () async {
      fakeRepository.cercarAmbFiltresResult = const SearchResults(
        activitats: [
          ActivitySearchResult(id: '2', titol: 'Concert', preu: 15.0),
        ],
      );

      await notifier.aplicarFiltres(gratuit: false);

      expect(fakeRepository.lastFiltresCall?['gratuit'], false);
    });

    test('should not send gratuit when null (Tots selected)', () async {
      await notifier.aplicarFiltres();

      expect(fakeRepository.lastFiltresCall?['gratuit'], isNull);
    });

    test('should send location data for distance filter', () async {
      await notifier.aplicarFiltres(
        latitud: 41.3851,
        longitud: 2.1734,
        radiKm: 15.0,
      );

      expect(fakeRepository.lastFiltresCall?['latitud'], 41.3851);
      expect(fakeRepository.lastFiltresCall?['longitud'], 2.1734);
      expect(fakeRepository.lastFiltresCall?['radiKm'], 15.0);
    });

    test('should send date range filters', () async {
      await notifier.aplicarFiltres(
        dataInici: '2026-04-01',
        dataFi: '2026-04-15',
      );

      expect(fakeRepository.lastFiltresCall?['dataInici'], '2026-04-01');
      expect(fakeRepository.lastFiltresCall?['dataFi'], '2026-04-15');
    });

    test('should combine multiple filters', () async {
      await notifier.aplicarFiltres(
        gratuit: true,
        dataInici: '2026-04-01',
        dataFi: '2026-04-01',
        latitud: 41.3851,
        longitud: 2.1734,
        radiKm: 10.0,
        categories: ['cat-musica'],
      );

      final call = fakeRepository.lastFiltresCall!;
      expect(call['gratuit'], true);
      expect(call['dataInici'], '2026-04-01');
      expect(call['latitud'], 41.3851);
      expect(call['radiKm'], 10.0);
      expect(call['categories'], ['cat-musica']);
    });

    test('should set error message when filters fail', () async {
      fakeRepository.shouldThrowOnFiltres = true;

      await notifier.aplicarFiltres(gratuit: true);

      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.errorMessage, isNotNull);
    });

    test('should clear previous error on new filter call', () async {
      fakeRepository.shouldThrowOnFiltres = true;
      await notifier.aplicarFiltres(gratuit: true);
      expect(notifier.state.errorMessage, isNotNull);

      fakeRepository.shouldThrowOnFiltres = false;
      await notifier.aplicarFiltres(gratuit: false);
      expect(notifier.state.errorMessage, isNull);
    });
  });

  // ==================== carregarHistorial ====================

  group('SearchNotifier.carregarHistorial', () {
    test('should load search history for user', () async {
      fakeRepository.historialResult = ['jazz', 'teatre', 'museu'];

      await notifier.carregarHistorial('user-123');

      expect(notifier.state.historial, ['jazz', 'teatre', 'museu']);
      expect(fakeRepository.lastHistorialUserId, 'user-123');
    });

    test('should return empty list for user without history', () async {
      fakeRepository.historialResult = [];

      await notifier.carregarHistorial('new-user');

      expect(notifier.state.historial, isEmpty);
    });

    test('should not crash if history fails', () async {
      fakeRepository.shouldThrowOnHistorial = true;

      await notifier.carregarHistorial('user-123');

      expect(notifier.state.historial, isEmpty);
    });
  });

  // ==================== canviarTipus ====================

  group('SearchNotifier.canviarTipus', () {
    test('should update search type to activitats', () {
      notifier.canviarTipus('activitats');
      expect(notifier.state.tipus, 'activitats');
    });

    test('should update search type to espais', () {
      notifier.canviarTipus('espais');
      expect(notifier.state.tipus, 'espais');
    });

    test('should update search type to tots', () {
      notifier.canviarTipus('activitats');
      notifier.canviarTipus('tots');
      expect(notifier.state.tipus, 'tots');
    });
  });

  // ==================== netejarCerca ====================

  group('SearchNotifier.netejarCerca', () {
    test('should reset all state to defaults', () async {
      fakeRepository.cercaPredictivaResult = const SearchResults(
        activitats: [
          ActivitySearchResult(id: '1', titol: 'Test'),
        ],
      );

      await notifier.cercar('test');
      expect(notifier.state.results.activitats.length, 1);

      notifier.netejarCerca();

      expect(notifier.state.terme, '');
      expect(notifier.state.tipus, 'tots');
      expect(notifier.state.results.isEmpty, isTrue);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.errorMessage, isNull);
    });

    test('should clear error messages', () async {
      fakeRepository.shouldThrowOnPredictiva = true;
      await notifier.cercar('test');
      expect(notifier.state.errorMessage, isNotNull);

      notifier.netejarCerca();
      expect(notifier.state.errorMessage, isNull);
    });
  });
}