import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/feed_activity.dart';
import '../../domain/repositories/i_feed_repository.dart';
import 'feed_providers.dart';

// ── Estat ────────────────────────────────────────────────────────────────────

class CategoryActivitiesState {
  final List<FeedActivity> activities;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final String? errorMessage;

  const CategoryActivitiesState({
    this.activities = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 0,
    this.errorMessage,
  });

  CategoryActivitiesState copyWith({
    List<FeedActivity>? activities,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
  }) {
    return CategoryActivitiesState(
      activities: activities ?? this.activities,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage,
    );
  }
}

// ── Notifier ─────────────────────────────────────────────────────────────────

class CategoryActivitiesNotifier
    extends StateNotifier<CategoryActivitiesState> {
  final String _categoryId;
  final IFeedRepository _repo;

  CategoryActivitiesNotifier(this._categoryId, this._repo)
      : super(const CategoryActivitiesState());

  Future<void> loadInitial() async {
    if (state.isLoading) return;
    state = const CategoryActivitiesState(isLoading: true);
    try {
      final result = await _repo.getActivitiesByCategory(
        categoryId: _categoryId,
        page: 1,
      );
      state = CategoryActivitiesState(
        activities: result.data,
        hasMore: result.hasMore,
        currentPage: 1,
      );
    } catch (e) {
      state = CategoryActivitiesState(errorMessage: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final result = await _repo.getActivitiesByCategory(
        categoryId: _categoryId,
        page: state.currentPage + 1,
      );
      state = CategoryActivitiesState(
        activities: [...state.activities, ...result.data],
        hasMore: result.hasMore,
        currentPage: state.currentPage + 1,
      );
    } catch (_) {
      state = state.copyWith(isLoadingMore: false);
    }
  }
}

// ── Provider ─────────────────────────────────────────────────────────────────

final categoryActivitiesProvider = StateNotifierProvider.family
    .autoDispose<CategoryActivitiesNotifier, CategoryActivitiesState, String>(
  (ref, categoryId) => CategoryActivitiesNotifier(
    categoryId,
    ref.watch(feedRepositoryProvider),
  ),
);
