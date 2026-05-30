import '../../domain/repositories/i_feed_repository.dart';
import '../datasources/feed_remote_data_source.dart';
import '../models/feed_activity.dart';
import '../models/feed_category.dart';
import '../models/paginated_response.dart';

class FeedRepositoryImpl implements IFeedRepository {
  final FeedRemoteDataSource _dataSource;

  const FeedRepositoryImpl(this._dataSource);

  @override
  Future<List<FeedActivity>> getTrending() => _dataSource.getTrending();

  @override
  Future<List<FeedCategory>> getCategories() => _dataSource.getCategories();

  @override
  Future<PaginatedResponse<FeedActivity>> getRecommended({
    required String userId,
    int page = 1,
    int limit = 20,
  }) =>
      _dataSource.getRecommended(userId: userId, page: page, limit: limit);

  @override
  Future<PaginatedResponse<FeedActivity>> getActivitiesByCategory({
    required String categoryId,
    int page = 1,
    int limit = 20,
  }) =>
      _dataSource.getActivitiesByCategory(
          categoryId: categoryId, page: page, limit: limit);

  @override
  Future<PaginatedResponse<FeedActivity>> getNearby({
    required double lat,
    required double lng,
    int radiusMeters = 5000,
    int page = 1,
    int limit = 20,
  }) =>
      _dataSource.getNearby(
        lat: lat,
        lng: lng,
        radiusMeters: radiusMeters,
        page: page,
        limit: limit,
      );
}
