import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/models/post.dart';

class PublicacioRepository {
  final Dio _dio;
  final String? _usuariId;

  PublicacioRepository(this._dio, this._usuariId);

  /// GET /publicacio/feed → { success, data: [...], meta }
  Future<List<Post>> fetchFeed({int skip = 0, int take = 10}) async {
    try {
      final response = await _dio.get(
        '/publicacio/feed',
        queryParameters: {'skip': skip, 'take': take},
      );
      final wrapper = response.data as Map<String, dynamic>;
      final list = wrapper['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Error de xarxa al obtenir el feed: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperat al obtenir el feed: $e');
    }
  }

  /// POST /publicacio (multipart)
  /// Requereix que l'usuari estigui apuntat a una quedada de l'activitat indicada.
  Future<void> createPublicacio({
    required String textDescripcio,
    required String activitatId,
    XFile? imatge,
  }) async {
    try {
      final map = <String, dynamic>{
        'textDescripcio': textDescripcio,
        'activitatId': activitatId,
      };
      if (imatge != null) {
        map['fitxers'] = await MultipartFile.fromFile(
          imatge.path,
          filename: imatge.name,
        );
      }
      final formData = FormData.fromMap(map);
      await _dio.post(
        '/publicacio',
        data: formData,
        options: Options(
          headers: {
            'usuari-id': _usuariId,
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
    } on DioException catch (e) {
      throw Exception('Error de xarxa al crear la publicació: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperat al crear la publicació: $e');
    }
  }
}
