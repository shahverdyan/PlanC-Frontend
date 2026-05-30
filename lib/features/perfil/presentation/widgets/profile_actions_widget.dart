import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/chat/presentation/providers/chat_list_provider.dart';
import 'package:plan_c_frontend/features/chat/presentation/providers/chat_repository_provider.dart';
import 'package:plan_c_frontend/features/chat/presentation/screens/chat_room_screen.dart';
import 'package:plan_c_frontend/features/perfil/domain/models/relationship_status.dart';
import 'package:plan_c_frontend/features/perfil/presentation/providers/relationship_actions_provider.dart';
import 'package:plan_c_frontend/features/perfil/presentation/providers/relationship_status_provider.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class ProfileActionsWidget extends ConsumerWidget {
  final String profileUserId;
  final String profileName;

  const ProfileActionsWidget({
    super.key,
    required this.profileUserId,
    required this.profileName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<RelationshipActionsState>(
      relationshipActionsProvider(profileUserId),
      (_, next) {
        if (next.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.error!)),
          );
          ref
              .read(relationshipActionsProvider(profileUserId).notifier)
              .clearError();
        }
      },
    );

    final statusAsync = ref.watch(relationshipStatusProvider(profileUserId));
    final actionsState = ref.watch(relationshipActionsProvider(profileUserId));
    final notifier =
        ref.read(relationshipActionsProvider(profileUserId).notifier);

    return statusAsync.when(
      loading: () => const SizedBox(
        height: 40,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) {
        final t = AppLocalizations.of(context)!;
        return Column(
          children: [
            Text(t.relationshipErrorPrefix(err.toString()),
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
            TextButton(
              onPressed: () =>
                  ref.invalidate(relationshipStatusProvider(profileUserId)),
              child: Text(t.relationshipRetry),
            ),
          ],
        );
      },
      data: (status) => _buildButtons(
        context,
        ref,
        status,
        actionsState,
        notifier,
      ),
    );
  }

  Widget _buildButtons(
    BuildContext context,
    WidgetRef ref,
    RelationshipStatus status,
    RelationshipActionsState actionsState,
    RelationshipActionsNotifier notifier,
  ) {
    final t = AppLocalizations.of(context)!;

    switch (status) {
      case RelationshipStatus.friends:
        return Row(
          children: [
            Expanded(
              child: _CompactButton(
                label: t.relationshipRemoveFriend,
                outlined: true,
                isLoading: actionsState.isLoadingAction(RelationshipAction.remove),
                isDisabled: actionsState.loadingAction != null,
                onPressed: notifier.eliminarAmic,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _CompactButton(
                label: t.profileEnviarMissatge,
                icon: Icons.chat_bubble_outline,
                onPressed: () async => _obrirXat(context, ref, t),
              ),
            ),
          ],
        );

      case RelationshipStatus.requestReceived:
        return Row(
          children: [
            Expanded(
              child: _CompactButton(
                label: t.relationshipAccept,
                isLoading: actionsState.isLoadingAction(RelationshipAction.accept),
                isDisabled: actionsState.loadingAction != null,
                onPressed: notifier.acceptarSolicitud,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _CompactButton(
                label: t.relationshipReject,
                outlined: true,
                isLoading: actionsState.isLoadingAction(RelationshipAction.reject),
                isDisabled: actionsState.loadingAction != null,
                onPressed: notifier.rebutjarSolicitud,
              ),
            ),
          ],
        );

      case RelationshipStatus.requestSent:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CompactButton(
              label: t.relationshipRequestSent,
              outlined: true,
              isDisabled: true,
              onPressed: () async {},
            ),
            const SizedBox(height: 8),
            _CompactButton(
              label: t.relationshipCancel,
              outlined: true,
              isLoading: actionsState.isLoadingAction(RelationshipAction.cancel),
              isDisabled: actionsState.loadingAction != null,
              onPressed: notifier.cancelarSolicitud,
            ),
          ],
        );

      case RelationshipStatus.stranger:
        return _CompactButton(
          label: t.relationshipSendRequest,
          icon: Icons.person_add_outlined,
          isLoading: actionsState.isLoadingAction(RelationshipAction.add),
          isDisabled: actionsState.loadingAction != null,
          onPressed: notifier.afegirAmic,
        );
    }
  }

  Future<void> _obrirXat(BuildContext context, WidgetRef ref, AppLocalizations t) async {
    // 1. Comprova si el xat ja existeix localment
    final chats = ref.read(chatListProvider).valueOrNull ?? [];
    ChatItemModel? chat;
    for (final c in chats.where((c) => c.type == 'INDIVIDUAL')) {
      if (c.members.any((m) => m.id == profileUserId)) {
        chat = c;
        break;
      }
    }

    String? xatId = chat?.id;

    // 2. Si no existeix, crea'l (o recupera'l) via WebSocket
    if (xatId == null) {
      try {
        final repository = ref.read(chatRepositoryProvider);
        xatId = await repository.obrirXatPrivat(profileUserId);
        ref.invalidate(chatListProvider);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
          );
        }
        return;
      }
    }

    // 3. Navega al xat
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatRoomScreen(
            chatName: profileName,
            chatId: xatId!,
          ),
        ),
      );
    }
  }
}

class _CompactButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool outlined;
  final bool isLoading;
  final bool isDisabled;
  final Future<void> Function() onPressed;

  const _CompactButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.outlined = false,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
    final padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 12);

    if (outlined) {
      return OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: padding,
          shape: shape,
          side: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        child: child,
      );
    }
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: padding,
        shape: shape,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
      ),
      child: child,
    );
  }
}
