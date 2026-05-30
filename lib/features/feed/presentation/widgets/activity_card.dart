import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import '../../data/models/feed_activity.dart';
import 'amics_feed_widget.dart';

class ActivityCard extends StatelessWidget {
  final FeedActivity activity;
  final VoidCallback onTap;

  const ActivityCard({super.key, required this.activity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        DateFormat('d MMM · HH:mm').format(activity.dataInici);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: _buildImage(context),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: AmicsFeedWidget(activitatId: activity.id),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.titol,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateLabel,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _PriceBadge(
                      esGratuit: activity.esGratuit, preu: activity.preu),
                ],
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
        height: 100,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (ctx, error, _) => _placeholder(ctx),
      );
    }
    return _placeholder(context);
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  final bool esGratuit;
  final double? preu;

  const _PriceBadge({required this.esGratuit, this.preu});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

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
