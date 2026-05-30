import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plan_c_frontend/features/activitats/presentation/screens/activitat_detail_screen.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import '../../data/models/feed_activity.dart';
import '../providers/category_activities_provider.dart';

class CategoryActivitiesScreen extends ConsumerStatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryActivitiesScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  ConsumerState<CategoryActivitiesScreen> createState() =>
      _CategoryActivitiesScreenState();
}

class _CategoryActivitiesScreenState
    extends ConsumerState<CategoryActivitiesScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(categoryActivitiesProvider(widget.categoryId).notifier)
          .loadInitial();
    });
  }

  void _onScroll() {
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      ref
          .read(categoryActivitiesProvider(widget.categoryId).notifier)
          .loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToDetail(FeedActivity activity) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ActivitatDetailByIdScreen(
          activitatId: activity.id,
          preu: activity.preu,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final state =
        ref.watch(categoryActivitiesProvider(widget.categoryId));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        elevation: 0,
      ),
      body: _buildBody(context, t, state),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations t,
    CategoryActivitiesState state,
  ) {
    if (state.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
      );
    }

    if (state.errorMessage != null && state.activities.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: 16),
              Text(
                t.feedLoadError,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(categoryActivitiesProvider(widget.categoryId)
                        .notifier)
                    .loadInitial(),
                child: Text(t.feedRetry),
              ),
            ],
          ),
        ),
      );
    }

    if (state.activities.isEmpty) {
      return Center(
        child: Text(
          t.feedNoCategoryActivities,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      );
    }

    final itemCount = state.activities.length +
        (state.isLoadingMore || !state.hasMore ? 1 : 0);

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (_, i) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == state.activities.length) {
          if (state.isLoadingMore) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Theme.of(context).colorScheme.primary),
              ),
            );
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                t.feedNoMoreActivities,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
              ),
            ),
          );
        }
        final activity = state.activities[index];
        return _ActivityListItem(
          activity: activity,
          onTap: () => _navigateToDetail(activity),
        );
      },
    );
  }
}

// ── Ítem de llista ────────────────────────────────────────────────────────────

class _ActivityListItem extends StatelessWidget {
  final FeedActivity activity;
  final VoidCallback onTap;

  const _ActivityListItem({required this.activity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final dateLabel =
        DateFormat('d MMM · HH:mm').format(activity.dataInici);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(12)),
              child: _buildImage(context),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.titol,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateLabel,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
                    ),
                    if (activity.espaiLocalitat != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        activity.espaiLocalitat!,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11),
                      ),
                    ],
                    const SizedBox(height: 6),
                    _PriceBadge(
                        esGratuit: activity.esGratuit,
                        preu: activity.preu,
                        t: t),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final url = activity.imatgePrincipal;
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (ctx, error, _) => _placeholder(ctx),
      );
    }
    return _placeholder(context);
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(Icons.image_not_supported_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  final bool esGratuit;
  final double? preu;
  final AppLocalizations t;

  const _PriceBadge(
      {required this.esGratuit, required this.t, this.preu});

  @override
  Widget build(BuildContext context) {
    final String label;
    final Color bgColor;
    final Color textColor;

    if (esGratuit) {
      label = t.feedFree;
      bgColor = Colors.green.withValues(alpha: 0.12);
      textColor = Colors.green.shade700;
    } else if (preu != null) {
      label = '${preu!.toStringAsFixed(0)}€';
      bgColor = Theme.of(context).colorScheme.primary.withValues(alpha: 0.12);
      textColor = Theme.of(context).colorScheme.primary;
    } else {
      label = t.feedInfoUnavailable;
      bgColor = Theme.of(context).colorScheme.surfaceContainerHighest;
      textColor = Theme.of(context).colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }
}
