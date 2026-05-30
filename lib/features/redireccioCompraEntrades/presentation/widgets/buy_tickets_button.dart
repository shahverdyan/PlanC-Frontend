import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import '../providers/activity_link_provider.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class BuyTicketsButton extends ConsumerWidget {
  final String url;
  final double? preu;

  const BuyTicketsButton({
    super.key,
    required this.url,
    this.preu,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final sem = AppSemanticColors.of(context);
    final esGratuit = preu == null || preu == 0;
    if (esGratuit) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: sem.ticketButtonSurface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: sem.ticketButton, width: 2),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle_outline, color: sem.ticketButton),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                t.buyTicketsGratuit,
                style: TextStyle(
                  color: sem.ticketButton,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      );
    }

    if (url.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                t.buyTicketsFree,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      );
    }

    final state = ref.watch(buyTicketsProvider(url));

    ref.listen(buyTicketsProvider(url), (_, next) {
      if (next.status == BuyTicketsStatus.error) {
        final localT = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localT.buyTicketsLinkError),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    final isLoading = state.status == BuyTicketsStatus.loading;
    final label = t.buyTicketsLabel;
    final preuText = preu != null && preu! > 0
        ? '${preu!.toStringAsFixed(2)} €'
        : null;

    return SizedBox(
      width: double.infinity,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : ElevatedButton(
              onPressed: () =>
                  ref.read(buyTicketsProvider(url).notifier).openLink(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.open_in_new, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (preuText != null) ...[
                    const SizedBox(width: 12),
                    Text(
                      preuText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}