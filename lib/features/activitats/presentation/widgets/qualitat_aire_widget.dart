import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import '../../model/qualitat_aire.dart';
import '../provider/activitats_providers.dart';

class QualitatAireWidget extends ConsumerWidget {
  const QualitatAireWidget({required this.activitatId, super.key});

  final String activitatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qualitatAsync = ref.watch(qualitatAireProvider(activitatId));

    return qualitatAsync.when(
      loading: () => _AqiShell(child: _AqiLoading()),
      error: (error, _) => _AqiShell(child: _AqiUnavailable()),
      data: (qualitat) {
        if (qualitat == null) return _AqiShell(child: _AqiUnavailable());
        return _AqiCard(qualitat: qualitat);
      },
    );
  }
}

class _AqiShell extends StatelessWidget {
  const _AqiShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final traducciones = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            traducciones.qualitatAireTitol,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _AqiLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _AqiUnavailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final traducciones = AppLocalizations.of(context)!;
    return Row(
      children: [
        Icon(
          Icons.cloud_off_outlined,
          size: 20,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            traducciones.qualitatAireNoDisponible,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

({Color bg, Color fg, String Function(AppLocalizations) label}) aqiStyle(
  int aqi,
  bool isDark,
) {
  if (aqi <= 50) {
    return (
      bg: isDark ? AppColors.greenDark800 : AppColors.green50,
      fg: isDark ? AppColors.greenDark200 : AppColors.green700,
      label: (l) => l.qualitatAireBona,
    );
  } else if (aqi <= 100) {
    return (
      bg: isDark ? const Color(0xFF3D2500) : const Color(0xFFFFF8E1),
      fg: isDark ? AppColors.amber400 : const Color(0xFFF59E0B),
      label: (l) => l.qualitatAireModerada,
    );
  } else if (aqi <= 150) {
    return (
      bg: isDark ? const Color(0xFF3A1800) : AppColors.orange50,
      fg: isDark ? AppColors.orange300 : AppColors.orange600,
      label: (l) => l.qualitatAireDolentaGrups,
    );
  } else if (aqi <= 200) {
    return (
      bg: isDark ? AppColors.red900 : AppColors.red50,
      fg: isDark ? AppColors.red400 : AppColors.red700,
      label: (l) => l.qualitatAireDolenta,
    );
  } else {
    return (
      bg: isDark ? const Color(0xFF2A0040) : const Color(0xFFF3E5F5),
      fg: isDark ? const Color(0xFFCE93D8) : const Color(0xFF7B1FA2),
      label: (l) => l.qualitatAireMoltDolenta,
    );
  }
}

class _AqiCard extends StatelessWidget {
  const _AqiCard({required this.qualitat});

  final QualitatAire qualitat;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final traducciones = AppLocalizations.of(context)!;
    final style = aqiStyle(qualitat.aqi, isDark);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            traducciones.qualitatAireTitol,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: style.bg,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${qualitat.aqi}',
                    style: TextStyle(
                      color: style.fg,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: style.bg,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        style.label(traducciones),
                        style: TextStyle(
                          color: style.fg,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      traducciones.qualitatAireEstacio(qualitat.estacio),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      traducciones.qualitatAireDistancia(
                        qualitat.distanciaKm.toStringAsFixed(1),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
