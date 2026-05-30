import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plan_c_frontend/core/config/api_config.dart';
import 'package:plan_c_frontend/core/models/api_models.dart';
import 'package:plan_c_frontend/core/services/socket_service.dart';
import 'package:plan_c_frontend/features/chat/data/models/chat_local_model.dart';
import 'package:plan_c_frontend/features/chat/domain/models/message.dart';

class ChatRepository {
  final Dio _dio;
  final SocketService _socketService;

  ChatRepository({
    Dio? dio,
    SocketService? socketService,
  })  : _dio = dio ?? _createDio(),
        _socketService = socketService ?? SocketService();

  static Dio _createDio() {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.httpTimeout,
      receiveTimeout: ApiConfig.httpTimeout,
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          const storage = FlutterSecureStorage();
          var token = await storage.read(key: 'auth_token');

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          } else {
            debugPrint('❌ [INTERCEPTOR] CRÍTICO: La petición a ${options.path} saldrá SIN TOKEN');
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          debugPrint('❌ Error de Dio en ${e.requestOptions.path}: ${e.response?.statusCode}');
          return handler.next(e);
        }
      ),
    );

    return dio;
  }

  Future<void> connect({String? userId, String? token}) async {
    try {
      final finalToken = token ?? await const FlutterSecureStorage().read(key: 'auth_token');
      if (finalToken == null || finalToken.isEmpty) return;

      _dio.options.headers['Authorization'] = 'Bearer $finalToken';
      await _socketService.connect(token: finalToken);
    } catch (e) {
      debugPrint('❌ Error conectando ChatRepository: $e');
    }
  }

  void disconnect() {
    _socketService.disconnect();
  }

  Future<List<ChatLocalModel>> getAllXats() async {
    try {
      final response = await _dio.get(ApiConfig.xatsListaEndpoint);
      if (response.data == null) return [];

      final List<dynamic> dataList = response.data as List<dynamic>;

      final chatModels = dataList.map((json) {
        final xat = XatDTO.fromJson(json as Map<String, dynamic>);
        final now = DateTime.now();
        final lastMessageDate = xat.dataUltimMissatge?.toLocal() ?? now;
        final difference = now.difference(lastMessageDate);

        String timeString = '';
        if (difference.inMinutes < 1) {
          timeString = 'Ara';
        } else if (difference.inMinutes < 60) {
          timeString = '${difference.inMinutes}m';
        } else if (difference.inHours < 24) {
          timeString = '${difference.inHours}h';
        } else {
          timeString = '${difference.inDays}d';
        }

        return ChatLocalModel(
          id: xat.id,
          name: xat.nom,
          lastMessage: xat.ultimMissatge ?? '',
          time: timeString,
          unread: xat.missatgesNoLlegits,
          isMuted: xat.teSilenciat,
          photoUrl: xat.fotoGrup,
          isActive: xat.actiu,
          createdAt: DateTime.now(),
          updatedAt: lastMessageDate,
          type: xat.tipus,
          members: xat.membres.map((m) => {
            'id': m.id,
            'name': m.nomUsuari,
            'photoUrl': m.fotoPerfil,
          }).toList(),
          quedadaId: xat.quedadaId,
        );
      }).toList();

      chatModels.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return chatModels;
    } catch (e) {
      debugPrint('❌ Error obtenint xats: $e');
      rethrow;
    }
  }

  Future<ChatLocalModel?> getXatById(String xatId) async {
    try {
      final response = await _dio.get('${ApiConfig.xatsListaEndpoint}/$xatId');
      final xat = XatDTO.fromJson(response.data as Map<String, dynamic>);

      return ChatLocalModel(
        id: xat.id,
        name: xat.nom,
        lastMessage: xat.ultimMissatge ?? '',
        time: 'Ara',
        unread: xat.missatgesNoLlegits,
        isMuted: xat.teSilenciat,
        photoUrl: xat.fotoGrup,
        isActive: xat.actiu,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        type: xat.tipus,
        members: xat.membres.map((m) => {
          'id': m.id,
          'name': m.nomUsuari,
          'photoUrl': m.fotoPerfil,
        }).toList(),
        quedadaId: xat.quedadaId,
      );
    } catch (e) {
      return null;
    }
  }

  Future<({List<Message> messages, String? nextCursor})> getMessages(
    String xatId, {
    int limit = 50,
    String? cursor,
  }) async {
    try {
      final response = await _dio.get('${ApiConfig.missatgesEndpoint}/$xatId/missatges', queryParameters: {'limit': limit, 'cursor': cursor});
      final missatgesRes = MissatgesResponse.fromJson(response.data as Map<String, dynamic>);
      
      final messages = missatgesRes.data.map((dto) => _convertDTOToMessage(dto)).toList();
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      return (messages: messages, nextCursor: missatgesRes.nextCursor);
    } catch (e) {
      debugPrint('❌ Error obtenint missatges: $e');
      return (messages: <Message>[], nextCursor: null);
    }
  }

  void sendMessage(String xatId, String text) {
    if (_socketService.isConnected) {
      _socketService.sendMissatge(xatId, text);
    } else {
      throw Exception('WebSocket desconectado');
    }
  }

  /// Obre (o crea si no existia) un xat privat amb [altreUsuariId].
  /// Retorna el xatId del xat resultant.
  Future<String> obrirXatPrivat(String altreUsuariId) {
    return _socketService.joinXatPrivat(altreUsuariId);
  }

  Future<void> toggleSilenciarXat(String xatId, bool silenciat) async {
    try {
      final request = SilenciarXatRequest(silenciat: silenciat);
      await _dio.patch('${ApiConfig.silenciarEndpoint}/$xatId/silenciar', data: request.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> marcarComLlegit(String xatId) async {
    try {
      await _dio.post('${ApiConfig.marcarLlegitEndpoint}/$xatId/llegit');
    } catch (e) {
      debugPrint('⚠️ Error marcant llegit: $e');
    }
  }

  Future<void> deleteXat(String xatId) async {
    try {
      await _dio.delete('${ApiConfig.xatsListaEndpoint}/$xatId');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> hideXat(String xatId) async {
    try {
      await _dio.delete('${ApiConfig.hideXatEndpoint}/$xatId');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> abandonXat(String xatId) async {
    try {
      await _dio.delete('${ApiConfig.leaveXatEndpoint}/$xatId/abandonar');
    } catch (e) {
      rethrow;
    }
  }

  Future<Message?> uploadImage(String xatId, String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'imatge': await MultipartFile.fromFile(imagePath),
      });
      final response = await _dio.post('${ApiConfig.imageUploadEndpoint}/$xatId/imatge', data: formData);
      return _convertDTOToMessage(MissatgeDTO.fromJson(response.data as Map<String, dynamic>));
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getSecureImageUrl(String xatId, String missatgeId) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.imageDownloadEndpoint}/$xatId/imatge/$missatgeId',
        options: Options(followRedirects: true, validateStatus: (status) => status != null && status < 400),
      );
      return response.realUri.toString();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> shareActivity(String xatId, String activitatId) async {
    if (!_socketService.isConnected) throw Exception('❌ WebSocket no conectado.');
    try {
      _socketService.sendActivitat(xatId, activitatId);
    } catch (e) {
      rethrow;
    }
  }

  void onNouMissatge(Function(Message) callback) {
    _socketService.on(ApiConfig.socketEventNouMissatge, (data) {
      try {
        Map<String, dynamic> jsonData;
        if (data is List) {
          if (data.isEmpty) return;
          jsonData = data.first as Map<String, dynamic>;
        } else if (data is Map) {
          jsonData = data as Map<String, dynamic>;
        } else {
          return;
        }

        final dto = MissatgeDTO.fromJson(jsonData);
        final message = _convertDTOToMessage(dto);
        callback(message);
      } catch (e) {
        debugPrint('⚠️ Error processant onNouMissatge: $e'); // SOLUCIONADO EL ERROR DE CATCH VACÍO
      }
    });
  }

  void onUsuariEscrivint(Function(String userId, bool isTyping) callback) {
    _socketService.on(ApiConfig.socketEventUsuariEscrivint, (data) {
      try {
        final Map<String, dynamic> jsonData = (data is List) ? data.first as Map<String, dynamic> : data as Map<String, dynamic>;
        final userId = jsonData['userId'] as String?;
        final isTyping = jsonData['isTyping'] as bool?;
        if (userId != null && isTyping != null) {
          callback(userId, isTyping);
        }
      } catch (e) {
        debugPrint('⚠️ Error processant onUsuariEscrivint: $e'); // SOLUCIONADO EL ERROR DE CATCH VACÍO
      }
    });
  }

  void onXatSilenciat(Function(String xatId, bool silenciat) callback) {
    _socketService.on(ApiConfig.socketEventXatSilenciat, (data) {
      try {
        final Map<String, dynamic> jsonData = (data is List) ? data.first as Map<String, dynamic> : data as Map<String, dynamic>;
        final xatId = jsonData['xatId'] as String?;
        final silenciat = jsonData['teSilenciat'] as bool?;
        if (xatId != null && silenciat != null) {
          callback(xatId, silenciat);
        }
      } catch (e) {
        debugPrint('⚠️ Error processant onXatSilenciat: $e'); // SOLUCIONADO EL ERROR DE CATCH VACÍO
      }
    });
  }

  Message _convertDTOToMessage(MissatgeDTO dto) {
    final messageType = switch (dto.tipusContingut) {
      'IMATGE' => MessageType.image,
      'ACTIVITAT_COMPARTIDA' => MessageType.activity,
      'SISTEMA' => MessageType.system,
      _ => MessageType.text,
    };

    String? finalImageUrl;
    if (messageType == MessageType.image) {
      finalImageUrl = '${ApiConfig.baseUrl}${ApiConfig.imageDownloadEndpoint}/${dto.xatId}/imatge/${dto.id}';
    }

    Map<String, dynamic>? activityData;
    if (dto.activitatCompartida != null) {
      final act = dto.activitatCompartida!;
      activityData = {
        'id': act.id,
        'titol': act.titol,
        'descripcio': act.descripcio,
        'categoria': act.categoria.nom,
        'nomEspai': act.espai.nom,
        'dataInici': act.dataInici.toIso8601String(),
        'dataFi': act.dataFi.toIso8601String(),
        'lat': act.latitud,
        'lng': act.longitud,
        'urlEntrades': act.enlaces,
      };
    }

    return Message(
      id: dto.id,
      senderId: dto.emissorId,
      senderName: dto.emissor.nomUsuari,
      senderAvatar: dto.emissor.fotoPerfil,
      type: messageType,
      text: dto.text,
      imageUrl: finalImageUrl,
      activityData: activityData,
      timestamp: dto.dataEnviament.toLocal(),
      chatId: dto.xatId,
    );
  }

  bool get isConnected => _socketService.isConnected;
  SocketService get socketService => _socketService;
}