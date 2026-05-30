import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import '../providers/publications_feed_provider.dart';
import 'publication_card.dart';

class PublicationsFeedContent extends ConsumerStatefulWidget {
  final ScrollController? scrollController;

  const PublicationsFeedContent({super.key, this.scrollController});

  @override
  ConsumerState<PublicationsFeedContent> createState() =>
      _PublicationsFeedContentState();
}

class _PublicationsFeedContentState
    extends ConsumerState<PublicationsFeedContent> {
  ScrollController? _internalController;

  ScrollController get _effectiveController =>
      widget.scrollController ?? (_internalController ??= ScrollController());

  @override
  void initState() {
    super.initState();
    _effectiveController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(publicationsFeedProvider.notifier).loadInitial();
    });
  }

  @override
  void didUpdateWidget(covariant PublicationsFeedContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController?.removeListener(_onScroll);
      _effectiveController.addListener(_onScroll);
    }
  }

  void _onScroll() {
    final pos = _effectiveController.position;
    if (pos.pixels >= pos.maxScrollExtent - 300) {
      ref.read(publicationsFeedProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_onScroll);
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final state = ref.watch(publicationsFeedProvider);

    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.orange500),
      );
    }

    if (state.error != null && state.publications.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: 16),
              Text(
                t.feedPublicationsError,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(publicationsFeedProvider.notifier).loadInitial(),
                child: Text(t.feedPublicationsRetry),
              ),
            ],
          ),
        ),
      );
    }

    if (state.publications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined,
                size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              t.feedNoPublications,
              style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.orange500,
      onRefresh: () =>
          ref.read(publicationsFeedProvider.notifier).loadInitial(),
      child: ListView.builder(
        controller: _effectiveController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.publications.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.publications.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.orange500,
                ),
              ),
            );
          }
          return PublicationCard(publication: state.publications[index]);
        },
      ),
    );
  }
}
