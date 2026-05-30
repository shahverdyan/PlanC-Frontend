import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/activitats/model/amic_assistent.dart';
import 'package:plan_c_frontend/features/activitats/presentation/provider/activitats_providers.dart';
import 'package:plan_c_frontend/features/perfil/presentation/profile_screen.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class AmicsFeedWidget extends ConsumerWidget {
  final String activitatId;

  const AmicsFeedWidget({super.key, required this.activitatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amicsAsync = ref.watch(amicsAssistentsProvider(activitatId));

    return amicsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) {
        debugPrint('[AmicsFeedWidget] error per activitat $activitatId: $e');
        return const SizedBox.shrink();
      },
      data: (amics) {
        debugPrint('[AmicsFeedWidget] activitat=$activitatId → ${amics.length} amics');
        if (amics.isEmpty) return const SizedBox.shrink();

        final seen = <String>{};
        final unique = amics.where((a) => seen.add(a.id)).toList();
        final visible = unique.take(3).toList();
        final restants = unique.length - visible.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < visible.length; i++)
              Padding(
                padding: EdgeInsets.only(
                  left: i * 5.0,
                  bottom: i < visible.length - 1 ? 2 : 0,
                ),
                child: _AmicFeedAvatar(amic: visible[i], index: i),
              ),
            if (restants > 0) ...[
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inverseSurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  AppLocalizations.of(context)!.mesAmics(restants),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _AmicFeedAvatar extends StatefulWidget {
  final AmicAssistentModel amic;
  final int index;

  const _AmicFeedAvatar({required this.amic, required this.index});

  @override
  State<_AmicFeedAvatar> createState() => _AmicFeedAvatarState();
}

class _AmicFeedAvatarState extends State<_AmicFeedAvatar>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _floatController;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryController, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );
    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutBack),
    );

    _floatController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    final entryDelay = widget.index * 80;
    Future.delayed(Duration(milliseconds: entryDelay), () {
      if (mounted) {
        _entryController.forward();
        _floatController.value = widget.index * 0.15;
        _floatController.repeat();
      }
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double r = 17;
    final inicials = widget.amic.nomUsuari.isNotEmpty
        ? widget.amic.nomUsuari[0].toUpperCase()
        : '?';

    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            final floatY =
                math.sin(_floatController.value * 2 * math.pi) * 3;
            return Transform.translate(
              offset: Offset(0, floatY),
              child: child,
            );
          },
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => ProfileScreen(profileUserId: widget.amic.id),
              ),
            ),
            child: Container(
              width: r * 2,
              height: r * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.20),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: r - 2,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                backgroundImage: widget.amic.fotoPerfil != null
                    ? NetworkImage(widget.amic.fotoPerfil!)
                    : null,
                child: widget.amic.fotoPerfil == null
                    ? Text(
                        inicials,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
