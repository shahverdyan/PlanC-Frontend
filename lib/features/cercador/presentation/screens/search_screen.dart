import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';
import '../providers/filter_provider.dart';
import '../widgets/search_result_tile.dart';
import '../widgets/empty_search_state.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../../../activitats/presentation/screens/activitat_detail_screen.dart';
import '../../../perfil/presentation/profile_screen.dart';
import '../../../auth/domain/auth_provider.dart';
import '../../data/models/profile_search_result.dart';
import 'package:plan_c_frontend/features/feed/presentation/providers/feed_providers.dart';
import 'package:plan_c_frontend/features/feed/data/models/feed_activity.dart';
import 'package:plan_c_frontend/features/activitats/presentation/provider/activitats_providers.dart';
import 'package:plan_c_frontend/features/map/presentation/screens/espai_activitats_loader_screen.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

String _toTitleCase(String s) {
  if (s.isEmpty) return s;
  return s.split(' ').map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  Timer? _debounce;

  final List<String> _tipusValues = ['tots', 'perfils', 'activitats', 'espais'];

  List<String> _localizedTabs(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return [t.searchTabAll, t.searchTabProfiles, t.searchTabActivities, t.searchTabSpaces];
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final newTipus = _tipusValues[_tabController.index];
        ref.read(searchProvider.notifier).canviarTipus(newTipus);
        if (newTipus == 'perfils') {
          ref.read(searchProvider.notifier).carregarHistorialPerfils();
        }
        _triggerSearch(_searchController.text);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _triggerSearch(String terme) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final userId = ref.read(currentUserIdProvider);
      ref.read(searchProvider.notifier).cercar(terme, usuariId: userId);
    });
  }

  void _obririFiltres() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final tabs = _localizedTabs(context);
    final searchState = ref.watch(searchProvider);
    final filterState = ref.watch(filterProvider);
    final terme = _searchController.text;
    final isPerfils = searchState.tipus == 'perfils';

    final allResultsEmpty =
        searchState.results.isEmpty && searchState.profileResults.isEmpty;
    final isSearching = terme.length >= 2 || filterState.teFiltresActius;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Navigator.canPop(context)
            ? const BackButton()
            : Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface),
        automaticallyImplyLeading: false,
        title: _SearchBar(
          controller: _searchController,
          onChanged: _triggerSearch,
          onClear: () {
            _searchController.clear();
            ref.read(searchProvider.notifier).netejarCerca();
          },
        ),
        actions: [
          if (!isPerfils)
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.tune, color: Theme.of(context).colorScheme.onSurface),
                  onPressed: _obririFiltres,
                  tooltip: t.searchFiltersTooltip,
                ),
                if (filterState.teFiltresActius)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: tabs.map((label) => Tab(text: label)).toList(),
        ),
      ),
      body: Column(
        children: [
          // Historial general (tabs no-perfils)
          if (terme.isEmpty &&
              !isPerfils &&
              searchState.historial.isNotEmpty)
            _HistorialSection(
              historial: searchState.historial,
              onTap: (h) {
                _searchController.text = h;
                _triggerSearch(h);
              },
            ),

          // Historial de perfils (tab perfils)
          if (terme.isEmpty &&
              isPerfils &&
              searchState.profileHistorial.isNotEmpty)
            _ProfileHistorialSection(
              historial: searchState.profileHistorial,
              onTap: (h) {
                _searchController.text = h;
                _triggerSearch(h);
              },
              onDelete: (h) {
                ref
                    .read(searchProvider.notifier)
                    .eliminarDeHistorialPerfils(h);
              },
            ),

          // Resultats
          Expanded(
            child: searchState.tipus == 'espais'
                // La pestanya d'espais sempre mostra la llista local del mapa,
                // filtrada pel terme de cerca. No depèn de la API de cerca.
                ? _SpacesDiscovery(terme: terme)
                : searchState.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary),
                  )
                : searchState.errorMessage != null
                    ? _ErrorState(
                        missatge: searchState.errorMessage!,
                        onRetry:
                            searchState.errorMessage!.contains('arrancant')
                                ? () => ref
                                    .read(searchProvider.notifier)
                                    .cercar(
                                      _searchController.text,
                                      usuariId:
                                          ref.read(currentUserIdProvider),
                                    )
                                : null,
                      )
                    // Pantalla descoberta: camp buit, sense historial i no estem filtrant
                    : terme.isEmpty &&
                            searchState.historial.isEmpty &&
                            searchState.profileHistorial.isEmpty &&
                            !filterState.teFiltresActius
                        ? _DiscoverySection(
                            tipus: searchState.tipus,
                            onSearch: (t) {
                              _searchController.text = t;
                              _triggerSearch(t);
                            },
                          )
                        : isSearching && allResultsEmpty && !isPerfils
                            ? filterState.teFiltresActius
                                ? EmptySearchState(
                                    type: EmptyResultType.filter,
                                    onModifyFilters: _obririFiltres,
                                  )
                                : EmptySearchState(
                                    terme: terme,
                                    type: EmptyResultType.search,
                                  )
                            : TabBarView(
                            controller: _tabController,
                            children: [
                              _ResultList(
                                state: searchState,
                                tipus: 'tots',
                                terme: terme,
                                gratuitFilter: filterState.gratuit,
                              ),
                              _ResultList(
                                state: searchState,
                                tipus: 'perfils',
                                terme: terme,
                                gratuitFilter: filterState.gratuit,
                              ),
                              _ResultList(
                                state: searchState,
                                tipus: 'activitats',
                                terme: terme,
                                gratuitFilter: filterState.gratuit,
                              ),
                              _ResultList(
                                state: searchState,
                                tipus: 'espais',
                                terme: terme,
                                gratuitFilter: filterState.gratuit,
                              ),
                            ],
                          ),
          ),
        ],
      ),
    );
  }
}

// ---------- Subwidgets privats ----------

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.searchHint,
        border: InputBorder.none,
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurfaceVariant),
                onPressed: onClear,
              )
            : null,
      ),
    );
  }
}

class _HistorialSection extends StatelessWidget {
  final List<String> historial;
  final ValueChanged<String> onTap;

  const _HistorialSection({required this.historial, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            AppLocalizations.of(context)!.searchRecentTitle,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
        ...historial.map(
          (h) => ListTile(
            leading: Icon(Icons.history, color: Theme.of(context).colorScheme.onSurfaceVariant),
            title: Text(h),
            onTap: () => onTap(h),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class _ProfileHistorialSection extends StatelessWidget {
  final List<String> historial;
  final ValueChanged<String> onTap;
  final ValueChanged<String> onDelete;

  const _ProfileHistorialSection({
    required this.historial,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            'Cerques recents de perfils',
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
        ...historial.map(
          (h) => ListTile(
            leading: Icon(Icons.history, color: Theme.of(context).colorScheme.onSurfaceVariant),
            title: Text(h),
            trailing: IconButton(
              icon: Icon(Icons.close, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
              onPressed: () => onDelete(h),
            ),
            onTap: () => onTap(h),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class _ResultList extends StatelessWidget {
  final SearchState state;
  final String tipus;
  final String terme;
  final bool? gratuitFilter;

  const _ResultList({
    required this.state,
    required this.tipus,
    required this.terme,
    this.gratuitFilter,
  });

  @override
  Widget build(BuildContext context) {
    final showProfiles = tipus == 'tots' || tipus == 'perfils';
    final showActivities = tipus != 'espais' && tipus != 'perfils';
    final showEspais = tipus != 'activitats' && tipus != 'perfils';

    final profiles = showProfiles
        ? state.profileResults
        : const <ProfileSearchResult>[];
    final activitats =
        showActivities ? state.results.activitats : const [];
    final espais = showEspais ? state.results.espais : const [];

    // Perfils tab: show dedicated empty state when searching with no results
    if (tipus == 'perfils') {
      if (profiles.isEmpty && terme.length >= 2) {
        return const _ProfileEmptyState();
      }
      if (profiles.isEmpty) {
        return const SizedBox.shrink();
      }
    } else {
      if (profiles.isEmpty && activitats.isEmpty && espais.isEmpty) {
        return const SizedBox.shrink();
      }
    }

    return ListView(
      children: [
        if (profiles.isNotEmpty) ...[
          if (tipus == 'tots')
            _SectionHeader(titol: 'Perfils (${profiles.length})'),
          ...profiles.map(
            (p) => _ProfileResultTile(
              profile: p,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => ProfileScreen(profileUserId: p.id),
                ),
              ),
            ),
          ),
        ],
        if (activitats.isNotEmpty) ...[
          if (tipus == 'tots')
            _SectionHeader(titol: AppLocalizations.of(context)!.searchActivitiesHeader(activitats.length)),
          ...activitats.map(
            (a) => ActivityResultTile(
              activitat: a,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ActivitatDetailByIdScreen(
                      activitatId: a.id,
                      preu: a.preu,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
        if (espais.isNotEmpty) ...[
          if (tipus == 'tots')
            _SectionHeader(titol: AppLocalizations.of(context)!.searchSpacesHeader(espais.length)),
          ...espais.map(
            (e) => SpaceResultTile(
              espai: e,
              onTap: () {
                // Carreguem les activitats de l'espai des del mapaActivitatsProvider
                // (té totes les activitats amb coordenades i adreces, a diferència
                // dels resultats de cerca predictiva que no inclouen activitats relacionades).
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => EspaiActivitatsLoaderScreen(
                      nomEspai: e.nom,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _ProfileResultTile extends StatelessWidget {
  final ProfileSearchResult profile;
  final VoidCallback onTap;

  const _ProfileResultTile({required this.profile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final foto = profile.fotoPerfil;
    final hasFoto = foto != null && foto.isNotEmpty;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
        backgroundImage: hasFoto ? NetworkImage(foto) : null,
        child: hasFoto
            ? null
            : Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(
        profile.nomUsuari,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }
}

class _ProfileEmptyState extends StatelessWidget {
  const _ProfileEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search,
                size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              'No s\'ha trobat cap perfil',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Prova amb un nom d\'usuari diferent',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String titol;

  const _SectionHeader({required this.titol});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        titol,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String missatge;
  final VoidCallback? onRetry;

  const _ErrorState({required this.missatge, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              missatge,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Torna-ho a provar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Secció de descoberta — mostrada quan la cerca és buida i sense historial.
// El contingut varia segons la pestanya activa.
// ---------------------------------------------------------------------------

class _DiscoverySection extends ConsumerWidget {
  final String tipus;
  final ValueChanged<String> onSearch;

  const _DiscoverySection({
    required this.tipus,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (tipus) {
      'perfils' => _ProfilesDiscovery(onSearch: onSearch),
      'espais' => const _SpacesDiscovery(),
      'activitats' => _ActivitatsDiscovery(),
      _ => _TotsDiscovery(), // 'tots' i qualsevol altre
    };
  }
}

// ── Tots: trending activities ──

class _TotsDiscovery extends ConsumerWidget {
  const _TotsDiscovery();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final trendingAsync = ref.watch(trendingProvider);
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DiscoveryHeader(t.searchDiscoverTitle),
          trendingAsync.when(
            loading: () => _DiscoveryLoading(cs),
            error: (e, _) => const SizedBox.shrink(),
            data: (activities) {
              final preview = activities.take(8).toList();
              if (preview.isEmpty) return const SizedBox.shrink();
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: preview.length,
                separatorBuilder: (_, i) => const Divider(height: 1, indent: 72),
                itemBuilder: (ctx, i) => _DiscoveryTile(activity: preview[i]),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Activitats: activitats properes o trending ──

class _ActivitatsDiscovery extends ConsumerWidget {
  const _ActivitatsDiscovery();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final nearbyAsync = ref.watch(nearbyProvider);
    final trendingAsync = ref.watch(trendingProvider);
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Properes: si hi ha ubicació
          nearbyAsync.when(
            loading: () => _DiscoveryLoading(cs),
            error: (e, _) => const SizedBox.shrink(),
            data: (nearby) {
              if (nearby.isNotEmpty) {
                final preview = nearby.take(6).toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DiscoveryHeader(t.feedNearby),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: preview.length,
                      separatorBuilder: (_, i) =>
                          const Divider(height: 1, indent: 72),
                      itemBuilder: (ctx, i) =>
                          _DiscoveryTile(activity: preview[i]),
                    ),
                  ],
                );
              }
              // Sense ubicació → trending
              return trendingAsync.when(
                loading: () => _DiscoveryLoading(cs),
                error: (e, _) => const SizedBox.shrink(),
                data: (trending) {
                  final preview = trending.take(8).toList();
                  if (preview.isEmpty) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DiscoveryHeader(t.searchDiscoverTitle),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: preview.length,
                        separatorBuilder: (_, i) =>
                            const Divider(height: 1, indent: 72),
                        itemBuilder: (ctx, i) =>
                            _DiscoveryTile(activity: preview[i]),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Perfils: prompt de cerca ──

class _ProfilesDiscovery extends StatelessWidget {
  final ValueChanged<String> onSearch;

  const _ProfilesDiscovery({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search,
                size: 72, color: cs.onSurfaceVariant.withValues(alpha: 0.4)),
            const SizedBox(height: 20),
            Text(
              'Troba persones',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cerca per nom d\'usuari per connectar amb gent que comparteix els teus interessos culturals.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: cs.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Espais: llista real d'espais amb activitats al mapa ──

class _SpacesDiscovery extends ConsumerWidget {
  /// Terme de cerca per filtrar. Buit = mostra tots els espais.
  final String terme;

  const _SpacesDiscovery({this.terme = ''});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final mapaAsync = ref.watch(mapaActivitatsProvider);

    return mapaAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(
        child: Text(
          'No s\'han pogut carregar els espais',
          style: TextStyle(color: cs.onSurfaceVariant),
        ),
      ),
      data: (state) {
        // Deduplicació per nomEspai normalitzat
        final seen = <String>{};
        final normalized = terme.toLowerCase().trim();

        final espais = state.activitats
            .where((a) => a.nomEspai.isNotEmpty)
            .where((a) {
              // Filtre per terme de cerca
              if (normalized.isEmpty) return true;
              return a.nomEspai.toLowerCase().contains(normalized) ||
                  a.adreca.toLowerCase().contains(normalized) ||
                  a.localitat.toLowerCase().contains(normalized);
            })
            .where((a) => seen.add(a.nomEspai.toLowerCase().trim()))
            .toList()
          ..sort((a, b) => a.nomEspai.compareTo(b.nomEspai));

        if (espais.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_city_outlined,
                    size: 48, color: cs.onSurfaceVariant.withValues(alpha: 0.4)),
                const SizedBox(height: 12),
                Text(
                  normalized.isEmpty
                      ? 'No hi ha espais disponibles'
                      : 'Cap espai coincideix amb "$terme"',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: espais.length,
          separatorBuilder: (ctx, i) =>
              const Divider(height: 1, indent: 72),
          itemBuilder: (ctx, i) {
            final a = espais[i];
            final adreca = [a.adreca, a.localitat]
                .where((s) => s.isNotEmpty)
                .join(', ');
            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.location_city,
                    size: 22, color: cs.primary),
              ),
              title: Text(
                _toTitleCase(a.nomEspai),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14),
              ),
              subtitle: adreca.isNotEmpty
                  ? Text(adreca,
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurfaceVariant),
                      overflow: TextOverflow.ellipsis)
                  : null,
              trailing: Icon(Icons.arrow_forward_ios,
                  size: 14, color: cs.onSurfaceVariant),
              onTap: () => Navigator.push(
                ctx,
                MaterialPageRoute<void>(
                  builder: (_) =>
                      EspaiActivitatsLoaderScreen(nomEspai: a.nomEspai),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ── Helpers compartits ──

class _DiscoveryHeader extends StatelessWidget {
  final String title;
  const _DiscoveryHeader(this.title);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
      ),
    );
  }
}

class _DiscoveryLoading extends StatelessWidget {
  final ColorScheme cs;
  const _DiscoveryLoading(this.cs);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: CircularProgressIndicator(strokeWidth: 2, color: cs.primary),
      ),
    );
  }
}

class _DiscoveryTile extends StatelessWidget {
  final FeedActivity activity;

  const _DiscoveryTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: activity.imatgePrincipal != null &&
                activity.imatgePrincipal!.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  activity.imatgePrincipal!,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, _) => Icon(
                    Icons.local_activity_outlined,
                    color: cs.primary,
                    size: 22,
                  ),
                ),
              )
            : Icon(
                Icons.local_activity_outlined,
                color: cs.primary,
                size: 22,
              ),
      ),
      title: Text(
        activity.titol,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        activity.espaiNom.isNotEmpty ? activity.espaiNom : activity.categoriaNom,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
      ),
      trailing: Icon(Icons.arrow_forward_ios,
          size: 14, color: cs.onSurfaceVariant),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => ActivitatDetailByIdScreen(
            activitatId: activity.id,
          ),
        ),
      ),
    );
  }
}
