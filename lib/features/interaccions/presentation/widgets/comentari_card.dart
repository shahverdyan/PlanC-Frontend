import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/perfil/presentation/profile_screen.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import '../../domain/models/comentari.dart';
import '../providers/interaccions_provider.dart';

class ComentariCard extends ConsumerStatefulWidget {
  final Comentari comentari;
  final String publicacioId;

  const ComentariCard({
    super.key,
    required this.comentari,
    required this.publicacioId,
  });

  @override
  ConsumerState<ComentariCard> createState() => _ComentariCardState();
}

class _ComentariCardState extends ConsumerState<ComentariCard> {
  // Les respostes comencen desplegades si n'hi ha poques; complem si n'hi ha moltes.
  bool _showReplies = true;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final respostes = widget.comentari.respostes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Comentari principal ──────────────────────────────────────────
        _ComentariBubble(
          comentari: widget.comentari,
          publicacioId: widget.publicacioId,
          onReply: () => ref
              .read(replyTargetProvider(widget.publicacioId).notifier)
              .state = widget.comentari,
        ),

        // ── Controls de respostes ────────────────────────────────────────
        if (respostes.isNotEmpty) ...[
          // Botó per amagar/mostrar respostes
          Padding(
            padding: const EdgeInsets.only(left: 62, bottom: 2),
            child: GestureDetector(
              onTap: () => setState(() => _showReplies = !_showReplies),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 1,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _showReplies
                        ? t.comentariHideReplies
                        : t.comentariShowReplies(respostes.length),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Respostes niuades (un nivell) ─────────────────────────────
          if (_showReplies)
            Padding(
              padding: const EdgeInsets.only(left: 52),
              child: Column(
                children: respostes
                    .map((r) => _ComentariBubble(
                          comentari: r,
                          publicacioId: widget.publicacioId,
                          isReply: true,
                          // Les respostes d'una resposta també responen al pare
                          onReply: () => ref
                              .read(replyTargetProvider(widget.publicacioId).notifier)
                              .state = widget.comentari,
                        ))
                    .toList(),
              ),
            ),
        ],
      ],
    );
  }
}

// ─── Bubble reutilitzable per a comentari i resposta ─────────────────────────

class _ComentariBubble extends ConsumerWidget {
  final Comentari comentari;
  final String publicacioId;
  final bool isReply;
  final VoidCallback onReply;

  const _ComentariBubble({
    required this.comentari,
    required this.publicacioId,
    required this.onReply,
    this.isReply = false,
  });

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
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final avatarRadius = isReply ? 14.0 : 18.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isReply ? 6.0 : 10.0,
        horizontal: 20.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(profileUserId: comentari.usuariId),
              ),
            ),
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
              backgroundImage: comentari.fotoPerfil != null
                  ? NetworkImage(comentari.fotoPerfil!)
                  : null,
              child: comentari.fotoPerfil == null
                  ? Text(
                      comentari.nomUsuari.isNotEmpty
                          ? comentari.nomUsuari[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: isReply ? 11.0 : 14.0,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      comentari.nomUsuari,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: isReply ? 13.0 : 14.0,
                      ),
                    ),
                    Text(
                      _tempsRelatiu(context, comentari.dataCreacio),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  comentari.text,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onReply,
                  child: Text(
                    t.comentariResponder,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
