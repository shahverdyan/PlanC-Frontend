import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plan_c_frontend/features/chat/domain/models/message.dart';
import 'package:plan_c_frontend/features/chat/presentation/providers/chat_repository_provider.dart';
import 'package:plan_c_frontend/features/chat/data/repositories/chat_repository.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/activitats/model/activitat.dart';

class ChatMessagesState {
  final List<Message> messages;
  final String? nextCursor;
  final bool isLoadingMore;
  final bool isInitialized;
  final bool isSocketConnected;
  final int messageCount;
  final bool isOtherTyping; // ✅ AC #6: Estado visual de escritura

  ChatMessagesState({
    this.messages = const [],
    this.nextCursor,
    this.isLoadingMore = false,
    this.isInitialized = false,
    this.isSocketConnected = false,
    this.messageCount = 0,
    this.isOtherTyping = false,
  });

  ChatMessagesState copyWith({
    List<Message>? messages,
    String? nextCursor,
    bool? isLoadingMore,
    bool? isInitialized,
    bool? isSocketConnected,
    int? messageCount,
    bool? isOtherTyping,
  }) {
    return ChatMessagesState(
      messages: messages ?? this.messages,
      nextCursor: nextCursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isInitialized: isInitialized ?? this.isInitialized,
      isSocketConnected: isSocketConnected ?? this.isSocketConnected,
      messageCount: messageCount ?? (this.messageCount + 1),
      isOtherTyping: isOtherTyping ?? this.isOtherTyping,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatMessagesState> {
  final String chatId;
  final String currentUserId;
  final ChatRepository _repository;

  bool _listenersConfigured = false;

  ChatNotifier(this.chatId, this.currentUserId, this._repository) 
      : super(ChatMessagesState()) {
    _initialize();
  }

  void _initialize() async {
    try {
      if (currentUserId.isEmpty) {
        state = state.copyWith(isInitialized: true);
        return;
      }

      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      if (token == null || token.isEmpty) {
        throw Exception('Token no disponible en el almacenamiento local');
      }

      await _repository.connect(token: token);
      await Future.delayed(const Duration(milliseconds: 200));

      await _repository.marcarComLlegit(chatId);

      final result = await _repository.getMessages(chatId, limit: 50);
      
      state = state.copyWith(
        messages: result.messages,
        nextCursor: result.nextCursor,
        isSocketConnected: true,
      );

      _repository.socketService.joinXat(chatId);
      _setupSocketListeners();

      state = state.copyWith(isInitialized: true);
    } catch (e) {
      debugPrint('❌ [Chat] Error inicializando sala: $e');
      state = state.copyWith(isInitialized: true, isSocketConnected: false);
    }
  }

  void _setupSocketListeners() {
    if (_listenersConfigured) return;
    _listenersConfigured = true;

    _repository.onNouMissatge((message) {
      if (message.chatId == chatId) {
        // Evitar duplicados por si el backend nos rebota nuestro propio mensaje
        final exists = state.messages.any((m) => m.id == message.id);
        if (!exists) {
          final updatedMessages = [...state.messages, message];
          state = state.copyWith(messages: updatedMessages);
          _repository.marcarComLlegit(chatId);
        }
      }
    });

    // ✅ AC #6: Escuchar eventos de teclado
    _repository.onUsuariEscrivint((userId, isTyping) {
      if (userId != currentUserId) {
        state = state.copyWith(isOtherTyping: isTyping);
      }
    });

    _repository.onXatSilenciat((xatIdSilenciat, silenciat) {});
  }

  Future<void> loadMoreMessages() async {
    if (!state.isLoadingMore && state.nextCursor != null) {
      try {
        state = state.copyWith(isLoadingMore: true);
        final result = await _repository.getMessages(chatId, limit: 50, cursor: state.nextCursor);

        state = state.copyWith(
          messages: [...result.messages, ...state.messages],
          nextCursor: result.nextCursor,
          isLoadingMore: false,
        );
      } catch (e) {
        state = state.copyWith(isLoadingMore: false);
      }
    }
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    if (!state.isSocketConnected || !_repository.isConnected) throw Exception('WebSocket desconectado.');
   
    // Emitimos al servidor
    _repository.sendMessage(chatId, text.trim());
  }

  // ✅ Emisor del evento Typing
  void notifyTyping(bool isTyping) {
    if (state.isSocketConnected && _repository.isConnected) {
      _repository.socketService.notifyTyping(chatId, isTyping: isTyping);
    }
  }

  Future<void> sendImage(String imagePath) async {
    if (!state.isSocketConnected || !_repository.isConnected) throw Exception('WebSocket desconectado.');
    await _repository.uploadImage(chatId, imagePath);
  }

  Future<void> sendActivityMessage(Activitat activitat) async {
    if (!state.isSocketConnected || !_repository.isConnected) throw Exception('WebSocket desconectado.');
    await _repository.shareActivity(chatId, activitat.id);
  }

  @override
  void dispose() {
    _repository.socketService.leaveXat(chatId);
    _listenersConfigured = false;
    super.dispose();
  }
}

final chatProvider = StateNotifierProvider.family<ChatNotifier, ChatMessagesState, String>((ref, chatId) {
  final repository = ref.watch(chatRepositoryProvider);
  final currentUserId = ref.watch(currentUserIdProvider);
  
  return ChatNotifier(chatId, currentUserId ?? '', repository);
});