import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:plan_c_frontend/features/notificacions/domain/models/notificacio.dart';

class NotificacionsRepository {
  final Dio _dio;
  static const _baseUrl = 'https://planc-backend-aff2.onrender.com/notificacions';

  NotificacionsRepository(this._dio);

  Future<List<Notificacio>> obtenirNotificacions({required String usuariId}) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        options: Options(headers: {'usuari-id': usuariId}),
      );
      final list = (response.data as Map<String, dynamic>)['notificacions'] as List;
      final notificacions = list
          .map((e) => Notificacio.fromJson(e as Map<String, dynamic>))
          .toList();
      notificacions.sort((a, b) => b.dataCreacio.compareTo(a.dataCreacio));
      return notificacions;
    } on DioException catch (e) {
      debugPrint('[NotificacionsRepo] obtenirNotificacions error: $e');
      throw 'No s\'han pogut carregar les notificacions.';
    }
  }

  Future<bool> teNoLlegides({required String usuariId}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/te-no-llegides',
        options: Options(headers: {'usuari-id': usuariId}),
      );
      return response.data['teNoLlegides'] as bool;
    } on DioException catch (e) {
      debugPrint('[NotificacionsRepo] teNoLlegides error: $e');
      return false;
    }
  }

  Future<void> marcarLlegides({required String usuariId}) async {
    try {
      await _dio.patch(
        '$_baseUrl/marcar-llegides',
        options: Options(headers: {'usuari-id': usuariId}),
      );
    } on DioException catch (e) {
      debugPrint('[NotificacionsRepo] marcarLlegides error: $e');
    }
  }
}
