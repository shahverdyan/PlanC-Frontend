import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import '../../data/models/feed_category.dart';

class CategorySelector extends StatelessWidget {
  final List<FeedCategory> categories;
  final void Function(String categoriaId) onCategoryTap;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, i) => const SizedBox(width: 8),
        itemBuilder: (_, i) => _CategoryChip(
          category: categories[i],
          onTap: () => onCategoryTap(categories[i].id),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final FeedCategory category;
  final VoidCallback onTap;

  const _CategoryChip({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = _colorForSlug(category.nom);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _iconForSlug(category.nom),
              size: 16,
              color: color,
            ),
            const SizedBox(width: 6),
            Text(
              _nomTraduit(category.nom, AppLocalizations.of(context)!),
              style: TextStyle(
                fontSize: 13,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _nomTraduit(String nom, AppLocalizations l10n) =>
      nomTraduitCategoria(nom, l10n);
}

String nomTraduitCategoria(String nom, AppLocalizations l10n) {
    switch (nom.toLowerCase()) {
      case 'exposicions': return l10n.categoriaExposicions;
      case 'infantil': return l10n.categoriaInfantil;
      case 'teatre': return l10n.categoriaTeatre;
      case 'concerts': return l10n.categoriaConcerts;
      case 'festivals-i-mostres': return l10n.categoriaFestivalsIMostres;
      case 'conferencies': return l10n.categoriaConferencies;
      case 'rutes-i-visites': return l10n.categoriaRutesIVisites;
      case 'festes': return l10n.categoriaFestes;
      case 'activitats-virtuals': return l10n.categoriaActivitatsVirtuals;
      case 'dansa': return l10n.categoriaDansa;
      case 'fires-i-mercats': return l10n.categoriaFiresIMercats;
      case 'carnavals': return l10n.categoriaCarnavals;
      case 'cicles': return l10n.categoriaCicles;
      case 'setmana-santa': return l10n.categoriaSetmanaSanta;
      case 'sardanes': return l10n.categoriaSardanes;
      case 'gegants': return l10n.categoriaGegants;
      case 'circ': return l10n.categoriaCirc;
      case 'commemoracions': return l10n.categoriaCommemoracions;
      case 'cursos': return l10n.categoriaCursos;
      case 'nadal': return l10n.categoriaNadal;
      case 'cultura-digital': return l10n.categoriaCulturaDigital;
      case 'any-gaudi': return l10n.categoriaAnyGaudi;
      case 'altres': return l10n.categoriaAltres;
      default: return nom;
    }
  }

  IconData _iconForSlug(String slug) {
    switch (slug) {
      case 'exposicions': return Icons.palette_outlined;
      case 'infantil': return Icons.child_care_outlined;
      case 'teatre': return Icons.theater_comedy_outlined;
      case 'concerts': return Icons.music_note_outlined;
      case 'festivals-i-mostres': return Icons.festival_outlined;
      case 'conferencies': return Icons.mic_none_outlined;
      case 'rutes-i-visites': return Icons.map_outlined;
      case 'festes': return Icons.celebration_outlined;
      case 'activitats-virtuals': return Icons.laptop_mac_outlined;
      case 'dansa': return Icons.accessibility_new_outlined;
      case 'fires-i-mercats': return Icons.storefront_outlined;
      case 'carnavals': return Symbols.domino_mask;
      case 'cicles': return Icons.event_repeat_outlined;
      case 'setmana-santa': return Icons.church_outlined;
      case 'sardanes': return Icons.diversity_3_outlined;
      case 'gegants': return Icons.emoji_people;
      case 'circ': return Icons.stars_outlined;
      case 'commemoracions': return Icons.emoji_events_outlined;
      case 'cursos': return Icons.school_outlined;
      case 'nadal': return Icons.ac_unit_outlined;
      case 'cultura-digital': return Icons.devices_outlined;
      case 'any-gaudi': return Icons.architecture_outlined;
      default: return Icons.category_outlined;
    }
  }

  Color _colorForSlug(String slug) {
    switch (slug) {
      case 'exposicions': return Colors.red;
      case 'infantil': return Colors.pinkAccent;
      case 'teatre': return Colors.amber;
      case 'concerts': return Colors.green;
      case 'festivals-i-mostres': return Colors.purple;
      case 'conferencies': return Colors.cyan;
      case 'rutes-i-visites': return Colors.blue;
      case 'festes': return Colors.deepOrange;
      case 'activitats-virtuals': return Colors.teal;
      case 'dansa': return Colors.pink;
      case 'fires-i-mercats': return Colors.orange;
      case 'carnavals': return Colors.deepPurple;
      case 'cicles': return Colors.blueGrey;
      case 'setmana-santa': return Colors.brown;
      case 'sardanes': return Colors.orange;
      case 'gegants': return Colors.brown;
      case 'circ': return Colors.redAccent;
      case 'commemoracions': return Colors.amber;
      case 'cursos': return Colors.lightBlue;
      case 'nadal': return Colors.lightBlue;
      case 'cultura-digital': return Colors.cyan;
      case 'any-gaudi': return Colors.deepOrange;
      default: return Colors.indigo;
    }
}
