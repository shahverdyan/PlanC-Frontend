import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/chat/presentation/providers/chat_list_provider.dart';
import 'package:plan_c_frontend/features/chat/presentation/screens/chat_room_screen.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.myChatsTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 1,
        centerTitle: false,
      ),
      body: const ChatListBody(),
    );
  }
}

class ChatListBody extends ConsumerWidget {
  const ChatListBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final chatsAsync = ref.watch(chatListProvider);
    final currentUserId = ref.watch(currentUserIdProvider);

    return chatsAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
          ),
        ),
        error: (error, stackTrace) => Center(
          child: Text(
            t.chatListError(error.toString()),
            textAlign: TextAlign.center,
          ),
        ),
        data: (chats) {
          if (chats.isEmpty) {
            return RefreshIndicator(
              color: Theme.of(context).colorScheme.primary,
              onRefresh: () => ref.read(chatListProvider.notifier).refreshChats(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 150),
                  Center(
                    child: Text(
                      t.chatListEmpty,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: Theme.of(context).colorScheme.primary,
            onRefresh: () => ref.read(chatListProvider.notifier).refreshChats(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: chats.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                indent: 80,
              ),
              itemBuilder: (context, index) {
                final chat = chats[index];
                final unread = chat.unread;
                final isIndividual = chat.type == 'INDIVIDUAL';

                // Per a xats individuals, fotoGrup és null; usem la foto de l'altre membre.
                String? resolvedPhotoUrl = chat.photoUrl;
                if (resolvedPhotoUrl == null && isIndividual && chat.members.isNotEmpty) {
                  final other = chat.members.firstWhere(
                    (m) => m.id != currentUserId,
                    orElse: () => chat.members.first,
                  );
                  resolvedPhotoUrl = other.photoUrl;
                }

                return Dismissible(
                  key: ValueKey(chat.id),
                  direction: DismissDirection.endToStart,
                  // ✅ AC #2: Pedimos confirmación estricta antes de borrar por deslizamiento
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(t.chatDeleteDialogTitle),
                        content: Text(t.chatDeleteDialogContent(chat.name)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(t.chatDeleteCancel),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(t.chatDeleteConfirm, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (_) {
                    ref.read(chatListProvider.notifier).deleteChat(chat.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(t.chatDeletedSnackbar(chat.name)),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    color: Theme.of(context).colorScheme.error,
                    child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      radius: 28,
                      backgroundImage: (resolvedPhotoUrl != null && resolvedPhotoUrl.isNotEmpty)
                          ? NetworkImage(resolvedPhotoUrl)
                          : null,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          if (resolvedPhotoUrl == null || resolvedPhotoUrl.isEmpty)
                            Icon(
                              isIndividual ? Icons.person : Icons.group,
                              color: Theme.of(context).colorScheme.primary,
                              size: 30,
                            ),
                          if (chat.isMuted)
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.error,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.volume_off,
                                size: 8,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: chat.isMuted || !chat.isActive
                                  ? Theme.of(context).colorScheme.onSurfaceVariant
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!chat.isActive) ...[
                          const SizedBox(width: 6),
                          Icon(Icons.lock_outline, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ],
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: chat.isMuted
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : (unread > 0 ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurfaceVariant),
                          fontWeight: unread > 0 ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          chat.time,
                          style: TextStyle(
                            color: chat.isMuted
                                ? Theme.of(context).colorScheme.onSurfaceVariant
                                : (unread > 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant),
                            fontSize: 12,
                            fontWeight: unread > 0 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (unread > 0 && !chat.isMuted)
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              unread.toString(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatRoomScreen(
                            chatName: chat.name,
                            chatId: chat.id,
                          ),
                        ),
                      );
                      
                      if (context.mounted) {
                        ref.read(chatListProvider.notifier).refreshChats();
                      }
                    },
                    onLongPress: () {
                      _showChatContextMenu(context, chat, ref);
                    },
                  ),
                );
              },
            ),
          );
        },
      );
  }

  void _showChatContextMenu(
    BuildContext context,
    ChatItemModel chat,
    WidgetRef ref,
  ) {
    final t = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        top: false,
        child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                chat.isMuted ? Icons.volume_up : Icons.volume_off,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              title: Text(
                chat.isMuted ? t.chatUnmuteAction : t.chatMuteAction,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              onTap: () {
                ref.read(chatListProvider.notifier).toggleMutedChat(chat.id, !chat.isMuted);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      chat.isMuted ? t.chatUnmutedSnackbar(chat.name) : t.chatMutedSnackbar(chat.name),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
              title: Text(
                t.chatDeleteDialogTitle,
                style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.error),
              ),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(t.chatDeleteDialogTitle),
                    content: Text(t.chatDeleteDialogContent(chat.name)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(t.chatDeleteCancel),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(chatListProvider.notifier).deleteChat(chat.id);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(t.chatDeletedSnackbar(chat.name)),
                              backgroundColor: Theme.of(context).colorScheme.error,
                            ),
                          );
                        },
                        child: Text(t.chatDeleteConfirm, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      ),
    );
  }
}