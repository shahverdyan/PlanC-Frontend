import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/features/activitats/model/activitat.dart';
import 'package:plan_c_frontend/features/calendari/domain/entities/calendari_compte.dart';
import 'package:plan_c_frontend/features/calendari/domain/entities/calendari_event.dart';
import 'package:plan_c_frontend/features/calendari/presentation/providers/calendari_provider.dart';
import 'package:plan_c_frontend/features/groups/domain/models/group.dart';

void mostrarAfegirCalendariBottomSheet({
  required BuildContext context,
  required Activitat activitat,
  required Group group,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AfegirCalendariBottomSheet(
      activitat: activitat,
      group: group,
    ),
  );
}

Future<String?> mostrarDialegSeleccioCalendari({
  required BuildContext context,
  required List<CalendariCompte> calendaris,
}) async {
  final seleccionat = await showDialog<CalendariCompte>(
    context: context,
    builder: (ctx) => _DialogSeleccioCalendari(calendaris: calendaris),
  );
  return seleccionat?.id;
}

class AfegirCalendariBottomSheet extends ConsumerStatefulWidget {
  final Activitat activitat;
  final Group group;

  const AfegirCalendariBottomSheet({
    super.key,
    required this.activitat,
    required this.group,
  });

  @override
  ConsumerState<AfegirCalendariBottomSheet> createState() =>
      _AfegirCalendariBottomSheetState();
}

class _AfegirCalendariBottomSheetState
    extends ConsumerState<AfegirCalendariBottomSheet> {
  late final TextEditingController _titolController;
  late final TextEditingController _ubicacioController;
  late final TextEditingController _descripcioController;
  late DateTime _dataInici;
  late DateTime _dataFi;
  int? _alertaMinuts = 30;


  @override
  void initState() {
    super.initState();
    final event = CalendariNotifier.buildEvent(
      activitat: widget.activitat,
      group: widget.group,
    );
    _titolController = TextEditingController(text: event.titol);
    _ubicacioController = TextEditingController(text: event.ubicacio);
    _descripcioController = TextEditingController(text: event.descripcio);
    _dataInici = event.dataInici;
    _dataFi = event.dataFi;
    _alertaMinuts = event.alertaMinuts;
  }

  @override
  void dispose() {
    _titolController.dispose();
    _ubicacioController.dispose();
    _descripcioController.dispose();
    super.dispose();
  }

  String _formatDT(DateTime dt) =>
      DateFormat('dd/MM/yyyy · HH:mm').format(dt);

  Future<void> _seleccionarDataHora({required bool esInici}) async {
    final inicial = esInici ? _dataInici : _dataFi;
    final primerDia = esInici ? DateTime.now() : _dataInici;

    final data = await showDatePicker(
      context: context,
      initialDate: inicial,
      firstDate: primerDia,
      lastDate: DateTime.now().add(const Duration(days: 730)),
      locale: const Locale('ca'),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(primary: Theme.of(ctx).colorScheme.primary),
        ),
        child: child!,
      ),
    );
    if (data == null || !mounted) return;

    final hora = await showDialog<TimeOfDay>(
      context: context,
      barrierColor: Colors.black45,
      builder: (ctx) {
        DateTime tempTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          inicial.hour,
          inicial.minute,
        );
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Selecciona l\'hora',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    TimePickerSpinner(
                      is24HourMode: true,
                      time: tempTime,
                      onTimeChange: (time) => tempTime = time,
                      normalTextStyle: TextStyle(
                        fontSize: 16,
                        color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                      ),
                      highlightedTextStyle: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(ctx).colorScheme.secondary,
                      ),
                      spacing: 44,
                      itemHeight: 48,
                      isForce2Digits: true,
                      isShowSeconds: false,
                    ),
                    Text(
                      ':',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(ctx).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, null),
                      child: Text(
                        'Cancel·la',
                        style: TextStyle(color: Theme.of(ctx).colorScheme.secondary),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(
                        ctx,
                        TimeOfDay(
                          hour: tempTime.hour,
                          minute: tempTime.minute,
                        ),
                      ),
                      child: Text(
                        'D\'acord',
                        style: TextStyle(color: Theme.of(ctx).colorScheme.secondary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    if (hora == null || !mounted) return;

    final nouDT = DateTime(
      data.year, data.month, data.day, hora.hour, hora.minute,
    );

    setState(() {
      if (esInici) {
        _dataInici = nouDT;
        if (!_dataFi.isAfter(nouDT)) {
          _dataFi = nouDT.add(const Duration(hours: 2));
        }
      } else {
        _dataFi = nouDT;
      }
    });
  }

  Future<void> _confirmar() async {
    final event = CalendariEvent(
      titol: _titolController.text.trim(),
      ubicacio: _ubicacioController.text.trim(),
      descripcio: _descripcioController.text.trim(),
      dataInici: _dataInici,
      dataFi: _dataFi,
      alertaMinuts: _alertaMinuts,
    );
    await ref
        .read(calendariProvider.notifier)
        .iniciarAfegirAlCalendari(event);
  }

  Future<void> _mostrarDialegSeleccioCalendari(
    List<CalendariCompte> calendaris,
  ) async {
    if (!mounted) return;

    final seleccionat = await showDialog<CalendariCompte>(
      context: context,
      builder: (ctx) => _DialogSeleccioCalendari(calendaris: calendaris),
    );

    if (!mounted) return;

    if (seleccionat == null) {
      ref.read(calendariProvider.notifier).reiniciar();
    } else {
      await ref
          .read(calendariProvider.notifier)
          .confirmarCalendari(seleccionat.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(calendariProvider).status;
    final isLoading = status == CalendariStatus.loading;

    ref.listen(calendariProvider, (prev, next) async {
      if (!mounted) return;

      switch (next.status) {
        case CalendariStatus.seleccionantCalendari:
          await _mostrarDialegSeleccioCalendari(next.calendarisDisponibles);

        case CalendariStatus.success:
          final messenger = ScaffoldMessenger.of(context);
          Navigator.of(context).pop();
          messenger.showSnackBar(
            SnackBar(
              content: Builder(
                builder: (ctx) {
                  final sem = AppSemanticColors.of(ctx);
                  return Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: sem.onSuccess),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text('Esdeveniment afegit al calendari correctament'),
                      ),
                    ],
                  );
                }
              ),
              backgroundColor: AppSemanticColors.of(context).success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          ref.read(calendariProvider.notifier).reiniciar();

        case CalendariStatus.permisDenega:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Cal concedir permisos d\'accés al calendari des de Configuració',
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
          );
          ref.read(calendariProvider.notifier).reiniciar();

        case CalendariStatus.error:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${next.errorMessage ?? 'Error desconegut'}'),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
          );
          ref.read(calendariProvider.notifier).reiniciar();

        case CalendariStatus.loading:
        case CalendariStatus.initial:
          break;
      }
    });

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: EdgeInsets.only(bottom: bottomInset),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(
                    Icons.calendar_month_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Afegir al calendari',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 42),
              child: Text(
                'Revisa i edita els detalls abans de confirmar',
                style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ),
            const SizedBox(height: 20),

            _SectionLabel('Títol'),
            const SizedBox(height: 6),
            _InputField(
                controller: _titolController,
                hint: 'Títol de l\'esdeveniment'),
            const SizedBox(height: 14),

            _SectionLabel('Ubicació'),
            const SizedBox(height: 6),
            _InputField(controller: _ubicacioController, hint: 'Ubicació'),
            const SizedBox(height: 14),

            _SectionLabel('Inici'),
            const SizedBox(height: 6),
            _DateRow(
              dateTime: _dataInici,
              onTap: () => _seleccionarDataHora(esInici: true),
              label: _formatDT(_dataInici),
            ),
            const SizedBox(height: 14),

            _SectionLabel('Fi'),
            const SizedBox(height: 6),
            _DateRow(
              dateTime: _dataFi,
              onTap: () => _seleccionarDataHora(esInici: false),
              label: _formatDT(_dataFi),
            ),
            const SizedBox(height: 14),

            _SectionLabel('Alerta'),
            const SizedBox(height: 6),
            _AlertDropdown(
              value: _alertaMinuts,
              onChanged: (v) => setState(() => _alertaMinuts = v),
            ),
            const SizedBox(height: 14),

            _SectionLabel('Descripció'),
            const SizedBox(height: 6),
            _InputField(
              controller: _descripcioController,
              hint: 'Descripció',
              maxLines: 5,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : _confirmar,
                icon: isLoading
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                    : const Icon(Icons.calendar_month),
                label: Text(
                  isLoading ? 'Carregant...' : 'Afegir al calendari',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  disabledBackgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Diàleg selecció de calendari ────────────────────────────────────────────

class _DialogSeleccioCalendari extends StatelessWidget {
  const _DialogSeleccioCalendari({required this.calendaris});

  final List<CalendariCompte> calendaris;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.account_circle_outlined, color: Theme.of(context).colorScheme.primary),
          SizedBox(width: 10),
          Text(
            'Selecciona un compte',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'On vols desar l\'esdeveniment?',
              style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < calendaris.length; i++) ...[
                    if (i > 0) const Divider(height: 1),
                    _CalendariTile(
                      compte: calendaris[i],
                      onTap: () =>
                          Navigator.of(context).pop(calendaris[i]),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Divider(height: 1),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel·lar',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}

// ── Sub-widgets ─────────────────────────────────────────────────────────────

class _CalendariTile extends StatelessWidget {
  const _CalendariTile({required this.compte, required this.onTap});

  final CalendariCompte compte;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
        child: Text(
          compte.nomCalendari.isNotEmpty
              ? compte.nomCalendari[0].toUpperCase()
              : 'G',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        compte.nomCalendari,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        compte.nomCompte,
        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      onTap: onTap,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({
    required this.dateTime,
    required this.onTap,
    required this.label,
  });

  final DateTime dateTime;
  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.schedule_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 15),
            ),
            const Spacer(),
            Icon(Icons.edit_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 16),
          ],
        ),
      ),
    );
  }
}

class _AlertDropdown extends StatelessWidget {
  const _AlertDropdown({required this.value, required this.onChanged});

  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          value: value,
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: null, child: Text('Sense alerta')),
            DropdownMenuItem(value: 15, child: Text('15 minuts abans')),
            DropdownMenuItem(value: 30, child: Text('30 minuts abans')),
            DropdownMenuItem(value: 60, child: Text('1 hora abans')),
            DropdownMenuItem(value: 1440, child: Text('1 dia abans')),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
