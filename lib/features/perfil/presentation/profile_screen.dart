import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/amistats/presentation/screens/friends_list_screen.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/perfil/presentation/edit_profile_screen.dart';
import 'package:plan_c_frontend/features/perfil/presentation/posts_grid.dart';
import 'package:plan_c_frontend/features/perfil/presentation/providers/profile_provider.dart';
import 'package:plan_c_frontend/features/perfil/presentation/trophies_grid.dart';
import 'package:plan_c_frontend/features/perfil/presentation/widgets/profile_actions_widget.dart';
import 'package:plan_c_frontend/features/settings/presentation/settings_screen.dart';
import 'package:plan_c_frontend/shared/data_box.dart';
import 'package:plan_c_frontend/shared/error_screen.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class ProfileScreen extends ConsumerWidget {
  final String? profileUserId;
  final bool showAppBar;

  const ProfileScreen({super.key, this.profileUserId, this.showAppBar = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final currentUserId = ref.watch(currentUserIdProvider) ?? '';
    final targetUserId =
        (profileUserId != null && profileUserId!.isNotEmpty)
            ? profileUserId!
            : currentUserId;
    final isOwnProfile =
        profileUserId == null || targetUserId == currentUserId;

    final profileAsync = targetUserId.isNotEmpty
        ? ref.watch(profileByIdProvider(targetUserId))
        : const AsyncValue<dynamic>.loading();

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              surfaceTintColor: Colors.transparent,
              scrolledUnderElevation: 0,
              centerTitle: true,
              title: profileAsync.when(
                data: (profile) => Text('@${profile.username}', style: const TextStyle(fontWeight: FontWeight.bold)),
                loading: () => const SizedBox.shrink(),
                error: (err, stack) => const SizedBox.shrink(),
              ),
              actions: [
                if (isOwnProfile)
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsScreen()),
                    );
                  },
                  icon: const Icon(Icons.settings),
                ),
              ],
            )
          : null,
      body: SafeArea(
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => ErrorScreen(error: err.toString()), 
          data: (profile) {
            return DefaultTabController(
              length: 2,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 32, right: 32, top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                      backgroundImage: (profile.profilePictureUrl != null && profile.profilePictureUrl!.isNotEmpty)
                                          ? NetworkImage(profile.profilePictureUrl!)
                                          : NetworkImage('https://ui-avatars.com/api/?name=${Uri.encodeComponent(profile.username)}&background=random'),
                                    ),
                                    if (isOwnProfile)
                                      GestureDetector(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => EditProfileScreen(userId: targetUserId, isOwnProfile: isOwnProfile)),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary,
                                            shape: BoxShape.circle,
                                            boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.26), blurRadius: 4, offset: const Offset(0, 2))],
                                          ),
                                          child: Icon(Icons.edit, size: 16, color: Theme.of(context).colorScheme.onPrimary),
                                        ),
                                      ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FriendsListScreen(viewedUserId: targetUserId),
                                    ),
                                  ),
                                  child: DataBox(label: t.profileFriendsBox, value: "${profile.numFriends}"),
                                ),
                                DataBox(label: t.profilePostsBox, value: "${profile.numPosts}"),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column (
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile.name.trim().isEmpty && profile.surname.trim().isEmpty
                                      ? profile.username
                                      : '${profile.name} ${profile.surname}'.trim(),
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                  profile.description.isNotEmpty ? profile.description : t.profileNoDescription,
                                  softWrap: true,
                                  maxLines: null,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                ],
                              )
                            ),
                            const SizedBox(height: 12),
                            if (!isOwnProfile)
                              ProfileActionsWidget(
                                profileUserId: targetUserId,
                                profileName: profile.username,
                              ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),

                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          dividerColor: Colors.transparent,
                          tabs: [
                            Tab(text: t.profilePublicationsSection),
                            Tab(text: t.profileTrophiesSection),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
              
                body: TabBarView(
                  children: [
                    Material(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: CustomScrollView(
                        slivers: [
                          PostsGrid(isOwnProfile: isOwnProfile, numPosts: profile.numPosts, posts: profile.posts),
                        ],
                      ),
                    ),
                    Material(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: CustomScrollView(
                        slivers: [
                          TrophiesGrid(trophies: profile.trophies),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return _tabBar != oldDelegate._tabBar;
  }
}