import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/activitats/model/amic_assistent.dart';
import 'package:plan_c_frontend/features/activitats/presentation/provider/activitats_providers.dart';
import 'package:plan_c_frontend/features/perfil/presentation/profile_screen.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class AmicsAssistentsWidget extends ConsumerWidget {
  const AmicsAssistentsWidget({
    required this.activitatId,
    this.quedadaId,
    super.key,
  });

  final String activitatId;
  // Si s'especifica, filtra per mostrar només els amics d'aquesta quedada concreta.
  final String? quedadaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amicsAsync = ref.watch(amicsAssistentsProvider(activitatId));

    return amicsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (totsElsAmics) {
        // Filtra per quedada si cal
        final amicsFiltrats = quedadaId != null
            ? totsElsAmics.where((a) => a.quedada.id == quedadaId).toList()
            : totsElsAmics;

        // Deduplicació per id d'usuari
        final vistos = <String>{};
        final amics = amicsFiltrats.where((a) => vistos.add(a.id)).toList();

        if (amics.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.amicsApuntats(amics.length),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 76,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: amics.length,
                itemBuilder: (context, index) {
                  return _AmicCard(
                    amic: amics[index],
                    index: index,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => ProfileScreen(profileUserId: amics[index].id),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AmicCard extends StatefulWidget {
  const _AmicCard({
    required this.amic,
    required this.index,
    required this.onTap,
  });

  final AmicAssistentModel amic;
  final int index;
  final VoidCallback onTap;

  @override
  State<_AmicCard> createState() => _AmicCardState();
}

class _AmicCardState extends State<_AmicCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    Future.delayed(Duration(milliseconds: widget.index * 60), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final amic = widget.amic;
    final colorScheme = Theme.of(context).colorScheme;
    final inicials = amic.nomUsuari.isNotEmpty ? amic.nomUsuari[0].toUpperCase() : '?';

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: colorScheme.primaryContainer,
                  backgroundImage:
                      amic.fotoPerfil != null ? NetworkImage(amic.fotoPerfil!) : null,
                  child: amic.fotoPerfil == null
                      ? Text(
                          inicials,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 60,
                  child: Text(
                    amic.nomUsuari,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
