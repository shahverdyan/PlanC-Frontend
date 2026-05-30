import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import '../providers/interaccions_provider.dart';
import '../providers/comentaris_provider.dart';

class ComentariInput extends ConsumerStatefulWidget {
  final String publicacioId;

  const ComentariInput({super.key, required this.publicacioId});

  @override
  ConsumerState<ComentariInput> createState() => _ComentariInputState();
}

class _ComentariInputState extends ConsumerState<ComentariInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _enviar() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final replyTarget = ref.read(replyTargetProvider(widget.publicacioId));
    ref.read(enviarComentariProvider.notifier).enviar(
          widget.publicacioId,
          text,
          comentariPareId: replyTarget?.id,
        );
  }

  void _cancelarResposta() {
    ref.read(replyTargetProvider(widget.publicacioId).notifier).state = null;
    _controller.clear();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final enviarState = ref.watch(enviarComentariProvider);
    final isLoading = enviarState is AsyncLoading;
    final replyTarget = ref.watch(replyTargetProvider(widget.publicacioId));

    // Quan s'estableix un reply target, obrim el teclat automàticament
    ref.listen<dynamic>(replyTargetProvider(widget.publicacioId), (_, next) {
      if (next != null) _focusNode.requestFocus();
    });

    ref.listen<AsyncValue<void>>(enviarComentariProvider, (previous, next) {
      if (previous is AsyncLoading && next is AsyncData) {
        _controller.clear();
        FocusScope.of(context).unfocus();
        // Esborra el reply target i refresca la llista
        ref.read(replyTargetProvider(widget.publicacioId).notifier).state = null;
        ref.invalidate(comentarisProvider(widget.publicacioId));
        ref.read(comentarisAdicionalsProvider(widget.publicacioId).notifier).state++;
      }
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Banner de resposta — visible només quan es respon a algú
          if (replyTarget != null)
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.reply, size: 16, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      t.comentariResponent(replyTarget.nomUsuari),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: _cancelarResposta,
                    child: Icon(Icons.close, size: 16, color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),

          // Camp de text + botó d'enviament
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      hintText: replyTarget != null
                          ? t.comentariHintReply(replyTarget.nomUsuari)
                          : t.comentariHint,
                      hintStyle:
                          TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: isLoading ? null : (_) => _enviar(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 44,
                          height: 44,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onPrimary,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : IconButton(
                          icon: Icon(Icons.send,
                              color: Theme.of(context).colorScheme.onPrimary, size: 20),
                          onPressed: _enviar,
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
