import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/providers/dio_provider.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import '../../domain/models/publicacio_detall.dart';

class PublicationsFeedState {
  final List<PublicacioDetall> publications;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentSkip;
  final String? error;

  const PublicationsFeedState({
    this.publications = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentSkip = 0,
    this.error,
  });

  PublicationsFeedState copyWith({
    List<PublicacioDetall>? publications,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentSkip,
    String? error,
    bool clearError = false,
  }) {
    return PublicationsFeedState(
      publications: publications ?? this.publications,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentSkip: currentSkip ?? this.currentSkip,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class PublicationsFeedNotifier extends StateNotifier<PublicationsFeedState> {
  final Ref _ref;
  static const _take = 10;

  PublicationsFeedNotifier(this._ref) : super(const PublicationsFeedState());

  Future<void> loadInitial() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final items = await _fetchFeed(skip: 0);
      state = PublicationsFeedState(
        publications: items,
        hasMore: items.length >= _take,
        currentSkip: items.length,
      );
    } catch (e) {
      debugPrint('[PublicationsFeed] ERROR: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final items = await _fetchFeed(skip: state.currentSkip);
      state = state.copyWith(
        publications: [...state.publications, ...items],
        isLoadingMore: false,
        hasMore: items.length >= _take,
        currentSkip: state.currentSkip + items.length,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  Future<List<PublicacioDetall>> _fetchFeed({required int skip}) async {
    final dio = _ref.read(dioProvider);
    final userId = _ref.read(currentUserIdProvider);
    final response = await dio.get(
      '/publicacio/feed',
      queryParameters: {'skip': skip, 'take': _take},
      options: Options(headers: {'usuari-id': userId ?? ''}),
    );
    debugPrint('[PublicationsFeed] status=${response.statusCode} data type=${response.data.runtimeType}');
    final dynamic raw = response.data;
    final List<dynamic> list;
    if (raw is List) {
      list = raw;
    } else if (raw is Map && raw.containsKey('data')) {
      list = raw['data'] as List<dynamic>;
    } else {
      list = [];
    }
    return list
        .map((e) => PublicacioDetall.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

final publicationsFeedProvider =
    StateNotifierProvider.autoDispose<PublicationsFeedNotifier, PublicationsFeedState>(
  (ref) => PublicationsFeedNotifier(ref),
);
