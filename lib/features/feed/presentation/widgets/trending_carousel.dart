import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import '../../data/models/feed_activity.dart';
import 'amics_feed_widget.dart';

class TrendingCarousel extends StatelessWidget {
  final List<FeedActivity> activities;
  final void Function(FeedActivity) onTap;

  const TrendingCarousel({
    super.key,
    required this.activities,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          final cardWidth = MediaQuery.of(context).size.width * 0.82;
          return Padding(
            padding: EdgeInsets.only(right: index == activities.length - 1 ? 0 : 12),
            child: SizedBox(
              width: cardWidth,
              child: _TrendingCard(
                activity: activity,
                onTap: () => onTap(activity),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TrendingCard extends StatelessWidget {
  final FeedActivity activity;
  final VoidCallback onTap;

  const _TrendingCard({required this.activity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final dateLabel =
        DateFormat('d MMM · HH:mm').format(activity.dataInici);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildBackground(),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.75),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: AmicsFeedWidget(activitatId: activity.id),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    activity.titol,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        dateLabel,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                      const Spacer(),
                      _PriceChip(
                          esGratuit: activity.esGratuit,
                          preu: activity.preu,
                          t: t),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    final url = activity.imatgePrincipal;
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, _) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Builder(
      builder: (context) => Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.image_outlined,
          size: 64,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _PriceChip extends StatelessWidget {
  final bool esGratuit;
  final double? preu;
  final AppLocalizations t;

  const _PriceChip({
    required this.esGratuit,
    required this.t,
    this.preu,
  });

  @override
  Widget build(BuildContext context) {
    final String label;
    final Color bgColor;

    if (esGratuit) {
      label = t.feedFree;
      bgColor = Colors.green;
    } else if (preu != null) {
      label = '${preu!.toStringAsFixed(0)}€';
      bgColor = const Color(0xFFEA9B63);
    } else {
      label = t.feedInfoUnavailable;
      bgColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
