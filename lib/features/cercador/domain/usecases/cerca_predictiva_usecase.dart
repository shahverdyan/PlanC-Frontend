import '../entities/search_result.dart';
import '../repositories/i_search_repository.dart';

class CercaPredictivaUsecase {
  final ISearchRepository repository;

  const CercaPredictivaUsecase(this.repository);

  Future<SearchResults> call({
    required String terme,
    String tipus = 'tots',
    String? usuariId,
  }) {
    return repository.cercaPredictiva(
      terme: terme,
      tipus: tipus,
      usuariId: usuariId,
    );
  }
}