import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plan_c_frontend/features/activitats/presentation/screens/activitat_detail_screen.dart';
import 'package:plan_c_frontend/features/groups/domain/models/group.dart';
import 'package:plan_c_frontend/features/groups/presentation/providers/all_groups_provider.dart';
import 'package:plan_c_frontend/features/groups/presentation/screens/activity_groups_by_id_screen.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

/// Secció horitzontal del Feed que mostra les quedades obertes.
/// Permet als usuaris nous descobrir quedades existents.
class QuedadesFeedSection extends ConsumerWidget {
  const QuedadesFeedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final groupsAsync = ref.watch(allGroupsProvider);

    return groupsAsync.when(
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      error: (e, _) => const SizedBox.shrink(),
      data: (groups) {
        // Mostrem només quedades futures amb places disponibles
        final futures = groups
            .where((g) =>
                g.dateTime.isAfter(DateTime.now()) &&
                g.currentParticipants < g.maxParticipants)
            .toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

        if (futures.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              t.feedQuedadesEmpty,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          );
        }

        return SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: futures.length,
            separatorBuilder: (_, i) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _QuedadaCard(
              group: futures[index],
            ),
          ),
        );
      },
    );
  }
}

class _QuedadaCard extends StatelessWidget {
  final Group group;

  const _QuedadaCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;

    final dateLabel = DateFormat('d MMM · HH:mm', locale).format(group.dateTime.toLocal());
    final hasDescription = group.description.trim().isNotEmpty;

    return GestureDetector(
      // Tap principal → pantalla de quedades per unir-se
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => ActivityGroupsByIdScreen(
            activitatId: group.activityId,
          ),
        ),
      ),
      child: Container(
        width: 210,
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: cs.outline.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icona + títol
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: group.imageUrl != null && group.imageUrl!.isNotEmpty
                        ? Image.network(
                            group.imageUrl!,
                            width: 34,
                            height: 34,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) => Container(
                              width: 34,
                              height: 34,
                              color: cs.primaryContainer,
                              child: Icon(Icons.people_outline,
                                  size: 19, color: cs.primary),
                            ),
                          )
                        : Container(
                            width: 34,
                            height: 34,
                            color: cs.primaryContainer,
                            child: Icon(Icons.people_outline,
                                size: 19, color: cs.primary),
                          ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      group.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: cs.onSurface,
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Data
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 13, color: cs.primary),
                  const SizedBox(width: 5),
                  Text(
                    dateLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              if (hasDescription) ...[
                const SizedBox(height: 6),
                Text(
                  group.description.trim(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
              const Spacer(),
              // Botó "Veure activitat" — tap independent del card principal
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => ActivitatDetailByIdScreen(
                      activitatId: group.activityId,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      t.feedQuedadesJoin,
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(Icons.arrow_forward_ios,
                        size: 11, color: cs.primary),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
