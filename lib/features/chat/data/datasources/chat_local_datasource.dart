import 'package:plan_c_frontend/features/chat/data/models/chat_local_model.dart';

/// Datasource local para Chat
/// Simula llamadas a la API (Supabase/NestJS)
/// En el futuro, reemplazar con llamadas HTTP reales
class ChatLocalDatasource {
  // Simulación de base de datos local
  static final Map<String, ChatLocalModel> _localChats = {
    'chat_1': ChatLocalModel(
      id: 'chat_1',
      name: 'Visita al Museu Picasso',
      lastMessage: 'Izan: Algú sap si cal portar l\'entrada impresa?',
      time: '10:42',
      unread: 2,
      isMuted: false,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now(),
    ),
    'chat_2': ChatLocalModel(
      id: 'chat_2',
      name: 'Concert de Jazz al Palau',
      lastMessage: 'Roger: Ens veiem a la porta en 10 minuts!',
      time: 'Ahir',
      unread: 0,
      isMuted: false,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now(),
    ),
    'chat_3': ChatLocalModel(
      id: 'chat_3',
      name: 'Fira del Llibre',
      lastMessage: 'Naia ha compartit una imatge.',
      time: 'Dimarts',
      unread: 0,
      isMuted: false,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now(),
    ),
    'chat_4': ChatLocalModel(
      id: 'chat_4',
      name: 'Quedada Amics Gràcia',
      lastMessage: 'Esperant respostes...',
      time: 'Divendres',
      unread: 1,
      isMuted: false,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now(),
    ),
  };

  /// Obtener todos los chats
  Future<List<ChatLocalModel>> getAllChats() async {
    // Simular latencia de red
    await Future.delayed(const Duration(milliseconds: 300));
    return _localChats.values.toList();
  }

  /// Obtener un chat por ID
  Future<ChatLocalModel?> getChatById(String chatId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _localChats[chatId];
  }

  /// Silenciar/dessilenciar un chat
  Future<void> toggleMutedChat(String chatId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    
    if (_localChats.containsKey(chatId)) {
      final chat = _localChats[chatId]!;
      _localChats[chatId] = chat.copyWith(
        isMuted: !chat.isMuted,
        updatedAt: DateTime.now(),
      );
    } else {
      throw Exception('Chat no encontrado: $chatId');
    }
  }

  /// Eliminar un chat
  Future<void> deleteChat(String chatId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (_localChats.containsKey(chatId)) {
      _localChats.remove(chatId);
    } else {
      throw Exception('Chat no encontrado: $chatId');
    }
  }

  /// Actualizar último mensaje de un chat
  Future<void> updateLastMessage(String chatId, String lastMessage) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (_localChats.containsKey(chatId)) {
      final chat = _localChats[chatId]!;
      _localChats[chatId] = chat.copyWith(
        lastMessage: lastMessage,
        time: _formatTime(DateTime.now()),
        updatedAt: DateTime.now(),
      );
    } else {
      throw Exception('Chat no encontrado: $chatId');
    }
  }

  /// Helper para formatear tiempo
  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'Ara';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m';
    if (difference.inHours < 24) return '${difference.inHours}h';
    if (difference.inDays < 7) return '${difference.inDays}d';

    return '${dateTime.day}/${dateTime.month}';
  }

  /// Reiniciar datasource (para testing)
  void reset() {
    _localChats.clear();
    _localChats.addAll({
      'chat_1': ChatLocalModel(
        id: 'chat_1',
        name: 'Visita al Museu Picasso',
        lastMessage: 'Izan: Algú sap si cal portar l\'entrada impresa?',
        time: '10:42',
        unread: 2,
        isMuted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now(),
      ),
      'chat_2': ChatLocalModel(
        id: 'chat_2',
        name: 'Concert de Jazz al Palau',
        lastMessage: 'Roger: Ens veiem a la porta en 10 minuts!',
        time: 'Ahir',
        unread: 0,
        isMuted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now(),
      ),
      'chat_3': ChatLocalModel(
        id: 'chat_3',
        name: 'Fira del Llibre',
        lastMessage: 'Naia ha compartit una imatge.',
        time: 'Dimarts',
        unread: 0,
        isMuted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now(),
      ),
      'chat_4': ChatLocalModel(
        id: 'chat_4',
        name: 'Quedada Amics Gràcia',
        lastMessage: 'Esperant respostes...',
        time: 'Divendres',
        unread: 1,
        isMuted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
      ),
    });
  }
}
