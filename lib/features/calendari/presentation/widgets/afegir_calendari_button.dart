import 'package:flutter/material.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/features/activitats/model/activitat.dart';
import 'package:plan_c_frontend/features/calendari/presentation/widgets/afegir_calendari_bottom_sheet.dart';
import 'package:plan_c_frontend/features/groups/domain/models/group.dart';

class AfegirCalendariButton extends StatelessWidget {
  final Activitat activitat;
  final Group group;

  const AfegirCalendariButton({
    super.key,
    required this.activitat,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => mostrarAfegirCalendariBottomSheet(
          context: context,
          activitat: activitat,
          group: group,
        ),
        icon: const Icon(Icons.calendar_month_outlined, size: 18),
        label: const Text('Afegir al calendari'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary,
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}
