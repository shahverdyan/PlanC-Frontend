import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/providers/location_provider.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/map/presentation/services/location_service.dart';
import '../../data/datasources/feed_remote_data_source.dart';
import '../../data/models/feed_activity.dart';
import '../../data/models/feed_category.dart';
import '../../data/repositories/feed_repository_impl.dart';
import '../../domain/repositories/i_feed_repository.dart';

final feedRepositoryProvider = Provider<IFeedRepository>((ref) {
  return FeedRepositoryImpl(FeedRemoteDataSource());
});

final trendingProvider = FutureProvider.autoDispose<List<FeedActivity>>((ref) {
  return ref.watch(feedRepositoryProvider).getTrending();
});

final categoriesProvider =
    FutureProvider.autoDispose<List<FeedCategory>>((ref) {
  return ref.watch(feedRepositoryProvider).getCategories();
});

final recommendedProvider =
    FutureProvider.autoDispose<List<FeedActivity>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null || userId.isEmpty) return [];
  final result = await ref
      .watch(feedRepositoryProvider)
      .getRecommended(userId: userId);
  return result.data;
});

final nearbyProvider =
    FutureProvider.autoDispose<List<FeedActivity>>((ref) async {
  final locationService = ref.watch(locationServiceProvider);
  final repository = ref.watch(feedRepositoryProvider);
  try {
    final result = await locationService.obtenirUbicacioActual();
    if (result.estat != EstatPermisUbicacio.concedit ||
        result.position == null) {
      return [];
    }
    final pos = result.position!;
    final paginated =
        await repository.getNearby(lat: pos.latitude, lng: pos.longitude);
    return paginated.data;
  } catch (_) {
    return [];
  }
});
