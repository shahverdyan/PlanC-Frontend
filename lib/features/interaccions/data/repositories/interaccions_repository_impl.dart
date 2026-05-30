import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/comentari.dart';
import '../../domain/models/usuari_like.dart';
import '../../domain/repositories/interaccions_repository.dart';
import '../../../publicacions/domain/models/publicacio_detall.dart';

class InteraccionsRepositoryImpl implements InteraccionsRepository {
  final Dio _dio;
  final String? _usuariId;

  InteraccionsRepositoryImpl(this._dio, this._usuariId);

  // El backend requereix 'usuari-id' a totes les rutes d'interaccions.
  Options get _opts => Options(headers: {'usuari-id': ?_usuariId});

  // GET /publicacio/{id}
  @override
  Future<PublicacioDetall> fetchPublicacioDetall(String publicacioId) async {
    try {
      final response = await _dio.get(
        '/publicacio/$publicacioId',
        options: _opts,
      );
      // El backend retorna { success: true, data: { ... } }
      final wrapper = response.data as Map<String, dynamic>;
      final data = wrapper['data'] as Map<String, dynamic>;
      // DEBUG: log isLikedByMe-related fields to diagnose persistence issue
      debugPrint('[fetchDetall] keys: ${data.keys.where((k) => k.toLowerCase().contains('like') || k.toLowerCase().contains('agrada') || k.toLowerCase().contains('liked')).toList()}');
      debugPrint('[fetchDetall] isLikedByMe=${data['isLikedByMe']}  likedByMe=${data['likedByMe']}  liked=${data['liked']}  isMagrada=${data['isMagrada']}');
      return PublicacioDetall.fromJson(data);
    } on DioException catch (e) {
      throw Exception('Error de xarxa al obtenir la publicació: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperat al obtenir la publicació: $e');
    }
  }

  // GET /publicacio/{id}/comentaris
  @override
  Future<List<Comentari>> fetchComentaris(String publicacioId) async {
    try {
      final response = await _dio.get(
        '/publicacio/$publicacioId/comentaris',
        options: _opts,
      );
      final list = response.data as List<dynamic>;
      return list
          .map((e) => Comentari.fromJson(
                e as Map<String, dynamic>,
                publicacioId: publicacioId,
              ))
          .toList();
    } on DioException catch (e) {
      throw Exception('Error de xarxa al obtenir comentaris: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperat al obtenir comentaris: $e');
    }
  }

  // POST /publicacions/{id}/comentaris
  @override
  Future<void> enviarComentari(
    String publicacioId,
    String text, {
    String? comentariPareId,
  }) async {
    try {
      await _dio.post(
        '/publicacions/$publicacioId/comentaris',
        data: {
          'text': text,
          'comentariPareId': ?comentariPareId,
        },
        options: _opts,
      );
    } on DioException catch (e) {
      throw Exception('Error de xarxa al enviar el comentari: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperat al enviar el comentari: $e');
    }
  }

  // POST /publicacions/{id}/m-agrada  (toggle)
  @override
  Future<void> toggleMeGusta(String publicacioId) async {
    try {
      await _dio.post(
        '/publicacions/$publicacioId/m-agrada',
        options: _opts,
      );
    } on DioException catch (e) {
      throw Exception("Error de xarxa al fer m'agrada: ${e.message}");
    } catch (e) {
      throw Exception("Error inesperat al fer m'agrada: $e");
    }
  }

  // GET /publicacio/{id}/m-agrades  — llista d'usuaris que han donat m'agrada
  @override
  Future<List<UsuariLike>> fetchMeGustaList(String publicacioId) async {
    try {
      final response = await _dio.get(
        '/publicacio/$publicacioId/m-agrades',
        options: _opts,
      );
      final raw = response.data;
      debugPrint('[fetchMeGusta] type=${raw.runtimeType}  raw=$raw');

      // Suportem tots els formats habituals de resposta del backend
      List<dynamic> list = [];
      if (raw is List) {
        list = raw;
      } else if (raw is Map) {
        list = raw['data'] as List<dynamic>?
            ?? raw['likes'] as List<dynamic>?
            ?? raw['magrades'] as List<dynamic>?
            ?? raw['usuaris'] as List<dynamic>?
            ?? raw['users'] as List<dynamic>?
            ?? raw['items'] as List<dynamic>?
            ?? [];
      }

      debugPrint('[fetchMeGusta] parsed ${list.length} items');
      if (list.isNotEmpty) {
        debugPrint('[fetchMeGusta] first item: ${list.first}');
      }

      return list
          .map((e) => UsuariLike.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception("Error de xarxa al obtenir m'agrades: ${e.message}");
    } catch (e) {
      throw Exception("Error inesperat al obtenir m'agrades: $e");
    }
  }

  // GET /publicacio/{id}/guardat → {guardat: bool}
  @override
  Future<bool> checkPublicacioGuardada(String publicacioId) async {
    try {
      final response = await _dio.get(
        '/publicacio/$publicacioId/guardat',
        options: Options(headers: {
          'usuari-id': _usuariId,
          'id': publicacioId,
        }),
      );
      final raw = response.data;
      final data = (raw is Map && raw.containsKey('data')) ? raw['data'] : raw;
      if (data is Map) {
        final guardada = data['guardat'] ?? data['guardada'] ?? data['isGuardada'];
        if (guardada is bool) return guardada;
      }
      if (data is bool) return data;
      return false;
    } on DioException catch (e) {
      throw Exception('Error de xarxa al comprovar si la publicació és guardada: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperat al comprovar si la publicació és guardada: $e');
    }
  }

  // POST /publicacio/{id}/guardar → {guardada: bool}
  @override
  Future<bool> toggleGuardarPublicacio(String publicacioId) async {
    try {
      final response = await _dio.post(
        '/publicacio/$publicacioId/guardar',
        options: _opts,
      );
      final raw = response.data;
      final data = (raw is Map && raw.containsKey('data')) ? raw['data'] : raw;
      if (data is Map) {
        final guardada = data['guardada'] ?? data['isGuardada'];
        if (guardada is bool) return guardada;
      }
      throw Exception('Resposta inesperada del servidor: $raw');
    } on DioException catch (e) {
      throw Exception('Error de xarxa al guardar la publicació: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperat al guardar la publicació: $e');
    }
  }
}
