import 'dart:async';
import 'dart:developer' as dev;
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/foundation.dart';
import 'package:plan_c_frontend/core/config/api_config.dart';

/// Servicio de WebSocket para comunicación en tiempo real
class SocketService {
  static final SocketService _instance = SocketService._internal();

  late io.Socket _socket;
  bool _isConnected = false;

  final Map<String, List<Function>> _listeners = {};

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  io.Socket get socket => _socket;
  bool get isConnected => _isConnected && _socket.connected;

  /// Conecta y ESPERA a que la conexión se establezca firmemente
  Future<void> connect({String? token}) async {
    if (isConnected) return;

    final completer = Completer<void>();

    try {
      // ✅ LA SOLUCIÓN: Conectamos obligatoriamente al Namespace '/xat' del backend
      String wsUrl = ApiConfig.wsUrl;
      if (!wsUrl.endsWith('/xat')) {
        wsUrl = '$wsUrl/xat';
      }

      _socket = io.io(
        wsUrl,
        {
          'transports': ['websocket'], 
          'autoConnect': false,
          'reconnection': true,
          'reconnectionDelay': ApiConfig.socketReconnectDelay.inMilliseconds,
          'reconnectionDelayMax': 5000,
          'reconnectionAttempts': ApiConfig.maxReconnectAttempts,
          'auth': token != null ? {
            'token': token,
            'Authorization': 'Bearer $token',
          } : {},
          'extraHeaders': token != null ? {
            'Authorization': 'Bearer $token',
          } : {},
        },
      );

      _socket.onConnect((_) {
        _isConnected = true;
        _emitEvent('connected', null);
        debugPrint('✅ [SOCKET] WebSocket conectado a NestJS (Namespace /xat)');
        if (!completer.isCompleted) completer.complete();
      });

      _socket.onDisconnect((_) {
        _isConnected = false;
        _emitEvent('disconnected', null);
        debugPrint('❌ [SOCKET] WebSocket desconectado');
      });

      _socket.onConnectError((data) {
        debugPrint('⚠️ [SOCKET] Error de conexión: $data');
        if (!completer.isCompleted) completer.completeError('Error de conexión socket');
      });

      _socket.onError((data) {
        debugPrint('❌ [SOCKET] Error crudo: $data');
      });

      _socket.onAny((event, data) {
        debugPrint('🌐 [SOCKET ANY] Evento recibido: $event | Payload: $data');
      });

      _setupServerListeners();
      
      debugPrint('🔄 [SOCKET] Iniciando handshake con el servidor en $wsUrl...');
      _socket.connect();

      await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          if (!completer.isCompleted) {
            completer.completeError(Exception('Timeout al conectar WebSocket'));
          }
        },
      );
    } catch (e) {
      debugPrint('❌ [SOCKET] Error crítico en connect: $e');
      rethrow;
    }
  }

  void disconnect() {
    if (_socket.connected) {
      _socket.disconnect();
      _isConnected = false;
      debugPrint('🔌 [SOCKET] WebSocket desconectado manualmente');
    }
  }

  void _setupServerListeners() {
    debugPrint('🎧 [SOCKET] Registrando listeners de eventos del servidor...');
    
    _socket.on(ApiConfig.socketEventNouMissatge, (data) {
      debugPrint('📨 [SOCKET-EVENT] nou-missatge recibido: $data');
      _emitEvent(ApiConfig.socketEventNouMissatge, data);
    });

    _socket.on(ApiConfig.socketEventUsuariEscrivint, (data) {
      debugPrint('✍️ [SOCKET-EVENT] usuari-escrivint recibido: $data');
      _emitEvent(ApiConfig.socketEventUsuariEscrivint, data);
    });

    _socket.on(ApiConfig.socketEventXatSilenciat, (data) {
      debugPrint('🔇 [SOCKET-EVENT] xat-silenciat recibido: $data');
      _emitEvent(ApiConfig.socketEventXatSilenciat, data);
    });
    
    debugPrint('✅ [SOCKET] Listeners registrados exitosamente');
  }

  void on(String event, Function callback) {
    if (!_listeners.containsKey(event)) {
      _listeners[event] = [];
    }
    _listeners[event]!.add(callback);
  }

  void off(String event, Function? callback) {
    if (callback == null) {
      _listeners.remove(event);
    } else {
      _listeners[event]?.remove(callback);
    }
  }

  void _emitEvent(String event, dynamic data) {
    if (_listeners.containsKey(event)) {
      for (var callback in _listeners[event]!) {
        callback(data);
      }
    }
  }

  void emit(String event, dynamic data) {
    if (isConnected) {
      _socket.emit(event, data);
    }
  }

  void joinXat(String xatId) {
    final payload = {'xatId': xatId};
    if (isConnected) {
      _socket.emitWithAck(ApiConfig.socketEmitJoinXat, payload, ack: (response) {
        debugPrint('🚨 [ACK DEL SERVIDOR -> JOIN]: $response');
      });
      debugPrint('👋 Emitiendo join-xat: $payload');
    }
  }

  void leaveXat(String xatId) {
    emit(ApiConfig.socketEmitLeaveXat, {'xatId': xatId});
  }

  void sendMissatge(String xatId, String text) {
    final payload = {
      'xatId': xatId,
      'text': text,
    };
    
    if (isConnected) {
      _socket.emitWithAck(ApiConfig.socketEmitSendMissatge, payload, ack: (response) {
        debugPrint('🚨 [ACK DEL SERVIDOR -> SEND MISSATGE]: $response');
      });
      debugPrint('💬 Emitiendo send-missatge: $payload');
    }
  }

  void notifyTyping(String xatId, {bool isTyping = true}) {
    emit(ApiConfig.socketEmitTyping, {'xatId': xatId, 'isTyping': isTyping});
  }

  /// Emet [join-xat-privat] i retorna el xatId creat/recuperat.
  /// Llança una excepció amb el missatge d'error si el backend rebutja la petició.
  Future<String> joinXatPrivat(String altreUsuariId) {
    final completer = Completer<String>();
    _socket.emitWithAck(
      ApiConfig.socketEmitJoinXatPrivat,
      {'altreUsuariId': altreUsuariId},
      ack: (response) {
        dev.log('[SOCKET] join-xat-privat ack: $response');
        if (response is Map && response['ok'] == true) {
          completer.complete(response['xatId'] as String);
        } else {
          final msg = response is Map
              ? (response['error']?.toString() ?? 'Error desconegut')
              : 'Error desconegut';
          completer.completeError(Exception(msg));
        }
      },
    );
    return completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw Exception('Temps d\'espera superat obrint el xat'),
    );
  }

  void sendActivitat(String xatId, String activitatId) {
    final payload = {
      'xatId': xatId,
      'activitatId': activitatId,
    };

    if (isConnected) {
      _socket.emitWithAck(ApiConfig.socketEmitSendActivitat, payload, ack: (response) {
        debugPrint('🚨 [ACK DEL SERVIDOR -> SEND ACTIVITAT]: $response');
      });
      debugPrint('🎯 Emitiendo send-activitat: $payload');
    }
  }
}