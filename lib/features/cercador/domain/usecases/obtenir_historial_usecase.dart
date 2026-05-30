import '../repositories/i_search_repository.dart';

class ObtenirHistorialUsecase {
  final ISearchRepository repository;

  const ObtenirHistorialUsecase(this.repository);

  Future<List<String>> call(String usuariId) {
    return repository.obtenirHistorial(usuariId);
  }
}