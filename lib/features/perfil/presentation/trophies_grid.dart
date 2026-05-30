import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';

// Ranks que tenen imatge local al directori assets/images/
const _ranksAmbImatge = {'principiant', 'aficionat', 'expert'};

class TrophiesGrid extends ConsumerWidget {
  final List<dynamic> trophies; 

  const TrophiesGrid({super.key, required this.trophies});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    if (trophies.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                const SizedBox(height: 16),
                Text(
                  t.profileNoTrophies,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final trophy = trophies[index];

            final double currentPoints = trophy.points.toDouble();
            final double targetPoints =  100.0; 
            
            final double progress = (currentPoints / targetPoints).clamp(0.0, 1.0);

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
                    horizontalTitleGap: 8,
                    leading: _TrophyIcon(rank: trophy.rank, size: 56),
                    title: Text(_traducirCategoria(context, trophy.category)),
                    subtitle: Text(
                      "${t.trophyLevelLabel} ${trophy.level} • ${trophy.points} / ${targetPoints.toInt()} pts",
                    ),
                    trailing: Text(trophy.rank),
                    onLongPress: () => _showTrophyDetails(context, trophy, progress, targetPoints.toInt(), t),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                        minHeight: 6,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          childCount: trophies.length,
        ),
      ),
    );
  }

  void _showTrophyDetails(BuildContext context, dynamic trophy, double progress, int targetPoints, AppLocalizations t) {
    showDialog(
      context: context,
      barrierDismissible: true, 
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              _TrophyIcon(rank: trophy.rank, size: 48),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _traducirCategoria(context, trophy.category),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                _buildDetailRow(context, t.actualRankLabel, trophy.rank),
                const Divider(height: 20),
                _buildDetailRow(context, t.achievedLevelLabel, "${trophy.level}"),
                const Divider(height: 20),
                _buildDetailRow(context, t.levelProgressLabel, "${(progress * 100).toInt()}%"),
                const SizedBox(height: 8),

                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(AppSemanticColors.of(context).ratingFilled),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${(targetPoints - trophy.points)} ${t.pointsForNextLevelLabel} ${trophy.level + 1}",
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.close, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        ],
      ),
    );
  }

  String _traducirCategoria(BuildContext context, String categoriaOriginal) {
    final t = AppLocalizations.of(context)!;
    
    switch (categoriaOriginal.trim().toLowerCase()) {
      case 'exposicions': 
        return t.categoriaExposicions;
        
      case 'infantil': 
        return t.categoriaInfantil;
        
      case 'teatre': 
        return t.categoriaTeatre;
        
      case 'concerts': 
        return t.categoriaConcerts;
        
      case 'festes': 
        return t.categoriaFestes;
        
      case 'festivals-i-mostres':
      case 'festivals i mostres': 
        return t.categoriaFestivalsIMostres;
        
      case 'conferencies':
      case 'conferències': 
        return t.categoriaConferencies;
        
      case 'rutes-i-visites':
      case 'rutes i visites': 
        return t.categoriaRutesIVisites;
        
      case 'altres': 
        return t.categoriaAltres;
        
      case 'activitats-virtuals':
      case 'activitats virtuals': 
        return t.categoriaActivitatsVirtuals;
        
      case 'dansa': 
        return t.categoriaDansa;
        
      case 'fires-i-mercats':
      case 'fires i mercats': 
        return t.categoriaFiresIMercats;
        
      case 'carnavals': 
        return t.categoriaCarnavals;
        
      case 'cicles': 
        return t.categoriaCicles;
        
      case 'setmana-santa':
      case 'setmana santa': 
        return t.categoriaSetmanaSanta;
        
      case 'sardanes': 
        return t.categoriaSardanes;
        
      case 'gegants': 
        return t.categoriaGegants;
        
      case 'circ': 
        return t.categoriaCirc;
        
      case 'commemoracions': 
        return t.categoriaCommemoracions;
        
      case 'cursos': 
        return t.categoriaCursos;
        
      case 'nadal': 
        return t.categoriaNadal;
        
      case 'cultura-digital':
      case 'cultura digital': 
        return t.categoriaCulturaDigital;
        
      case 'any-gaudi':
      case 'any gaudi': 
        return t.categoriaAnyGaudi;
        
      default: 
        // Si arriba un text que no coincideix amb cap cas, retorna el valor original sense traduir
        return categoriaOriginal;
    }
  }
}

// ── Icona del trofeu: imatge local si el rank és conegut, icona de fallback si no ──

class _TrophyIcon extends StatelessWidget {
  final String rank;
  final double size;

  const _TrophyIcon({required this.rank, required this.size});

  @override
  Widget build(BuildContext context) {
    final rankKey = rank.toLowerCase().trim();
    if (_ranksAmbImatge.contains(rankKey)) {
      return Image.asset(
        'assets/images/$rankKey.png',
        width: size,
        height: size,
        errorBuilder: (ctx, err, st) => _fallback(context),
      );
    }
    return _fallback(context);
  }

  Widget _fallback(BuildContext context) {
    return Icon(
      Icons.emoji_events,
      size: size,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}