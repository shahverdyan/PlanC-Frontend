import '../entities/search_result.dart';
import '../repositories/i_search_repository.dart';

class CercaQualitatAireUsecase {
  final ISearchRepository repository;

  const CercaQualitatAireUsecase(this.repository);

  Future<AirQualitySearchResult> call({
    required double lat,
    required double lng,
    double? radi,
    int? aqiMax,
  }) {
    return repository.cercaQualitatAire(
      lat: lat,
      lng: lng,
      radi: radi,
      aqiMax: aqiMax,
    );
  }
}
