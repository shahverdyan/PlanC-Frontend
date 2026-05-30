import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plan_c_frontend/features/activitats/model/activitat.dart';
import 'package:plan_c_frontend/features/activitats/presentation/screens/activitat_detail_screen.dart';
import 'package:plan_c_frontend/features/publicacions/domain/models/post_preview.dart';
import 'package:plan_c_frontend/features/publicacions/presentation/post_screen.dart';
import 'package:plan_c_frontend/features/preferits/presentation/providers/preferits_provider.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class PreferitsScreen extends ConsumerWidget {
  const PreferitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final preferitsAsync = ref.watch(preferitsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            t.preferitsAppBarTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: t.preferitsTabActivitats),
              Tab(text: t.preferitsTabPublicacions),
            ],
          ),
        ),
        body: preferitsAsync.when(
          loading: () => Center(
            child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
          ),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                t.preferitsLoadError(e.toString()),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          data: (preferitsState) => TabBarView(
            children: [
              _ActivitatsTab(
                activitats: preferitsState.activitats,
                onRefresh: () => ref.read(preferitsProvider.notifier).refreshPreferits(),
              ),
              _PublicacionsTab(
                publicacions: preferitsState.publicacions,
                error: preferitsState.publicacionsError,
                onRefresh: () => ref.read(preferitsProvider.notifier).refreshPreferits(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Tab 1: Activitats ────────────────────────────────────────────────────────

class _ActivitatsTab extends StatelessWidget {
  final List<Activitat> activitats;
  final Future<void> Function() onRefresh;

  const _ActivitatsTab({required this.activitats, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    if (activitats.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bookmark_border,
                size: 54,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                t.preferitsEmptyTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                t.preferitsEmptyDescription,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: activitats.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final activitat = activitats[index];
          return _PreferitCard(
            activitat: activitat,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ActivitatDetailScreen(activitat: activitat),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Tab 2: Publicacions ──────────────────────────────────────────────────────

class _PublicacionsTab extends StatelessWidget {
  final List<PostPreview> publicacions;
  final String? error;
  final Future<void> Function() onRefresh;

  const _PublicacionsTab({
    required this.publicacions,
    required this.onRefresh,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: 12),
              Text(
                error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: onRefresh,
                child: Text(t.feedPublicationsRetry,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary)),
              ),
            ],
          ),
        ),
      );
    }

    if (publicacions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bookmark_border,
                size: 54,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                t.preferitsPublicacionsEmptyTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                t.preferitsPublicacionsEmptyDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemCount: publicacions.length,
        itemBuilder: (context, index) {
          final post = publicacions[index];
          return InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => PostScreen(postId: post.id),
              ),
            ),
            child: (post.imageUrl?.isNotEmpty ?? false)
                ? Image.network(
                    post.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
          );
        },
      ),
    );
  }
}

// ─── Activity card ─────────────────────────────────────────────────────────────

class _PreferitCard extends StatelessWidget {
  final Activitat activitat;
  final VoidCallback onTap;

  const _PreferitCard({required this.activitat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final dateLabel = DateFormat('d MMM · HH:mm').format(activitat.dataInici);

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
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                child: _buildImage(),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activitat.titol,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateLabel,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    if (activitat.localitat.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        activitat.localitat,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    _PriceBadge(
                      esGratuit: activitat.esGratuit ?? false,
                      preu: activitat.preu,
                      t: t,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    const imageWidth = 100.0;
    final url = activitat.imatge;
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        width: imageWidth,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(imageWidth),
      );
    }
    return _placeholder(imageWidth);
  }

  Widget _placeholder(double width) {
    return Builder(
      builder: (context) => SizedBox(
        width: width,
        child: Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.image_not_supported_outlined,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  final bool esGratuit;
  final double? preu;
  final AppLocalizations t;

  const _PriceBadge({required this.esGratuit, required this.t, this.preu});

  @override
  Widget build(BuildContext context) {
    final String label;
    final Color bgColor;
    final Color textColor;

    if (esGratuit) {
      label = t.feedFree;
      bgColor = Colors.green.withValues(alpha: 0.12);
      textColor = Colors.green;
    } else if (preu != null) {
      label = '${preu!.toStringAsFixed(0)}€';
      bgColor = const Color(0xFFEA9B63).withValues(alpha: 0.15);
      textColor = const Color(0xFFEA9B63);
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
