import 'package:intl/intl.dart';

// Definimos los tipos de mensaje que soporta la aplicación
enum MessageType { text, image, activity, system }

class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final MessageType type;
  final String text; // Contenido del mensaje
  final String? imageUrl; // URL de la imagen si type == image
  final Map<String, dynamic>? activityData; // Datos de actividad si type == activity
  final DateTime timestamp;
  final String chatId; // ID del xat

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.type,
    required this.text,
    this.imageUrl,
    this.activityData,
    required this.timestamp,
    required this.chatId,
  });

  /// Convertir de JSON - Soporte para múltiples formatos
  factory Message.fromJson(Map<String, dynamic> json) {
    // Detectar tipo de mensaje
    final tipusContingut = json['tipusContingut'] as String? ?? 'TEXT';
    final messageType = switch (tipusContingut) {
      'IMATGE' => MessageType.image,
      'ACTIVITAT_COMPARTIDA' => MessageType.activity,
      'SISTEMA' => MessageType.system,
      _ => MessageType.text,
    };

    // Parsear emisor (puede venir anidado)
    String senderName = 'Usuario';
    String? senderAvatar;
    if (json['emissor'] != null && json['emissor'] is Map<String, dynamic>) {
      final emissor = json['emissor'] as Map<String, dynamic>;
      senderName = emissor['nomUsuari'] as String? ?? 'Usuario';
      senderAvatar = emissor['fotoPerfil'] as String?;
    } else {
      senderName = json['senderName'] as String? ?? json['sender_name'] as String? ?? 'Usuario';
      senderAvatar = json['senderAvatar'] as String? ?? json['sender_avatar'] as String?;
    }

    // Parsear actividad compartida
    Map<String, dynamic>? activityData;
    if (json['activitatCompartida'] != null && json['activitatCompartida'] is Map<String, dynamic>) {
      final activitat = json['activitatCompartida'] as Map<String, dynamic>;
      activityData = {
        'id': activitat['id'],
        'titol': activitat['titol'],
        'descripcio': activitat['descripcio'],
        'categoria': activitat['categoria']?['nom'] ?? '',
        'nomEspai': activitat['espai']?['nom'] ?? '',
        'dataInici': activitat['dataInici'],
        'dataFi': activitat['dataFi'],
        'lat': activitat['latitud'],
        'lng': activitat['longitud'],
        'urlEntrades': activitat['enlaces'] ?? '',
      };
    }

    return Message(
      id: json['id'] as String,
      senderId: json['emissorId'] as String? ?? json['senderId'] as String? ?? json['sender_id'] as String? ?? '',
      senderName: senderName,
      senderAvatar: senderAvatar,
      type: messageType,
      text: json['text'] as String? ?? json['content'] as String? ?? '',
      imageUrl: json['urlImatge'] as String? ?? json['imageUrl'] as String? ?? json['image_url'] as String?,
      activityData: activityData ?? json['activityData'] as Map<String, dynamic>? ?? json['activity_data'] as Map<String, dynamic>?,
      timestamp: json['dataEnviament'] != null
          ? DateTime.parse(json['dataEnviament'] as String)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : json['created_at'] != null
                  ? DateTime.parse(json['created_at'] as String)
                  : DateTime.now(),
      chatId: json['xatId'] as String? ?? json['chatId'] as String? ?? json['chat_id'] as String? ?? '',
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emissorId': senderId,
      'nomUsuari': senderName,
      'tipusContingut': switch (type) {
        MessageType.image => 'IMATGE',
        MessageType.system => 'SISTEMA',
        MessageType.activity => 'ACTIVITAT_COMPARTIDA',
        _ => 'TEXT',
      },
      'text': text,
      'urlImatge': imageUrl,
      'dataEnviament': timestamp.toIso8601String(),
      'xatId': chatId,
    };
  }

  /// Copiar con cambios
  Message copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    MessageType? type,
    String? text,
    String? imageUrl,
    Map<String, dynamic>? activityData,
    DateTime? timestamp,
    String? chatId,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      type: type ?? this.type,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      activityData: activityData ?? this.activityData,
      timestamp: timestamp ?? this.timestamp,
      chatId: chatId ?? this.chatId,
    );
  }

  /// Verificar si el mensaje es mío
  bool isMe(String currentUserId) => senderId == currentUserId;

  /// Obtener hora formateada
  String get formattedTime => DateFormat('HH:mm').format(timestamp);

  /// Obtener fecha formateada completa
  String get formattedDate => DateFormat('dd MMM, HH:mm').format(timestamp);
}