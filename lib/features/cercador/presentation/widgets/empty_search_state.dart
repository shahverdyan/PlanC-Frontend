import 'package:flutter/material.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

enum EmptyResultType { search, filter }

class EmptySearchState extends StatelessWidget {
  final String? terme;
  final EmptyResultType type;
  final VoidCallback? onModifyFilters;

  const EmptySearchState({
    super.key,
    this.terme,
    this.type = EmptyResultType.search,
    this.onModifyFilters,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type == EmptyResultType.filter
                  ? Icons.filter_alt_off
                  : Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              type == EmptyResultType.filter
                  ? t.emptySearchFilterTitle
                  : t.emptySearchSearchTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              type == EmptyResultType.filter
                  ? t.emptySearchFilterDescription
                  : t.emptySearchSearchDescription(terme ?? ''),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (type == EmptyResultType.filter && onModifyFilters != null)
              OutlinedButton.icon(
                onPressed: onModifyFilters,
                icon: Icon(Icons.tune, color: Theme.of(context).colorScheme.primary),
                label: Text(t.emptySearchModifyFilters),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  side: BorderSide(color: Theme.of(context).colorScheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
            if (type == EmptyResultType.search)
              Wrap(
                spacing: 8,
                children: [
                  t.emptySearchCategoryMusic,
                  t.emptySearchCategoryTheater,
                  t.emptySearchCategoryArt,
                  t.emptySearchCategoryCinema,
                ].map((cat) {
                  return ActionChip(
                    label: Text(cat),
                    onPressed: () {},
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}