import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:plan_c_frontend/features/amistats/data/models/amistat_model.dart';
import 'package:plan_c_frontend/features/amistats/domain/models/amistat.dart';
import 'package:plan_c_frontend/features/amistats/domain/repositories/amistats_repository.dart';

class AmistatsRepositoryImpl implements AmistatsRepository {
  final Dio dio;
  final String _baseUrl = 'https://planc-backend-aff2.onrender.com/amistats';
  final String _usuarisBaseUrl = 'https://planc-backend-aff2.onrender.com/usuari';

  AmistatsRepositoryImpl(this.dio);

  String _mapError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return 'No s\'ha pogut connectar amb el servidor. Revisa la teva connexió a internet.';
    }

    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map && data.containsKey('message')) {
        return data['message'].toString();
      }

      switch (e.response?.statusCode) {
        case 400:
          return 'Les dades són incorrectes. Revisa els camps.';
        case 401:
          return 'La teva sessió ha caducat. Torna a iniciar sessió.';
        case 403:
          return 'No tens permís per fer aquesta acció.';
        case 404:
          return 'No s\'ha trobat la informació al servidor.';
        case 409:
          return 'Ja existeix una amistat o hi ha un conflicte.';
        case 500:
          return 'Error intern del servidor de Backend.';
        case 503:
          return 'El servidor està en manteniment. Torna-ho a provar en uns minuts.';
        default:
          return 'Error inesperat (${e.response?.statusCode}).';
      }
    }

    return 'Ha sorgit un error desconegut.';
  }

  Future<String?> _fetchFotoPerfil(String id) async {
    try {
      final response = await dio.get('$_usuarisBaseUrl/$id/perfil');
      return response.data['fotoPerfil']?.toString();
    } catch (_) {
      return null;
    }
  }

  Future<List<SolicitudAmistat>> _enriquirAmbFotos(
    List<SolicitudAmistatModel> models,
  ) async {
    final fotos = await Future.wait(
      models.map((m) => m.fotoPerfil != null ? Future.value(m.fotoPerfil) : _fetchFotoPerfil(m.usuariId)),
    );
    return List.generate(
      models.length,
      (i) => SolicitudAmistatModel(
        usuariId: models[i].usuariId,
        nomUsuari: models[i].nomUsuari,
        fotoPerfil: fotos[i],
      ).toDomain(),
    );
  }

  @override
  Future<List<SolicitudAmistat>> obtenirAmistats({
    required String usuariId,
  }) async {
    try {
      final response = await dio.get(
        _baseUrl,
        options: Options(headers: {'usuari-id': usuariId}),
      );
      final models = (response.data as List)
          .map((a) => SolicitudAmistatModel.fromJson(a as Map<String, dynamic>))
          .toList();
      return _enriquirAmbFotos(models);
    } on DioException catch (e) {
      throw _mapError(e);
    } catch (e) {
      debugPrint('[AmistatsRepo] Error parsing obtenirAmistats: $e');
      throw 'Error processant la resposta del servidor.';
    }
  }

  @override
  Future<List<SolicitudAmistat>> obtenirAmistatsPendents({
    required String usuariId,
  }) async {
    try {
      final response = await dio.get(
        '$_baseUrl/solicituds',
        options: Options(headers: {'usuari-id': usuariId}),
      );

      final models = (response.data as List)
          .map((a) => SolicitudAmistatModel.fromJson(a as Map<String, dynamic>))
          .toList();
      return _enriquirAmbFotos(models);
    } on DioException catch (e) {
      throw _mapError(e);
    } catch (e) {
      debugPrint('[AmistatsRepo] Error parsing obtenirAmistatsPendents: $e');
      throw 'Error processant la resposta del servidor.';
    }
  }

  @override
  Future<List<SolicitudAmistat>> obtenirSolicitudsEnviades({
    required String usuariId,
  }) async {
    try {
      final response = await dio.get(
        '$_baseUrl/solicituds/enviades',
        options: Options(headers: {'usuari-id': usuariId}),
      );

      final models = (response.data as List)
          .map((a) => SolicitudAmistatModel.fromJson(a as Map<String, dynamic>))
          .toList();
      return _enriquirAmbFotos(models);
    } on DioException catch (e) {
      throw _mapError(e);
    } catch (e) {
      debugPrint('[AmistatsRepo] Error parsing obtenirSolicitudsEnviades: $e');
      throw 'Error processant la resposta del servidor.';
    }
  }

  @override
  Future<void> enviarSolicitud({
    required String usuariId,
    required String altreUsuariId,
  }) async {
    try {
      await dio.post(
        '$_baseUrl/$altreUsuariId/solicitud',
        data: {},
        options: Options(headers: {'usuari-id': usuariId}),
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> cancelarSolicitud({
    required String usuariId,
    required String altreUsuariId,
  }) async {
    try {
      await dio.delete(
        '$_baseUrl/$altreUsuariId/solicitud',
        options: Options(headers: {'usuari-id': usuariId}),
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> acceptarSolicitud({
    required String usuariId,
    required String altreUsuariId,
  }) async {
    try {
      await dio.post(
        '$_baseUrl/$altreUsuariId/acceptar',
        data: {},
        options: Options(headers: {'usuari-id': usuariId}),
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> rebutjarSolicitud({
    required String usuariId,
    required String altreUsuariId,
  }) async {
    try {
      await dio.post(
        '$_baseUrl/$altreUsuariId/rebutjar',
        data: {},
        options: Options(headers: {'usuari-id': usuariId}),
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> eliminarAmistat({
    required String usuariId,
    required String altreUsuariId,
  }) async {
    try {
      await dio.delete(
        '$_baseUrl/$altreUsuariId',
        options: Options(headers: {'usuari-id': usuariId}),
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }
}