import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/features/interaccions/presentation/providers/interaccions_provider.dart';
import 'package:plan_c_frontend/features/interaccions/presentation/widgets/comentaris_list.dart';
import 'package:plan_c_frontend/features/perfil/presentation/profile_screen.dart';
import 'package:plan_c_frontend/features/publicacions/domain/models/publicacio_detall.dart';
import 'package:plan_c_frontend/features/publicacions/presentation/post_screen.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class PublicationCard extends ConsumerStatefulWidget {
  final PublicacioDetall publication;

  const PublicationCard({super.key, required this.publication});

  @override
  ConsumerState<PublicationCard> createState() => _PublicationCardState();
}

class _PublicationCardState extends ConsumerState<PublicationCard> {
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(likePostProvider(widget.publication.id).notifier)
          .initialize(widget.publication.likesCount, widget.publication.isLikedByMe);
      ref
          .read(bookmarkPostProvider(widget.publication.id).notifier)
          .fetchGuardada();
    });
  }

  String _tempsRelatiu(BuildContext context, DateTime data) {
    final t = AppLocalizations.of(context)!;
    final diff = DateTime.now().difference(data);
    if (diff.inSeconds < 60) return t.timeJustNow;
    if (diff.inMinutes < 60) return t.timeMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return t.timeHoursAgo(diff.inHours);
    if (diff.inDays == 1) return t.timeYesterday;
    if (diff.inDays < 7) return t.timeDaysAgo(diff.inDays);
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    final pub = widget.publication;
    final likeState = ref.watch(likePostProvider(pub.id));
    final bookmarkState = ref.watch(bookmarkPostProvider(pub.id));
    final delta = ref.watch(comentarisAdicionalsProvider(pub.id));
    final commentsCount = pub.commentsCount + delta;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(profileUserId: pub.autor.id),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: pub.autor.fotoPerfil != null
                      ? NetworkImage(pub.autor.fotoPerfil!)
                      : null,
                  child: pub.autor.fotoPerfil == null
                      ? const Icon(Icons.person, size: 18)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    pub.autor.nomUsuari,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                Text(
                  _tempsRelatiu(context, pub.dataCreacio),
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Images
        if (pub.imatges.isNotEmpty) _buildImages(pub),

        // Actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  likeState.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: likeState.isLiked ? AppColors.orange500 : null,
                ),
                onPressed: () =>
                    ref.read(likePostProvider(pub.id).notifier).toggle(),
              ),
              Text(
                '${likeState.likesCount}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: () => _openComments(context),
              ),
              Text(
                '$commentsCount',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  bookmarkState.isGuardat ? Icons.bookmark : Icons.bookmark_border,
                  color: bookmarkState.isGuardat
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                onPressed: () =>
                    ref.read(bookmarkPostProvider(pub.id).notifier).toggle(),
              ),
            ],
          ),
        ),

        // Description
        if (pub.descripcio.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PostScreen(postId: pub.id)),
              ),
              child: RichText(
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style.copyWith(fontSize: 13),
                  children: [
                    TextSpan(
                      text: '${pub.autor.nomUsuari} ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: pub.descripcio),
                  ],
                ),
              ),
            ),
          ),

        const SizedBox(height: 12),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildImages(PublicacioDetall pub) {
    if (pub.imatges.length == 1) {
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PostScreen(postId: pub.id)),
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            pub.imatges.first.url,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (_, e, s) => Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Icon(Icons.broken_image, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PostScreen(postId: pub.id)),
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: PageView.builder(
              itemCount: pub.imatges.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (_, i) => Image.network(
                pub.imatges[i].url,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, e, s) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(Icons.broken_image, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            pub.imatges.length,
            (i) => Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == _currentPage
                    ? AppColors.orange500
                    : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  void _openComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ComentarisList(publicacioId: widget.publication.id),
    );
  }
}
