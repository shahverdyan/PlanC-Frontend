import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import 'package:plan_c_frontend/features/calendari/presentation/screens/calendari_screen.dart';
import 'package:plan_c_frontend/features/cercador/presentation/screens/search_screen.dart';
import 'package:plan_c_frontend/features/feed/presentation/screens/feed_screen.dart';
import 'package:plan_c_frontend/features/chat/presentation/providers/chat_repository_provider.dart';
import 'package:plan_c_frontend/features/chat/presentation/screens/chat_friends_screen.dart';
import 'package:plan_c_frontend/features/gustos/presentation/providers/gustos_provider.dart';
import 'package:plan_c_frontend/features/gustos/presentation/screens/seleccio_gustos_screen.dart';
import 'package:plan_c_frontend/features/gustos/presentation/widgets/gustos_benvinguda_dialog.dart';
import 'package:plan_c_frontend/features/map/presentation/screens/map_screen.dart';
import 'package:plan_c_frontend/features/navigation/domain/navigation_provider.dart';
import 'package:plan_c_frontend/features/amistats/presentation/providers/amistats_provider.dart';
import 'package:plan_c_frontend/features/notificacions/presentation/providers/fcm_provider.dart';
import 'package:plan_c_frontend/features/notificacions/presentation/providers/notificacions_provider.dart';
import 'package:plan_c_frontend/features/notificacions/presentation/screens/notificacions_list_screen.dart';
import 'package:plan_c_frontend/features/perfil/presentation/profile_screen.dart';
import 'package:plan_c_frontend/features/perfil/presentation/providers/profile_provider.dart';
import 'package:plan_c_frontend/features/preferits/presentation/screens/preferits_screen.dart';
import 'package:plan_c_frontend/features/settings/presentation/settings_screen.dart';

/// Canvia a `false` per amagar les etiquetes de la barra inferior.
/// Quan estan amagades, les icones es fan més grans automàticament.
const bool kShowNavLabels = true;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  StreamSubscription<RemoteMessage>? _fcmSubscription;
  bool _gustosCheckDone = false;

  /// Índex de l'última pestanya de la barra inferior seleccionada.
  /// S'usa per mantenir la selecció visible quan es navega al perfil.
  int _prevBottomNavIndex = 1; // mapa per defecte

  Future<void> _connectSocket() async {
    final token = await const FlutterSecureStorage().read(key: 'auth_token');
    if (!mounted) return;
    await ref.read(chatRepositoryProvider).connect(token: token);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fcmProvider.notifier).requestAndRegister();
      _connectSocket();
      _checkGustos();
    });
    _fcmSubscription = FirebaseMessaging.onMessage.listen((message) {
      final userId = ref.read(currentUserIdProvider) ?? '';
      if (userId.isEmpty) return;

      ref.invalidate(teNoLlegidesProvider(userId));
      ref.invalidate(notificacionsProvider(userId));

      final tipus = message.data['tipus'] as String?;
      if (tipus == 'NOVA_AMISTAT' || tipus == 'AMISTAT_ACCEPTADA') {
        ref.invalidate(sollicitudsRebudesProvider(userId));
        ref.invalidate(sollicitudsEnviadesProvider(userId));
        ref.invalidate(amistatsProvider(userId));
        ref.invalidate(profileByIdProvider(userId));
      }
    });
  }

  @override
  void dispose() {
    _fcmSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkGustos() async {
    if (_gustosCheckDone || !mounted) return;
    _gustosCheckDone = true;

    final userId = ref.read(currentUserIdProvider) ?? '';
    if (userId.isEmpty) return;

    try {
      final repo = ref.read(gustosRepositoryProvider);
      final gustos = await repo.getUserGustos(userId);
      if (gustos.isEmpty && mounted) {
        final result = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => const GustosBenvingudaDialog(),
        );
        if (result == true && mounted) {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SeleccioGustosScreen()),
          );
        }
      }
    } catch (_) {
      // Si falla la comprovació, no bloquejem l'app
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final indexNav = ref.watch(navigationProvider);
    final currentUserId = ref.watch(currentUserIdProvider) ?? '';

    final profileAsync = currentUserId.isNotEmpty
        ? ref.watch(profileByIdProvider(currentUserId))
        : const AsyncValue<dynamic>.loading();

    final teNoLlegides = currentUserId.isNotEmpty
        ? ref.watch(teNoLlegidesProvider(currentUserId))
        : const AsyncValue.data(false);
    final hiHaNoLlegides = teNoLlegides.valueOrNull ?? false;

    // Índex per a la barra inferior (no pot superar els 5 ítems).
    // Quan s'està al perfil, manté l'última pestanya seleccionada.
    final bottomNavIndex = indexNav == NavTab.profile
        ? _prevBottomNavIndex
        : indexNav.index;

    const double iconSize = kShowNavLabels ? 24.0 : 30.0;

    return Scaffold(
      appBar: indexNav == NavTab.profile
          ? AppBar(
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  ref.read(navigationProvider.notifier).state =
                      NavTab.values[_prevBottomNavIndex];
                },
              ),
              title: profileAsync.when(
                data: (profile) => Text(
                  '@${profile.username}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                loading: () => const SizedBox.shrink(),
                error: (e, s) => const SizedBox.shrink(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
              ],
            )
          : AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 8,
        title: Row(
          children: [
            // Avatar del perfil (esquerra) — mateixa amplada que el botó del cor
            SizedBox(
              width: 48,
              child: GestureDetector(
                onTap: () {
                  ref.read(navigationProvider.notifier).state = NavTab.profile;
                },
                child: Center(
                  child: profileAsync.when(
                    data: (profile) => CircleAvatar(
                      radius: 18,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      backgroundImage: profile.profilePictureUrl != null &&
                              profile.profilePictureUrl!.isNotEmpty
                          ? NetworkImage(profile.profilePictureUrl!)
                          : NetworkImage(
                              'https://ui-avatars.com/api/?name=${profile.username}&background=random',
                            ),
                    ),
                    loading: () => CircleAvatar(
                      radius: 18,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                    error: (e, s) => CircleAvatar(
                      radius: 18,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.person, size: 18),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            // Centre: search bar al mapa, títol a la resta
            Expanded(
              child: indexNav == NavTab.map
                  ? GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const SearchScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              size: 18,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              t.searchHint,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Text(
                      switch (indexNav) {
                        NavTab.home => t.homeTabExplora,
                        NavTab.chat => t.chatNotificationsTitle,
                        NavTab.notifications => t.notificacionsTitol,
                        NavTab.calendar => t.calendariTitol,
                        NavTab.profile => t.homeTabProfile,
                        _ => '',
                      },
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
            // Icona preferits (dreta) — només visible al feed i al mapa
            if (indexNav == NavTab.home || indexNav == NavTab.map)
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                tooltip: t.mapFavoritesTooltip,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const PreferitsScreen(),
                    ),
                  );
                },
              )
            else
              const SizedBox(width: 48),
          ],
        ),
      ),
      body: IndexedStack(
        index: indexNav.index,
        children: [
          const FeedScreen(),
          const MapScreen(),
          const ChatFriendsScreen(),
          NotificacionsListScreen(
            usuariId: currentUserId,
            onNavigateToAmistats: () {
              if (currentUserId.isNotEmpty) {
                ref.invalidate(sollicitudsRebudesProvider(currentUserId));
              }
              ref.read(chatSubTabProvider.notifier).state = 1;
              ref.read(navigationProvider.notifier).state = NavTab.chat;
            },
            onNavigateToXats: () {
              ref.read(chatSubTabProvider.notifier).state = 0;
              ref.read(navigationProvider.notifier).state = NavTab.chat;
            },
          ),
          const CalendariScreen(),
          const ProfileScreen(showAppBar: false),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        iconSize: iconSize,
        showSelectedLabels: kShowNavLabels,
        showUnselectedLabels: kShowNavLabels,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
        currentIndex: bottomNavIndex,
        onTap: (index) {
          final current = ref.read(navigationProvider);
          if (index == NavTab.home.index && current == NavTab.home) {
            ref.read(feedScrollToTopProvider.notifier).update((s) => s + 1);
          }
          setState(() => _prevBottomNavIndex = index);
          ref.read(navigationProvider.notifier).state = NavTab.values[index];
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore_outlined),
            activeIcon: const Icon(Icons.explore),
            label: t.homeTabExplora,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map_outlined),
            activeIcon: const Icon(Icons.map),
            label: t.homeTabMap,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_bubble_outline),
            activeIcon: const Icon(Icons.chat_bubble),
            label: t.homeTabChat,
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_outlined),
                if (hiHaNoLlegides)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            activeIcon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications),
                if (hiHaNoLlegides)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            label: t.homeTabNotifications,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month_outlined),
            activeIcon: const Icon(Icons.calendar_month),
            label: t.homeTabCalendar,
          ),
        ],
      ),
    );
  }
}
