import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:plan_c_frontend/core/config/app_config.dart';
import 'package:plan_c_frontend/features/groups/domain/models/validation_result.dart';

class ValidationRemoteDataSource {
  final http.Client client;

  const ValidationRemoteDataSource(this.client);

  Future<ValidationResult> validateAttendance({
    required String quedadaId,
    required String usuariId,
    required double latitud,
    required double longitud,
  }) async {
    final uri = Uri.parse(
      '${AppConfig.baseUrl}activitats/quedades/$quedadaId/validar-assistencia',
    );

    debugPrint('ValidationDataSource: POST $uri');

    final response = await client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'usuari-id': usuariId,          // ← afegir header
      },
      body: jsonEncode({
        'usuariId': usuariId,
        'latitud': latitud,
        'longitud': longitud,
      }),
    );

    debugPrint('ValidationDataSource: response ${response.statusCode}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return ValidationResult.fromJson(json);
    }

    if (response.statusCode == 400) {
      Map<String, dynamic>? errorJson;
      try {
        errorJson = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {}

      if (errorJson != null) {
        final distancia = (errorJson['distancia'] as num?)?.toDouble();
        if (distancia != null) {
          throw Exception('distance:${distancia.toStringAsFixed(0)}');
        }
        final message = errorJson['message']?.toString();
        if (message != null) {
          throw Exception(message);
        }
      }
      throw Exception('Ets fora del rang per validar l\'assistència');
    }

    throw Exception('Error validant assistència: ${response.statusCode}');
  }
}
