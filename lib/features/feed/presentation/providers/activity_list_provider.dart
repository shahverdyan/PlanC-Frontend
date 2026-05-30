import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/feed_activity.dart';
import '../../data/models/paginated_response.dart';
import '../../domain/repositories/i_feed_repository.dart';
import 'feed_providers.dart';

// ── Tipus de llista ───────────────────────────────────────────────────────────

enum FeedListType { recommended, nearby }

// ── Estat ────────────────────────────────────────────────────────────────────

class ActivityListState {
  final List<FeedActivity> activities;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final String? errorMessage;

  const ActivityListState({
    this.activities = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 0,
    this.errorMessage,
  });

  ActivityListState copyWith({
    List<FeedActivity>? activities,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
  }) {
    return ActivityListState(
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

class ActivityListNotifier extends StateNotifier<ActivityListState> {
  final IFeedRepository _repository;
  final FeedListType _type;

  String? _userId;
  double? _lat;
  double? _lng;

  ActivityListNotifier(this._repository, this._type)
      : super(const ActivityListState());

  Future<void> loadInitial({
    String? userId,
    double? lat,
    double? lng,
  }) async {
    _userId = userId;
    _lat = lat;
    _lng = lng;

    state = const ActivityListState(isLoading: true);
    try {
      final result = await _fetchPage(1);
      if (result == null) {
        state = const ActivityListState(hasMore: false);
        return;
      }
      state = ActivityListState(
        activities: result.data,
        hasMore: result.hasMore,
        currentPage: 1,
      );
    } catch (e) {
      state = ActivityListState(errorMessage: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final result = await _fetchPage(state.currentPage + 1);
      if (result == null) {
        state = state.copyWith(isLoadingMore: false, hasMore: false);
        return;
      }
      state = ActivityListState(
        activities: [...state.activities, ...result.data],
        hasMore: result.hasMore,
        currentPage: state.currentPage + 1,
      );
    } catch (_) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  Future<PaginatedResponse<FeedActivity>?> _fetchPage(int page) async {
    if (_type == FeedListType.recommended) {
      if (_userId == null || _userId!.isEmpty) return null;
      return _repository.getRecommended(userId: _userId!, page: page);
    } else {
      if (_lat == null || _lng == null) return null;
      return _repository.getNearby(lat: _lat!, lng: _lng!, page: page);
    }
  }
}

// ── Provider ─────────────────────────────────────────────────────────────────

final activityListProvider = StateNotifierProvider.family
    .autoDispose<ActivityListNotifier, ActivityListState, FeedListType>(
  (ref, type) => ActivityListNotifier(
    ref.watch(feedRepositoryProvider),
    type,
  ),
);
