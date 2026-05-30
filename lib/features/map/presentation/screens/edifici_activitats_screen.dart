import 'package:flutter/material.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import '../../../activitats/model/activitat.dart';
import '../../../activitats/presentation/screens/activitat_detail_screen.dart';
import '../../../activitats/presentation/widgets/amics_assistents_widget.dart';
import '../../../groups/presentation/screens/activity_groups_screen.dart';
import '../utils/categoria_color_helper.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class EdificiActivitatsScreen extends StatelessWidget {
  final String nomEspai;
  final String adreca;
  final String localitat;
  final List<Activitat> activitats;

  const EdificiActivitatsScreen({
    super.key,
    required this.nomEspai,
    required this.adreca,
    required this.localitat,
    required this.activitats,
  });

  /// Capitalitza la primera lletra de cada paraula.
  static String _toTitleCase(String s) {
    if (s.isEmpty) return s;
    return s.split(' ').map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final adrecaCompleta = [adreca, localitat].where((s) => s.isNotEmpty).join(', ');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _toTitleCase(nomEspai),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        elevation: 1,
      ),
      body: Column(
        children: [
          if (adrecaCompleta.isNotEmpty)
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      adrecaCompleta,
                      style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: activitats.length,
              itemBuilder: (_, i) => _ActivitatCard(activitat: activitats[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivitatCard extends StatelessWidget {
  final Activitat activitat;
  const _ActivitatCard({required this.activitat});

  String _formatData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final any = data.year.toString();
    final hora = data.hour.toString().padLeft(2, '0');
    final minut = data.minute.toString().padLeft(2, '0');
    return '$dia/$mes/$any $hora:$minut';
  }

  String _traduzCat(BuildContext context, String cat) {
    final t = AppLocalizations.of(context)!;
    switch (cat.toLowerCase()) {
      case 'exposicions': return t.categoriaExposicions;
      case 'infantil': return t.categoriaInfantil;
      case 'teatre': return t.categoriaTeatre;
      case 'concerts': return t.categoriaConcerts;
      case 'festes': return t.categoriaFestes;
      case 'festivals i mostres': return t.categoriaFestivalsIMostres;
      case 'conferencies':
      case 'conferències': return t.categoriaConferencies;
      case 'rutes i visites': return t.categoriaRutesIVisites;
      case 'altres': return t.categoriaAltres;
      default: return cat;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final color = CategoriaColorHelper.getColor(activitat.categoria);
    final adrecaCompleta = [activitat.adreca, activitat.localitat]
        .where((s) => s.isNotEmpty)
        .join(', ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                const SizedBox(width: double.infinity),
                Positioned.fill(
                  child: activitat.imatge != null && activitat.imatge!.isNotEmpty
                      ? Image.network(
                          activitat.imatge!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(color: Theme.of(context).colorScheme.primary),
                        )
                      : Container(color: Theme.of(context).colorScheme.primary),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.25),
                          Colors.black.withValues(alpha: 0.65),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _traduzCat(context, activitat.categoria),
                          style: const TextStyle(
                            color: AppColors.neutral0,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        activitat.titol,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AmicsAssistentsWidget(activitatId: activitat.id),
                const SizedBox(height: 14),
                _InfoRow(icon: Icons.calendar_today, label: t.mapInfoStart, value: _formatData(activitat.dataInici), color: color),
                const SizedBox(height: 12),
                _InfoRow(icon: Icons.access_time, label: t.mapInfoEnd, value: _formatData(activitat.dataFi), color: color),
                const SizedBox(height: 12),
                _InfoRow(icon: Icons.location_on, label: t.mapInfoSpace, value: activitat.nomEspai, color: color),
                if (adrecaCompleta.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _InfoRow(icon: Icons.home_outlined, label: t.mapInfoAddress, value: adrecaCompleta, color: color),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => ActivitatDetailScreen(activitat: activitat),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(t.mapDetailsButton, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => ActivityGroupsScreen(activitat: activitat),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(t.mapGroupsButton, style: const TextStyle(fontWeight: FontWeight.bold)),
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
