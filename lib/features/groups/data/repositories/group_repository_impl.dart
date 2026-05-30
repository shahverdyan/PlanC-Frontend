import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:plan_c_frontend/features/groups/domain/models/group.dart';
import 'package:plan_c_frontend/features/groups/domain/repositories/group_repository.dart';

class GroupRepositoryImpl implements GroupRepository {
  final Dio dio;
  final String _baseUrl = 'https://planc-backend-aff2.onrender.com/quedada';
  final String _activitiesBaseUrl =
      'https://planc-backend-aff2.onrender.com/activitats';

  GroupRepositoryImpl(this.dio);

  String _mapError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return 'No s’ha pogut connectar amb el servidor. Revisa la teva connexió a internet.';
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
          return 'No tens permís per modificar aquesta quedada.';
        case 404:
          return 'No s’ha trobat la informació al servidor.';
        case 409:
          return 'Ja existeix una quedada amb aquestes dades o hi ha un conflicte.';
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

  @override
  Future<void> createGroup(Group group) async {
    try {
      await dio.post(
        _baseUrl,
        options: Options(headers: {'usuari-id': group.creatorId}),
        data: {
          'titol': group.title,
          'descripcio': group.description,
          'minimParticipants': group.minParticipants,
          'maximParticipants': group.maxParticipants,
          'dataHoraTrobada': group.dateTime.toUtc().toIso8601String(),
          'activitatId': group.activityId,
        },
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> updateGroup(String groupId, Group group) async {
    try {
      await dio.patch(
        '$_baseUrl/$groupId',
        options: Options(headers: {'usuari-id': group.creatorId}),
        data: {
          'titol': group.title,
          'descripcio': group.description,
          'minimParticipants': group.minParticipants,
          'maximParticipants': group.maxParticipants,
          'dataHoraTrobada': group.dateTime.toUtc().toIso8601String(),
        },
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> joinGroup({
    required String groupId,
    required String userId,
  }) async {
    try {
      await dio.post(
        '$_activitiesBaseUrl/$groupId/apuntar',
        data: {},
        options: Options(headers: {'usuari-id': userId}),
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> confirmAttendance({
    required String groupId,
    required String userId,
  }) async {
    try {
      await dio.post(
        '$_activitiesBaseUrl/$groupId/confirmar-assistencia',
        data: {},
        options: Options(headers: {'usuari-id': userId}),
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> unconfirmAttendance({
    required String groupId,
    required String userId,
  }) async {
    try {
      await dio.post(
        '$_activitiesBaseUrl/$groupId/desconfirmar-assistencia',
        data: {},
        options: Options(headers: {'usuari-id': userId}),
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> leaveGroup({
    required String groupId,
    required String userId,
  }) async {
    try {
      await dio.delete(
        '$_activitiesBaseUrl/$groupId/desapuntar',
        options: Options(headers: {'usuari-id': userId}),
      );
    } on DioException catch (e) {
      debugPrint('ERROR leaveGroup: ${e.response?.statusCode}');
      debugPrint('BODY leaveGroup: ${e.response?.data}');
      throw _mapError(e);
    }
  }

  @override
  Future<void> deleteGroup({
    required String groupId,
    required String userId,
  }) async {
    try {
      await dio.delete(
        '$_baseUrl/$groupId',
        options: Options(headers: {'usuari-id': userId}),
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<List<Group>> getGroupsByActivity(String activityId) async {
    try {
      final response = await dio.get('$_baseUrl/activitat/$activityId');
      debugPrint('=== QUEDADES RESPONSE ===');
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Data: ${response.data}');
      return List<Group>.from(
        (response.data as List).map(
              (g) => Group.fromJson(g as Map<String, dynamic>),
        ),
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<Group> getGroupById(String groupId) async {
    try {
      final response = await dio.get('$_baseUrl/$groupId');
      return Group.fromJson(response.data);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<List<Group>> getAllGroups() async {
    try {
      final response = await dio.get(_baseUrl);
      return List<Group>.from(
        (response.data as List).map(
          (g) => Group.fromJson(g as Map<String, dynamic>),
        ),
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<String> uploadGroupPhoto({
    required String quedadaId,
    required File imageFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        'fitxer': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });
      final response = await dio.patch('$_baseUrl/$quedadaId/imatge', data: formData);
      final url = response.data['quedada']['imatge'] as String;
      return url;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }
}