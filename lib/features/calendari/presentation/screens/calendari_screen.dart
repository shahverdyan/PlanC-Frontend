import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:plan_c_frontend/features/calendari/data/models/quedada_apuntada_model.dart';
import 'package:plan_c_frontend/features/calendari/presentation/providers/quedades_calendari_provider.dart';
import 'package:plan_c_frontend/features/calendari/presentation/providers/sync_calendari_provider.dart';
import 'package:plan_c_frontend/features/calendari/presentation/widgets/afegir_calendari_bottom_sheet.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class CalendariScreen extends ConsumerStatefulWidget {
  const CalendariScreen({super.key});

  @override
  ConsumerState<CalendariScreen> createState() => _CalendariScreenState();
}

class _CalendariScreenState extends ConsumerState<CalendariScreen> {

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  static DateTime _dayKey(DateTime dt) {
    final l = dt.toLocal();
    return DateTime(l.year, l.month, l.day);
  }

  Map<DateTime, List<QuedadaApuntadaModel>> _buildEventMap(
      List<QuedadaApuntadaModel> list) {
    final map = <DateTime, List<QuedadaApuntadaModel>>{};
    for (final q in list) {
      final key = _dayKey(q.dataHoraTrobada);
      map.putIfAbsent(key, () => []).add(q);
    }
    return map;
  }

  List<QuedadaApuntadaModel> _eventsForDay(
      Map<DateTime, List<QuedadaApuntadaModel>> map, DateTime day) {
    return map[_dayKey(day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final cs = Theme.of(context).colorScheme;
    final sem = AppSemanticColors.of(context);
    final colorOrange = cs.primary;
    final colorOrangeDark = cs.primary;
    final colorGreen = sem.success;

    final quedadesAsync = ref.watch(quedadesCalendariProvider);
    final eventMap = quedadesAsync.valueOrNull != null
        ? _buildEventMap(quedadesAsync.value!)
        : <DateTime, List<QuedadaApuntadaModel>>{};
    final selectedEvents = _selectedDay != null
        ? _eventsForDay(eventMap, _selectedDay!)
        : <QuedadaApuntadaModel>[];

    final syncStatus = ref.watch(syncCalendariProvider).status;
    final isSyncing = syncStatus == SyncCalendariStatus.syncing ||
        syncStatus == SyncCalendariStatus.loading;

    ref.listen(syncCalendariProvider, (prev, next) async {
      if (!mounted) return;
      switch (next.status) {
        case SyncCalendariStatus.seleccionantCalendari:
          final calendarId = await mostrarDialegSeleccioCalendari(
            context: context,
            calendaris: next.calendaris,
          );
          if (!mounted) return;
          if (calendarId == null) {
            ref.read(syncCalendariProvider.notifier).reiniciar();
          } else {
            await ref
                .read(syncCalendariProvider.notifier)
                .confirmarCalendari(calendarId);
          }
        case SyncCalendariStatus.success:
          final result = next.result;
          final msg = result != null
              ? t.calendariSyncSuccess(
                  result.created, result.updated, result.deleted)
              : t.calendariSyncSuccessNoResult;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              backgroundColor: sem.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm)),
            ),
          );
          ref.read(syncCalendariProvider.notifier).reiniciar();
        case SyncCalendariStatus.permisDenega:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t.calendariSyncPermisDenega),
              backgroundColor: cs.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm)),
            ),
          );
          ref.read(syncCalendariProvider.notifier).reiniciar();
        case SyncCalendariStatus.error:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t.calendariSyncError(
                  next.errorMessage ?? t.calendariErrorDesconegut)),
              backgroundColor: cs.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm)),
            ),
          );
          ref.read(syncCalendariProvider.notifier).reiniciar();
        default:
          break;
      }
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          if (isSyncing)
            Padding(
              padding: const EdgeInsets.all(14),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorOrange,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.sync),
              color: colorOrange,
              tooltip: t.calendariSyncTooltip,
              onPressed: () =>
                  ref.read(syncCalendariProvider.notifier).iniciarSync(),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Calendari ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: TableCalendar<QuedadaApuntadaModel>(
                    locale: locale,
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) =>
                        isSameDay(_selectedDay, day),
                    eventLoader: (day) => _eventsForDay(eventMap, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    calendarFormat: CalendarFormat.month,
                    availableCalendarFormats: {
                      CalendarFormat.month: t.calendariFormatMes,
                    },
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      leftChevronIcon:
                          Icon(Icons.chevron_left, color: colorOrange),
                      rightChevronIcon:
                          Icon(Icons.chevron_right, color: colorOrange),
                      headerPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurfaceVariant),
                      weekendStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colorOrangeDark),
                    ),
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      defaultTextStyle: TextStyle(
                          fontSize: 14, color: Theme.of(context).colorScheme.onSurface),
                      weekendTextStyle:
                          TextStyle(fontSize: 14, color: colorOrangeDark),
                      todayDecoration: BoxDecoration(
                        color: colorOrange.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: colorOrangeDark),
                      selectedDecoration: BoxDecoration(
                          color: colorOrange, shape: BoxShape.circle),
                      selectedTextStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: cs.onPrimary),
                      cellMargin: const EdgeInsets.all(4),
                      markersOffset: const PositionedOffset(bottom: -6),
                    ),
                    calendarBuilders: CalendarBuilders<QuedadaApuntadaModel>(
                      todayBuilder: (context, day, focusedDay) {
                        return Center(
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: colorOrange.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: colorOrangeDark,
                              ),
                            ),
                          ),
                        );
                      },
                      selectedBuilder: (context, day, focusedDay) {
                        return Center(
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: colorOrange,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: cs.onPrimary,
                              ),
                            ),
                          ),
                        );
                      },
                      markerBuilder: (context, day, events) {
                        if (events.isEmpty) return const SizedBox.shrink();
                        final hasConfirmat =
                            events.any((e) => e.estat == 'CONFIRMAT');
                        final hasPendent = events.any(
                            (e) => e.estat == 'PENDENT_CONFIRMACIO');
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (hasConfirmat) _dot(colorGreen),
                            if (hasConfirmat && hasPendent)
                              const SizedBox(width: 3),
                            if (hasPendent) _dot(colorOrange),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // ── Capçalera del dia seleccionat ──────────────────────
            if (_selectedDay != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 16, 6),
                child: Row(
                  children: [
                    Text(
                      DateFormat('EEEE, d MMMM', locale)
                          .format(_selectedDay!),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (selectedEvents.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorOrange,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          '${selectedEvents.length}',
                          style: TextStyle(
                              fontSize: 11,
                              color: cs.onPrimary,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

            // ── Llista d'events ────────────────────────────────────
            Expanded(
              child: quedadesAsync.isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: colorOrange))
                  : quedadesAsync.hasError
                      ? Center(
                          child: Text(
                            t.calendariErrorCarregant,
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                        )
                      : _selectedDay == null
                          ? Center(
                              child: Text(
                                t.calendariSeleccionaDia,
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14),
                              ),
                            )
                          : selectedEvents.isEmpty
                              ? Center(
                                  child: Text(
                                    t.calendariCapQuedada,
                                    style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14),
                                  ),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.fromLTRB(
                                      16, 4, 16, 24),
                                  itemCount: selectedEvents.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(height: 8),
                                  itemBuilder: (ctx, i) => _EventCard(
                                    event: selectedEvents[i],
                                    onTap: () => _showDetail(
                                        context, selectedEvents[i]),
                                  ),
                                ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot(Color color) => Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );

  void _showDetail(BuildContext context, QuedadaApuntadaModel q) {
    final t = AppLocalizations.of(context)!;
    final isConfirmat = q.estat == 'CONFIRMAT';
    final isAdmin = q.rol == 'ADMINISTRADOR';
    final sem = AppSemanticColors.of(context);
    final cs = Theme.of(context).colorScheme;
    final statusColor = isConfirmat ? sem.success : cs.primary;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final bottomInset = MediaQuery.viewPaddingOf(ctx).bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(24, 12, 24, bottomInset + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(ctx).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              q.quedadaTitol,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.event_note_outlined,
              label: t.calendariLabelActivitat,
              value: q.titolActivitat,
            ),
            const SizedBox(height: 10),
            _DetailRow(
              icon: Icons.category_outlined,
              label: t.calendariLabelCategoria,
              value: q.categoriaNom,
            ),
            const SizedBox(height: 10),
            _DetailRow(
              icon: Icons.access_time,
              label: t.calendariLabelHora,
              value: DateFormat('HH:mm').format(q.dataHoraTrobada.toLocal()),
            ),
            const SizedBox(height: 10),
            _DetailRow(
              icon: isAdmin ? Icons.star_outlined : Icons.person_outline,
              label: t.calendariLabelRol,
              value: isAdmin ? t.calendariRolAdministrador : t.calendariRolMembre,
              valueColor: isAdmin ? sem.ratingFilled : null,
            ),
            const SizedBox(height: 10),
            _DetailRow(
              icon: isConfirmat
                  ? Icons.check_circle_outline
                  : Icons.hourglass_empty,
              label: t.calendariLabelEstat,
              value: isConfirmat
                  ? t.calendariEstatConfirmat
                  : t.calendariEstatPendentConfirmacio,
              valueColor: statusColor,
            ),
          ],
        ),
      );
      },
    );
  }
}

// ── Event Card ────────────────────────────────────────────────────────────────

class _EventCard extends StatelessWidget {
  final QuedadaApuntadaModel event;
  final VoidCallback onTap;

  const _EventCard({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isConfirmat = event.estat == 'CONFIRMAT';
    final isAdmin = event.rol == 'ADMINISTRADOR';
    final sem = AppSemanticColors.of(context);
    final cs = Theme.of(context).colorScheme;
    final color = isConfirmat ? sem.success : cs.primary;
    final timeStr =
        DateFormat('HH:mm').format(event.dataHoraTrobada.toLocal());

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.35), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.07),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Hora
            Container(
              width: 52,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                timeStr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color),
              ),
            ),
            const SizedBox(width: 12),
            // Títols
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.quedadaTitol,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.titolActivitat,
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Badges
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isAdmin)
                  Icon(Icons.star, size: 15, color: sem.ratingFilled),
                if (isAdmin) const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isConfirmat ? t.calendariEstatConfirmat : t.calendariEstatPendent,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: color),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Detail Row ────────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text('$label: ',
            style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: valueColor ?? Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ],
    );
  }
}
