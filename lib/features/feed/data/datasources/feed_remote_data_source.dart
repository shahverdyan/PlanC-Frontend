import 'package:dio/dio.dart';
import 'package:plan_c_frontend/core/config/app_config.dart';
import '../models/feed_activity.dart';
import '../models/feed_category.dart';
import '../models/paginated_response.dart';

class FeedRemoteDataSource {
  final Dio _dio;

  FeedRemoteDataSource()
      : _dio = Dio(BaseOptions(baseUrl: AppConfig.baseUrl));

  Future<List<FeedActivity>> getTrending() async {
    try {
      final response = await _dio.get('descobriment/tendencies');
      final list = response.data as List;
      return list
          .map((e) => FeedActivity.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error carregant tendències: $e');
    }
  }

  Future<List<FeedCategory>> getCategories() async {
    try {
      final response = await _dio.get('descobriment/categories');
      final list = response.data as List;
      return list
          .map((e) => FeedCategory.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error carregant categories: $e');
    }
  }

  Future<PaginatedResponse<FeedActivity>> getRecommended({
    required String userId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        'descobriment/recomanades',
        queryParameters: {'page': page, 'limit': limit},
        options: Options(headers: {'usuari-id': userId}),
      );
      return PaginatedResponse.fromJson(
        response.data as Map<String, dynamic>,
        FeedActivity.fromJson,
      );
    } catch (e) {
      throw Exception('Error carregant recomanades: $e');
    }
  }

  Future<PaginatedResponse<FeedActivity>> getActivitiesByCategory({
    required String categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        'descobriment/categories/$categoryId/activitats',
        queryParameters: {'page': page, 'limit': limit},
      );
      return PaginatedResponse.fromJson(
        response.data as Map<String, dynamic>,
        FeedActivity.fromJson,
      );
    } catch (e) {
      throw Exception('Error carregant activitats de la categoria: $e');
    }
  }

  Future<PaginatedResponse<FeedActivity>> getNearby({
    required double lat,
    required double lng,
    int radiusMeters = 5000,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        'descobriment/properes',
        queryParameters: {
          'lat': lat,
          'lng': lng,
          'radiMetres': radiusMeters,
          'page': page,
          'limit': limit,
        },
      );
      return PaginatedResponse.fromJson(
        response.data as Map<String, dynamic>,
        FeedActivity.fromJson,
      );
    } catch (e) {
      throw Exception('Error carregant activitats properes: $e');
    }
  }
}
