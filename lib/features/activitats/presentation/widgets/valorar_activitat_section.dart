import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/features/activitats/presentation/providers/valorar_activitat_provider.dart';
import 'package:plan_c_frontend/features/calendari/data/models/quedada_apuntada_model.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class ValorarActivitatSection extends ConsumerWidget {
  const ValorarActivitatSection({required this.activitatId, super.key});

  final String activitatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eligiblesAsync =
        ref.watch(quedadesEligiblesProvider(activitatId));

    return eligiblesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (_) {
        final perValorarAsync = ref.watch(quedadesPerValorarProvider(activitatId));

        return perValorarAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (perValorar) {
            final valorarState = ref.watch(valorarActivitatProvider(activitatId));
            final disponibles = perValorar
                .where((q) => !valorarState.jaValorades.contains(q.quedadaId))
                .toList();

            if (disponibles.isEmpty) return const SizedBox.shrink();

            return _FormulariValoracio(
              activitatId: activitatId,
              disponibles: disponibles,
            );
          },
        );
      },
    );
  }
}

class _FormulariValoracio extends ConsumerWidget {
  const _FormulariValoracio({
    required this.activitatId,
    required this.disponibles,
  });

  final String activitatId;
  final List<QuedadaApuntadaModel> disponibles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final state = ref.watch(valorarActivitatProvider(activitatId));
    final notifier = ref.read(valorarActivitatProvider(activitatId).notifier);
    final isLoading = state.status == ValorarStatus.loading;

    if (disponibles.length == 1 && state.quedadaIdSeleccionada == null) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => notifier.seleccionarQuedada(disponibles.first.quedadaId));
    }

    final cs = Theme.of(context).colorScheme;
    final sem = AppSemanticColors.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.3),
        border: Border.all(color: cs.primaryContainer),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.valorarTitol,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          // ── Selector / indicador de quedada ──
          if (disponibles.length == 1) ...[
            Text(
              t.valorarLabelQuedada,
              style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: cs.surface,
                border: Border.all(color: cs.outline),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                () {
                  final q = disponibles.first;
                  final data = DateFormat('d MMM yyyy, HH:mm', 'ca')
                      .format(q.dataHoraTrobada.toLocal());
                  return '${q.quedadaTitol} · $data';
                }(),
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
          ] else if (disponibles.length > 1) ...[
            Text(
              t.valorarLabelQuedada,
              style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              decoration: BoxDecoration(
                color: cs.surface,
                border: Border.all(color: cs.outline),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: state.quedadaIdSeleccionada,
                isExpanded: true,
                underline: const SizedBox.shrink(),
                hint: Text(t.valorarSelectQuedada,
                    style: const TextStyle(fontSize: 13)),
                items: disponibles.map((q) {
                  final data = DateFormat('d MMM yyyy, HH:mm', 'ca')
                      .format(q.dataHoraTrobada.toLocal());
                  return DropdownMenuItem(
                    value: q.quedadaId,
                    child: Text(
                      '${q.quedadaTitol} · $data',
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: isLoading
                    ? null
                    : (v) {
                        if (v != null) notifier.seleccionarQuedada(v);
                      },
              ),
            ),
            const SizedBox(height: 12),
          ],

          // ── Selector d'estrelles ──
          Text(
            t.valorarLabelPuntuacio,
            style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(5, (i) {
              final estrella = i + 1;
              return GestureDetector(
                onTap: isLoading
                    ? null
                    : () => notifier.setPuntuacio(estrella),
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Icon(
                    Icons.star,
                    size: 34,
                    color: estrella <= state.puntuacio
                        ? sem.ratingFilled
                        : cs.outline,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),

          // ── Camp de comentari ──
          Text(
            t.valorarLabelComentari,
            style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 6),
          _ComentariField(
            activitatId: activitatId,
            enabled: !isLoading,
          ),
          const SizedBox(height: 12),

          // ── Missatge d'èxit ──
          if (state.status == ValorarStatus.success) ...[
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: sem.successSurface,
                border: Border.all(color: sem.success.withValues(alpha: 0.4)),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline,
                      color: sem.success, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.puntsBonificacio != null &&
                              state.puntsBonificacio! > 0
                          ? t.valorarSuccessWithPoints(state.puntsBonificacio!)
                          : t.valorarSuccess,
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
            const SizedBox(height: 8),
          ],

          // ── Missatge d'error ──
          if (state.status == ValorarStatus.error &&
              state.errorMessage != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                state.errorMessage!,
                style: TextStyle(
                    color: cs.error,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],

          // ── Botó enviar ──
          if (disponibles.isNotEmpty || state.status == ValorarStatus.loading)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (isLoading ||
                        state.puntuacio == 0 ||
                        state.quedadaIdSeleccionada == null)
                    ? null
                    : () => notifier.enviar(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  disabledBackgroundColor: cs.primary.withValues(alpha: 0.4),
                  disabledForegroundColor: cs.onPrimary.withValues(alpha: 0.7),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md)),
                  elevation: AppElevation.none,
                ),
                child: isLoading
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: cs.onPrimary),
                      )
                    : Text(
                        state.quedadaIdSeleccionada == null
                            ? t.valorarButtonNoQuedada
                            : state.puntuacio == 0
                                ? t.valorarButtonNoPuntuacio
                                : t.valorarButtonEnviar,
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

// Camp de comentari separat per tenir el seu propi controlador
class _ComentariField extends ConsumerStatefulWidget {
  const _ComentariField({required this.activitatId, required this.enabled});

  final String activitatId;
  final bool enabled;

  @override
  ConsumerState<_ComentariField> createState() => _ComentariFieldState();
}

class _ComentariFieldState extends ConsumerState<_ComentariField> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(valorarActivitatProvider(widget.activitatId), (prev, next) {
      if (prev?.status != ValorarStatus.success &&
          next.status == ValorarStatus.success &&
          _ctrl.text.isNotEmpty) {
        _ctrl.clear();
      }
    });

    final t = AppLocalizations.of(context)!;
    return TextField(
      controller: _ctrl,
      enabled: widget.enabled,
      maxLines: 3,
      maxLength: 500,
      onChanged: (v) => ref
          .read(valorarActivitatProvider(widget.activitatId).notifier)
          .setComentari(v),
      decoration: InputDecoration(
        hintText: t.valorarComentariHint,
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
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        counterStyle: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}
