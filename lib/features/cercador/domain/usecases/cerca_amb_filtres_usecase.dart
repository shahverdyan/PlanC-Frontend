import '../entities/search_result.dart';
import '../repositories/i_search_repository.dart';

class CercaAmbFiltresUsecase {
  final ISearchRepository repository;

  const CercaAmbFiltresUsecase(this.repository);

  Future<SearchResults> call({
    String? dataInici,
    String? dataFi,
    bool? gratuit,
    double? preuMax,
    double? latitud,
    double? longitud,
    double? radiKm,
    List<String>? categories,
  }) {
    return repository.cercarAmbFiltres(
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
}