import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import '../providers/comentaris_provider.dart';
import 'comentari_card.dart';
import 'comentari_input.dart';

class ComentarisList extends ConsumerWidget {
  final String publicacioId;

  const ComentarisList({super.key, required this.publicacioId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    // Escuchamos el estado de los comentarios para esta publicación en concreto
    final comentarisAsync = ref.watch(comentarisProvider(publicacioId));

    return DraggableScrollableSheet(
      initialChildSize: 0.7, // Ocupa el 70% de la pantalla al abrirse
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Barra superior / Cabecera
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  t.comentarisTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Divider(height: 1),
              
              // Lista de comentarios (Estado Async)
              Expanded(
                child: comentarisAsync.when(
                  loading: () => Center(
                    child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
                  ),
                  error: (error, stack) => Center(
                    child: Text(
                      t.comentarisError,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                  data: (comentaris) {
                    if (comentaris.isEmpty) {
                      return Center(
                        child: Text(
                          t.comentarisEmpty,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      );
                    }
                    
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: comentaris.length,
                      itemBuilder: (context, index) {
                        return ComentariCard(
                          comentari: comentaris[index],
                          publicacioId: publicacioId,
                        );
                      },
                    );
                  },
                ),
              ),
              
              // Input fijo abajo
              ComentariInput(publicacioId: publicacioId),
            ],
          ),
        );
      },
    );
  }
}