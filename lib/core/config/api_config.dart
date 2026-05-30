/// Configuración de la API del Backend (NestJS)
/// Definir URLs, endpoints y constantes globales
/// Documentación: FRONTEND_INTEGRACIO_XAT.md (actualizado 27/04/2026)
class ApiConfig {
  // 1. Dejamos la baseUrl y wsUrl limpias, apuntando a la raíz del servidor
  static const String baseUrl = 'https://planc-backend-aff2.onrender.com';
  static const String wsUrl = 'https://planc-backend-aff2.onrender.com';

  // ============================================
  // REST Endpoints (chat - xats) 
  // QUITAR EL /api QUE ESTABA PROVOCANDO EL 404
  // ============================================
  static const String xatsListaEndpoint = '/xats';
  static const String missatgesEndpoint = '/xats'; 
  static const String silenciarEndpoint = '/xats'; 
  static const String marcarLlegitEndpoint = '/xats'; 
  static const String imageUploadEndpoint = '/xats'; // POST /xats/:id/imatge
  static const String imageDownloadEndpoint = '/xats'; // GET /xats/:xatId/imatge/:missatgeId
  static const String activityPreviewEndpoint = '/activitats'; // GET /activitats/:id/preview

  // ============================================
  // REST Endpoints (chat management)
  // ============================================
  static const String hideXatEndpoint = '/xats'; // DELETE /xats/:id
  static const String leaveXatEndpoint = '/xats'; // DELETE /xats/:id/abandonar

  // WebSocket Namespace
  static const String socketNamespace = '/xat';

  // ============================================
  // Socket eventos (Servidor → Cliente, escucha)
  // ============================================
  static const String socketEventNouMissatge = 'nou-missatge';
  static const String socketEventUsuariEscrivint = 'usuari-escrivint';
  static const String socketEventXatSilenciat = 'xat-silenciat';

  // Eventos de conexión/desconexión
  static const String socketEventConnected = 'connect';
  static const String socketEventDisconnected = 'disconnect';
  static const String socketEventError = 'error';

  // ============================================
  // Socket eventos (Cliente → Servidor, emisión)
  // ============================================
  static const String socketEmitSendMissatge = 'send-missatge';
  static const String socketEmitJoinXat = 'join-xat';
  static const String socketEmitLeaveXat = 'leave-xat';
  static const String socketEmitTyping = 'typing';
  static const String socketEmitSendActivitat = 'send-activitat'; // NUEVO: compartir actividad
  static const String socketEmitJoinXatPrivat = 'join-xat-privat';

  // Timeouts
  static const Duration socketConnectTimeout = Duration(seconds: 10);
  static const Duration socketReconnectDelay = Duration(seconds: 3);
  static const Duration httpTimeout = Duration(seconds: 60);

  // Max reintentos de conexión WebSocket
  static const int maxReconnectAttempts = 5;

  // Límites de imagen
  static const int maxImageSizeMB = 10;
  static const List<String> allowedImageFormats = ['jpeg', 'png', 'gif', 'webp'];
}