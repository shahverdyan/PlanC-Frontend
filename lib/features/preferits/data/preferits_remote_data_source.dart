import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plan_c_frontend/core/config/app_config.dart';
import 'package:plan_c_frontend/features/activitats/model/activitat.dart';
import 'package:plan_c_frontend/features/publicacions/domain/models/post_preview.dart';

abstract class PreferitsRemoteDataSource {
  Future<List<Activitat>> getActivitatsGuardades({
    required String usuariId,
  });

  Future<void> guardarActivitat({
    required String activitatId,
    required String usuariId,
  });

  Future<void> desguardarActivitat({
    required String activitatId,
    required String usuariId,
  });

  Future<List<PostPreview>> getPublicacionsGuardades({
    required String usuariId,
  });
}

class PreferitsRemoteDataSourceImpl implements PreferitsRemoteDataSource {
  final http.Client client;

  PreferitsRemoteDataSourceImpl(this.client);

  @override
  Future<List<Activitat>> getActivitatsGuardades({
    required String usuariId,
  }) async {
    final uri = Uri.parse('${AppConfig.baseUrl}activitats/guardades');

    final response = await client.get(
      uri,
      headers: {
        'usuari-id': usuariId,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Error obtenint preferides: ${response.statusCode} - ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is List) {
      return decoded.map((item) {
        final json = item is Map && item.containsKey('activitat')
            ? item['activitat'] as Map<String, dynamic>
            : item as Map<String, dynamic>;
        return Activitat.fromJson(json);
      }).toList();
    }

    throw Exception('Format de resposta inesperat a /activitats/guardades');
  }

  @override
  Future<void> guardarActivitat({
    required String activitatId,
    required String usuariId,
  }) async {
    final uri = Uri.parse('${AppConfig.baseUrl}activitats/$activitatId/guardar');

    final response = await client.post(
      uri,
      headers: {
        'usuari-id': usuariId,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(
        'Error guardant activitat: ${response.statusCode} - ${response.body}',
      );
    }
  }

  @override
  Future<void> desguardarActivitat({
    required String activitatId,
    required String usuariId,
  }) async {
    final uri = Uri.parse('${AppConfig.baseUrl}activitats/$activitatId/desguardar');

    final response = await client.delete(
      uri,
      headers: {
        'usuari-id': usuariId,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception(
        'Error desguardant activitat: ${response.statusCode} - ${response.body}',
      );
    }
  }

  @override
  Future<List<PostPreview>> getPublicacionsGuardades({
    required String usuariId,
  }) async {
    final uri = Uri.parse('${AppConfig.baseUrl}publicacio/desats').replace(
      queryParameters: {'page': '1', 'limit': '50'},
    );

    final response = await client.get(
      uri,
      headers: {
        'usuari-id': usuariId,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Error obtenint publicacions guardades: ${response.statusCode} - ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);
    final List raw = decoded is List ? decoded : (decoded['data'] as List? ?? []);

    return raw.whereType<Map<String, dynamic>>().map((json) {
      final id = json['id'] as String? ?? '';
      final multimedia = json['multimedia'] as List?;
      final imageUrl = multimedia != null && multimedia.isNotEmpty
          ? (multimedia.first['url'] as String? ?? '')
          : '';
      return PostPreview(id: id, imageUrl: imageUrl);
    }).toList();
  }
}