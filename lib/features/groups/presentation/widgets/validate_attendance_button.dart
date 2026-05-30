import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/core/providers/location_provider.dart';
import 'package:plan_c_frontend/features/groups/domain/models/group.dart';
import 'package:plan_c_frontend/features/groups/presentation/providers/validate_attendance_provider.dart';
import 'package:plan_c_frontend/features/map/presentation/services/location_service.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class ValidateAttendanceButton extends ConsumerWidget {
  final Group group;
  final String? currentUserId;
  final bool isAttendanceConfirmed;
  final bool isAttendanceValidated;
  final DateTime dataHoraTrobada;
  final DateTime dataFiActivitat;
  final VoidCallback? onValidated;

  const ValidateAttendanceButton({
    super.key,
    required this.group,
    required this.currentUserId,
    required this.isAttendanceConfirmed,
    required this.isAttendanceValidated,
    required this.dataHoraTrobada,
    required this.dataFiActivitat,
    this.onValidated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    if (!isAttendanceConfirmed || isAttendanceValidated) {
      return const SizedBox.shrink();
    }

    ref.listen(validateAttendanceProvider(group.id), (prev, next) {
      if (prev?.status == ValidateAttendanceStatus.loading &&
          next.status == ValidateAttendanceStatus.validated) {
        final localT = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localT.validateAttendanceValidatedSnackbar),
            backgroundColor: AppSemanticColors.of(context).success,
          ),
        );
        onValidated?.call();
      }
    });

    String? buildErrorMessage(ValidateAttendanceState s) {
      if (s.status != ValidateAttendanceStatus.error) return null;
      final rawError = s.errorMessage ?? '';
      final error = rawError.replaceFirst('Exception: ', '');
      final isTooFarError = error.startsWith('distance:') ||
          error.toLowerCase().contains('lluny');
      if (isTooFarError) {
        if (error.startsWith('distance:')) {
          final distStr = error.substring('distance:'.length);
          return t.validateAttendanceTooFarKnown(distStr);
        }
        return t.validateAttendanceTooFar;
      }
      return error.isNotEmpty ? error : t.validateAttendanceGenericError;
    }

    final state = ref.watch(validateAttendanceProvider(group.id));

    final sem = AppSemanticColors.of(context);
    final primaryOrange = Theme.of(context).colorScheme.primary;
    const buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    );

    if (state.status == ValidateAttendanceStatus.validated) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.check_circle_outline),
          label: Text(t.validateAttendanceValidatedButton),
          style: ElevatedButton.styleFrom(
            backgroundColor: sem.success,
            foregroundColor: sem.onSuccess,
            disabledBackgroundColor: sem.success,
            disabledForegroundColor: sem.onSuccess,
            shape: buttonShape,
          ),
        ),
      );
    }

    if (state.status == ValidateAttendanceStatus.loading) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryOrange,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            disabledBackgroundColor: primaryOrange,
            disabledForegroundColor: Theme.of(context).colorScheme.onPrimary,
            shape: buttonShape,
          ),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      );
    }

    final errorMessage = buildErrorMessage(state);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final now = DateTime.now();
              final trobada = DateTime(
                dataHoraTrobada.year, dataHoraTrobada.month, dataHoraTrobada.day,
                dataHoraTrobada.hour, dataHoraTrobada.minute,
              );
              final fi = DateTime(
                dataFiActivitat.year, dataFiActivitat.month, dataFiActivitat.day,
                dataFiActivitat.hour, dataFiActivitat.minute,
              );
              final windowStart = trobada.subtract(const Duration(minutes: 30));
              final isInWindow = now.isAfter(windowStart) && now.isBefore(fi);

              if (!isInWindow) {
                if (context.mounted) {
                  final localT = AppLocalizations.of(context)!;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(localT.validateAttendanceOutsideWindow),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  );
                }
                return;
              }

              final locationService = ref.read(locationServiceProvider);
              final result = await locationService.obtenirUbicacioActual();

              if (result.estat != EstatPermisUbicacio.concedit) {
                if (context.mounted) {
                  final localT = AppLocalizations.of(context)!;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(localT.validateAttendanceLocationRequired),
                    ),
                  );
                }
                return;
              }

              ref.read(validateAttendanceProvider(group.id).notifier).validate(
                    quedadaId: group.id,
                    usuariId: currentUserId!,
                    latitud: result.position!.latitude,
                    longitud: result.position!.longitude,
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryOrange,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: buttonShape,
            ),
            child: Text(t.validateAttendanceButton),
          ),
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
