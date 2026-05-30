import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/publicacions/presentation/providers/post_provider.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import '../../interaccions/presentation/widgets/comentaris_list.dart';
import '../../interaccions/presentation/widgets/me_gusta_list_sheet.dart';
import '../../interaccions/presentation/providers/interaccions_provider.dart';
import '../domain/models/publicacio_detall.dart';
import 'package:plan_c_frontend/features/perfil/presentation/providers/profile_provider.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/publicacions/presentation/edit_post_screen.dart';  
import 'package:plan_c_frontend/features/perfil/presentation/profile_screen.dart'; // Importa la pantalla de perfil para navegar a ella desde las menciones

class PostScreen extends ConsumerStatefulWidget {
  final String postId;

  const PostScreen({super.key, required this.postId});

  @override
  ConsumerState<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  int _imatgeActual = 0;

  void _syncPostData(PublicacioDetall post) {
    ref
        .read(likePostProvider(widget.postId).notifier)
        .syncFromBackend(post.likesCount, post.isLikedByMe);
    ref
        .read(bookmarkPostProvider(widget.postId).notifier)
        .fetchGuardada();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(publicacioDetallProvider(widget.postId)).whenData((post) {
        _syncPostData(post);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final postAsync = ref.watch(publicacioDetallProvider(widget.postId));

    ref.listen<AsyncValue<PublicacioDetall>>(
        publicacioDetallProvider(widget.postId),
        (_, next) {
          next.whenData((post) {
            Future.microtask(() {
              if (!mounted) return;
              _syncPostData(post);
            });
          });
        },
      );

    // Mostra error del like
    ref.listen<LikeState>(likePostProvider(widget.postId), (previous, next) {
      if (next.error != null && previous?.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
        ref.read(likePostProvider(widget.postId).notifier).clearError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          t.postTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: postAsync.when(
        loading: () => const _PostSkeleton(),
        error: (error, _) => _PostError(
          onRetry: () => ref.invalidate(publicacioDetallProvider(widget.postId)),
        ),
        data: (post) => _PostContent(
          post: post,
          postId: widget.postId,
          imatgeActual: _imatgeActual,
          onPageChanged: (i) => setState(() => _imatgeActual = i),
          onObrirComentaris: () => _obrirComentaris(context),
        ),
      ),
    );
  }

  void _obrirComentaris(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ComentarisList(publicacioId: widget.postId),
    );
  }
}

// ─── Contingut real de la publicació ────────────────────────────────────────

class _PostContent extends ConsumerWidget {
  final PublicacioDetall post;
  final String postId;
  final int imatgeActual;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onObrirComentaris;

  const _PostContent({
    required this.post,
    required this.postId,
    required this.imatgeActual,
    required this.onPageChanged,
    required this.onObrirComentaris,
  });

  void _mostrarMencions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Necessari perquè el DraggableScrollableSheet funcioni bé
      backgroundColor: Colors.transparent, // Transparent per veure les vores arrodonides
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5, // Ocupa el 50% de la pantalla a l'obrir-se
          minChildSize: 0.3,     // Mínim al fer scroll cap avall
          maxChildSize: 0.9,     // Màxim si fan scroll cap amunt
          expand: false,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // Píndola gris superior (indicador de scroll)
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Mencions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  // Llista d'usuaris mencionats
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: post.mencions.length,
                      itemBuilder: (context, index) {
                        final mencio = post.mencions[index];
                        return ListTile(
                          leading: _Avatar(
                            nomUsuari: mencio.nomUsuari,
                            fotoPerfil: mencio.fotoPerfil,
                          ),
                          title: Text(
                            mencio.nomUsuari,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('@${mencio.nomUsuari}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(profileUserId: mencio.id),
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
      },
    );
  }

  Future<bool> _mostrarDialogoConfirmacion(BuildContext context) async {
    // Esperamos la respuesta del diálogo (true o false)
    final bool? resultat = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar publicació'),
          content: const Text('Estàs segur que vols eliminar aquesta publicació? Aquesta acció no es pot desfer.'),
          actions: [
            TextButton(
              // Si pulsa Cancelar, cerramos y devolvemos FALSE
              onPressed: () => Navigator.of(context).pop(false), 
              child: const Text('Cancel·lar'),
            ),
            TextButton(
              // Si pulsa Eliminar, cerramos y devolvemos TRUE
              onPressed: () => Navigator.of(context).pop(true), 
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    return resultat ?? false;
  }

  void _obrirMeGustaList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MeGustaListSheet(publicacioId: postId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final likeState = ref.watch(likePostProvider(postId));
    final bookmarkState = ref.watch(bookmarkPostProvider(postId));
    final addicionals = ref.watch(comentarisAdicionalsProvider(postId));
    final totalComentaris = post.commentsCount + addicionals;
    final currentUserId = ref.watch(currentUserIdProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Capçalera autor ─────────────────────────────────────────
          ListTile(
            leading: _Avatar(
              nomUsuari: post.autor.nomUsuari,
              fotoPerfil: post.autor.fotoPerfil,
            ),
            title: Text(
              post.autor.nomUsuari,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            // 🌟 CAMBIO AQUÍ: Menú desplegable unificado y corregido dentro de ListTile
            trailing: post.autor.id == currentUserId 
                ? PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) async {
                      if (value == 'editar') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPostScreen(postId: postId),
                          ),
                        );
                      } else if (value == 'eliminar') {
                        final bool confirmoEliminar = await _mostrarDialogoConfirmacion(context);

                        if (confirmoEliminar && context.mounted) {
                          ref.read(postRepositoryProvider).deletePost(postId: postId, userId: post.autor.id);
                          ref.invalidate(profileByIdProvider(post.autor.id));
                          
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Publicació eliminada correctament')),
                            );
                            Navigator.of(context).pop(); 
                          }
                        }
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'editar',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined),
                            SizedBox(width: 8),
                            Text('Editar publicació'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'eliminar',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Eliminar publicació', 
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ) 
                : null,
          ),

          // --- Carrusel d'imatges ---
          if (post.imatges.isNotEmpty)
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    itemCount: post.imatges.length,
                    onPageChanged: onPageChanged,
                    itemBuilder: (context, index) => Image.network(
                      post.imatges[index].url,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      },
                      errorBuilder: (ctx, err, _) => Container(
                        color: Theme.of(ctx).colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 48,
                          color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  
                  if (post.mencions.isNotEmpty)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: GestureDetector(
                        onTap: () => _mostrarMencions(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6), // Cercle fosc semi-transparent
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_pin_outlined, 
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),

                  // Indicador de pàgines (punts del carrusel)
                  if (post.imatges.length > 1)
                    Positioned(
                      bottom: 12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: post.imatges.asMap().entries.map((entry) {
                          return Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: imatgeActual == entry.key
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withValues(alpha: 0.6),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),

          // ─── Barra d'interaccions ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    likeState.isLiked ? Icons.favorite : Icons.favorite_border,
                    size: 28,
                    color: likeState.isLiked
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () =>
                      ref.read(likePostProvider(postId).notifier).toggle(),
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline, size: 26),
                  onPressed: onObrirComentaris,
                ),
                const Spacer(),
                // Botó guardar
                IconButton(
                  icon: Icon(
                    bookmarkState.isGuardat
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    size: 28,
                    color: bookmarkState.isGuardat
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () async {
                    final wasGuardat = bookmarkState.isGuardat;
                    await ref.read(bookmarkPostProvider(postId).notifier).toggle();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            wasGuardat ? t.postUnsavedSuccess : t.postSavedSuccess,
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),

          // ─── Comptador de likes (tap → llista) ───────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () => _obrirMeGustaList(context),
              child: Text(
                t.postLikesCount(likeState.likesCount),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),

          // ─── Descripció ───────────────────────────────────────────────
          if (post.descripcio.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: '${post.autor.nomUsuari} ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: post.descripcio),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),

          // ─── Accés als comentaris ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: onObrirComentaris,
              child: Text(
                t.postViewComments(totalComentaris),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Avatar ───────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String nomUsuari;
  final String? fotoPerfil;

  const _Avatar({required this.nomUsuari, this.fotoPerfil});

  @override
  Widget build(BuildContext context) {
    if (fotoPerfil != null && fotoPerfil!.isNotEmpty) {
      return CircleAvatar(backgroundImage: NetworkImage(fotoPerfil!));
    }
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Text(
        nomUsuari.isNotEmpty ? nomUsuari[0].toUpperCase() : '?',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ─── Skeleton ─────────────────────────────────────────────────────────────────

class _PostSkeleton extends StatelessWidget {
  const _PostSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest),
            title: const _SkeletonBox(width: 120, height: 12),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _SkeletonBox(width: 80, height: 12),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _SkeletonBox(width: double.infinity, height: 12),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;

  const _SkeletonBox({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// ─── Error ────────────────────────────────────────────────────────────────────

class _PostError extends StatelessWidget {
  final VoidCallback onRetry;

  const _PostError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(
            t.feedPublicationsError,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onRetry,
            child: Text(
              t.feedPublicationsRetry,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}