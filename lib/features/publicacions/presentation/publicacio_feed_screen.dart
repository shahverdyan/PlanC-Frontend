import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/publicacions/domain/models/post.dart';
import 'package:plan_c_frontend/features/publicacions/presentation/post_screen.dart';
import 'package:plan_c_frontend/features/publicacions/presentation/providers/publicacio_provider.dart';
import 'package:plan_c_frontend/features/perfil/presentation/profile_screen.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class PublicacioFeedScreen extends ConsumerWidget {
  const PublicacioFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final feedAsync = ref.watch(publicacioFeedProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.feedTabPublications,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: feedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: 12),
              Text(t.feedLoadError,
                  style: TextStyle(
                      color:
                          Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => ref.invalidate(publicacioFeedProvider),
                child: Text(t.feedRetry),
              ),
            ],
          ),
        ),
        data: (posts) {
          if (posts.isEmpty) {
            return Center(
              child: Text(
                t.feedNoPublications,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(publicacioFeedProvider),
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) =>
                  _PostCard(post: posts[index]),
            ),
          );
        },
      ),
    );
  }
}

// ─── Card d'una publicació al feed ──────────────────────────────────────────

class _PostCard extends StatelessWidget {
  final Post post;

  const _PostCard({required this.post});

  String _tempsRelatiu(DateTime data) {
    final diff = DateTime.now().difference(data);
    if (diff.inMinutes < 1) return 'Ara mateix';
    if (diff.inMinutes < 60) return 'Fa ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Fa ${diff.inHours} h';
    if (diff.inDays == 1) return 'Ahir';
    if (diff.inDays < 7) return 'Fa ${diff.inDays} dies';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (_) => PostScreen(postId: post.id)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Capçalera autor ───────────────────────────────────────
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (_) =>
                        ProfileScreen(profileUserId: post.autorId)),
              ),
              child: _Avatar(
                  nomUsuari: post.nomAutor,
                  fotoPerfil: post.fotoPerfilAutor),
            ),
            title: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (_) =>
                        ProfileScreen(profileUserId: post.autorId)),
              ),
              child: Text(post.nomAutor,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            subtitle: post.titolActivitat != null
                ? Text(post.titolActivitat!,
                    style: TextStyle(
                        fontSize: 12, color: cs.onSurfaceVariant),
                    overflow: TextOverflow.ellipsis)
                : null,
            trailing: Text(
              _tempsRelatiu(post.dataCreacio),
              style:
                  TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
            ),
          ),

          // ─── Imatge (si n'hi ha) ───────────────────────────────────
          if (post.urlImatgePreview != null &&
              post.urlImatgePreview!.isNotEmpty)
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                post.urlImatgePreview!,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, st) => Container(
                  color: cs.surfaceContainerHighest,
                  child: Icon(Icons.broken_image_outlined,
                      color: cs.onSurfaceVariant),
                ),
              ),
            ),

          // ─── Descripció ────────────────────────────────────────────
          if (post.descripcio.isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: TextStyle(color: cs.onSurface, fontSize: 14),
                  children: [
                    TextSpan(
                      text: '${post.nomAutor} ',
                      style:
                          const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: post.descripcio),
                  ],
                ),
              ),
            ),

          // ─── Comptadors ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Icon(Icons.favorite_border, size: 18,
                    color: cs.onSurfaceVariant),
                const SizedBox(width: 4),
                Text('${post.likesCount}',
                    style: TextStyle(
                        fontSize: 13, color: cs.onSurfaceVariant)),
                const SizedBox(width: 16),
                Icon(Icons.chat_bubble_outline,
                    size: 18, color: cs.onSurfaceVariant),
                const SizedBox(width: 4),
                Text('${post.commentsCount}',
                    style: TextStyle(
                        fontSize: 13, color: cs.onSurfaceVariant)),
              ],
            ),
          ),

          const Divider(height: 1, indent: 16, endIndent: 16),
        ],
      ),
    );
  }
}

// ─── Avatar ─────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String nomUsuari;
  final String? fotoPerfil;

  const _Avatar({required this.nomUsuari, this.fotoPerfil});

  @override
  Widget build(BuildContext context) {
    if (fotoPerfil != null && fotoPerfil!.isNotEmpty) {
      return CircleAvatar(
          radius: 20, backgroundImage: NetworkImage(fotoPerfil!));
    }
    return CircleAvatar(
      radius: 20,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Text(
        nomUsuari.isNotEmpty ? nomUsuari[0].toUpperCase() : '?',
        style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
