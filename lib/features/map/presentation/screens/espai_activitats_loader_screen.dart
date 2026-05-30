import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/activitats/presentation/provider/activitats_providers.dart';
import 'edifici_activitats_screen.dart';

/// Carrega les activitats d'un espai concret a partir del [mapaActivitatsProvider]
/// i navega directament a [EdificiActivitatsScreen] amb les dades completes.
///
/// Evita la pantalla buida que apareixia quan la cerca predictiva retornava
/// l'espai però no les activitats relacionades.
class EspaiActivitatsLoaderScreen extends ConsumerWidget {
  final String nomEspai;

  const EspaiActivitatsLoaderScreen({super.key, required this.nomEspai});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapaAsync = ref.watch(mapaActivitatsProvider);
    final cs = Theme.of(context).colorScheme;

    return mapaAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(
          title: Text(
            nomEspai,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: cs.primary,
          ),
        ),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(
          title: Text(
            nomEspai,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline,
                    size: 48, color: cs.onSurfaceVariant),
                const SizedBox(height: 16),
                Text(
                  e.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(mapaActivitatsProvider),
                  child: const Text('Torna-ho a provar'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (mapaState) {
        // Busquem activitats que coincideixin amb el nom de l'espai.
        // Fem cerca flexible per cobrir variacions de majúscules i noms parcials.
        final normalized = nomEspai.toLowerCase().trim();
        final activitats = mapaState.activitats
            .where((a) {
              final aNom = a.nomEspai.toLowerCase().trim();
              return aNom == normalized ||
                  aNom.contains(normalized) ||
                  normalized.contains(aNom);
            })
            .toList()
          ..sort((a, b) => a.dataInici.compareTo(b.dataInici));

        // Cap activitat en aquest espai — mostrem un estat buit informatiu.
        if (activitats.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                nomEspai,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_off_outlined,
                      size: 72,
                      color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Cap activitat disponible',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ara mateix no hi ha activitats programades a $nomEspai.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: cs.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Activitats trobades — passem l'adreça real de la primera activitat.
        final first = activitats.first;
        return EdificiActivitatsScreen(
          nomEspai: first.nomEspai,
          adreca: first.adreca,
          localitat: first.localitat,
          activitats: activitats,
        );
      },
    );
  }
}
