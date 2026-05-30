class PaginatedResponse<T> {
  final List<T> data;
  final int total;
  final int page;
  final int lastPage;
  final bool hasMore;

  const PaginatedResponse({
    required this.data,
    required this.total,
    required this.page,
    required this.lastPage,
    required this.hasMore,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    final rawData = json['data'] as List? ?? [];
    return PaginatedResponse<T>(
      data: rawData
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      total: (meta['total'] as num?)?.toInt() ?? 0,
      page: (meta['page'] as num?)?.toInt() ?? 1,
      lastPage: (meta['lastPage'] as num?)?.toInt() ?? 1,
      hasMore: meta['hasMore'] as bool? ?? false,
    );
  }
}
