import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../activitats/model/activitat.dart';
import 'group_form_screen.dart';
import '../providers/get_activity_groups_provider.dart';
import '../widgets/group_card_widget.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/chat/presentation/providers/chat_list_provider.dart'; // ✅ Importamos el provider de la lista de chats
import 'package:plan_c_frontend/features/navigation/domain/navigation_provider.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class ActivityGroupsScreen extends ConsumerWidget {
  final Activitat activitat;

  const ActivityGroupsScreen({super.key, required this.activitat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final currentUserId = ref.watch(currentUserIdProvider);
    final groupsAsync = ref.watch(activityGroupsProvider(activitat.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.groupsActivityTitle(activitat.titol),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: groupsAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              t.groupsLoadError(error.toString()),
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
        data: (groups) {
          if (groups.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group_off_outlined,
                      size: 60, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text(
                    t.groupsEmpty,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: Theme.of(context).colorScheme.primary,
            onRefresh: () async {
              ref.invalidate(activityGroupsProvider(activitat.id));
              ref.invalidate(chatListProvider); // ✅ También refrescamos los chats al estirar hacia abajo
            },
            child: ListView.builder(
              padding: EdgeInsets.only(
                top: 10,
                bottom: MediaQuery.of(context).padding.bottom + 88,
              ),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];

                final isCreator =
                    currentUserId != null && group.creatorId == currentUserId;

                return GroupCardWidget(
                  key: ValueKey(group.id),
                  group: group,
                  activitat: activitat,
                  currentParticipants: group.currentParticipants,
                  currentUserId: currentUserId,
                  isCreator: isCreator,
                  onGroupUpdated: () {
                    ref.invalidate(activityGroupsProvider(activitat.id));
                    ref.invalidate(chatListProvider);
                  },
                );
              },
            ),
          );
        },
      ),
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
            icon: const Icon(Icons.notifications_outlined),
            activeIcon: const Icon(Icons.notifications),
            label: t.homeTabNotifications,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month_outlined),
            activeIcon: const Icon(Icons.calendar_month),
            label: t.homeTabCalendar,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GroupFormScreen(activityId: activitat.id, activitat: activitat),
            ),
          );

          if (result == true) {
            ref.invalidate(activityGroupsProvider(activitat.id));
            // La actualización de chatListProvider al crear se maneja dentro de GroupFormScreen
          }
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: Text(
          t.groupsCreateButton,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}