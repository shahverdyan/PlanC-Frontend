import '../../domain/entities/search_result.dart';
import '../../domain/repositories/i_search_repository.dart';
import '../datasources/search_remote_data_source.dart';
import '../models/profile_search_result.dart';

class SearchRepositoryImpl implements ISearchRepository {
  final SearchRemoteDataSource dataSource;

  const SearchRepositoryImpl(this.dataSource);

  @override
  Future<SearchResults> cercaPredictiva({
    required String terme,
    String tipus = 'tots',
    String? usuariId,
  }) {
    return dataSource.cercaPredictiva(
      terme: terme,
      tipus: tipus,
      usuariId: usuariId,
    );
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
  }) {
    return dataSource.cercarAmbFiltres(
      dataInici: dataInici,
      dataFi: dataFi,
      gratuit: gratuit,
      preuMax: preuMax,
      latitud: latitud,
      longitud: longitud,
      radiKm: radiKm,
      categories: categories,
    );
  }

  @override
  Future<List<String>> obtenirHistorial(String usuariId) {
    return dataSource.obtenirHistorial(usuariId);
  }

  @override
  Future<List<ProfileSearchResult>> searchProfiles({
    required String query,
    required String userId,
  }) {
    return dataSource.searchProfiles(query: query, userId: userId);
  }

  @override
  Future<AirQualitySearchResult> cercaQualitatAire({
    required double lat,
    required double lng,
    double? radi,
    int? aqiMax,
  }) {
    return dataSource.cercaQualitatAire(
      lat: lat,
      lng: lng,
      radi: radi,
      aqiMax: aqiMax,
    );
  }
}