import 'package:flutter/material.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import '../../data/models/feed_activity.dart';
import 'activity_card.dart';

class ActivitySection extends StatelessWidget {
  final String title;
  final List<FeedActivity> activities;
  final VoidCallback? onSeeAll;
  final void Function(FeedActivity) onActivityTap;

  const ActivitySection({
    super.key,
    required this.title,
    required this.activities,
    required this.onActivityTap,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  child: Text(t.feedSeeAll),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: activities.length,
            separatorBuilder: (_, i) => const SizedBox(width: 12),
            itemBuilder: (_, i) => ActivityCard(
              activity: activities[i],
              onTap: () => onActivityTap(activities[i]),
            ),
          ),
        ),
      ],
    );
  }
}
