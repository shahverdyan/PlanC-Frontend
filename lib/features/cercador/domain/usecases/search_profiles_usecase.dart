import '../repositories/i_search_repository.dart';
import '../../data/models/profile_search_result.dart';

class SearchProfilesUsecase {
  final ISearchRepository repository;

  const SearchProfilesUsecase(this.repository);

  Future<List<ProfileSearchResult>> call({
    required String query,
    required String userId,
  }) {
    return repository.searchProfiles(query: query, userId: userId);
  }
}
