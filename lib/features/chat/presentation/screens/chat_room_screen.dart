import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plan_c_frontend/features/chat/domain/models/message.dart';
import 'package:plan_c_frontend/features/chat/presentation/providers/chat_provider.dart';
import 'package:plan_c_frontend/features/chat/presentation/providers/chat_list_provider.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';

import 'package:plan_c_frontend/features/activitats/model/activitat.dart';
import 'package:plan_c_frontend/features/activitats/presentation/screens/activitat_detail_screen.dart';
import 'package:plan_c_frontend/features/chat/presentation/screens/chat_details_screen.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String chatName;
  final String chatId;

  const ChatRoomScreen({
    super.key,
    required this.chatName,
    required this.chatId,
  });

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();

  bool _initialScrollDone = false;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = _messageController.text;
    if (text.isNotEmpty) {
      ref.read(chatProvider(widget.chatId).notifier).notifyTyping(true);
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          ref.read(chatProvider(widget.chatId).notifier).notifyTyping(false);
        }
      });
    }
  }

  void _sendMessage() {
    final text = _messageController.text;
    if (text.trim().isEmpty) return;

    _messageController.clear();
    ref.read(chatProvider(widget.chatId).notifier).notifyTyping(false); 

    try {
      ref.read(chatProvider(widget.chatId).notifier).sendMessage(text);
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.chatRoomNotFoundError(e.toString())),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    Navigator.pop(context);

    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        await ref.read(chatProvider(widget.chatId).notifier).sendImage(pickedFile.path);
        _scrollToBottom();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.chatRoomImagePickError(e.toString())),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _pickImageFromCamera() async {
    Navigator.pop(context);

    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        await ref.read(chatProvider(widget.chatId).notifier).sendImage(pickedFile.path);
        _scrollToBottom();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.chatRoomImageCaptureError(e.toString())),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getDateSeparatorText(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    final t = AppLocalizations.of(context)!;
    if (messageDate == today) {
      return t.chatRoomTodayLabel;
    } else if (messageDate == yesterday) {
      return t.chatRoomYesterdayLabel;
    } else {
      final months = ['gener', 'febrer', 'març', 'abril', 'maig', 'juny', 
                      'juliol', 'agost', 'setembre', 'octubre', 'novembre', 'desembre'];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }
  }

  bool _shouldShowDateSeparator(int currentIndex, List<Message> messages) {
    if (currentIndex == 0) return true;
    
    final currentMessage = messages[currentIndex];
    final previousMessage = messages[currentIndex - 1];
    
    final currentDate = DateTime(
      currentMessage.timestamp.year,
      currentMessage.timestamp.month,
      currentMessage.timestamp.day,
    );
    final previousDate = DateTime(
      previousMessage.timestamp.year,
      previousMessage.timestamp.month,
      previousMessage.timestamp.day,
    );
    
    return currentDate != previousDate;
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAttachmentOption(
                      icon: Icons.image_outlined,
                      color: AppSemanticColors.of(context).info,
                      label: AppLocalizations.of(context)!.chatRoomAttachmentGallery,
                      onTap: _pickImageFromGallery,
                    ),
                    _buildAttachmentOption(
                      icon: Icons.camera_alt_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      label: AppLocalizations.of(context)!.chatRoomAttachmentCamera,
                      onTap: _pickImageFromCamera,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withValues(alpha:0.1),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _typingTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final messagesState = ref.watch(chatProvider(widget.chatId));
    final currentUserId = ref.watch(currentUserIdProvider);

    // Scroll to bottom on initial load (messages arriving from async fetch)
    if (!_initialScrollDone && messagesState.messages.isNotEmpty) {
      _initialScrollDone = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }

    // Scroll to bottom when new messages arrive (WebSocket), but not when loading older messages
    ref.listen<ChatMessagesState>(
      chatProvider(widget.chatId),
      (previous, next) {
        if (previous == null) return;
        if (next.messages.length > previous.messages.length && !previous.isLoadingMore) {
          _scrollToBottom();
        }
      },
    );

    final chatListAsync = ref.watch(chatListProvider);
    bool canWrite = true;
    bool isMuted = false;
    String? chatPhotoUrl;
    bool chatIsGroup = false;

    if (chatListAsync.value != null) {
      try {
        final chatInfo = chatListAsync.value!.firstWhere((c) => c.id == widget.chatId);
        canWrite = chatInfo.isActive;
        isMuted = chatInfo.isMuted;
        chatPhotoUrl = chatInfo.photoUrl;
        chatIsGroup = chatInfo.type != 'INDIVIDUAL';

        // Per a xats individuals, fotoGrup és null al backend.
        // Usem la foto del membre que no és l'usuari actual.
        if (chatPhotoUrl == null && !chatIsGroup && chatInfo.members.isNotEmpty) {
          final currentUserId = ref.read(currentUserIdProvider);
          final other = chatInfo.members.firstWhere(
            (m) => m.id != currentUserId,
            orElse: () => chatInfo.members.first,
          );
          chatPhotoUrl = other.photoUrl;
        }
      } catch (e) {
        debugPrint('⚠️ Info: Xat no trobat a la llista local. Error: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailsScreen(chatId: widget.chatId),
              ),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar estil WhatsApp
              CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                backgroundImage: (chatPhotoUrl != null && chatPhotoUrl.isNotEmpty)
                    ? NetworkImage(chatPhotoUrl)
                    : null,
                child: (chatPhotoUrl == null || chatPhotoUrl.isEmpty)
                    ? Icon(
                        chatIsGroup ? Icons.group : Icons.person,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.chatName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.info_outline, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ],
          ),
        ),
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(
              isMuted ? Icons.notifications_off : Icons.notifications_none,
              color: isMuted ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurface,
            ),
            tooltip: isMuted ? t.chatUnmuteAction : t.chatMuteAction,
            onPressed: () async {
              try {
                await ref.read(chatListProvider.notifier).toggleMutedChat(widget.chatId, !isMuted);
                if (context.mounted) {
                  final localT = AppLocalizations.of(context)!;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isMuted ? localT.chatRoomMuteOff : localT.chatRoomMuteOn),
                      backgroundColor: isMuted ? AppSemanticColors.of(context).success : Theme.of(context).colorScheme.primary,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  final localT = AppLocalizations.of(context)!;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(localT.chatRoomMuteUnmuteError), backgroundColor: Theme.of(context).colorScheme.error),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (!canWrite)
              _buildInactiveBanner(t),
            Expanded(
              child: messagesState.messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          const SizedBox(height: 16),
                          Text(
                            t.chatRoomNoMessages,
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            t.chatRoomStartConversation,
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
                          ),
                        ],
                      ),
                    )
                  : Stack(
                      children: [
                        ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          itemCount: messagesState.messages.length + (messagesState.nextCursor != null ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == 0 && messagesState.nextCursor != null) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Center(
                                  child: TextButton(
                                    onPressed: () {
                                      ref.read(chatProvider(widget.chatId).notifier).loadMoreMessages();
                                    },
                                    child: Text(t.chatRoomLoadOlder),
                                  ),
                                ),
                              );
                            }

                            final messageIndex = messagesState.nextCursor != null ? index - 1 : index;
                            final message = messagesState.messages[messageIndex];
                            final isMe = currentUserId != null && message.senderId == currentUserId;

                            final showDateSeparator = _shouldShowDateSeparator(messageIndex, messagesState.messages);

                            return Column(
                              children: [
                                if (showDateSeparator)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          _getDateSeparatorText(message.timestamp),
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                _buildMessageBubble(
                                  message: message,
                                  isMe: isMe,
                                ),
                              ],
                            );
                          },
                        ),
                        if (messagesState.isLoadingMore)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: LinearProgressIndicator(
                              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                            ),
                          ),
                      ],
                    ),
            ),
            
            if (messagesState.isOtherTyping)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          t.chatRoomSomeoneTyping,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontStyle: FontStyle.italic, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (canWrite)
              _buildMessageInput()
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Text(
                      t.chatRoomReadOnlyNotice,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble({
    required Message message,
    required bool isMe,
  }) {
    if (message.type == MessageType.system) {
      return _buildSystemMessage(message);
    }

    if (message.type == MessageType.activity) {
      return _buildActivityCard(message: message, isMe: isMe);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
              child: Text(
                message.senderName,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (message.type == MessageType.image && message.imageUrl != null)
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                    child: Image.network(
                      message.imageUrl!,
                      fit: BoxFit.cover,
                      height: 200,
                      headers: {
                        'Authorization': 'Bearer ${ref.watch(accessTokenProvider).value ?? ""}',
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 100,
                          width: 100,
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.image_not_supported),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 100,
                          width: 100,
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                  ),
                )
              else
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isMe ? AppSemanticColors.of(context).chatBubbleOwn : AppSemanticColors.of(context).chatBubbleOther,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow.withValues(alpha: isMe ? 0.15 : 0.10),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isMe ? AppSemanticColors.of(context).onChatBubbleOwn : AppSemanticColors.of(context).onChatBubbleOther,
                      fontSize: 15,
                      height: 1.3,
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 6.0,
              left: isMe ? 0 : 12.0,
              right: isMe ? 12.0 : 0,
            ),
            child: Text(
              message.formattedTime,
              style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard({required Message message, required bool isMe}) {
    final activityData = message.activityData;
    
    if (activityData == null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(AppLocalizations.of(context)!.chatRoomActivityError),
        ),
      );
    }

    final aktivitatT = AppLocalizations.of(context)!;
    final aktivitat = Activitat(
      id: activityData['id'] as String? ?? '',
      titol: activityData['titol'] as String? ?? aktivitatT.chatRoomActivityNoTitle,
      descripcio: activityData['descripcio'] as String? ?? '',
      categoria: activityData['categoria'] as String? ?? aktivitatT.chatRoomActivityCategoryOther,
      urlEntrades: activityData['urlEntrades'] as String? ?? '',
      nomEspai: activityData['nomEspai'] as String? ?? aktivitatT.chatRoomActivityNoLocation,
      lat: double.tryParse(activityData['lat'].toString()) ?? 0.0,
      lng: double.tryParse(activityData['lng'].toString()) ?? 0.0,
      dataInici: activityData['dataInici'] != null 
          ? DateTime.parse(activityData['dataInici'] as String)
          : DateTime.now(),
      dataFi: activityData['dataFi'] != null
          ? DateTime.parse(activityData['dataFi'] as String)
          : DateTime.now(), adreca: '', localitat: '',
    );

    final dateFormat = DateFormat('dd MMM, HH:mm');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
              child: Text(
                message.senderName,
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600),
              ),
            ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActivitatDetailScreen(activitat: aktivitat),
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              margin: EdgeInsets.only(
                left: isMe ? 0 : 8,
                right: isMe ? 8 : 0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.10), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Center(
                        child: Icon(Icons.local_activity_outlined, color: Theme.of(context).colorScheme.primary, size: 40),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          aktivitat.titol,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text(dateFormat.format(aktivitat.dataInici), style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                aktivitat.nomEspai, 
                                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                      border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3))),
                    ),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.chatRoomViewActivity,
                        style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 6.0, left: isMe ? 0 : 12.0, right: isMe ? 12.0 : 0),
            child: Text(
              message.formattedTime,
              style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveBanner(AppLocalizations t) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppSemanticColors.of(context).warningSurface,
        border: Border(
          bottom: BorderSide(color: AppSemanticColors.of(context).warning, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_outline, color: AppSemanticColors.of(context).warning, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.chatRoomInactiveBannerTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppSemanticColors.of(context).warning,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  t.chatRoomInactiveBannerBody,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppSemanticColors.of(context).warning,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemMessage(Message message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 32.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            message.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: IconButton(
              icon: Icon(Icons.attach_file, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 26),
              onPressed: _showAttachmentMenu,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 4,
              minLines: 1,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.chatRoomInputHint,
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                filled: true,
                fillColor: AppSemanticColors.of(context).chatInputFill,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: 24,
              child: IconButton(
                icon: Icon(Icons.send, color: Theme.of(context).colorScheme.onPrimary, size: 22),
                onPressed: _sendMessage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}