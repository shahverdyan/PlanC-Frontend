import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/features/preferits/presentation/providers/preferits_provider.dart';
import 'package:plan_c_frontend/features/redireccioCompraEntrades/presentation/widgets/buy_tickets_button.dart';
import 'package:plan_c_frontend/features/chat/presentation/providers/chat_list_provider.dart';
import '../../model/activitat.dart';
import '../provider/activitats_providers.dart';
import '../widgets/qualitat_aire_widget.dart';
import '../widgets/valoracions_seccio.dart';
import '../widgets/valorar_activitat_section.dart';
import 'package:plan_c_frontend/features/chat/presentation/providers/chat_repository_provider.dart';
import 'package:plan_c_frontend/features/groups/presentation/screens/activity_groups_screen.dart';
import 'package:plan_c_frontend/features/navigation/domain/navigation_provider.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class ActivitatDetailScreen extends ConsumerWidget {
  const ActivitatDetailScreen({
    required this.activitat,
    super.key,
  });

  final Activitat activitat;

  String _formatData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final any = data.year.toString();
    final hora = data.hour.toString().padLeft(2, '0');
    final minut = data.minute.toString().padLeft(2, '0');

    return '$dia/$mes/$any · $hora:$minut';
  }

  void _showShareBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ShareBottomSheet(activitat: activitat),
    );
  }

  Future<void> _obrirGoogleMaps(BuildContext context, double lat, double lng, String nomEspai) async {
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          final traducciones = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(traducciones.errorGoogleMaps)),
          );
        }
      }
    } catch (e) {
      debugPrint('Error obrint Google Maps: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final preferitsAsync = ref.watch(preferitsProvider);
    final traducciones = AppLocalizations.of(context)!;

    final esPreferida =
        preferitsAsync.valueOrNull?.activitats.any((a) => a.id == activitat.id) ?? false;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: ref.watch(navigationProvider).index.clamp(0, 4),
        onTap: (index) {
          ref.read(navigationProvider.notifier).state = NavTab.values[index];
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore_outlined),
            activeIcon: const Icon(Icons.explore),
            label: traducciones.homeTabExplora,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map_outlined),
            activeIcon: const Icon(Icons.map),
            label: traducciones.homeTabMap,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_bubble_outline),
            activeIcon: const Icon(Icons.chat_bubble),
            label: traducciones.homeTabChat,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications_outlined),
            activeIcon: const Icon(Icons.notifications),
            label: traducciones.homeTabNotifications,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month_outlined),
            activeIcon: const Icon(Icons.calendar_month),
            label: traducciones.homeTabCalendar,
          ),
        ],
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          traducciones.detallActivitatTitol,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined, color: Theme.of(context).colorScheme.onSurface),
            tooltip: traducciones.compartirActivitatTooltip,
            onPressed: () => _showShareBottomSheet(context),
          ),
          IconButton(
            icon: Icon(
              esPreferida ? Icons.bookmark : Icons.bookmark_border,
              color: esPreferida ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
            ),
            tooltip: esPreferida
                ? traducciones.treurePreferidesTooltip
                : traducciones.afegirPreferidesTooltip,
            onPressed: preferitsAsync.isLoading
                ? null
                : () async {
                    try {
                      await ref
                          .read(preferitsProvider.notifier)
                          .togglePreferida(activitat);

                      if (!context.mounted) return;

                      final araEsPreferida = !esPreferida;
                      final localTraducciones = AppLocalizations.of(context)!;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            araEsPreferida
                                ? localTraducciones.activitatAfegidaPreferides
                                : localTraducciones.activitatEliminadaPreferides,
                          ),
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      final localTraducciones = AppLocalizations.of(context)!;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            localTraducciones.errorActualitzarPreferides(e.toString()),
                          ),
                        ),
                      );
                    }
                  },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                child: Stack(
                  fit: StackFit.passthrough,
                  children: [
                    const SizedBox(width: double.infinity),
                    Positioned.fill(
                      child: activitat.imatge != null && activitat.imatge!.isNotEmpty
                          ? Image.network(
                              activitat.imatge!,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, st) => Container(color: Theme.of(context).colorScheme.primary),
                            )
                          : Container(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.2),
                              Colors.black.withValues(alpha: 0.65),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(AppRadius.full),
                            ),
                            child: Text(
                              activitat.categoria,
                              style: const TextStyle(
                                color: AppColors.neutral0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            activitat.titol,
                            style: tema.textTheme.headlineSmall?.copyWith(
                              color: AppColors.neutral0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            activitat.nomEspai,
                            style: const TextStyle(
                              color: AppColors.neutral0,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _InfoCard(
                title: traducciones.descripcioTitol,
                child: _ExpandableDescription(text: activitat.descripcio),
              ),
              const SizedBox(height: 16),
              _InfoCard(
                title: traducciones.quanTitol,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(
                      icon: Icons.play_circle_outline,
                      label: traducciones.iniciLabel,
                      value: _formatData(activitat.dataInici),
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.stop_circle_outlined,
                      label: traducciones.fiLabel,
                      value: _formatData(activitat.dataFi),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _InfoCard(
                title: traducciones.onTitol,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(
                      icon: Icons.location_on_outlined,
                      label: traducciones.espaiLabel,
                      value: activitat.nomEspai,
                    ),
                    if (activitat.adreca.isNotEmpty || activitat.localitat.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _DetailRow(
                        icon: Icons.home_outlined,
                        label: traducciones.adrecaLabel,
                        value: [
                          if (activitat.adreca.isNotEmpty) activitat.adreca,
                          if (activitat.localitat.isNotEmpty) activitat.localitat,
                        ].join(', '),
                      ),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.map),
                        label: Text(traducciones.obrirGoogleMapsButton),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                        onPressed: () {
                          _obrirGoogleMaps(
                            context,
                            activitat.lat,
                            activitat.lng,
                            activitat.nomEspai,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              QualitatAireWidget(activitatId: activitat.id),
              const SizedBox(height: 16),
              _InfoCard(
                title: traducciones.entradesTitol,
                child: BuyTicketsButton(
                  url: activitat.urlEntrades,
                  preu: activitat.preu,
                ),
              ),
              const SizedBox(height: 16),
              _InfoCard(
                title: traducciones.valoracionsTitol,
                child: ValoracionsSection(activitatId: activitat.id),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.group),
                  label: Text(traducciones.veurQuedades),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ActivityGroupsScreen(activitat: activitat),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ValorarActivitatSection(activitatId: activitat.id),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
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
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
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

class _ExpandableDescription extends StatefulWidget {
  final String text;

  const _ExpandableDescription({required this.text});

  @override
  State<_ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  static const int _maxLines = 4;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    const style = TextStyle(height: 1.45);

    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: style),
          maxLines: _maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final overflows = painter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: style,
              maxLines: _expanded ? null : _maxLines,
              overflow: _expanded ? null : TextOverflow.ellipsis,
            ),
            if (overflows) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Text(
                  _expanded ? t.mostrarMenys : t.mostrarMes,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _ShareBottomSheet extends ConsumerStatefulWidget {
  final Activitat activitat;

  const _ShareBottomSheet({required this.activitat});

  @override
  ConsumerState<_ShareBottomSheet> createState() => _ShareBottomSheetState();
}

class _ShareBottomSheetState extends ConsumerState<_ShareBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<ChatItemModel> _filteredChats = [];

  @override
  void initState() {
    super.initState();
    _updateFilteredChats(chats: [], query: '');
  }

  void _updateFilteredChats({
    required List<ChatItemModel> chats,
    required String query,
  }) {
    setState(() {
      if (query.isEmpty) {
        _filteredChats = List.from(chats);
      } else {
        _filteredChats = chats
            .where((chat) => chat.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _filterChats(String query, List<ChatItemModel> chats) {
    _updateFilteredChats(chats: chats, query: query);
  }

  // LÓGICA DE COMPARTICIÓN EXTERNA (US #310) - SOLUCIONADO EL WARNING CI
  void _shareExternal() {
    Navigator.pop(context);
    final traducciones = AppLocalizations.of(context)!;
    
    // Opción B: Enlace puro de PlanC para el Deep Linking
    final urlStr = 'https://planc-backend-aff2.onrender.com/activitats/${widget.activitat.id}';
        
    final message = traducciones.whatsappShareMessage(widget.activitat.titol, urlStr);
    
    // Nueva sintaxis estricta obligatoria para SharePlus 10.x.x
    SharePlus.instance.share(ShareParams(text: message)); 
  }

  void _shareToChat(String chatId, String chatName) async {
    try {
      final repository = ref.read(chatRepositoryProvider);
      
      await repository.shareActivity(chatId, widget.activitat.id);

      if (mounted) Navigator.pop(context);

      if (mounted) {
        final traducciones = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(traducciones.activitatCompartidaExit(chatName)),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final traducciones = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(traducciones.errorCompartir(e.toString())),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final chatsAsync = ref.watch(chatListProvider);
    final traducciones = AppLocalizations.of(context)!;

    return Container(
      margin: EdgeInsets.only(bottom: bottomInset),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            traducciones.compartirActivitatTooltip,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // --- SECCIÓN: Compartir Externo Nativo ---
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.share_outlined),
              label: const Text('Compartir a altres aplicacions'), 
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _shareExternal,
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Divider(),
          ),
          // --------------------------------------------

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              traducciones.compartirXatTitol,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _searchController,
            onChanged: (query) {
              final chats = chatsAsync.valueOrNull ?? [];
              _filterChats(query, chats);
            },
            decoration: InputDecoration(
              hintText: traducciones.cercaXatHint,
              prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurfaceVariant),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          chatsAsync.when(
            loading: () => ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.3,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
            error: (err, stack) => ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.3,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(traducciones.errorCarregarXats(err.toString()), style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            ),
            data: (chats) {
              if (_filteredChats.isEmpty && chats.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _updateFilteredChats(chats: chats, query: _searchController.text);
                });
              }

              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.3,
                ),
                child: _filteredChats.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(traducciones.noXatsTrobats, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredChats.length,
                        itemBuilder: (context, index) {
                          final chat = _filteredChats[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              backgroundImage: (chat.photoUrl != null && chat.photoUrl!.isNotEmpty)
                                  ? NetworkImage(chat.photoUrl!)
                                  : null,
                              child: (chat.photoUrl == null || chat.photoUrl!.isEmpty)
                                  ? Icon(Icons.group, color: Theme.of(context).colorScheme.primary)
                                  : null,
                            ),
                            title: Text(
                              chat.name,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
                                elevation: AppElevation.none,
                              ),
                              onPressed: () {
                                _shareToChat(chat.id, chat.name);
                              },
                              child: Text(traducciones.enviarButton),
                            ),
                          );
                        },
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Wrapper that fetches full activity data by ID before showing the detail screen.
// Use this when navigating from the feed, where the payload lacks description/coords.
class ActivitatDetailByIdScreen extends ConsumerWidget {
  final String activitatId;
  final double? preu;
  final String? imatge;

  const ActivitatDetailByIdScreen({
    required this.activitatId,
    this.preu,
    this.imatge,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncActivitat = ref.watch(activitatByIdProvider(activitatId));

    return asyncActivitat.when(
      loading: () => Scaffold(
        appBar: AppBar(elevation: 0),
        body: Center(
          child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(elevation: 0),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              AppLocalizations.of(context)!.activitatDetailError,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      data: (activitat) {
        Activitat resolved = activitat;
        if (preu != null && resolved.preu == null) {
          resolved = resolved.copyWith(preu: preu);
        }
        if (imatge != null && resolved.imatge == null) {
          resolved = resolved.copyWith(imatge: imatge);
        }
        return ActivitatDetailScreen(activitat: resolved);
      },
    );
  }
}