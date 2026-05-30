import '../../data/models/feed_activity.dart';
import '../../data/models/feed_category.dart';
import '../../data/models/paginated_response.dart';

abstract class IFeedRepository {
  Future<List<FeedActivity>> getTrending();

  Future<List<FeedCategory>> getCategories();

  Future<PaginatedResponse<FeedActivity>> getRecommended({
    required String userId,
    int page = 1,
    int limit = 20,
  });

  Future<PaginatedResponse<FeedActivity>> getActivitiesByCategory({
    required String categoryId,
    int page = 1,
    int limit = 20,
  });

  Future<PaginatedResponse<FeedActivity>> getNearby({
    required double lat,
    required double lng,
    int radiusMeters = 5000,
    int page = 1,
    int limit = 20,
  });
}
