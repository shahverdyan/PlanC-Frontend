// Modelo de datos local para Chat
// Este modelo se usa en la capa Data/Datasource
// En el futuro, se parseará desde JSON de Supabase/NestJS

class ChatLocalModel {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unread;
  final bool isMuted;
  final String? photoUrl; 
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final String type; // ✅ AÑADIDO: Tipo de chat
  final List<Map<String, dynamic>> members; // ✅ AÑADIDO: Lista de miembros
  final String? quedadaId;

  ChatLocalModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unread,
    this.isMuted = false,
    this.photoUrl,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.type = 'INDIVIDUAL',
    this.members = const [],
    this.quedadaId,
  });

  // Conversion a JSON para simular API
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'lastMessage': lastMessage,
    'time': time,
    'unread': unread,
    'isMuted': isMuted,
    'photoUrl': photoUrl,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'type': type,
    'members': members,
    'quedadaId': quedadaId,
  };

  // Parsing desde JSON
  factory ChatLocalModel.fromJson(Map<String, dynamic> json) => ChatLocalModel(
    id: json['id'] as String,
    name: json['name'] as String,
    lastMessage: json['lastMessage'] as String,
    time: json['time'] as String,
    unread: json['unread'] as int? ?? 0,
    isMuted: json['isMuted'] as bool? ?? false,
    photoUrl: json['photoUrl'] as String?,
    isActive: json['isActive'] as bool? ?? true,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    type: json['type'] as String? ?? 'INDIVIDUAL',
    members: List<Map<String, dynamic>>.from(json['members'] ?? []),
    quedadaId: json['quedadaId'] as String?,
  );

  // Copy con cambios
  ChatLocalModel copyWith({
    String? id,
    String? name,
    String? lastMessage,
    String? time,
    int? unread,
    bool? isMuted,
    String? photoUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? type,
    List<Map<String, dynamic>>? members,
    String? quedadaId,
  }) =>
      ChatLocalModel(
        id: id ?? this.id,
        name: name ?? this.name,
        lastMessage: lastMessage ?? this.lastMessage,
        time: time ?? this.time,
        unread: unread ?? this.unread,
        isMuted: isMuted ?? this.isMuted,
        photoUrl: photoUrl ?? this.photoUrl,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        type: type ?? this.type,
        members: members ?? this.members,
        quedadaId: quedadaId ?? this.quedadaId,
      );
}