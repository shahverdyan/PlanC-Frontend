import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plan_c_frontend/features/amistats/presentation/screens/friends_list_screen.dart';
import 'package:plan_c_frontend/features/chat/presentation/screens/chat_room_screen.dart';
import 'package:plan_c_frontend/features/notificacions/domain/models/notificacio.dart';
import 'package:plan_c_frontend/features/notificacions/presentation/providers/notificacions_provider.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';

class NotificacionsListScreen extends ConsumerStatefulWidget {
  final String usuariId;
  final VoidCallback onNavigateToAmistats;
  final VoidCallback onNavigateToXats;

  const NotificacionsListScreen({
    super.key,
    required this.usuariId,
    required this.onNavigateToAmistats,
    required this.onNavigateToXats,
  });

  @override
  ConsumerState<NotificacionsListScreen> createState() =>
      _NotificacionsListScreenState();
}

class _NotificacionsListScreenState
    extends ConsumerState<NotificacionsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final repo = ref.read(notificacionsRepositoryProvider);
      await repo.marcarLlegides(usuariId: widget.usuariId);
      if (mounted) ref.invalidate(teNoLlegidesProvider(widget.usuariId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final notificacionsAsync = ref.watch(notificacionsProvider(widget.usuariId));

    return Scaffold(
      body: notificacionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 40),
                const SizedBox(height: 12),
                Text(
                  e.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      ref.invalidate(notificacionsProvider(widget.usuariId)),
                  child: Text(t.notificacionsRetry),
                ),
              ],
            ),
          ),
        ),
        data: (notificacions) {
          if (notificacions.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_none,
                      size: 56, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(height: 12),
                  Text(
                    t.notificacionsEmpty,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 16),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async =>
                ref.invalidate(notificacionsProvider(widget.usuariId)),
            child: ListView.separated(
              itemCount: notificacions.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final n = notificacions[index];
                return _NotificacioCard(
                  notificacio: n,
                  onTap: _resolveOnTap(context, n),
                );
              },
            ),
          );
        },
      ),
    );
  }

  VoidCallback? _resolveOnTap(BuildContext context, Notificacio n) {
    switch (n.tipus) {
      case 'NOVA_AMISTAT':
        return widget.onNavigateToAmistats;
      case 'AMISTAT_ACCEPTADA':
        return () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FriendsListScreen(viewedUserId: widget.usuariId),
              ),
            );
      case 'NOU_MEMBRE_GRUP':
        if (n.xatId != null) {
          return () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatRoomScreen(
                    chatId: n.xatId!,
                    chatName: n.xatNom ?? 'Grup',
                  ),
                ),
              );
        }
        return widget.onNavigateToXats;
      case 'NOU_MISSATGE':
        if (n.xatId != null) {
          return () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatRoomScreen(
                    chatId: n.xatId!,
                    chatName: n.xatNom ?? 'Xat',
                  ),
                ),
              );
        }
        return widget.onNavigateToXats;
      default:
        return null;
    }
  }
}

class _NotificacioCard extends StatelessWidget {
  final Notificacio notificacio;
  final VoidCallback? onTap;

  const _NotificacioCard({required this.notificacio, this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final noLlegida = !notificacio.estaLlegida;
    final tappable = onTap != null;

    return Material(
      color: noLlegida ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.25) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TipusIcon(tipus: notificacio.tipus, noLlegida: noLlegida),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notificacio.titol,
                            style: TextStyle(
                              fontWeight: noLlegida
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        if (noLlegida)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notificacio.cosText,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          _formatData(notificacio.dataCreacio, t, locale),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (tappable) ...[
                          const SizedBox(width: 6),
                          Icon(
                            Icons.chevron_right,
                            size: 14,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatData(DateTime data, AppLocalizations t, String locale) {
    final local = data.toLocal();
    final ara = DateTime.now();
    final avui = DateTime(ara.year, ara.month, ara.day);
    final diaData = DateTime(local.year, local.month, local.day);
    final diferencia = avui.difference(diaData).inDays;
    final hora =
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';

    if (diferencia == 0) return t.notificacionsDataAvui(hora);
    if (diferencia == 1) return t.notificacionsDataAhir(hora);
    if (diferencia < 7) {
      final nomDia = DateFormat('EEEE', locale).format(local);
      return t.notificacionsDataDiaSetmana(nomDia, hora);
    }
    return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year}';
  }
}

class _TipusIcon extends StatelessWidget {
  final String tipus;
  final bool noLlegida;

  const _TipusIcon({required this.tipus, required this.noLlegida});

  @override
  Widget build(BuildContext context) {
    final sem = AppSemanticColors.of(context);
    final IconData iconData;
    final Color color;

    switch (tipus) {
      case 'NOVA_AMISTAT':
        iconData = Icons.person_add;
        color = sem.success;
      case 'AMISTAT_ACCEPTADA':
        iconData = Icons.people;
        color = sem.info;
      case 'NOU_MEMBRE_GRUP':
        iconData = Icons.group;
        color = sem.info;
      default:
        iconData = Icons.notifications;
        color = Theme.of(context).colorScheme.primary;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: noLlegida ? 0.15 : 0.08),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: color, size: 20),
    );
  }
}
