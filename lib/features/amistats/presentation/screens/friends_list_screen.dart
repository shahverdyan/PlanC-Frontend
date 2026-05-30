import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/amistats/domain/models/amistat.dart';
import 'package:plan_c_frontend/features/amistats/presentation/providers/amistats_provider.dart';
import 'package:plan_c_frontend/features/amistats/presentation/providers/amistats_repository_provider.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/perfil/presentation/profile_screen.dart';
import 'package:plan_c_frontend/features/perfil/presentation/providers/profile_provider.dart';
import 'package:plan_c_frontend/features/perfil/presentation/providers/relationship_status_provider.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class FriendsListScreen extends ConsumerStatefulWidget {
  final String viewedUserId;

  const FriendsListScreen({super.key, required this.viewedUserId});

  @override
  ConsumerState<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends ConsumerState<FriendsListScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final currentUserId = ref.watch(currentUserIdProvider) ?? '';
    final isOwnProfile = widget.viewedUserId == currentUserId;
    final amistatsAsync = ref.watch(amistatsProvider(widget.viewedUserId));

    return Scaffold(
      appBar: AppBar(
        title: Text(t.friendsListTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 1,
      ),
      body: amistatsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(err.toString(), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => ref.invalidate(amistatsProvider(widget.viewedUserId)),
                child: Text(t.friendsListRetry),
              ),
            ],
          ),
        ),
        data: (amics) {
          final filtered = _query.isEmpty
              ? amics
              : amics.where((a) =>
                  a.nomUsuari.toLowerCase().contains(_query.toLowerCase())).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: t.friendsListSearchHint,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              if (amics.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      isOwnProfile ? t.friendsListNoneOwn : t.friendsListNoneOther,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 15,
                      ),
                    ),
                  ),
                )
              else if (filtered.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      t.friendsListNoResults,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 15,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: RefreshIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    onRefresh: () async => ref.invalidate(amistatsProvider(widget.viewedUserId)),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
                      itemBuilder: (context, i) => _FriendTile(
                        key: ValueKey(filtered[i].usuariId),
                        friend: filtered[i],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfileScreen(profileUserId: filtered[i].usuariId),
                          ),
                        ),
                        onDelete: isOwnProfile
                            ? () async {
                                final repo = ref.read(amistatsRepositoryProvider);
                                await repo.eliminarAmistat(
                                  usuariId: currentUserId,
                                  altreUsuariId: filtered[i].usuariId,
                                );
                                ref.invalidate(amistatsProvider(currentUserId));
                                ref.invalidate(profileByIdProvider(currentUserId));
                                ref.invalidate(relationshipStatusProvider(filtered[i].usuariId));
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _FriendTile extends StatefulWidget {
  final SolicitudAmistat friend;
  final VoidCallback onTap;
  final Future<void> Function()? onDelete;

  const _FriendTile({
    super.key,
    required this.friend,
    required this.onTap,
    this.onDelete,
  });

  @override
  State<_FriendTile> createState() => _FriendTileState();
}

class _FriendTileState extends State<_FriendTile> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: _Avatar(nom: widget.friend.nomUsuari, foto: widget.friend.fotoPerfil),
      title: Text(
        widget.friend.nomUsuari,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: widget.onDelete == null
          ? null
          : _isDeleting
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : IconButton(
                  icon: Icon(Icons.person_remove_outlined, color: Theme.of(context).colorScheme.error),
                  tooltip: AppLocalizations.of(context)!.friendsListRemoveTooltip,
                  onPressed: () async {
                    final t = AppLocalizations.of(context)!;
                    final messenger = ScaffoldMessenger.of(context);
                    final errorColor = Theme.of(context).colorScheme.error;
                    final confirmat = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(t.friendsListRemoveDialogTitle),
                        content: Text(
                          t.friendsListRemoveDialogContent(widget.friend.nomUsuari),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(t.friendsListRemoveCancel),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                            child: Text(t.friendsListRemoveConfirm),
                          ),
                        ],
                      ),
                    );
                    if (confirmat != true || !mounted) return;
                    setState(() => _isDeleting = true);
                    try {
                      await widget.onDelete!();
                    } catch (e) {
                      if (mounted) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: errorColor,
                          ),
                        );
                        setState(() => _isDeleting = false);
                      }
                    }
                  },
                ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String nom;
  final String? foto;

  const _Avatar({required this.nom, this.foto});

  @override
  Widget build(BuildContext context) {
    if (foto != null && foto!.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(foto!),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      );
    }
    final initial = nom.isNotEmpty ? nom[0].toUpperCase() : '?';
    return CircleAvatar(
      radius: 24,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Text(
        initial,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
