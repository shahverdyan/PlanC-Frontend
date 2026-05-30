import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import '../providers/interaccions_provider.dart';
import '../../../perfil/presentation/profile_screen.dart';

class MeGustaListSheet extends ConsumerWidget {
  final String publicacioId;

  const MeGustaListSheet({super.key, required this.publicacioId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final likesAsync = ref.watch(meGustaListProvider(publicacioId));

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
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
              // Títol
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  t.postLikedByTitle,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
              const Divider(height: 1),
              // Llista
              Expanded(
                child: likesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, _) => Center(
                    child: Text(
                      t.postLikesError,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                  data: (likes) {
                    if (likes.isEmpty) {
                      return Center(
                        child: Text(
                          t.postNoLikes,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: likes.length,
                      itemBuilder: (context, index) {
                        final user = likes[index];
                        return ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProfileScreen(profileUserId: user.id),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundImage: user.fotoPerfil != null
                                ? NetworkImage(user.fotoPerfil!)
                                : null,
                            child: user.fotoPerfil == null
                                ? Text(
                                    user.nomUsuari.isNotEmpty
                                        ? user.nomUsuari[0].toUpperCase()
                                        : '?',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                          title: Text(
                            user.nomUsuari,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
