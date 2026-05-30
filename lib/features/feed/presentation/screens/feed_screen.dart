import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/features/activitats/presentation/screens/activitat_detail_screen.dart';
import 'package:plan_c_frontend/features/groups/presentation/providers/all_groups_provider.dart';
import 'package:plan_c_frontend/features/groups/presentation/widgets/quedades_feed_section.dart';
import 'package:plan_c_frontend/features/navigation/domain/navigation_provider.dart';
import 'package:plan_c_frontend/features/publicacions/presentation/providers/publications_feed_provider.dart';
import 'package:plan_c_frontend/features/publicacions/presentation/widgets/publications_feed_content.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import '../../data/models/feed_activity.dart';
import '../providers/activity_list_provider.dart';
import '../providers/feed_providers.dart';
import '../widgets/activity_section.dart';
import '../widgets/category_selector.dart';
import '../widgets/trending_carousel.dart';
import 'activity_list_screen.dart';
import 'category_activities_screen.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  int _selectedTab = 0;
  bool _showTabs = true;

  final _activitiesScrollController = ScrollController();
  final _publicationsScrollController = ScrollController();

  @override
  void dispose() {
    _activitiesScrollController.dispose();
    _publicationsScrollController.dispose();
    super.dispose();
  }

  void _scrollToTopAndRefresh() {
    final controller = _selectedTab == 0
        ? _activitiesScrollController
        : _publicationsScrollController;
    if (controller.hasClients) {
      controller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
    if (_selectedTab == 0) {
      ref.invalidate(trendingProvider);
      ref.invalidate(categoriesProvider);
      ref.invalidate(recommendedProvider);
      ref.invalidate(nearbyProvider);
      ref.invalidate(allGroupsProvider);
    } else {
      ref.read(publicationsFeedProvider.notifier).loadInitial();
    }
    setState(() => _showTabs = true);
  }

  void _navigateToDetail(BuildContext context, FeedActivity activity) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ActivitatDetailByIdScreen(
          activitatId: activity.id,
          preu: activity.preu,
          imatge: activity.imatgePrincipal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    ref.listen(feedScrollToTopProvider, (prev, next) {
      if (prev != next) _scrollToTopAndRefresh();
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ClipRect(
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.topCenter,
                heightFactor: _showTabs ? 1.0 : 0.0,
                child: _FeedTabs(
                  selectedIndex: _selectedTab,
                  onTabChanged: (i) => setState(() => _selectedTab = i),
                ),
              ),
            ),
            Expanded(
              child: NotificationListener<UserScrollNotification>(
                onNotification: (notification) {
                  if (notification.direction == ScrollDirection.reverse &&
                      _showTabs) {
                    setState(() => _showTabs = false);
                  } else if (notification.direction ==
                          ScrollDirection.forward &&
                      !_showTabs) {
                    setState(() => _showTabs = true);
                  }
                  return false;
                },
                child: IndexedStack(
                  index: _selectedTab,
                  children: [
                    _ActivitiesFeedContent(
                      scrollController: _activitiesScrollController,
                      onNavigateToDetail: (a) =>
                          _navigateToDetail(context, a),
                      t: t,
                    ),
                    PublicationsFeedContent(
                      scrollController: _publicationsScrollController,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const _FeedTabs({required this.selectedIndex, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final labels = [t.feedTabActivities, t.feedTabPublications];

    return Row(
      children: List.generate(labels.length, (i) {
        final isActive = i == selectedIndex;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTabChanged(i),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Container(
                  height: 2.5,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color:
                        isActive ? AppColors.orange500 : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _ActivitiesFeedContent extends ConsumerWidget {
  final ScrollController scrollController;
  final void Function(FeedActivity) onNavigateToDetail;
  final AppLocalizations t;

  const _ActivitiesFeedContent({
    required this.scrollController,
    required this.onNavigateToDetail,
    required this.t,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trending = ref.watch(trendingProvider);
    final categories = ref.watch(categoriesProvider);
    final recommended = ref.watch(recommendedProvider);
    final nearby = ref.watch(nearbyProvider);

    return RefreshIndicator(
      color: AppColors.orange500,
      onRefresh: () async {
        ref.invalidate(trendingProvider);
        ref.invalidate(categoriesProvider);
        ref.invalidate(recommendedProvider);
        ref.invalidate(nearbyProvider);
        ref.invalidate(allGroupsProvider);
      },
      child: SingleChildScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tendències
            const SizedBox(height: 16),
            _SectionTitle(t.feedTrending),
            const SizedBox(height: 8),
            trending.when(
              data: (data) => data.isEmpty
                  ? _EmptyLabel(t.feedEmpty)
                  : TrendingCarousel(
                      activities: data,
                      onTap: (a) => onNavigateToDetail(a),
                    ),
              error: (e, _) => _ErrorLabel(t.feedLoadError),
              loading: () => const _LoadingIndicator(),
            ),
            const SizedBox(height: 24),

            // Categories
            _SectionTitle(t.feedCategories),
            const SizedBox(height: 8),
            categories.when(
              data: (data) => data.isEmpty
                  ? _EmptyLabel(t.feedEmpty)
                  : CategorySelector(
                      categories: data,
                      onCategoryTap: (categoryId) {
                        final category = data.firstWhere(
                          (c) => c.id == categoryId,
                          orElse: () => data.first,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => CategoryActivitiesScreen(
                              categoryId: categoryId,
                              categoryName:
                                  nomTraduitCategoria(category.nom, t),
                            ),
                          ),
                        );
                      },
                    ),
              error: (e, _) => _ErrorLabel(t.feedLoadError),
              loading: () => const _LoadingIndicator(),
            ),
            const SizedBox(height: 24),

            // Quedades obertes
            _SectionTitle(t.feedQuedades),
            const SizedBox(height: 8),
            const QuedadesFeedSection(),
            const SizedBox(height: 24),

            // Recomanades
            recommended.when(
              data: (data) => data.isEmpty
                  ? _EmptySection(
                      title: t.feedRecommended, message: t.feedEmpty)
                  : ActivitySection(
                      title: t.feedRecommended,
                      activities: data,
                      onActivityTap: (a) => onNavigateToDetail(a),
                      onSeeAll: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => ActivityListScreen(
                            title: t.feedRecommended,
                            type: FeedListType.recommended,
                          ),
                        ),
                      ),
                    ),
              error: (e, _) => _EmptySection(
                  title: t.feedRecommended, message: t.feedLoadError),
              loading: () => _LoadingSection(title: t.feedRecommended),
            ),
            const SizedBox(height: 24),

            // A prop teu
            nearby.when(
              data: (data) => data.isEmpty
                  ? _EmptySection(
                      title: t.feedNearby, message: t.feedEmpty)
                  : ActivitySection(
                      title: t.feedNearby,
                      activities: data,
                      onActivityTap: (a) => onNavigateToDetail(a),
                      onSeeAll: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => ActivityListScreen(
                            title: t.feedNearby,
                            type: FeedListType.nearby,
                          ),
                        ),
                      ),
                    ),
              error: (e, _) =>
                  _EmptySection(title: t.feedNearby, message: t.feedLoadError),
              loading: () => _LoadingSection(title: t.feedNearby),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

// ── Private helpers ──────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ErrorLabel extends StatelessWidget {
  final String message;
  const _ErrorLabel(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(message,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13)),
    );
  }
}

class _EmptyLabel extends StatelessWidget {
  final String message;
  const _EmptyLabel(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(message,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13)),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: CircularProgressIndicator(
            strokeWidth: 2, color: AppColors.orange500),
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  final String title;
  final String message;
  const _EmptySection({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_SectionTitle(title), _EmptyLabel(message)],
    );
  }
}

class _LoadingSection extends StatelessWidget {
  final String title;
  const _LoadingSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_SectionTitle(title), const _LoadingIndicator()],
    );
  }
}
