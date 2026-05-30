import '../entities/search_result.dart';
import '../../data/models/profile_search_result.dart';

abstract class ISearchRepository {
  /// Cerca predictiva mentre l'usuari escriu
  Future<SearchResults> cercaPredictiva({
    required String terme,
    String tipus = 'tots',
    String? usuariId,
  });

  /// Cerca amb filtres aplicats
  Future<SearchResults> cercarAmbFiltres({
    String? dataInici,
    String? dataFi,
    bool? gratuit,
    double? preuMax,
    double? latitud,
    double? longitud,
    double? radiKm,
    List<String>? categories,
  });

  /// Historial de cerques recents de l'usuari
  Future<List<String>> obtenirHistorial(String usuariId);

  /// Cerca perfils d'usuaris per nom o username
  Future<List<ProfileSearchResult>> searchProfiles({
    required String query,
    required String userId,
  });

  /// Cerca activitats per qualitat de l'aire
  Future<AirQualitySearchResult> cercaQualitatAire({
    required double lat,
    required double lng,
    double? radi,
    int? aqiMax,
  });
}