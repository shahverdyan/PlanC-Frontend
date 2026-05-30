import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/activitats/presentation/provider/activitats_providers.dart';
import 'package:plan_c_frontend/features/groups/presentation/screens/activity_groups_screen.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

/// Carrega una activitat per ID i en mostra el llistat de quedades.
/// Punt d'entrada quan es coneix l'activitatId però no l'objecte Activitat.
class ActivityGroupsByIdScreen extends ConsumerWidget {
  final String activitatId;

  const ActivityGroupsByIdScreen({super.key, required this.activitatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitatAsync = ref.watch(activitatByIdProvider(activitatId));

    return activitatAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(height: 16),
                Text(
                  e.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      ref.invalidate(activitatByIdProvider(activitatId)),
                  child: Text(AppLocalizations.of(context)!.feedRetry),
                ),
              ],
            ),
          ),
        ),
      ),
      // Un cop carregada l'activitat, mostrem directament ActivityGroupsScreen
      // que ja té el seu propi AppBar i tota la lògica de unions.
      data: (activitat) => ActivityGroupsScreen(activitat: activitat),
    );
  }
}
