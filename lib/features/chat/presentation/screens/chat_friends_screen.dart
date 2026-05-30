import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/amistats/presentation/screens/friends_screen.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:plan_c_frontend/features/navigation/domain/navigation_provider.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class ChatFriendsScreen extends ConsumerStatefulWidget {
  const ChatFriendsScreen({super.key});

  @override
  ConsumerState<ChatFriendsScreen> createState() => _ChatFriendsScreenState();
}

class _ChatFriendsScreenState extends ConsumerState<ChatFriendsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final currentUserId = ref.watch(currentUserIdProvider) ?? '';

    ref.listen(chatSubTabProvider, (_, next) {
      _tabController.animateTo(next);
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: [
            Tab(text: t.chatTabChats),
            Tab(text: t.chatTabFriendships),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const ChatListBody(),
          FriendsScreen(usuariId: currentUserId),
        ],
      ),
    );
  }
}
