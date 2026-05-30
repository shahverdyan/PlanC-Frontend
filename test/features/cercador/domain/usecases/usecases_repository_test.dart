import 'package:flutter_test/flutter_test.dart';
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
  SearchResults? cercaPredictivaResult;
  SearchResults? cercarAmbFiltresResult;
  List<String>? historialResult;

  Map<String, dynamic>? lastPredictivaCall;
  Map<String, dynamic>? lastFiltresCall;
  String? lastHistorialUserId;

  bool shouldThrowOnPredictiva = false;
  bool shouldThrowOnFiltres = false;
  bool shouldThrowOnHistorial = false;

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
    if (shouldThrowOnPredictiva) throw Exception('Network error');
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
    if (shouldThrowOnFiltres) throw Exception('Server error');
    return cercarAmbFiltresResult ?? const SearchResults();
  }

  @override
  Future<List<String>> obtenirHistorial(String usuariId) async {
    historialCallCount++;
    lastHistorialUserId = usuariId;
    if (shouldThrowOnHistorial) throw Exception('DB error');
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
// TESTS
// ============================================================
void main() {
  late FakeSearchRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeSearchRepository();
  });

  // ==================== CercaPredictivaUsecase ====================

  group('CercaPredictivaUsecase', () {
    late CercaPredictivaUsecase usecase;

    setUp(() {
      usecase = CercaPredictivaUsecase(fakeRepository);
    });

    test('should delegate to repository with correct parameters', () async {
      fakeRepository.cercaPredictivaResult = SearchResults(
        activitats: [
          const ActivitySearchResult(id: '1', titol: 'Concert'),
        ],
      );

      final result = await usecase(
        terme: 'concert',
        tipus: 'activitats',
        usuariId: 'user-1',
      );

      expect(result.activitats.length, 1);
      expect(result.activitats.first.id, '1');
      expect(fakeRepository.lastPredictivaCall?['terme'], 'concert');
      expect(fakeRepository.lastPredictivaCall?['tipus'], 'activitats');
      expect(fakeRepository.lastPredictivaCall?['usuariId'], 'user-1');
      expect(fakeRepository.predictivaCallCount, 1);
    });

    test('should use default values for tipus and usuariId', () async {
      await usecase(terme: 'jazz');

      expect(fakeRepository.lastPredictivaCall?['terme'], 'jazz');
      expect(fakeRepository.lastPredictivaCall?['tipus'], 'tots');
      expect(fakeRepository.lastPredictivaCall?['usuariId'], isNull);
    });

    test('should return both activitats and espais', () async {
      fakeRepository.cercaPredictivaResult = SearchResults(
        activitats: [
          const ActivitySearchResult(id: '1', titol: 'Concert de Jazz'),
        ],
        espais: [
          const SpaceSearchResult(id: 'e1', nom: 'Palau de la Música'),
        ],
      );

      final result = await usecase(terme: 'palau');

      expect(result.activitats.length, 1);
      expect(result.espais.length, 1);
      expect(result.espais.first.nom, 'Palau de la Música');
    });

    test('should return empty results when no matches', () async {
      fakeRepository.cercaPredictivaResult = const SearchResults();

      final result = await usecase(terme: 'xyznonexistent');

      expect(result.isEmpty, isTrue);
    });

    test('should propagate repository exceptions', () async {
      fakeRepository.shouldThrowOnPredictiva = true;

      expect(
        () => usecase(terme: 'error'),
        throwsA(isA<Exception>()),
      );
    });
  });

  // ==================== CercaAmbFiltresUsecase ====================

  group('CercaAmbFiltresUsecase', () {
    late CercaAmbFiltresUsecase usecase;

    setUp(() {
      usecase = CercaAmbFiltresUsecase(fakeRepository);
    });

    test('should filter by gratuit=true', () async {
      fakeRepository.cercarAmbFiltresResult = const SearchResults(
        activitats: [
          ActivitySearchResult(id: '1', titol: 'Exposició gratuïta', preu: 0),
          ActivitySearchResult(id: '2', titol: 'Festa Major', preu: 0),
        ],
      );

      final result = await usecase(gratuit: true);

      expect(result.activitats.length, 2);
      expect(fakeRepository.lastFiltresCall?['gratuit'], true);
    });

    test('should filter by gratuit=false for paid events', () async {
      fakeRepository.cercarAmbFiltresResult = const SearchResults(
        activitats: [
          ActivitySearchResult(id: '3', titol: 'Concert', preu: 25.0),
        ],
      );

      final result = await usecase(gratuit: false);

      expect(result.activitats.length, 1);
      expect(result.activitats.first.preu, 25.0);
      expect(fakeRepository.lastFiltresCall?['gratuit'], false);
    });

    test('should send null gratuit when no price filter', () async {
      await usecase();

      expect(fakeRepository.lastFiltresCall?['gratuit'], isNull);
    });

    test('should filter by date range', () async {
      await usecase(dataInici: '2026-04-01', dataFi: '2026-04-30');

      expect(fakeRepository.lastFiltresCall?['dataInici'], '2026-04-01');
      expect(fakeRepository.lastFiltresCall?['dataFi'], '2026-04-30');
    });

    test('should filter by location and radius', () async {
      await usecase(
        latitud: 41.3851,
        longitud: 2.1734,
        radiKm: 10.0,
      );

      expect(fakeRepository.lastFiltresCall?['latitud'], 41.3851);
      expect(fakeRepository.lastFiltresCall?['longitud'], 2.1734);
      expect(fakeRepository.lastFiltresCall?['radiKm'], 10.0);
    });

    test('should filter by categories', () async {
      await usecase(categories: ['cat-musica', 'cat-teatre']);

      expect(
        fakeRepository.lastFiltresCall?['categories'],
        ['cat-musica', 'cat-teatre'],
      );
    });

    test('should combine multiple filters', () async {
      await usecase(
        dataInici: '2026-04-01',
        dataFi: '2026-04-01',
        gratuit: true,
        latitud: 41.3851,
        longitud: 2.1734,
        radiKm: 5.0,
        categories: ['cat-musica'],
      );

      final call = fakeRepository.lastFiltresCall!;
      expect(call['dataInici'], '2026-04-01');
      expect(call['gratuit'], true);
      expect(call['latitud'], 41.3851);
      expect(call['radiKm'], 5.0);
      expect(call['categories'], ['cat-musica']);
      expect(fakeRepository.filtresCallCount, 1);
    });

    test('should propagate repository exceptions', () async {
      fakeRepository.shouldThrowOnFiltres = true;

      expect(
        () => usecase(gratuit: true),
        throwsA(isA<Exception>()),
      );
    });

    test('should filter by preuMax', () async {
      await usecase(preuMax: 20.0);

      expect(fakeRepository.lastFiltresCall?['preuMax'], 20.0);
    });
  });

  // ==================== ObtenirHistorialUsecase ====================

  group('ObtenirHistorialUsecase', () {
    late ObtenirHistorialUsecase usecase;

    setUp(() {
      usecase = ObtenirHistorialUsecase(fakeRepository);
    });

    test('should return search history for user', () async {
      fakeRepository.historialResult = ['jazz', 'teatre'];

      final result = await usecase('user-1');

      expect(result, ['jazz', 'teatre']);
      expect(fakeRepository.lastHistorialUserId, 'user-1');
      expect(fakeRepository.historialCallCount, 1);
    });

    test('should return empty list for user without history', () async {
      fakeRepository.historialResult = [];

      final result = await usecase('new-user');

      expect(result, isEmpty);
    });

    test('should propagate exceptions', () async {
      fakeRepository.shouldThrowOnHistorial = true;

      expect(
        () => usecase('user-1'),
        throwsA(isA<Exception>()),
      );
    });

    test('should pass correct userId', () async {
      await usecase('user-abc-123');

      expect(fakeRepository.lastHistorialUserId, 'user-abc-123');
    });
  });
}