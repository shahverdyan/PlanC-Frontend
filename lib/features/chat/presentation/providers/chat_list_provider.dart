import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plan_c_frontend/features/chat/data/repositories/chat_repository.dart';
import 'package:plan_c_frontend/features/chat/presentation/providers/chat_repository_provider.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';

// ✅ CLASE AUXILIAR PARA LOS MIEMBROS
class ChatMember {
  final String id;
  final String name;
  final String? photoUrl;

  ChatMember({required this.id, required this.name, this.photoUrl});
}

class ChatItemModel {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unread;
  final bool isMuted;
  final String? photoUrl;
  final bool isActive;
  final String type;
  final List<ChatMember> members;
  final String? quedadaId;

  ChatItemModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unread,
    this.isMuted = false,
    this.photoUrl,
    this.isActive = true,
    required this.type,
    required this.members,
    this.quedadaId,
  });

  ChatItemModel copyWith({
    String? id,
    String? name,
    String? lastMessage,
    String? time,
    int? unread,
    bool? isMuted,
    String? photoUrl,
    bool? isActive,
    String? type,
    List<ChatMember>? members,
    String? quedadaId,
  }) =>
      ChatItemModel(
        id: id ?? this.id,
        name: name ?? this.name,
        lastMessage: lastMessage ?? this.lastMessage,
        time: time ?? this.time,
        unread: unread ?? this.unread,
        isMuted: isMuted ?? this.isMuted,
        photoUrl: photoUrl ?? this.photoUrl,
        isActive: isActive ?? this.isActive,
        type: type ?? this.type,
        members: members ?? this.members,
        quedadaId: quedadaId ?? this.quedadaId,
      );
}

class ChatListNotifier extends StateNotifier<AsyncValue<List<ChatItemModel>>> {
  final ChatRepository _repository;
  final String? _userId;
  final Future<void> Function()? _onSessionExpired;

  ChatListNotifier(
    this._repository,
    this._userId, {
    Future<void> Function()? onSessionExpired,
  })  : _onSessionExpired = onSessionExpired,
        super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_userId == null || _userId.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    await _loadChats();
  }

  Future<void> _loadChats() async {
    state = const AsyncValue.loading();
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      if (token == null || token.isEmpty) {
        state = AsyncValue.error('Sessió invàlida o caducada. Torna a iniciar sessió.', StackTrace.current);
        return;
      }

      final chats = await _repository.getAllXats();
      
      // 🔥 DIAGNÓSTICO PROFUNDO
      debugPrint('🔥 CHATS RECIBIDOS DEL BACKEND: ${chats.length}');
      for (var c in chats) {
        debugPrint('👉 Chat detectat - Nom: ${c.name} | Tipus: ${c.type} | ID: ${c.id}');
      }

      final items = chats.map((chat) => ChatItemModel(
        id: chat.id,
        name: chat.name,
        lastMessage: chat.lastMessage,
        time: chat.time,
        unread: chat.unread,
        isMuted: chat.isMuted,
        photoUrl: chat.photoUrl,
        isActive: chat.isActive,
        type: chat.type,
        members: chat.members.map((m) => ChatMember(
          id: m['id'] as String? ?? '',
          name: m['name'] as String? ?? '',
          photoUrl: m['photoUrl'] as String?,
        )).toList(),
        quedadaId: chat.quedadaId,
      )).toList();
      
      state = AsyncValue.data(items);
    } on DioException catch (e, st) {
      if (e.response?.statusCode == 401) {
        debugPrint('🔒 [ChatList] Token caducat (401). Invalidant sessió...');
        await _onSessionExpired?.call();
        state = AsyncValue.error(
          Exception('Sessió caducada. Torna a iniciar sessió.'),
          st,
        );
      } else {
        debugPrint('❌ [ChatList] Error Dio: $e');
        state = AsyncValue.error(e, st);
      }
    } catch (e, st) {
      debugPrint('❌ [ChatList] Error al cargar: $e');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refreshChats() async {
    await _loadChats();
  }

  void updateChatPhoto(String chatId, String newPhotoUrl) {
    final currentList = state.valueOrNull;
    if (currentList == null) return;
    state = AsyncValue.data(
      currentList
          .map((c) => c.id == chatId ? c.copyWith(photoUrl: newPhotoUrl) : c)
          .toList(),
    );
  }

  Future<void> toggleMutedChat(String xatId, bool shouldMute) async {
    try {
      await _repository.toggleSilenciarXat(xatId, shouldMute);
      await _loadChats();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteChat(String xatId) async {
    try {
      await _repository.deleteXat(xatId);
      await _loadChats();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> abandonChat(String xatId) async {
    try {
      await _repository.abandonXat(xatId);
      await _loadChats();
    } catch (e) {
      // No canviem l'estat a error: la llista segueix sent vàlida.
      // Rellancem perquè el diàleg pugui mostrar el missatge correcte.
      rethrow;
    }
  }
}

final chatListProvider = StateNotifierProvider<ChatListNotifier, AsyncValue<List<ChatItemModel>>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);

  return ChatListNotifier(
    repository,
    userId,
    onSessionExpired: () => ref.read(authProvider.notifier).handleSessionExpired(),
  );
});