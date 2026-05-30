import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:plan_c_frontend/features/activitats/model/activitat.dart';
import 'package:plan_c_frontend/features/activitats/presentation/provider/activitats_providers.dart';
import 'package:plan_c_frontend/features/activitats/presentation/screens/activitat_detail_screen.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/chat/presentation/providers/chat_list_provider.dart';
import 'package:plan_c_frontend/features/groups/data/providers.dart';
import 'package:plan_c_frontend/features/groups/domain/models/group.dart';
import 'package:plan_c_frontend/features/perfil/presentation/profile_screen.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class ChatDetailsScreen extends ConsumerStatefulWidget {
  final String chatId;

  const ChatDetailsScreen({super.key, required this.chatId});

  @override
  ConsumerState<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends ConsumerState<ChatDetailsScreen> {
  bool _isUploadingPhoto = false;

  Future<void> _handlePhotoUpload(String quedadaId) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() => _isUploadingPhoto = true);
    try {
      final newUrl = await ref.read(groupRepositoryProvider).uploadGroupPhoto(
            quedadaId: quedadaId,
            imageFile: File(picked.path),
          );
      // Esborra el caché del NetworkImage anterior perquè es mostri la foto nova
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
      ref.read(chatListProvider.notifier).updateChatPhoto(widget.chatId, newUrl);
      if (mounted) {
        final t = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.chatDetailsPhotoUpdateSuccess),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final t = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.chatDetailsPhotoUpdateError(e.toString())),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingPhoto = false);
    }
  }

  void _showConfirmationDialog(
      BuildContext context, ChatItemModel chat, bool isGroup) {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isGroup
            ? t.chatDetailsLeaveGroupDialogTitle
            : t.chatDetailsDeleteChatDialogTitle),
        content: Text(isGroup
            ? t.chatDetailsLeaveGroupDialogContent(chat.name)
            : t.chatDetailsDeleteChatDialogContent(chat.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.chatDetailsActionCancel),
          ),
          TextButton(
            onPressed: () async {
              try {
                if (isGroup) {
                  await ref
                      .read(chatListProvider.notifier)
                      .abandonChat(chat.id);
                } else {
                  await ref
                      .read(chatListProvider.notifier)
                      .deleteChat(chat.id);
                }

                if (context.mounted) {
                  final localT = AppLocalizations.of(context)!;
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isGroup
                          ? localT.chatDetailsGroupLeftSnackbar
                          : localT.chatDetailsChatDeletedSnackbar),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  final msg = _extractErrorMessage(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(msg),
                        backgroundColor: Theme.of(context).colorScheme.error),
                  );
                }
              }
            },
            child: Text(
                isGroup ? t.chatDetailsLeaveButton : t.chatDetailsDeleteButton,
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  String _extractErrorMessage(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
    }
    return e.toString();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final chatListAsync = ref.watch(chatListProvider);
    final chat =
        chatListAsync.valueOrNull?.firstWhere((c) => c.id == widget.chatId);
    final currentUserId = ref.watch(currentUserIdProvider);

    if (chat == null) {
      return Scaffold(
        appBar: AppBar(title: Text(t.chatDetailsFallbackTitle)),
        body: Center(child: Text(t.chatDetailsLoadError)),
      );
    }

    final isGroup = chat.type != 'INDIVIDUAL';
    final isQuedada = chat.type == 'QUEDADA';

    // Per a xats individuals, fotoGrup és null; usem la foto de l'altre membre.
    String? resolvedPhotoUrl = chat.photoUrl;
    if (resolvedPhotoUrl == null && !isGroup && chat.members.isNotEmpty) {
      final other = chat.members.firstWhere(
        (m) => m.id != currentUserId,
        orElse: () => chat.members.first,
      );
      resolvedPhotoUrl = other.photoUrl;
    }
    final displayType = chat.type == 'GRUP_AMICS'
        ? t.chatDetailsTypeFriendGroup
        : chat.type == 'QUEDADA'
            ? t.chatDetailsTypeMeetup
            : t.chatDetailsTypeIndividual;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.chatDetailsAppBarTitle,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Foto gran i botó per canviar-la
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    backgroundImage:
                        (resolvedPhotoUrl != null && resolvedPhotoUrl.isNotEmpty)
                            ? NetworkImage(resolvedPhotoUrl)
                            : null,
                    child: (resolvedPhotoUrl == null || resolvedPhotoUrl.isEmpty)
                        ? Icon(isGroup ? Icons.group : Icons.person,
                            size: 60,
                            color: Theme.of(context).colorScheme.primary)
                        : null,
                  ),
                  if (isGroup)
                    GestureDetector(
                      onTap: (_isUploadingPhoto ||
                              !isQuedada ||
                              chat.quedadaId == null)
                          ? null
                          : () => _handlePhotoUpload(chat.quedadaId!),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .shadow
                                    .withValues(alpha: 0.26),
                                blurRadius: 4,
                                offset: const Offset(0, 2))
                          ],
                        ),
                        child: _isUploadingPhoto
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              )
                            : Icon(Icons.camera_alt,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 20),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              chat.name,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Badge de tipus de xat
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                displayType,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
              ),
            ),
            const SizedBox(height: 32),

            // Secció d'informació de la quedada (només per xats de tipus QUEDADA)
            if (isQuedada && chat.quedadaId != null)
              _QuedadaInfoSection(quedadaId: chat.quedadaId!),

            // Llista de membres
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                t.chatDetailsMembersHeader,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              color: Theme.of(context).colorScheme.surface,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: chat.members.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1, indent: 70),
                itemBuilder: (context, index) {
                  final member = chat.members[index];
                  final isCurrentUser = member.id == currentUserId;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      backgroundImage: (member.photoUrl != null &&
                              member.photoUrl!.isNotEmpty)
                          ? NetworkImage(member.photoUrl!)
                          : null,
                      child: (member.photoUrl == null ||
                              member.photoUrl!.isEmpty)
                          ? Icon(Icons.person,
                              color: Theme.of(context).colorScheme.primary)
                          : null,
                    ),
                    title: Text(member.name,
                        style:
                            const TextStyle(fontWeight: FontWeight.w600)),
                    onTap: isCurrentUser
                        ? null
                        : () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProfileScreen(profileUserId: member.id),
                              ),
                            ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),

            // Botó Abandonar / Eliminar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .error
                        .withValues(alpha: 0.1),
                    foregroundColor: Theme.of(context).colorScheme.error,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.exit_to_app),
                  label: Text(
                    isGroup
                        ? t.chatDetailsLeaveChat
                        : t.chatDetailsDeleteChat,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    _showConfirmationDialog(context, chat, isGroup);
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _QuedadaInfoSection extends ConsumerWidget {
  final String quedadaId;

  const _QuedadaInfoSection({required this.quedadaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final groupAsync = ref.watch(groupByIdProvider(quedadaId));

    return groupAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => const SizedBox.shrink(),
      data: (group) => _buildQuedadaCard(context, ref, t, group),
    );
  }

  Widget _buildQuedadaCard(
      BuildContext context, WidgetRef ref, AppLocalizations t, Group group) {
    final dateStr =
        DateFormat('dd/MM/yyyy · HH:mm').format(group.dateTime.toLocal());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.chatDetailsQuedadaInfoHeader,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.event,
                  label: t.chatDetailsQuedadaDate,
                  value: dateStr,
                ),
                Divider(
                    height: 1,
                    indent: 52,
                    color: Theme.of(context).colorScheme.outlineVariant),
                _InfoRow(
                  icon: Icons.local_activity,
                  label: t.chatDetailsQuedadaActivity,
                  value: group.title,
                ),
                if (group.activityId.isNotEmpty) ...[
                  Divider(
                      height: 1,
                      indent: 52,
                      color: Theme.of(context).colorScheme.outlineVariant),
                  _ActivityButtonRow(
                    activityId: group.activityId,
                    label: t.chatDetailsQuedadaViewActivity,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityButtonRow extends ConsumerWidget {
  final String activityId;
  final String label;

  const _ActivityButtonRow({required this.activityId, required this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      onTap: () async {
        Activitat? activitat;
        try {
          activitat = await ref.read(activitatByIdProvider(activityId).future);
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('No s\'ha pogut carregar l\'activitat')),
            );
          }
          return;
        }
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ActivitatDetailScreen(activitat: activitat!),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(Icons.open_in_new,
                size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Text(label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary)),
            const Spacer(),
            Icon(Icons.chevron_right,
                size: 20, color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
