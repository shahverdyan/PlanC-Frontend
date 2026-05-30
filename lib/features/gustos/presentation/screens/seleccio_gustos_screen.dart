import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/gustos/domain/models/categoria_cultural.dart';
import 'package:plan_c_frontend/features/gustos/presentation/providers/gustos_provider.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

IconData _iconForCategoria(String slug) {
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

Color _colorForCategoria(String slug) {
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

String _nomTraduit(String slug, AppLocalizations l10n) {
  switch (slug) {
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
    default: return slug;
  }
}

class SeleccioGustosScreen extends ConsumerStatefulWidget {
  const SeleccioGustosScreen({super.key});

  @override
  ConsumerState<SeleccioGustosScreen> createState() => _SeleccioGustosScreenState();
}

class _SeleccioGustosScreenState extends ConsumerState<SeleccioGustosScreen> {
  List<CategoriaCultural> _categories = [];
  final Set<String> _selectedIds = {};
  final Set<String> _loadingIds = {};
  bool _isLoadingInitial = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final repo = ref.read(gustosRepositoryProvider);
    final userId = ref.read(currentUserIdProvider) ?? '';
    try {
      final results = await Future.wait([
        repo.getCategories(),
        repo.getUserGustos(userId),
      ]);
      if (!mounted) return;
      setState(() {
        _categories = results[0];
        _selectedIds.addAll(results[1].map((c) => c.id));
        _isLoadingInitial = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _isLoadingInitial = false;
      });
    }
  }

  Future<void> _toggleGust(CategoriaCultural categoria) async {
    if (_loadingIds.contains(categoria.id)) return;

    final userId = ref.read(currentUserIdProvider) ?? '';
    final repo = ref.read(gustosRepositoryProvider);
    final wasSelected = _selectedIds.contains(categoria.id);

    setState(() {
      _loadingIds.add(categoria.id);
      if (wasSelected) {
        _selectedIds.remove(categoria.id);
      } else {
        _selectedIds.add(categoria.id);
      }
    });

    try {
      if (wasSelected) {
        await repo.removeGust(userId, categoria.id);
      } else {
        await repo.addGust(userId, categoria.id);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        if (wasSelected) {
          _selectedIds.add(categoria.id);
        } else {
          _selectedIds.remove(categoria.id);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loadingIds.remove(categoria.id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          l10n.gustosTitol,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
        ),
      ),
      body: _buildBody(l10n),
      bottomNavigationBar: _buildBottomBar(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoadingInitial) {
      return Center(
        child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(l10n.gustosErrorCarregarCategories, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isLoadingInitial = true;
                  _hasError = false;
                });
                _loadData();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.gustosTornaAIntentarHo),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.gustosSeleccionaInteressos,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.gustosDesc,
                  style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 12),
                if (_selectedIds.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded, size: 16, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 6),
                        Text(
                          l10n.gustosCategoriesCount(_selectedIds.length),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.9,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _CategoriaCard(
                categoria: _categories[index],
                isSelected: _selectedIds.contains(_categories[index].id),
                isLoading: _loadingIds.contains(_categories[index].id),
                onTap: () => _toggleGust(_categories[index]),
              ),
              childCount: _categories.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            minimumSize: const Size(double.infinity, 52),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(
            l10n.gustosContinuaButton,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _CategoriaCard extends StatelessWidget {
  final CategoriaCultural categoria;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onTap;

  const _CategoriaCard({
    required this.categoria,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final catColor = _colorForCategoria(categoria.nom);
    final icon = _iconForCategoria(categoria.nom);
    final nom = _nomTraduit(categoria.nom, l10n);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08) : Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, size: 20, color: catColor),
                  ),
                  const Spacer(),
                  Text(
                    nom,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              )
            else if (isSelected)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_rounded, size: 14, color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
