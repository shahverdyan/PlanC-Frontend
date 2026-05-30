import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

/// Widget para mostrar imágenes seguras del chat
/// 
/// Las imágenes en los chats privados están en un bucket privado de Supabase.
/// Este widget obtiene una URL firmada temporal (1 hora) usando el token JWT
/// del usuario autenticado.
/// 
/// Uso:
/// ```dart
/// SecureImageWidget(
///   xatId: 'chat-uuid',
///   missatgeId: 'message-uuid',
///   token: userToken,
///   baseUrl: 'https://backend-url',
///   width: 200,
///   height: 200,
/// )
/// ```
class SecureImageWidget extends StatefulWidget {
  final String xatId;
  final String missatgeId;
  final String token;
  final String baseUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Duration cacheTime;

  const SecureImageWidget({
    super.key,
    required this.xatId,
    required this.missatgeId,
    required this.token,
    required this.baseUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.cacheTime = const Duration(minutes: 50), // URL vàlida 1 hora
  });

  @override
  State<SecureImageWidget> createState() => _SecureImageWidgetState();
}

class _SecureImageWidgetState extends State<SecureImageWidget> {
  late Future<String> _imageUrlFuture;
  late Dio _dio;

  @override
  void initState() {
    super.initState();
    _initDio();
    _imageUrlFuture = _getSecureImageUrl();
  }

  void _initDio() {
    _dio = Dio(BaseOptions(
      baseUrl: widget.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    ));
  }

  /// Obtener la URL firmada de la imagen desde el backend
  /// GET /api/xats/:xatId/imatge/:missatgeId → 302 Redirect
  Future<String> _getSecureImageUrl() async {
    try {
      debugPrint('🔐 Obtenint URL segura per a imatge de xat ${widget.xatId}...');

      final response = await _dio.get(
        '/api/xats/${widget.xatId}/imatge/${widget.missatgeId}',
        options: Options(
          followRedirects: true,
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      final imageUrl = response.realUri.toString();
      debugPrint('✅ URL obtinguda: ${imageUrl.substring(0, 60)}...');
      return imageUrl;
    } on DioException catch (e) {
      debugPrint('❌ Error obtenint URL d\'imatge: ${e.message}');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _imageUrlFuture,
      builder: (context, snapshot) {
        // Esperando la URL
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: widget.width,
            height: widget.height,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        // Error obteniendo URL
        if (snapshot.hasError) {
          return Container(
            width: widget.width,
            height: widget.height,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.secureImageLoadError,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        }

        // URL obtenida correctamente
        if (snapshot.hasData) {
          return Image.network(
            snapshot.data!,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                width: widget.width,
                height: widget.height,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: widget.width,
                height: widget.height,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Center(
                  child: Icon(Icons.broken_image, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  @override
  void dispose() {
    _dio.close();
    super.dispose();
  }
}

/// Widget alternativo: Mostrar imagen con botón de descargar
/// 
/// Incluye opciones para descargar, compartir o copiar la imagen
class SecureImageWithActions extends StatefulWidget {
  final String xatId;
  final String missatgeId;
  final String token;
  final String baseUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final VoidCallback? onDownload;

  const SecureImageWithActions({
    super.key,
    required this.xatId,
    required this.missatgeId,
    required this.token,
    required this.baseUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.onDownload,
  });

  @override
  State<SecureImageWithActions> createState() => _SecureImageWithActionsState();
}

class _SecureImageWithActionsState extends State<SecureImageWithActions> {
  bool _showActions = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _showActions = !_showActions);
      },
      child: Stack(
        children: [
          // Imagen segura
          SecureImageWidget(
            xatId: widget.xatId,
            missatgeId: widget.missatgeId,
            token: widget.token,
            baseUrl: widget.baseUrl,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
          ),

          // Overlay con acciones (opcional)
          if (_showActions)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.download, color: Colors.white),
                    onPressed: widget.onDownload ?? () {},
                    tooltip: AppLocalizations.of(context)!.secureImageDownloadTooltip,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}