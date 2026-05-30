import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/features/activitats/model/valoracio.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import '../providers/quedada_valoracions_provider.dart';

class QuedadaValoracionsSection extends ConsumerWidget {
  const QuedadaValoracionsSection({required this.quedadaId, super.key});

  final String quedadaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final llistat = ref.watch(valoracionsQuedadaProvider(quedadaId));
    final potValorarAsync = ref.watch(potValorarQuedadaProvider(quedadaId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Separador(),
        const _Titol(),
        const SizedBox(height: 12),

        // ── Capçalera (mitjana + total) ──
        if (llistat.loading)
          const _SkeletonCapcalera()
        else
          _Capcalera(mitjana: llistat.mitjana, total: llistat.total),

        const SizedBox(height: 12),

        // ── Llistat ──
        if (llistat.loading)
          const _SkeletonLlistat()
        else if (llistat.error != null)
          _ErrorText(llistat.error!)
        else if (llistat.valoracions.isEmpty && llistat.total == 0)
          const _BuitText()
        else ...[
          ...llistat.valoracions.map((v) => _ResenyaCard(valoracio: v)),
          if (llistat.hasMore) ...[
            const SizedBox(height: 8),
            _BotoCarregarMes(
              loading: llistat.loadingMore,
              onTap: () => ref
                  .read(valoracionsQuedadaProvider(quedadaId).notifier)
                  .carregarMes(),
            ),
          ],
        ],

        // ── Formulari (només si potValorar) ──
        potValorarAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (result) => result.potValorar
              ? Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: _FormulariValoracio(quedadaId: quedadaId),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ── Separador i títol ─────────────────────────────────────────────────────────

class _Separador extends StatelessWidget {
  const _Separador();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Divider(thickness: 1),
      );
}

class _Titol extends StatelessWidget {
  const _Titol();

  @override
  Widget build(BuildContext context) => Text(
        AppLocalizations.of(context)!.valoracionsTitol,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      );
}

// ── Capçalera ─────────────────────────────────────────────────────────────────

class _Capcalera extends StatelessWidget {
  const _Capcalera({required this.mitjana, required this.total});

  final double mitjana;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
            border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                mitjana.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 24,
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
              AppLocalizations.of(context)!.valoracionsCount(total),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.valoracionsMitjana,
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
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: valoracio.esMeva
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
            : Theme.of(context).colorScheme.surfaceContainerLow,
        border: Border.all(
          color: valoracio.esMeva
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(autor: valoracio.autor),
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
                          Text(
                            valoracio.autor.nomUsuari,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
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
                      DateFormat('d MMM yyyy', 'ca')
                          .format(valoracio.dataValoracio),
                      style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
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
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.autor});

  final AutorValoracio autor;

  @override
  Widget build(BuildContext context) {
    if (autor.fotoPerfil != null && autor.fotoPerfil!.isNotEmpty) {
      return CircleAvatar(
        radius: 18,
        backgroundImage: NetworkImage(autor.fotoPerfil!),
      );
    }
    return CircleAvatar(
      radius: 18,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Text(
        autor.nomUsuari[0].toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _Estrelles extends StatelessWidget {
  const _Estrelles({required this.valor});

  final int valor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Icon(
          Icons.star,
          size: 13,
          color: i < valor
              ? AppSemanticColors.of(context).ratingFilled
              : AppSemanticColors.of(context).ratingEmpty,
        ),
      ),
    );
  }
}

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
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 10),
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
            : Text(AppLocalizations.of(context)!.valoracionsCarregarMes,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

// ── Estat buit / error ────────────────────────────────────────────────────────

class _BuitText extends StatelessWidget {
  const _BuitText();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          AppLocalizations.of(context)!.valoracionsEmptyQuedada,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
        ),
      );
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.missatge);

  final String missatge;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          missatge,
          style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13),
        ),
      );
}

// ── Skeleton ──────────────────────────────────────────────────────────────────

class _SkeletonCapcalera extends StatelessWidget {
  const _SkeletonCapcalera();

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 72,
            height: 52,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 100, height: 12, color: Theme.of(context).colorScheme.surfaceContainerHighest),
              const SizedBox(height: 6),
              Container(width: 80, height: 10, color: Theme.of(context).colorScheme.surfaceContainerHighest),
            ],
          ),
        ],
      );
}

class _SkeletonLlistat extends StatelessWidget {
  const _SkeletonLlistat();

  @override
  Widget build(BuildContext context) => Column(
        children: List.generate(2, (_) => const _SkeletonCard()),
      );
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
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
                  Container(height: 10, width: 90, color: Theme.of(context).colorScheme.surfaceContainerHighest),
                  const SizedBox(height: 6),
                  Container(height: 10, width: double.infinity, color: Theme.of(context).colorScheme.surfaceContainerHighest),
                ],
              ),
            ),
          ],
        ),
      );
}

// ── Formulari de valoració ────────────────────────────────────────────────────

class _FormulariValoracio extends ConsumerStatefulWidget {
  const _FormulariValoracio({required this.quedadaId});

  final String quedadaId;

  @override
  ConsumerState<_FormulariValoracio> createState() =>
      _FormulariValoracioState();
}

class _FormulariValoracioState extends ConsumerState<_FormulariValoracio> {
  int _puntuacio = 0;
  final _comentariCtrl = TextEditingController();

  @override
  void dispose() {
    _comentariCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enviarState = ref.watch(enviarValoracioProvider(widget.quedadaId));
    final isLoading =
        enviarState.status == EnviarValoracioStatus.loading;

    ref.listen(enviarValoracioProvider(widget.quedadaId), (prev, next) {
      if (next.status == EnviarValoracioStatus.success) {
        setState(() {
          _puntuacio = 0;
          _comentariCtrl.clear();
        });
      }
    });

    final sem = AppSemanticColors.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.valorarTitol,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),

          // ── Selector d'estrelles ──
          Row(
            children: List.generate(5, (i) {
              final estrella = i + 1;
              return GestureDetector(
                onTap: isLoading
                    ? null
                    : () => setState(() => _puntuacio = estrella),
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.star,
                    size: 32,
                    color: estrella <= _puntuacio
                        ? sem.ratingFilled
                        : sem.ratingEmpty,
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 12),

          // ── Camp de comentari ──
          TextField(
            controller: _comentariCtrl,
            enabled: !isLoading,
            maxLines: 3,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.valorarComentariHint,
              hintStyle: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              counterStyle:
                  TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),

          const SizedBox(height: 12),

          // ── Estat ──
          if (enviarState.status == EnviarValoracioStatus.success) ...[
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: sem.successSurface,
                border: Border.all(color: sem.success.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline,
                      color: sem.success, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      enviarState.puntsBonificacio != null &&
                              enviarState.puntsBonificacio! > 0
                          ? AppLocalizations.of(context)!.valorarSuccessWithPoints(enviarState.puntsBonificacio!)
                          : AppLocalizations.of(context)!.valorarSuccess,
                      style: TextStyle(
                        fontSize: 13,
                        color: sem.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (enviarState.status == EnviarValoracioStatus.error) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                enviarState.errorMessage ?? AppLocalizations.of(context)!.calendariErrorDesconegut,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],

          // ── Botó enviar ──
          if (enviarState.status != EnviarValoracioStatus.success)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (isLoading || _puntuacio == 0)
                    ? null
                    : () => ref
                        .read(enviarValoracioProvider(widget.quedadaId)
                            .notifier)
                        .enviar(
                          puntuacio: _puntuacio,
                          comentari: _comentariCtrl.text.trim(),
                        ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  disabledBackgroundColor:
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                  disabledForegroundColor: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: isLoading
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                    : Text(
                        _puntuacio == 0
                            ? AppLocalizations.of(context)!.valorarButtonNoPuntuacio
                            : AppLocalizations.of(context)!.valorarButtonEnviar,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
