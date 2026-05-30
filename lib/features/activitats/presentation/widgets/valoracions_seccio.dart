import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/features/perfil/presentation/profile_screen.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import '../../model/valoracio.dart';
import '../providers/valoracions_provider.dart';

class ValoracionsSection extends ConsumerWidget {
  const ValoracionsSection({required this.activitatId, super.key});

  final String activitatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(valoracionsProvider(activitatId));

    if (state.loading) return const _SkeletonLlistat();

    if (state.error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          state.error!,
          style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (state.valoracions.isEmpty) {
      final t = AppLocalizations.of(context)!;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            t.valoracionsEmpty,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Capcalera(mitjana: state.mitjana, total: state.total),
        const SizedBox(height: 12),
        ...state.valoracions.map((v) => _ResenyaCard(valoracio: v)),
        if (state.hasMore) ...[
          const SizedBox(height: 8),
          _BotoCarregarMes(
            loading: state.loadingMore,
            onTap: () => ref
                .read(valoracionsProvider(activitatId).notifier)
                .carregarMes(),
          ),
        ],
      ],
    );
  }
}

// ── Capçalera ─────────────────────────────────────────────────────────────────

class _Capcalera extends StatelessWidget {
  const _Capcalera({required this.mitjana, required this.total});

  final double mitjana;
  final int total;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
            border: Border.all(color: Theme.of(context).colorScheme.primaryContainer),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            children: [
              Text(
                mitjana.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.primary,
                  height: 1.1,
                ),
              ),
              _Estrelles(valor: mitjana.round()),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.valoracionsCount(total),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              t.valoracionsMitjana,
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Ressenya card ─────────────────────────────────────────────────────────────

class _ResenyaCard extends StatelessWidget {
  const _ResenyaCard({required this.valoracio});

  final Valoracio valoracio;

  @override
  Widget build(BuildContext context) {
    final onTapAutor = valoracio.esMeva
        ? null
        : () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ProfileScreen(profileUserId: valoracio.autor.id),
              ),
            );

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: valoracio.esMeva
            ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
            : Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: valoracio.esMeva
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(autor: valoracio.autor, onTap: onTapAutor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: onTapAutor,
                            child: Text(
                              valoracio.autor.nomUsuari,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: valoracio.esMeva
                                    ? Theme.of(context).colorScheme.onSurface
                                    : Theme.of(context).colorScheme.primary,
                                decoration: valoracio.esMeva
                                    ? null
                                    : TextDecoration.underline,
                                decorationColor: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          if (valoracio.esMeva) ...[
                            const SizedBox(width: 6),
                            Text(
                              AppLocalizations.of(context)!.valoracionsLaTeva,
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Text(
                      _formatData(valoracio.dataValoracio),
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                _Estrelles(valor: valoracio.puntuacio),
                if (valoracio.comentari.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    valoracio.comentari,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatData(DateTime dt) =>
      DateFormat('d MMM yyyy', 'ca').format(dt);
}

// ── Avatar ────────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  const _Avatar({required this.autor, this.onTap});

  final AutorValoracio autor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final avatar = autor.fotoPerfil != null && autor.fotoPerfil!.isNotEmpty
        ? CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(autor.fotoPerfil!),
          )
        : CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              autor.nomUsuari[0].toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          );

    if (onTap == null) return avatar;
    return GestureDetector(onTap: onTap, child: avatar);
  }
}

// ── Estrelles ─────────────────────────────────────────────────────────────────

class _Estrelles extends StatelessWidget {
  const _Estrelles({required this.valor});

  final int valor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) => Icon(
        Icons.star,
        size: 14,
        color: i < valor ? AppSemanticColors.of(context).ratingFilled : Theme.of(context).colorScheme.outline,
      )),
    );
  }
}

// ── Botó carregar més ─────────────────────────────────────────────────────────

class _BotoCarregarMes extends StatelessWidget {
  const _BotoCarregarMes({required this.loading, required this.onTap});

  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: loading ? null : onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary,
          side: BorderSide(color: Theme.of(context).colorScheme.primaryContainer),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: loading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : Text(
                AppLocalizations.of(context)!.valoracionsCarregarMes,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
      ),
    );
  }
}

// ── Skeleton ──────────────────────────────────────────────────────────────────

class _SkeletonLlistat extends StatelessWidget {
  const _SkeletonLlistat();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (_) => const _SkeletonCard()),
    );
  }
}

class _SkeletonCard extends StatefulWidget {
  const _SkeletonCard();

  @override
  State<_SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<_SkeletonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 10, width: 100, color: Theme.of(context).colorScheme.surfaceContainerHighest),
                  const SizedBox(height: 8),
                  Container(height: 10, color: Theme.of(context).colorScheme.surfaceContainerHighest),
                  const SizedBox(height: 6),
                  Container(height: 10, width: double.infinity * 0.75, color: Theme.of(context).colorScheme.surfaceContainerHighest),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
